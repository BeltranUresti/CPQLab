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
private class VFP_DORedirectControllerTst {
	public static testMethod void testBehavior () {
		
		VFP_DORedirectController oppC = new VFP_DORedirectController ();
		pageReference pager = page.VIDSingerForSalesforce_Step2;
		Test.setCurrentPage(pager);
		Opportunity oppInstance = new Opportunity();
		oppInstance.Name                    = 'Test';
		oppInstance.StageName               = 'Negociación';
		oppInstance.CloseDate               = date.today();
		insert oppInstance;
		system.assert(oppInstance.Id != null);
		
		apexPages.Currentpage().getParameters().put('Id',oppInstance.id);
		
		oppC.doRedirect();
	}
}