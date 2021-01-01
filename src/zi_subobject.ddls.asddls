@AbapCatalog.sqlViewName: 'ZISUBOBJECT'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Data Model CDS for Subobject'
define view ZI_SUBOBJECT
  as select from zsubobject as Subobject
  association to parent ZI_OBJECT as _Object on $projection.ObjectUuid = _Object.ObjectUuid
{
key Subobject.subobject_uuid as SubobjectUuid,
Subobject.object_uuid as ObjectUuid,
Subobject.subobject as Subobject,
Subobject.subobject_text as SubobjectText,
Subobject.transport_request as TransportRequest,
@Semantics.systemDateTime.localInstanceLastChangedAt: true
Subobject.local_last_changed_at as LocalLastChangedAt,

  _Object // Make association public
}
