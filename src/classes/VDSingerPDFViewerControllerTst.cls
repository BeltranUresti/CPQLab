/********************************************************
* Author: josue.beltran 
* Date: 7/22/2020
* Project: CPQ_LAB
*------------------------------------------------------
* Comments:
*
*
********************************************************/

@IsTest
private class VDSingerPDFViewerControllerTst {
	public static testMethod void testBehavior () {
		
		
		pageReference pager = page.VIDSingerForSalesforce_Step2;
		Test.setCurrentPage(pager);

		
		Account accInstance = new Account();
		accInstance.Name    = 'Test';
		insert accInstance;
		
		
		Contact instanceContact = new Contact();
		instanceContact.LastName = 'TestContact';
		instanceContact.AccountId = accInstance.Id;
		insert instanceContact;
		
		Opportunity oppInstance = new Opportunity();
		oppInstance.Name    = 'Test';
		oppInstance.StageName  = 'Negociación';
		oppInstance.AccountId = accInstance.Id;
		oppInstance.CloseDate               = date.today();
		insert oppInstance;
		system.assert(oppInstance.Id != null);
		
		apexPages.Currentpage().getParameters().put('Id',oppInstance.Id);
		
		VDSingerPDFViewerController oppC = new  VDSingerPDFViewerController();
		oppC.doRedirect();
		
		ContentVersion contentVersionInsert = new ContentVersion(
				Title = 'Test',
				PathOnClient = 'Test.jpg',
				VersionData = Blob.valueOf('Test Content Data'),
				IsMajorVersion = true
				
		);
		insert contentVersionInsert;
		ContentDocument contentVersionUpdate = [Select Id, ParentId from ContentDocument LIMIT 1];
		contentVersionUpdate.ParentId =oppInstance.Id;
		//update contentVersionUpdate;
		
		VDSingerPDFViewerController.docsMapsResutl relatedRecord = VDSingerPDFViewerController.getRelatedFilesByRecordId(oppInstance.Id);
		
		
	}
}