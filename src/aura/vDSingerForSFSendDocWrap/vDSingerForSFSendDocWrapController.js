/**
 * Created by josue.beltran on 6/28/2020.
 */

({
    navigateToMyComponent : function(cmp, message, helper) {

       /* if (message != null && message.getParam("recordData") != null) {
            console.log(message.getParam("recordData"));
            var payload = {
                recordId: "some string",
                recordData: message.getParam("recordData")
            };
            setTimeout(function(){
                cmp.find("sampleMessageChannel").publish(payload);
            }, 2000);

        }*/

        var urlEvent = $A.get("e.force:navigateToURL");
        urlEvent.setParams({
            "url": "/apex/VIDSingerForSalesforce_Step2"
        });
        urlEvent.fire();
    }
});