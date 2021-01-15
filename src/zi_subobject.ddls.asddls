@AbapCatalog.sqlViewName: 'ZISUBOBJECT'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Data Model CDS for Subobject'
define view ZI_SUBOBJECT
  as select from zsubobject as Subobject
  association to parent ZI_OBJECT as _Object on $projection.ObjectUuid = _Object.ObjectUuid
  association [0..1] to ZI_LOGSTATUS    as _LogStatus   on $projection.LogObjectStatus    = _LogStatus.StatusId
{
key Subobject.subobject_uuid as SubobjectUuid,
Subobject.object_uuid as ObjectUuid,
Subobject.subobject as Subobject,
Subobject.subobject_text as SubobjectText,
Subobject.transport_request as TransportRequest,
Subobject.log_status as LogObjectStatus,
@Semantics.systemDateTime.localInstanceLastChangedAt: true
Subobject.local_last_changed_at as LocalLastChangedAt,
case when Subobject.log_status  = '01' then 1
      when Subobject.log_status  = '02' then 3
      else 0 end as criticality,
  _Object, // Make association public
  _LogStatus
}
