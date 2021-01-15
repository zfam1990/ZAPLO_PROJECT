@EndUserText.label: 'Projection view for Object'
@AccessControl.authorizationCheck: #NOT_REQUIRED

@UI: {
  headerInfo: { typeName: 'Application Log Object', typeNamePlural: 'Application Log Objects',
                title: { type: #STANDARD, value: 'Object' } } }
@UI.presentationVariant: [{sortOrder: [{by: 'Object', direction: #ASC }]}]

@Search.searchable: true
define root view entity ZC_OBJECT
  as projection on ZI_OBJECT
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

      @UI.hidden: true
  key ObjectUuid,
      @UI: {
                  lineItem:       [ { position: 10, label: 'Object', importance: #HIGH } ],
                  identification: [ { position: 10, label: 'Object' } ],
                  selectionField: [ { position: 10 } ] }
      @Consumption.valueHelpDefinition: [{ entity : {name: 'ZCE_OBJECT_VH', element: 'ABAPObject'  },
      additionalBinding: [{ localElement: 'PackageObj', element: 'package_obj', usage: #RESULT },
      { localElement: 'ObjectText', element: 'object_text', usage: #RESULT },
      { localElement: 'Object', element: 'object', usage: #RESULT }]}]
      @EndUserText: { quickInfo: 'Log Object Name' }
      Object,
      @UI: {
               lineItem:       [ { position: 20,label: 'Object Text', importance: #HIGH } ],
               identification: [ { position: 20, label: 'Object Text' } ]}
      @EndUserText: { quickInfo: 'Log Object Description' }        
      ObjectText,
      @UI: {
             lineItem:       [ { position: 30, label: 'Transport Request', importance: #HIGH } ],
             identification: [ { position: 30, label: 'Transport Request' } ]}
      @EndUserText: { quickInfo: 'Log Object Transport Request' }   
      TransportRequest,
      @UI: {
              lineItem:       [ { position: 40, label: 'Package', importance: #HIGH },
              { type: #FOR_ACTION, dataAction: 'DeactivateObject1', label: 'Deactivate' } ],
              identification: [ { position: 40, label: 'Package' },
              { type: #FOR_ACTION, dataAction: 'DeactivateObject1', label: 'Deactivate' } ]}   
      @EndUserText: { quickInfo: 'Log Object Package' }    
      PackageObj,
      @UI: {
              lineItem:       [ { position: 50, criticality: 'criticality', criticalityRepresentation: #WITH_ICON, label: 'Status', importance: #HIGH },
              { type: #FOR_ACTION, dataAction: 'ActivateObject', label: 'Activate' } ],
              identification: [ { position: 50, label: 'Status' },
              { type: #FOR_ACTION, dataAction: 'ActivateObject', label: 'Activate' } ]}   
      @ObjectModel.text.element: ['StatusName'] 
      @Search.defaultSearchElement: true
      @Search.fuzzinessThreshold: 0.7
      @EndUserText: { quickInfo: 'Log Object Status' }
      LogObjectStatus,
      _LogStatus.StatusName as StatusName,
      @UI.hidden: true
      criticality,
      
      @UI.hidden: true
      LocalLastChangedAt
      ,
      _LogStatus,
      /* Associations */

      _Subobject : redirected to composition child ZC_SUBOBJECT

}
