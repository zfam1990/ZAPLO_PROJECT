@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Data Model CDS for Object'
define root view entity ZI_OBJECT1
  as select from zobject1 as Object
  composition [0..*] of ZI_SUBOBJECT1 as _Subobject
{

  key Object.object                as Object,
      Object.object_text           as ObjectText,
      Object.transport_request     as TransportRequest,
      Object.package_obj           as PackageObj,
      @Semantics.user.createdBy: true
      Object.local_created_by      as LocalCreatedBy,
      @Semantics.systemDateTime.createdAt: true
      Object.local_created_at      as LocalCreatedAt,
      @Semantics.user.lastChangedBy: true
      Object.local_last_changed_by as LocalLastChangedBy,
      @Semantics.systemDateTime.localInstanceLastChangedAt: true
      Object.local_last_changed_at as LocalLastChangedAt,
      
      @Semantics.systemDateTime.lastChangedAt: true
      Object.last_changed_at as LastChangedAt,


      _Subobject // Make association public
}
