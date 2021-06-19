/********************************************************
* Author: josue.beltran 
* Date: 7/2/2020
* Project: CPQ_LAB
*------------------------------------------------------
* Comments:
*
*
********************************************************/

public with sharing class VFP_DORedirectController {
    
        
        public VFP_DORedirectController(){
        
        }
        public PageReference doRedirect(){
                ID PageID = ApexPages.currentPage().getParameters().get('id');
                PageReference pageRef = new PageReference('/apex/VIDSingerForSalesforce_Step2?'+ PageID);
                pageRef.setRedirect(true);
                return pageRef;
        }
    
}