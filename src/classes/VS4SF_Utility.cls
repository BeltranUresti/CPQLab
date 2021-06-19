/********************************************************
* Author: josue.beltran 
* Date: 7/6/2020
* Project: CPQ_LAB
*------------------------------------------------------
* Comments:
*
*
********************************************************/

public with sharing class VS4SF_Utility {
	
	public static Map<String, String> getAllFields(String sobjectname){
		if(!Schema.getGlobalDescribe().containsKey(sobjectname)) return new Map<String, String>{'Exception' => 'Invalid object name'};
		Map<String, Schema.SObjectField> fields = Schema.getGlobalDescribe().get(sobjectname).getDescribe().SObjectType.getDescribe().fields.getMap();
		
		List<String> accessiblefields = new List<String>();
		
		for(Schema.SObjectField field : fields.values()){
			if(field.getDescribe().isAccessible()){
				accessiblefields.add(field.getDescribe().getName());
			}
		}
		String allfields='';
		for(String fieldname : accessiblefields)
			allfields += fieldname+',';
		
		allfields = allfields.subString(0,allfields.length()-1);
		
		return new Map<String, String>{sobjectname => allfields};
	}
	public static Set<ID> getRelatedLookupIdsOfSObject(ID objectID, String lookupObjName){
		String objType = objectID.getSObjectType().getDescribe().getName();
		Map<String, String> ALL_FIELDS = getAllFields(objType);
		System.debug('SELECT ' + ALL_FIELDS.get(objType) + ' FROM ' + objType + ' WHERE Id = \'' + objectID + '\'');
		SObject theObject = Database.query('SELECT ' + ALL_FIELDS.get(objType) + ' FROM ' + objType + ' WHERE Id = \'' + objectID + '\'' );
		
		Set<ID> IdValues = new Set<ID>();
		Map<String, Schema.SObjectType> schemaMap = Schema.getGlobalDescribe();
		Schema.SObjectType leadSchema = schemaMap.get(objType);
		Map<String, Schema.SObjectField> fieldMap = leadSchema.getDescribe().fields.getMap();
		
		for (String fieldName: fieldMap.keySet()) {
			String fieldLabel = fieldMap.get(fieldName).getDescribe().getLabel();
			Schema.DescribeFieldResult f  = fieldMap.get(fieldName).getDescribe();
			for(Schema.SObjectType reference : f.getReferenceTo()) {
				if(lookupObjName == reference.getDescribe().getName())
				{
							if(theObject.get(fieldName) != null ){
								IdValues.add((ID)theObject.get(fieldName));
							}
				}
				
			}
			
		}
		System.debug('Lookup reference object label: ' + IdValues);
		return IdValues;
	}
	public static PageReference getPagRefFromPageName(String idContrato){
		Contract contrato = (Contract) [SELECT Id FROM Contract WHERE Id =: idContrato LIMIT 1];
		Date myDate = Date.newInstance(1960, 2, 17);
		integer year = integer.valueof(myDate.year());
		if(year < 2021){
			PageReference pageRef = new PageReference('/apex/PDFContract_Particular');
			pageRef.getParameters().put('Id',contrato.Id);
			return pageRef.setRedirect(true);
		}else if (year == 2021){
			PageReference pageRef = new PageReference('/apex/PDFContract_Particular_2021');
			pageRef.getParameters().put('Id',contrato.Id);
			return pageRef;
		}else if (year > 2021){
			PageReference pageRef = new PageReference('/apex/PDFContract_Particular_2022');
			pageRef.getParameters().put('Id',contrato.Id);
			return pageRef;

		}else return null;
	}

}