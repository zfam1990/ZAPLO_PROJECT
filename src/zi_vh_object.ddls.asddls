@AbapCatalog.sqlViewName: 'ZIVHOBJECT'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Value help for ApplLogObjects'
define view ZI_VH_OBJECT 
as select from I_CustABAPObjDirectoryEntry {

key ABAPObjectCategory,
key ABAPObjectType,
key ABAPObject,
ABAPObjectResponsibleUser,
ABAPObjectIsDeleted,
ABAPPackage,
ABAPSoftwareComponent,
/* Associations */
_CustABAPPackage

    
} where ABAPObjectType = 'APLO'
