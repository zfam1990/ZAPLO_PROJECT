@AbapCatalog.sqlViewName: 'ZILOGSTATUS'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Base view for Log Object Status'
define view ZI_LOGSTATUS 
as select from zlogstatus as LogStatus
{
key status_id as StatusId,
@Semantics.text: true
status_name as StatusName
    
}
