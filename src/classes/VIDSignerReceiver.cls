/**
 * Created by Administrador 1 on 05/06/2021.
 */
@RestResource(urlMapping='/docstatus/*')
global without sharing class VIDSignerReceiver {
    public static String responseString {get;set;}
    @HttpPost
    global static String doPost()
    {
        VIDSigner_Document__c docSF = null;
        try {
            RestRequest req = RestContext.request;
            Blob body = req.requestBody;
            String bodyString = body.toString();

            Map<String, Object> mapWrap = (Map<String, Object>) JSON.deserializeUntyped(bodyString);

            if(mapWrap.get('DocGUI') != null ){
                docSF = [SELECT Id, Contrato__c, DocumentId__c, NotifyToUser__c, NotifyToAdmin__c FROM VIDSigner_Document__c WHERE DocumentId__c =: mapWrap.get('DocGUI').toString() ];
                String pfData = VDSingerPDFViewerController.getSignedDoc(mapWrap.get('DocGUI').toString() );
                if(pfData != null)
                {
                    VIDSignerAttachSignedDocAsyncCls.insertAsyncMessage(mapWrap.get('DocGUI').toString(), docSF.Contrato__c, mapWrap.get('FileName').toString());
                    List<String> recipients  = new List<String>();
                    emailSendingClass emailService = new  emailSendingClass();
                    if(docSF.NotifyToUser__c != null)
                        emailService.toMail =   docSF.NotifyToUser__c;

                    if(docSF.NotifyToAdmin__c != null)
                        emailService.ccMail = docSF.NotifyToAdmin__c;
                    /*
                                EmailTemplate emailTemplate = [SELECT Id,
                                                                        Subject,
                                                                        Description,
                                                                        HtmlValue,
                                                                        DeveloperName,
                                                                        Body FROM EmailTemplate
                                                                WHERE Name = 'VIDSigner_RevisionContrato'];
                                emailService.templateId = emailTemplate.Id;*/
                    emailService.attBase64 = pfData;
                    emailService.attName = mapWrap.get('FileName').toString();
                    emailService.bodyMessage = 'Tiene el PDF firmado adjunto en este email' ;
                    emailService.subject = 'VIDsigner: Documento firmado - ' + mapWrap.get('DocStatus').toString();
                    System.debug(emailService);
                    emailService.sendMail();
                    VidSigner_HandleCustomException.LogException('',bodyString);

                    // 14-05-2021: ksanoja
                    try{
                        Id contratoFdoId = docSF.Contrato__c;
                        Contract contratoFdo = [select Status from contract where id =: contratoFdoId];
                        contratoFdo.Status = 'Firmado';
                        update contratoFdo;
                    } catch(Exception e){
                        system.debug('Fallo actualizando status del contrato: '+ e.getMessage());
                    }
                }
            }
        } catch (Exception e) { VidSigner_HandleCustomException.LogException(e);
        } finally {

        }

        responseString = '[accepted]';
        return '[accepted]';

    }
}