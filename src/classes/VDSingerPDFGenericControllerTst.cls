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
private class VDSingerPDFGenericControllerTst {
	public static testMethod void testBehavior () {

		pageReference pager = page.VIDSingerForSalesforce_Step2;
		Test.setCurrentPage( pager );
		Opportunity oppInstance = new Opportunity( );
		oppInstance.Name = 'Test';
		oppInstance.StageName = 'Negociación';
		oppInstance.CloseDate = date.today( );
		insert oppInstance;
		ApexPages.StandardController stdOppty= new ApexPages.StandardController(oppInstance);
		VDSingerPDFGenericController oppC = new VDSingerPDFGenericController(stdOppty);
		system.assert( oppInstance.Id != null );
		
		apexPages.Currentpage( ).getParameters( ).put( 'Id', oppInstance.id );
		
		oppC.doRedirect( );
	}
}