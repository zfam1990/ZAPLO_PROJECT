@EndUserText.label: 'Projection view for Object'
@AccessControl.authorizationCheck: #NOT_REQUIRED

@UI: {
  headerInfo: { typeName: 'Application Log Object', typeNamePlural: 'Application Log Objects',
                title: { type: #STANDARD, value: 'Object' } } }
@UI.presentationVariant: [{sortOrder: [{by: 'Object', direction: #ASC }]}]

@Search.searchable: true
define root view entity ZC_OBJECT1
  as projection on ZI_OBJECT1
{

      @UI.facet: [ {             id:              'Object',
                                 purpose:         #STANDARD,
                                 type:            #IDENTIFICATION_REFERENCE,
                                 label:           'Application Log Object',
                                 position:        10 },
                               { id:              'Subobject',
                                 purpose:         #STANDARD,
                                 type:            #LINEITEM_REFERENCE,
                                 label:           'Application Log Subobject',
                                 position:        20,
                                 targetElement:   '_Subobject'}]

      @UI: {
              lineItem:       [ { position: 10, label: 'Object', importance: #HIGH } ],
              identification: [ { position: 10, label: 'Object' } ],
              selectionField: [ { position: 10 } ] }
      @Search.defaultSearchElement: true
  key Object,
      @UI: {
               lineItem:       [ { position: 20,label: 'Object Text', importance: #HIGH } ],
               identification: [ { position: 20, label: 'Object Text' } ],
               selectionField: [ { position: 20 } ] }
      ObjectText,
      @UI: {
             lineItem:       [ { position: 30, label: 'Transport Request', importance: #HIGH } ],
             identification: [ { position: 30, label: 'Transport Request' } ],
             selectionField: [ { position: 30 } ] }      
      TransportRequest,
      @UI: {
              lineItem:       [ { position: 40, label: 'Package', importance: #HIGH } ],
              identification: [ { position: 40, label: 'Package' } ],
              selectionField: [ { position: 40 } ] }      
      PackageObj,
      @UI.hidden: true
      LocalLastChangedAt
      ,
      /* Associations */
      _Subobject: redirected to composition child ZC_SUBOBJECT1
}
