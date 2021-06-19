/**
 * Created by Administrador 1 on 05/06/2021.
 */

public with sharing class emailSendingClass {
    public String toMail { get; set;}
    public String ccMail { get; set;}
    public String repMail { get; set;}
    public String attBase64 { get; set;}
    public String templateId {get;set;}
    public String whatId {get;set;}
    public String targetObjectId {get;set;}
    public String attName { get; set;}
    public String[] to_Addresses { get; set;}
    public String bodyMessage { get; set;}
    public List<Attachment> emailAttachments {get;set;}
    public String subject { get; set;}
    public void sendMail() {
        Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
        String[] to = new String[]{
                toMail
        };
        String[] cc = new String[]{
                ccMail
        };
        if (this.to_Addresses != null && !this.to_Addresses.isEmpty()) {
            email.setToAddresses(this.to_Addresses);
        } else {
            email.toAddresses = to;
        }

        if (ccMail != null && ccMail != '')
            email.setCcAddresses(cc);
        if (repMail != null && repMail != '')
            email.setInReplyTo(repMail);
        if (this.templateId != null) {
            email.setTemplateId(this.templateId);
            email.setWhatId(this.whatId);
            email.setTargetObjectId(this.targetObjectId);
        } else {
            email.setSubject(subject);
            email.setHtmlBody(bodyMessage);
        }

        Messaging.EmailFileAttachment[] mssgAtt = new Messaging.EmailFileAttachment[]{
        };

        OrgWideEmailAddress owa = [SELECT id, DisplayName, Address FROM OrgWideEmailAddress WHERE DisplayName = 'Comercial' limit 1];
        email.setOrgWideEmailAddressId(owa.id);
        if (emailAttachments != null && emailAttachments.size() > 0) {

            for (Attachment a : emailattachments) {
                Messaging.EmailFileAttachment efa = new Messaging.EmailFileAttachment();
                efa.setBody(a.Body);
                efa.setFileName(a.Name);
                mssgAtt.add(efa);
                //delete a;
            }
        } else {
            if (attBase64 != null) {
                Messaging.EmailFileAttachment efa2 = new Messaging.EmailFileAttachment();
                efa2.setContentType('application/pdf');
                efa2.setBody(EncodingUtil.base64Decode(attBase64));
                efa2.setFileName(attName);
                mssgAtt.add(efa2);
            }

        }

        try {
            system.debug('mssgAtt: ' + mssgAtt);
            if (!mssgAtt.isEmpty()) {
                email.setFileAttachments(mssgAtt);
            }

        } catch (Exception e) {
            system.debug('KO setFileAttachments: ' + e.getMessage());
        }

        try {
            Messaging.sendEmail(new Messaging.SingleEmailMessage[]{
                    email
            });
        } catch (exception e) {
            System.debug(e.getMessage());
        }

        toMail = '';
        ccMail = '';
        repMail = '';
    }

}