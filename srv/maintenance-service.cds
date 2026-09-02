using { sap.cap.maintenance as my } from '../db/schema';

service MaintenanceService @(path: '/odata/v4/maintenance') {
  entity MaintenanceOrders      as projection on my.MaintenanceOrders;
  entity Equipments             as projection on my.Equipments;
  entity MaintenanceOperations  as projection on my.MaintenanceOperations;
  entity Materials              as projection on my.Materials;
  entity MaterialCatalog        as projection on my.MaterialCatalog;
  entity Technicians            as projection on my.Technicians;
  entity TechnicianCatalog      as projection on my.TechnicianCatalog;
  entity AuditHistory           as projection on my.AuditHistory;
  entity OrderHistory           as projection on my.OrderHistory;

  // Master Data
  entity Plants                 as projection on my.Plants;
  entity MaintenanceTypes       as projection on my.MaintenanceTypes;
  entity Priorities             as projection on my.Priorities;
  entity Planners               as projection on my.Planners;
  entity WorkCenters            as projection on my.WorkCenters;
  entity Statuses               as projection on my.Statuses;

  action cancelOrder(order_no: String, reason: String) returns MaintenanceOrders;
  action completeOrder(order_no: String) returns MaintenanceOrders;
}
