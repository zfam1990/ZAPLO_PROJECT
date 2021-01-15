@EndUserText.label: 'Projection view for Subobject'
@AccessControl.authorizationCheck: #NOT_REQUIRED

@UI: {
  headerInfo: { typeName: 'Application Log SUbobject', typeNamePlural: 'Application Log Objects',
                title: { type: #STANDARD, value: 'Subobject' } } }
@UI.presentationVariant: [{sortOrder: [{by: 'Subobject', direction: #ASC }]}]

@Search.searchable: true
define view entity ZC_SUBOBJECT
  as projection on ZI_SUBOBJECT
{

      @UI.facet: [ { id:            'Subobject',
                     purpose:       #STANDARD,
                     type:          #IDENTIFICATION_REFERENCE,
                     label:         'Application Log SUboZC_SUBOBJECTbject',
                     position:      10 }]

      @UI.hidden: true
  key SubobjectUuid,
      @UI.hidden: true
      ObjectUuid,
      @UI: {
                        lineItem:       [ { position: 10, label: 'Subobject', importance: #HIGH }
                        ,{ type: #FOR_ACTION, dataAction: 'DeactivateObject1', label: 'Deactivate'} 
                        ],
                        identification: [ { position: 10, label: 'Subobject' }
                        ,{ type: #FOR_ACTION, dataAction: 'DeactivateObject1', label: 'Deactivate'} 
                        ]}
      @Search.defaultSearchElement: true
      @EndUserText: { quickInfo: 'Subobject Name' }
      Subobject,
      @UI: {
               lineItem:       [ { position: 20,label: 'Object Text', importance: #HIGH } ],
               identification: [ { position: 20, label: 'Object Text' } ]}
      @EndUserText: { quickInfo: 'Subobject Description' }         
      SubobjectText,
      @UI: {
             lineItem:       [ { position: 30, label: 'Transport Request', importance: #HIGH }],
             identification: [ { position: 30, label: 'Transport Request' } ]}
      @EndUserText: { quickInfo: 'Subobject Transport Request' }
      TransportRequest,
      @UI: {
      lineItem:       [ { position: 40, label: 'Package', importance: #MEDIUM }],
      identification: [ { position: 40, label: 'Package' } ]}  
      @EndUserText: { quickInfo: 'Subobject Package' }  
      _Object.PackageObj,    
      @UI: {
              lineItem:       [ { position: 50,  criticality: 'criticality', criticalityRepresentation: #WITH_ICON, label: 'Status', importance: #HIGH },
              { type: #FOR_ACTION, dataAction: 'ActivateObject1', label: 'ActivateSubobject', position: 50} ],
              identification: [ { position: 50, label: 'Status' }
              ,{ type: #FOR_ACTION, dataAction: 'ActivateObject1', label: 'ActivateSubobject' } ]
              }     
      @ObjectModel.text.element: ['StatusName'] 
      @EndUserText: { quickInfo: 'Log Object Status' }
      LogObjectStatus,
      @UI.hidden: true
      criticality,
      _LogStatus.StatusName as StatusName,  
      @UI.hidden: true
      LocalLastChangedAt,
      /* Associations */
      _Object: redirected to parent ZC_OBJECT,
      _LogStatus

}
