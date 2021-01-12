@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Data Model CDS for Subobject'
define view entity ZI_SUBOBJECT1
  as select from zsubobject1 as Subobject
  association to parent ZI_OBJECT1 as _Object on $projection.Object = _Object.Object
{
key Subobject.subobject as Subobject,
key Subobject.object as Object,
Subobject.subobject_text as SubobjectText,
Subobject.transport_request as TransportRequest,
@Semantics.systemDateTime.localInstanceLastChangedAt: true
Subobject.local_last_changed_at as LocalLastChangedAt
,
    
    _Object // Make association public
}
