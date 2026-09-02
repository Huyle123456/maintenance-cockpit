const cds = require('@sap/cds');

module.exports = cds.service.impl(async function () {
  const { MaintenanceOrders, AuditHistory, OrderHistory, MaintenanceOperations } = this.entities;

  this.before('CREATE', 'MaintenanceOrders', async (req) => {
    const data = req.data;
    if (!data.order_no) {
      const highest = await SELECT.one.from(MaintenanceOrders).columns('order_no').orderBy('order_no desc');
      let nextNum = 1001;
      if (highest && highest.order_no) {
        const match = highest.order_no.match(/MO-(\d+)/);
        if (match) nextNum = parseInt(match[1], 10) + 1;
      }
      data.order_no = `MO-${nextNum}`;
    }
    if (!data.status) data.status = 'OPEN';
    if (!data.status_state) data.status_state = 'Success';
    if (!data.etag) data.etag = `W/"${Date.now()}"`;
  });

  this.after('CREATE', 'MaintenanceOrders', async (data, req) => {
    await INSERT.into(AuditHistory).entries({
      timestamp: new Date().toISOString().replace('T', ' ').substring(0, 16),
      user: req.user?.id || 'Current User',
      object: data.order_no,
      action: 'CREATE',
      details: 'Maintenance order created'
    });

    await INSERT.into(OrderHistory).entries({
      order_no: data.order_no,
      title: 'Order created',
      dateTime: new Date().toISOString().replace('T', ' ').substring(0, 16),
      userName: req.user?.id || 'Current User',
      text: 'Order initialized in system',
      icon: 'sap-icon://create'
    });
  });

  this.on('cancelOrder', async (req) => {
    const { order_no, reason } = req.data;
    if (!order_no) return req.error(400, 'Order number is required');

    await UPDATE(MaintenanceOrders)
      .set({ status: 'CANCELLED', status_state: 'Error' })
      .where({ order_no });

    await INSERT.into(AuditHistory).entries({
      timestamp: new Date().toISOString().replace('T', ' ').substring(0, 16),
      user: req.user?.id || 'Current User',
      object: order_no,
      action: 'CANCEL',
      details: reason || 'Order cancelled by user'
    });

    await INSERT.into(OrderHistory).entries({
      order_no: order_no,
      title: 'Status changed to CANCELLED',
      dateTime: new Date().toISOString().replace('T', ' ').substring(0, 16),
      userName: req.user?.id || 'Current User',
      text: reason || 'Order cancelled',
      icon: 'sap-icon://cancel'
    });

    return await SELECT.one.from(MaintenanceOrders).where({ order_no });
  });

  this.on('completeOrder', async (req) => {
    const { order_no } = req.data;
    if (!order_no) return req.error(400, 'Order number is required');

    await UPDATE(MaintenanceOrders)
      .set({ status: 'COMPLETED', status_state: 'Success' })
      .where({ order_no });

    await INSERT.into(AuditHistory).entries({
      timestamp: new Date().toISOString().replace('T', ' ').substring(0, 16),
      user: req.user?.id || 'Current User',
      object: order_no,
      action: 'COMPLETE',
      details: 'Order marked as completed'
    });

    await INSERT.into(OrderHistory).entries({
      order_no: order_no,
      title: 'Status changed to COMPLETED',
      dateTime: new Date().toISOString().replace('T', ' ').substring(0, 16),
      userName: req.user?.id || 'Current User',
      text: 'Maintenance work finished',
      icon: 'sap-icon://complete'
    });

    return await SELECT.one.from(MaintenanceOrders).where({ order_no });
  });
});
