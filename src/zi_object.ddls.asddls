@AbapCatalog.sqlViewName: 'ZIOBJECT'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Data Model CDS for Object'
define root view ZI_OBJECT
  as select from zobject as Object
  composition [0..*] of ZI_SUBOBJECT as _Subobject
  association [0..1] to ZI_LOGSTATUS    as _LogStatus   on $projection.LogObjectStatus    = _LogStatus.StatusId
{

  key Object.object_uuid           as ObjectUuid,
      Object.object                as Object,
      Object.object_text           as ObjectText,
      Object.transport_request     as TransportRequest,
      Object.package_obj           as PackageObj,
      Object.status                as ObjectStatus,
      Object.log_status            as LogObjectStatus,
      @Semantics.user.createdBy: true
      Object.local_created_by      as LocalCreatedBy,
      @Semantics.systemDateTime.createdAt: true
      Object.local_created_at      as LocalCreatedAt,
      @Semantics.user.lastChangedBy: true
      Object.local_last_changed_by as LocalLastChangedBy,
      @Semantics.systemDateTime.localInstanceLastChangedAt: true
      Object.local_last_changed_at as LocalLastChangedAt,
      
      @Semantics.systemDateTime.lastChangedAt: true
      last_changed_at as LastChangedAt,

      _Subobject, // Make association public
      _LogStatus
}
