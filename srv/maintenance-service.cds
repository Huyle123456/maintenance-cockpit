using { sap.cap.maintenance as my } from '../db/schema';

service MaintenanceService @(path: '/odata/v4/maintenance', requires: 'authenticated-user') {

  // Role-based entity projections (Admin has full write, User has read-only)
  entity MaintenanceOrders @(
    restrict: [
      { grant: 'READ', to: ['User', 'Admin', 'any'] },
      { grant: ['CREATE', 'UPDATE', 'DELETE'], to: 'Admin' }
    ]
  ) as projection on my.MaintenanceOrders;

  entity Equipments @(
    restrict: [
      { grant: 'READ', to: ['User', 'Admin', 'any'] },
      { grant: ['CREATE', 'UPDATE', 'DELETE'], to: 'Admin' }
    ]
  ) as projection on my.Equipments;

  entity MaintenanceOperations @(
    restrict: [
      { grant: 'READ', to: ['User', 'Admin', 'any'] },
      { grant: ['CREATE', 'UPDATE', 'DELETE'], to: 'Admin' }
    ]
  ) as projection on my.MaintenanceOperations;

  entity Materials @(
    restrict: [
      { grant: 'READ', to: ['User', 'Admin', 'any'] },
      { grant: ['CREATE', 'UPDATE', 'DELETE'], to: 'Admin' }
    ]
  ) as projection on my.Materials;

  entity MaterialCatalog @(
    restrict: [
      { grant: 'READ', to: ['User', 'Admin', 'any'] }
    ]
  ) as projection on my.MaterialCatalog;

  entity Technicians @(
    restrict: [
      { grant: 'READ', to: ['User', 'Admin', 'any'] },
      { grant: ['CREATE', 'UPDATE', 'DELETE'], to: 'Admin' }
    ]
  ) as projection on my.Technicians;

  entity TechnicianCatalog @(
    restrict: [
      { grant: 'READ', to: ['User', 'Admin', 'any'] }
    ]
  ) as projection on my.TechnicianCatalog;

  entity AuditHistory @(
    restrict: [
      { grant: 'READ', to: ['User', 'Admin', 'any'] },
      { grant: 'CREATE', to: ['User', 'Admin', 'any'] }
    ]
  ) as projection on my.AuditHistory;

  entity OrderHistory @(
    restrict: [
      { grant: 'READ', to: ['User', 'Admin', 'any'] },
      { grant: 'CREATE', to: ['User', 'Admin', 'any'] }
    ]
  ) as projection on my.OrderHistory;

  // Master Data (Read-only for all authenticated users)
  entity Plants @(restrict: [{ grant: 'READ', to: ['User', 'Admin', 'any'] }]) as projection on my.Plants;
  entity MaintenanceTypes @(restrict: [{ grant: 'READ', to: ['User', 'Admin', 'any'] }]) as projection on my.MaintenanceTypes;
  entity Priorities @(restrict: [{ grant: 'READ', to: ['User', 'Admin', 'any'] }]) as projection on my.Priorities;
  entity Planners @(restrict: [{ grant: 'READ', to: ['User', 'Admin', 'any'] }]) as projection on my.Planners;
  entity WorkCenters @(restrict: [{ grant: 'READ', to: ['User', 'Admin', 'any'] }]) as projection on my.WorkCenters;
  entity Statuses @(restrict: [{ grant: 'READ', to: ['User', 'Admin', 'any'] }]) as projection on my.Statuses;

  // Action restrictions
  action cancelOrder(order_no: String, reason: String) returns MaintenanceOrders;
  action completeOrder(order_no: String) returns MaintenanceOrders;

  // Function to return current authenticated user profile and roles from SAP / XSUAA
  type CurrentUserProfile {
    id: String;
    name: String;
    email: String;
    roles: array of String;
    isAdmin: Boolean;
    isUser: Boolean;
  };

  function getUserInfo() returns CurrentUserProfile;
}
