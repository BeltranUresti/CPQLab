/********************************************************
* Author: josue.beltran 
* Date: 7/6/2020
* Project: CPQ_LAB
*------------------------------------------------------
* Comments:
*
*
********************************************************/

public with sharing class VDSingerPDFGenericController {
	public ID objectId {get;set;}
	public ID PageID {get;set;}
	public String preLoadedPage {get; set;}
	public String templateName  {get; set;}
	public VDSingerPDFGenericController (ApexPages.StandardController controller) {
		this.PageID = controller.getId();
	}
	public PageReference doRedirect(){
		getAllConfig();
		PageReference pageRef = new PageReference('/apex/VIDSingerForSalesforce_Step2?id='+ this.PageID + '&defaultPDF=' + this.templateName );
		pageRef.setRedirect(true);
		return pageRef;
	}
	public void getAllConfig(){

		Boolean esProduccion = [SELECT IsSandbox, InstanceName FROM Organization LIMIT 1].IsSandbox;
		List<VIDSigner_Config__mdt> mcs = VIDSigner_Config__mdt.getall().values();
		for(VIDSigner_Config__mdt cf : mcs){
			if (!cf.Es_productivo__c == esProduccion) {
					this.templateName = cf.PDF_Empresas__c;
				}else{
					this.templateName = cf.PDF_Particular__c;
				}

		}
		System.debug(this.preLoadedPage );
		System.debug(this.templateName);

	}
}