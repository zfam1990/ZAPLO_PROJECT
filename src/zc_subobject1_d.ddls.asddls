@EndUserText.label: 'Projection view for Subobject'
@AccessControl.authorizationCheck: #NOT_REQUIRED

@UI: {
  headerInfo: { typeName: 'Application Log SUbobject', typeNamePlural: 'Application Log Objects',
                title: { type: #STANDARD, value: 'Subobject' } } }
@UI.presentationVariant: [{sortOrder: [{by: 'Subobject', direction: #ASC }]}]

@Search.searchable: true
define view entity ZC_SUBOBJECT1_D
  as projection on ZI_SUBOBJECT1
{

      @UI.facet: [ { id:            'Subobject',
                     purpose:       #STANDARD,
                     type:          #IDENTIFICATION_REFERENCE,
                     label:         'Application Log SUbobject',
                     position:      10 }]
      @UI: {
                        lineItem:       [ { position: 10, label: 'Subobject', importance: #HIGH } ],
                        identification: [ { position: 10, label: 'Subobject' } ],
                        selectionField: [ { position: 10 } ] }
      @Search.defaultSearchElement: true
  key Subobject,
      @UI.hidden: true
  key Object,
      @UI: {
               lineItem:       [ { position: 20,label: 'Object Text', importance: #HIGH } ],
               identification: [ { position: 20, label: 'Object Text' } ],
               selectionField: [ { position: 20 } ] }
      SubobjectText,
      @UI: {
             lineItem:       [ { position: 30, label: 'Transport Request', importance: #HIGH } ],
             identification: [ { position: 30, label: 'Transport Request' } ],
             selectionField: [ { position: 30 } ] }
      TransportRequest,
      @UI: {
              lineItem:       [ { position: 40, label: 'Package', importance: #HIGH } ],
              identification: [ { position: 40, label: 'Package' } ],
              selectionField: [ { position: 40 } ] }
      _Object.PackageObj,
      @UI.hidden: true
      LocalLastChangedAt
      ,
      /* Associations */
      _Object : redirected to parent ZC_OBJECT1_D
}
