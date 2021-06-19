/**
 * Created by Administrador 1 on 05/06/2021.
 */

@IsTest(SeeAllData=true)
public with sharing class VIDSignerControllerTestBis {
    public static testmethod void testBehavior() {

        Test.setMock(HttpCalloutMock.class, new MockVIDSignerReceiverMessage());
        Test.startTest();
        StaticResource sr= [SELECT Id, Body FROM StaticResource WHERE Name = 'createDocumentsRequest'];
        String  cd = sr.Body.toString();
        Contract contrato = [SELECT Id FROM Contract WHERE AccountId <> null  LIMIT 1];
        VDSingerPDFViewerController controllerTest = new VDSingerPDFViewerController(contrato.Id);

        //VDSingerPDFViewerController.sendPreviousMail('PDFContract_Particular_2021 (DEMO).pdf' ,'8001t000000QYE9AAO', 'JVBERi0xLjMKMyAwIG9iago8PC9UeXBlIC9QYWdlCi9QYXJlbnQgMSAwIFIKL1Jlc291cmNlcyAyIDAgUgovTWVkaWFCb3ggWzAgMCA1OTUuMjggODQxLjg5XQovQ29udGVudHMgNCAwIFIKPj4KZW5kb2JqCjQgMCBvYmoKPDwvTGVuZ3RoIDEzMz4+CnN0cmVhbQowLjIwIHcKMCBHCkJUCi9GMSAxNiBUZgoxOC40IFRMCjAgZwoxMDAuMDAgNzQxLjg5IFRkCihmaXJzdCBwYWdlKSBUagpFVApCVAovRjEgMTYgVGYKMTguNCBUTAowLjU4OCBnCjUwLjAwIDMwLjAwIFRkCihXYXRlcm1hcmspIFRqCkVUCmVuZHN0cmVhbQplbmRvYmoKNSAwIG9iago8PC9UeXBlIC9QYWdlCi9QYXJlbnQgMSAwIFIKL1Jlc291cmNlcyAyIDAgUgovTWVkaWFCb3ggWzAgMCA1OTUuMjggODQxLjg5XQovQ29udGVudHMgNiAwIFIKPj4KZW5kb2JqCjYgMCBvYmoKPDwvTGVuZ3RoIDEzND4+CnN0cmVhbQowLjIwIHcKMCBHCkJUCi9GMSAxNiBUZgoxOC40IFRMCjAgZwoxMDAuMDAgNzQxLjg5IFRkCihzZWNvbmQgcGFnZSkgVGoKRVQKQlQKL0YxIDE2IFRmCjE4LjQgVEwKMC41ODggZwo1MC4wMCAzMC4wMCBUZAooV2F0ZXJtYXJrKSBUagpFVAplbmRzdHJlYW0KZW5kb2JqCjEgMCBvYmoKPDwvVHlwZSAvUGFnZXMKL0tpZHMgWzMgMCBSIDUgMCBSIF0KL0NvdW50IDIKPj4KZW5kb2JqCjcgMCBvYmoKPDwvQmFzZUZvbnQvSGVsdmV0aWNhL1R5cGUvRm9udAovRW5jb2RpbmcvV2luQW5zaUVuY29kaW5nCi9TdWJ0eXBlL1R5cGUxPj4KZW5kb2JqCjggMCBvYmoKPDwvQmFzZUZvbnQvSGVsdmV0aWNhLUJvbGQvVHlwZS9Gb250Ci9FbmNvZGluZy9XaW5BbnNpRW5jb2RpbmcKL1N1YnR5cGUvVHlwZTE+PgplbmRvYmoKOSAwIG9iago8PC9CYXNlRm9udC9IZWx2ZXRpY2EtT2JsaXF1ZS9UeXBlL0ZvbnQKL0VuY29kaW5nL1dpbkFuc2lFbmNvZGluZwovU3VidHlwZS9UeXBlMT4+CmVuZG9iagoxMCAwIG9iago8PC9CYXNlRm9udC9IZWx2ZXRpY2EtQm9sZE9ibGlxdWUvVHlwZS9Gb250Ci9FbmNvZGluZy9XaW5BbnNpRW5jb2RpbmcKL1N1YnR5cGUvVHlwZTE+PgplbmRvYmoKMTEgMCBvYmoKPDwvQmFzZUZvbnQvQ291cmllci9UeXBlL0ZvbnQKL0VuY29kaW5nL1dpbkFuc2lFbmNvZGluZwovU3VidHlwZS9UeXBlMT4+CmVuZG9iagoxMiAwIG9iago8PC9CYXNlRm9udC9Db3VyaWVyLUJvbGQvVHlwZS9Gb250Ci9FbmNvZGluZy9XaW5BbnNpRW5jb2RpbmcKL1N1YnR5cGUvVHlwZTE+PgplbmRvYmoKMTMgMCBvYmoKPDwvQmFzZUZvbnQvQ291cmllci1PYmxpcXVlL1R5cGUvRm9udAovRW5jb2RpbmcvV2luQW5zaUVuY29kaW5nCi9TdWJ0eXBlL1R5cGUxPj4KZW5kb2JqCjE0IDAgb2JqCjw8L0Jhc2VGb250L0NvdXJpZXItQm9sZE9ibGlxdWUvVHlwZS9Gb250Ci9FbmNvZGluZy9XaW5BbnNpRW5jb2RpbmcKL1N1YnR5cGUvVHlwZTE+PgplbmRvYmoKMTUgMCBvYmoKPDwvQmFzZUZvbnQvVGltZXMtUm9tYW4vVHlwZS9Gb250Ci9FbmNvZGluZy9XaW5BbnNpRW5jb2RpbmcKL1N1YnR5cGUvVHlwZTE+PgplbmRvYmoKMTYgMCBvYmoKPDwvQmFzZUZvbnQvVGltZXMtQm9sZC9UeXBlL0ZvbnQKL0VuY29kaW5nL1dpbkFuc2lFbmNvZGluZwovU3VidHlwZS9UeXBlMT4+CmVuZG9iagoxNyAwIG9iago8PC9CYXNlRm9udC9UaW1lcy1JdGFsaWMvVHlwZS9Gb250Ci9FbmNvZGluZy9XaW5BbnNpRW5jb2RpbmcKL1N1YnR5cGUvVHlwZTE+PgplbmRvYmoKMTggMCBvYmoKPDwvQmFzZUZvbnQvVGltZXMtQm9sZEl0YWxpYy9UeXBlL0ZvbnQKL0VuY29kaW5nL1dpbkFuc2lFbmNvZGluZwovU3VidHlwZS9UeXBlMT4+CmVuZG9iagoxOSAwIG9iago8PC9CYXNlRm9udC9aYXBmRGluZ2JhdHMvVHlwZS9Gb250Ci9FbmNvZGluZy9TdGFuZGFyZEVuY29kaW5nCi9TdWJ0eXBlL1R5cGUxPj4KZW5kb2JqCjIgMCBvYmoKPDwKL1Byb2NTZXQgWy9QREYgL1RleHQgL0ltYWdlQiAvSW1hZ2VDIC9JbWFnZUldCi9Gb250IDw8Ci9GMSA3IDAgUgovRjIgOCAwIFIKL0YzIDkgMCBSCi9GNCAxMCAwIFIKL0Y1IDExIDAgUgovRjYgMTIgMCBSCi9GNyAxMyAwIFIKL0Y4IDE0IDAgUgovRjkgMTUgMCBSCi9GMTAgMTYgMCBSCi9GMTEgMTcgMCBSCi9GMTIgMTggMCBSCi9GMTMgMTkgMCBSCj4+Ci9YT2JqZWN0IDw8Cj4+Cj4+CmVuZG9iagoyMCAwIG9iago8PAovUHJvZHVjZXIgKGpzUERGIDEueC1tYXN0ZXIpCi9DcmVhdGlvbkRhdGUgKEQ6MjAyMDExMDUxNDA1NDItMDYnMDAnKQo+PgplbmRvYmoKMjEgMCBvYmoKPDwKL1R5cGUgL0NhdGFsb2cKL1BhZ2VzIDEgMCBSCi9PcGVuQWN0aW9uIFszIDAgUiAvRml0SCBudWxsXQovUGFnZUxheW91dCAvT25lQ29sdW1uCj4+CmVuZG9iagp4cmVmCjAgMjIKMDAwMDAwMDAwMCA2NTUzNSBmIAowMDAwMDAwNTkyIDAwMDAwIG4gCjAwMDAwMDE4OTQgMDAwMDAgbiAKMDAwMDAwMDAwOSAwMDAwMCBuIAowMDAwMDAwMTE4IDAwMDAwIG4gCjAwMDAwMDAzMDAgMDAwMDAgbiAKMDAwMDAwMDQwOSAwMDAwMCBuIAowMDAwMDAwNjU1IDAwMDAwIG4gCjAwMDAwMDA3NDUgMDAwMDAgbiAKMDAwMDAwMDg0MCAwMDAwMCBuIAowMDAwMDAwOTM4IDAwMDAwIG4gCjAwMDAwMDEwNDEgMDAwMDAgbiAKMDAwMDAwMTEzMCAwMDAwMCBuIAowMDAwMDAxMjI0IDAwMDAwIG4gCjAwMDAwMDEzMjEgMDAwMDAgbiAKMDAwMDAwMTQyMiAwMDAwMCBuIAowMDAwMDAxNTE1IDAwMDAwIG4gCjAwMDAwMDE2MDcgMDAwMDAgbiAKMDAwMDAwMTcwMSAwMDAwMCBuIAowMDAwMDAxNzk5IDAwMDAwIG4gCjAwMDAwMDIxMzIgMDAwMDAgbiAKMDAwMDAwMjIyMyAwMDAwMCBuIAp0cmFpbGVyCjw8Ci9TaXplIDIyCi9Sb290IDIxIDAgUgovSW5mbyAyMCAwIFIKPj4Kc3RhcnR4cmVmCjIzMjcKJSVFT0Y=');
        VDSingerPDFViewerController.uploadDoc(contrato.Id,cd);
        VIDSignerAttachSignedDocAsyncCls.insertAsyncMessage('a52e1ef0-c1ed-4000-ae9f-348f0c3e59e5',contrato.Id,'PDFContract_Particular_2021 (DEMO).pdf' );
        VIDSignerAttachSignedDocAsyncCls.handleAsyncMessage('a52e1ef0-c1ed-4000-ae9f-348f0c3e59e5','PDFContract_Particular_2021 (DEMO).pdf',contrato.Id);
        List<VS4SF_DocumentDTO.Signers> available_Signers = new List<VS4SF_DocumentDTO.Signers>();
        String available_Signers_Def = null;
        List<VS4SF_DocumentDTO.Signers> selected_Signers  = new List<VS4SF_DocumentDTO.Signers>();
        VS4SF_DocumentDTO.Signers current_Signer  = new VS4SF_DocumentDTO.Signers();
        VS4SF_DocumentDTO.VS4SF_DocumentRequestDTO ctx = new VS4SF_DocumentDTO.VS4SF_DocumentRequestDTO();

        StaticResource sr2= [SELECT Id, Body FROM StaticResource WHERE Name = 'getSignedDocsResponse'];
        String  cd2 = sr2.Body.toString();

        VIDSignerDocSignedResponse Wrapper  = (VIDSignerDocSignedResponse) JSON.deserialize(cd2, VIDSignerDocSignedResponse.class);
        Test.stopTest();

    }


    public static testmethod void testBehaviorSend() {

        Test.setMock(HttpCalloutMock.class, new MockVIDSignerReceiverMessage());
        Test.startTest();
        VS4SF_DocumentDTO.Visible  visible = new  VS4SF_DocumentDTO.Visible();
        visible.Page = 0;
        visible.PosX = Integer.valueOf('12');
        visible.PosY = Integer.valueOf('12');
        visible.SizeX = Integer.valueOf('12');
        visible.SizeY = Integer.valueOf('12');
        VS4SF_DocumentDTO.Signers signer = new VS4SF_DocumentDTO.Signers();
        signer.Visible = visible;
        signer.Id = 'asawsqa';
        signer.NotificationEmailMessage = new VS4SF_DocumentDTO.SignatureNotificationEmailDTO();
        signer.SignerName = 'asasas';
        //signer.Form = new VS4SF_DocumentDTO.Form();
        signer.NumberID = 'ssdada';
        signer.DeviceName = null;
        signer.PhoneNumber = '+5281234518298';
        signer.Language = 'es';
        signer.eMail ='jbeltran@gmail.com';
        signer.sendSignedDoc = true;
        signer.VerifyeMail = false;
        signer.TypeOfID = 'NIF';
        signer.SignatureType = 'emailandsms';
        List<VS4SF_DocumentDTO.Signers>available_Signers = new   List<VS4SF_DocumentDTO.Signers>();
        available_Signers.add(signer);
        Contract  contrato1 = [SELECT Id FROM Contract where AccountId <> null LIMIT 1];

        VDSingerPDFViewerController.generateContract( contrato1.Id,'Empresas');
        //  String signrs = JSON.serializePretty( JSON.deserializeUntyped('[{"Visible":{"Page":4,"PosX":30,"PosY":48,"SizeX":"60","SizeY":"20","anchor":null},"VerifyeMail":false,"TypeOfID":"DNI","SkipSignatureEmail":false,"SignerName":"Karelia Sanoja Figueroa","SignatureType":"emailandsms","sendSignedDoc":true,"PhoneNumber":"+34625186674","NumberID":"52062062K","NotificationEmailMessage":{"eMailBody":"Estimados,\\n\\nOs mandamos el contrato para que, si estáis de acuerdo con todo, me lo mandéis firmado junto con el justificante de la señal. Necesitamos que esta gestión sea lo más rápida posible.\\n\\nCualquier consulta no dudéis en escribirnos.\\n\\nUn saludo,","eMailSubject":"Firma Digital de su contrato con Grupo Mónico"},"Language":"es","isDigitalIdUser":null,"Form":{"Layout":{"FontFamily":"Times-Roman","FontSize":"11"},"Sections":[{"Groups":[{"Title":null,"RadioButtons":null,"TextBoxes":null,"CheckBoxes":[{"Title":{"Text":"LEY DE PROTECCIÓN DE DATOS: INDIQUE SU CONFORMIDAD","Position":{"Page":4,"PosX":28,"PosY":142,"SizeX":150,"SizeY":10,"Anchor":""}},"Id":"_zjivt84yu"}]}]}]},"eMail":"ksanoja@autanacrm.com","DocusignSigner":null},{"SignerName":"Josue","TypeOfID":"Pasaporte","NumberID":"123123GG","eMail":"josue.beltran.u@gmail.com","SignatureType":"emailandsms","PhoneNumber":"+34610094030","Language":"es","Visible":{"Page":4,"PosX":42,"PosY":76,"SizeX":"60","SizeY":"20","anchor":null},"NotificationEmailMessage":{"eMailBody":"pppppp","eMailSubject":"Prueba Contrato Karelia"},"sendSignedDoc":true,"SkipSignatureEmail":false}]'));
        VDSingerPDFViewerController.sendPreviousMail('PDFContract_Particular_2021 (DEMO).pdf' ,contrato1.Id,  JSON.serialize(available_Signers) , 'JVBERi0xLjMKMyAwIG9iago8PC9UeXBlIC9QYWdlCi9QYXJlbnQgMSAwIFIKL1Jlc291cmNlcyAyIDAgUgovTWVkaWFCb3ggWzAgMCA1OTUuMjggODQxLjg5XQovQ29udGVudHMgNCAwIFIKPj4KZW5kb2JqCjQgMCBvYmoKPDwvTGVuZ3RoIDEzMz4+CnN0cmVhbQowLjIwIHcKMCBHCkJUCi9GMSAxNiBUZgoxOC40IFRMCjAgZwoxMDAuMDAgNzQxLjg5IFRkCihmaXJzdCBwYWdlKSBUagpFVApCVAovRjEgMTYgVGYKMTguNCBUTAowLjU4OCBnCjUwLjAwIDMwLjAwIFRkCihXYXRlcm1hcmspIFRqCkVUCmVuZHN0cmVhbQplbmRvYmoKNSAwIG9iago8PC9UeXBlIC9QYWdlCi9QYXJlbnQgMSAwIFIKL1Jlc291cmNlcyAyIDAgUgovTWVkaWFCb3ggWzAgMCA1OTUuMjggODQxLjg5XQovQ29udGVudHMgNiAwIFIKPj4KZW5kb2JqCjYgMCBvYmoKPDwvTGVuZ3RoIDEzND4+CnN0cmVhbQowLjIwIHcKMCBHCkJUCi9GMSAxNiBUZgoxOC40IFRMCjAgZwoxMDAuMDAgNzQxLjg5IFRkCihzZWNvbmQgcGFnZSkgVGoKRVQKQlQKL0YxIDE2IFRmCjE4LjQgVEwKMC41ODggZwo1MC4wMCAzMC4wMCBUZAooV2F0ZXJtYXJrKSBUagpFVAplbmRzdHJlYW0KZW5kb2JqCjEgMCBvYmoKPDwvVHlwZSAvUGFnZXMKL0tpZHMgWzMgMCBSIDUgMCBSIF0KL0NvdW50IDIKPj4KZW5kb2JqCjcgMCBvYmoKPDwvQmFzZUZvbnQvSGVsdmV0aWNhL1R5cGUvRm9udAovRW5jb2RpbmcvV2luQW5zaUVuY29kaW5nCi9TdWJ0eXBlL1R5cGUxPj4KZW5kb2JqCjggMCBvYmoKPDwvQmFzZUZvbnQvSGVsdmV0aWNhLUJvbGQvVHlwZS9Gb250Ci9FbmNvZGluZy9XaW5BbnNpRW5jb2RpbmcKL1N1YnR5cGUvVHlwZTE+PgplbmRvYmoKOSAwIG9iago8PC9CYXNlRm9udC9IZWx2ZXRpY2EtT2JsaXF1ZS9UeXBlL0ZvbnQKL0VuY29kaW5nL1dpbkFuc2lFbmNvZGluZwovU3VidHlwZS9UeXBlMT4+CmVuZG9iagoxMCAwIG9iago8PC9CYXNlRm9udC9IZWx2ZXRpY2EtQm9sZE9ibGlxdWUvVHlwZS9Gb250Ci9FbmNvZGluZy9XaW5BbnNpRW5jb2RpbmcKL1N1YnR5cGUvVHlwZTE+PgplbmRvYmoKMTEgMCBvYmoKPDwvQmFzZUZvbnQvQ291cmllci9UeXBlL0ZvbnQKL0VuY29kaW5nL1dpbkFuc2lFbmNvZGluZwovU3VidHlwZS9UeXBlMT4+CmVuZG9iagoxMiAwIG9iago8PC9CYXNlRm9udC9Db3VyaWVyLUJvbGQvVHlwZS9Gb250Ci9FbmNvZGluZy9XaW5BbnNpRW5jb2RpbmcKL1N1YnR5cGUvVHlwZTE+PgplbmRvYmoKMTMgMCBvYmoKPDwvQmFzZUZvbnQvQ291cmllci1PYmxpcXVlL1R5cGUvRm9udAovRW5jb2RpbmcvV2luQW5zaUVuY29kaW5nCi9TdWJ0eXBlL1R5cGUxPj4KZW5kb2JqCjE0IDAgb2JqCjw8L0Jhc2VGb250L0NvdXJpZXItQm9sZE9ibGlxdWUvVHlwZS9Gb250Ci9FbmNvZGluZy9XaW5BbnNpRW5jb2RpbmcKL1N1YnR5cGUvVHlwZTE+PgplbmRvYmoKMTUgMCBvYmoKPDwvQmFzZUZvbnQvVGltZXMtUm9tYW4vVHlwZS9Gb250Ci9FbmNvZGluZy9XaW5BbnNpRW5jb2RpbmcKL1N1YnR5cGUvVHlwZTE+PgplbmRvYmoKMTYgMCBvYmoKPDwvQmFzZUZvbnQvVGltZXMtQm9sZC9UeXBlL0ZvbnQKL0VuY29kaW5nL1dpbkFuc2lFbmNvZGluZwovU3VidHlwZS9UeXBlMT4+CmVuZG9iagoxNyAwIG9iago8PC9CYXNlRm9udC9UaW1lcy1JdGFsaWMvVHlwZS9Gb250Ci9FbmNvZGluZy9XaW5BbnNpRW5jb2RpbmcKL1N1YnR5cGUvVHlwZTE+PgplbmRvYmoKMTggMCBvYmoKPDwvQmFzZUZvbnQvVGltZXMtQm9sZEl0YWxpYy9UeXBlL0ZvbnQKL0VuY29kaW5nL1dpbkFuc2lFbmNvZGluZwovU3VidHlwZS9UeXBlMT4+CmVuZG9iagoxOSAwIG9iago8PC9CYXNlRm9udC9aYXBmRGluZ2JhdHMvVHlwZS9Gb250Ci9FbmNvZGluZy9TdGFuZGFyZEVuY29kaW5nCi9TdWJ0eXBlL1R5cGUxPj4KZW5kb2JqCjIgMCBvYmoKPDwKL1Byb2NTZXQgWy9QREYgL1RleHQgL0ltYWdlQiAvSW1hZ2VDIC9JbWFnZUldCi9Gb250IDw8Ci9GMSA3IDAgUgovRjIgOCAwIFIKL0YzIDkgMCBSCi9GNCAxMCAwIFIKL0Y1IDExIDAgUgovRjYgMTIgMCBSCi9GNyAxMyAwIFIKL0Y4IDE0IDAgUgovRjkgMTUgMCBSCi9GMTAgMTYgMCBSCi9GMTEgMTcgMCBSCi9GMTIgMTggMCBSCi9GMTMgMTkgMCBSCj4+Ci9YT2JqZWN0IDw8Cj4+Cj4+CmVuZG9iagoyMCAwIG9iago8PAovUHJvZHVjZXIgKGpzUERGIDEueC1tYXN0ZXIpCi9DcmVhdGlvbkRhdGUgKEQ6MjAyMDExMDUxNDA1NDItMDYnMDAnKQo+PgplbmRvYmoKMjEgMCBvYmoKPDwKL1R5cGUgL0NhdGFsb2cKL1BhZ2VzIDEgMCBSCi9PcGVuQWN0aW9uIFszIDAgUiAvRml0SCBudWxsXQovUGFnZUxheW91dCAvT25lQ29sdW1uCj4+CmVuZG9iagp4cmVmCjAgMjIKMDAwMDAwMDAwMCA2NTUzNSBmIAowMDAwMDAwNTkyIDAwMDAwIG4gCjAwMDAwMDE4OTQgMDAwMDAgbiAKMDAwMDAwMDAwOSAwMDAwMCBuIAowMDAwMDAwMTE4IDAwMDAwIG4gCjAwMDAwMDAzMDAgMDAwMDAgbiAKMDAwMDAwMDQwOSAwMDAwMCBuIAowMDAwMDAwNjU1IDAwMDAwIG4gCjAwMDAwMDA3NDUgMDAwMDAgbiAKMDAwMDAwMDg0MCAwMDAwMCBuIAowMDAwMDAwOTM4IDAwMDAwIG4gCjAwMDAwMDEwNDEgMDAwMDAgbiAKMDAwMDAwMTEzMCAwMDAwMCBuIAowMDAwMDAxMjI0IDAwMDAwIG4gCjAwMDAwMDEzMjEgMDAwMDAgbiAKMDAwMDAwMTQyMiAwMDAwMCBuIAowMDAwMDAxNTE1IDAwMDAwIG4gCjAwMDAwMDE2MDcgMDAwMDAgbiAKMDAwMDAwMTcwMSAwMDAwMCBuIAowMDAwMDAxNzk5IDAwMDAwIG4gCjAwMDAwMDIxMzIgMDAwMDAgbiAKMDAwMDAwMjIyMyAwMDAwMCBuIAp0cmFpbGVyCjw8Ci9TaXplIDIyCi9Sb290IDIxIDAgUgovSW5mbyAyMCAwIFIKPj4Kc3RhcnR4cmVmCjIzMjcKJSVFT0Y=');

        Test.stopTest();

    }
}
