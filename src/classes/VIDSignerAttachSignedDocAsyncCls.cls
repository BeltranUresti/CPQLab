/**
 * Created by Administrador 1 on 05/06/2021.
 */

public with sharing class VIDSignerAttachSignedDocAsyncCls {
    static final Integer FIRST_ITEM        = 0;
    static final String  STR_STATUSDML     = 'Success';
    public static String insertAsyncMessage(String docGUIId, String IdContrato, String fileName) {
        VIDSigner_AttachFile__e[] messages = new List<VIDSigner_AttachFile__e>{
                new VIDSigner_AttachFile__e(Id_Doc_Externo__c =docGUIId,Contrato__c =IdContrato,
                        NombreArchivo__c = fileName)
        };
        String strResult = '';
        // Call method to publish events
        Database.SaveResult[] results = EventBus.publish(messages);
        for(Database.SaveResult r: results) {
            if (!r.isSuccess()) {
                strResult =  JSON.serializePretty(r.getErrors()[FIRST_ITEM].getMessage());
            } else {
                strResult = STR_STATUSDML;
            }
        }
        return strResult;
    }
    public static void handle( VIDSigner_AttachFile__e[] messages) {
        for ( VIDSigner_AttachFile__e message : messages) {
            handleAsyncMessage(message.Id_Doc_Externo__c,message.NombreArchivo__c,message.Contrato__c);
        }
    }
    @Future(Callout=true)
    public static void handleAsyncMessage(String idDocExterno, String fileName, String contrato)
    {
        try{
            String pfData = VDSingerPDFViewerController.getSignedDoc(idDocExterno );
            ContentVersion conVer = new ContentVersion();
            conVer.ContentLocation = 'S'; // to use S specify this document is in Salesforce, to use E for external files
            conVer.PathOnClient =fileName; // The files name, extension is very important here which will help the file in preview.
            conVer.Title = fileName; // Display name of the files
            conVer.VersionData = EncodingUtil.base64Decode(pfData); // converting your binary string to Blog
            insert conVer;    //Insert ContentVersion
            // First get the Content Document Id from ContentVersion Object
            Id conDoc = [SELECT ContentDocumentId FROM ContentVersion WHERE Id =:conVer.Id].ContentDocumentId;
            //create ContentDocumentLink  record
            ContentDocumentLink conDocLink = new ContentDocumentLink();
            conDocLink.LinkedEntityId =contrato; // Specify RECORD ID here i.e Any Object ID (Standard Object/Custom Object)
            conDocLink.ContentDocumentId = conDoc;  //ContentDocumentId Id from ContentVersion
            conDocLink.ShareType = 'V';
            insert conDocLink;
        }catch(Exception e){
            VidSigner_HandleCustomException.LogException(e);
        }
    }
}