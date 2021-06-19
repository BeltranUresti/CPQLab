/**
 * Created by josue.beltran on 10/5/2020.
 */

({
    toggleProgress: function (cmp) {

                    var evt = $A.get("e.force:navigateToComponent");
                    evt.setParams({
                        componentDef: "c:VIDSignerAdresableCont",
                        componentAttributes: {
                            recordId: cmp.get("v.recordId")
                        }
                    });
                    console.log( cmp.get("v.recordId"));
                    evt.fire();
                }

});