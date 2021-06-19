/********************************************************
* Author: josue.beltran 
* Date: 6/28/2020
* Project: CPQ_LAB
*------------------------------------------------------
* Comments:
*
*
********************************************************/

global with sharing class VDSingerPDFViewerController {
	public ID objectId {get;set;}
	public string NotificationURL {get;set;}
	public String currentName {get;set;}
	public docsMapsResutl    docMap {get;set;}
	public List<documentInfo>   docPlainList {get;set;}
	public List<VS4SF_DocumentDTO.Signers> available_Signers {get;set;}
	public String available_Signers_Def {get;set;}
	public List<VS4SF_DocumentDTO.Signers> selected_Signers {get;set;}
	public VS4SF_DocumentDTO.Signers current_Signer {get;set;}
	public VS4SF_DocumentDTO.VS4SF_DocumentRequestDTO ctx {get;set;}
	public ID PageID {get;set;}
	public cpqlab_2020__VIDSigner_Config__mdt config {get; set;}
	public String empPDF {get;set;}
	public String indPDF {get;set;}
	public String preLoadedPage {get;set;}
	public String file_b64_content {get;set;}
	public String apexFile {get;set;}
	public String contentVersionId {get;set;}
	public String file_name {get;set;}
	public String signature_page {get;set;} // 1
	public String signature_x {get;set;} //66
	public String signature_y {get;set;} //4
	public String signature_width {get;set;} //60
	public String signature_height {get;set;} //20
	public String cx_language {get;set;} //es
	public String cx_environment {get;set;} //PRE
	public String cx_subscription_user {get;set;} //AUTANACRMSubscriptionDemo
	public String cx_subscription_pass {get;set;} //ZNpeaY6Mt7F486b7n67q
	public String app_language {get;set;} //es
	public String question_page {get;set;} //1
	public String question_x {get;set;} //10
	public String question_y {get;set;} //250
	public String question_width {get;set;} //150
	public String question_height {get;set;} //10

	@AuraEnabled(Cacheable=true)
	public static String getSignerList(String objectID){
		String strRet;
		VDSingerPDFViewerController ctr = new VDSingerPDFViewerController(objectID);
		System.debug(ctr.available_Signers_Def);
		strRet =ctr.available_Signers_Def;

		return strRet;
	}
	public VDSingerPDFViewerController(String objectID) {
		this.objectId =objectID;
		this.initializeDefaults();
	}

	public VDSingerPDFViewerController() {
		this.objectId  = ApexPages.currentPage().getParameters().get('id');
		this.preLoadedPage = ApexPages.currentPage().getParameters().get('defaultPDF');
		System.debug(this.objectId);
		this.docMap = getRelatedFilesByRecordId(this.objectId);
		this.docPlainList = docMap.docPlainList;
		this.initializeDefaults();

	}
	public void initializeDefaults(){
		this.signature_page = '1';
		this.contentVersionId = null;
		this.signature_x ='66';
		this.signature_y ='4';
		this.signature_width ='60';
		this.signature_height ='20';
		this.app_language ='es';
		this.question_page ='1';
		this.question_x  ='10';
		this.question_y ='250';
		this.question_width ='150';
		this.question_height ='10';
		this.current_Signer = new VS4SF_DocumentDTO.Signers();
		this.selected_Signers = new List<VS4SF_DocumentDTO.Signers>();
		this.ctx = new VS4SF_DocumentDTO.VS4SF_DocumentRequestDTO();
		VS4SF_DocumentDTO.StampCertificateDTO stampCertificate = new VS4SF_DocumentDTO.StampCertificateDTO();
		VS4SF_DocumentDTO.SignatureNotificationEmailDTO notiMessage = new VS4SF_DocumentDTO.SignatureNotificationEmailDTO();
		this.currentName = UserInfo.getName();
		stampCertificate.CertificateGUI ='014da938-9d0d-4098-b0b2-793eced3a61f';
		stampCertificate.Pin='111';
		this.current_Signer.UserCertificateName = 'NIFAUTANACRM';
		this.current_Signer.DeviceName = 'AUTANACRM-2624-VIDM0000';
		this.current_Signer.StampCertificate = stampCertificate;
		this.current_Signer.Language = 'es';
		this.current_Signer.SignatureType = 'emailandsms';
		this.selected_Signers.add(current_Signer);
		this.ctx.Signers = selected_Signers;
		this.ctx.IssuerName = UserInfo.getName();
		Set<ID> AccountId = VS4SF_Utility.getRelatedLookupIdsOfSObject(this.objectId,'Account');
		try{

		//getAllConfig();
			this.available_Signers = new List<VS4SF_DocumentDTO.Signers>();
			List<Account> relateContacts =(List<Account>) [SELECT Id,AccountNumber,Name,Phone, ( SELECT MobilePhone, Name, Email, BirthDate FROM Contacts) FROM Account where Id IN :AccountId];
			Integer index = 1;
			for(Account cn : relateContacts){
				transient VS4SF_DocumentDTO.Visible  visible = new  VS4SF_DocumentDTO.Visible();
				visible.Page = 0;
				visible.PosX = Integer.valueOf(this.signature_x);
				visible.PosY = Integer.valueOf(this.signature_y);
				visible.SizeX = Integer.valueOf(this.signature_width);
				visible.SizeY = Integer.valueOf(this.signature_height);
				if(index == 1){
					this.current_Signer.NotificationEmailMessage = new VS4SF_DocumentDTO.SignatureNotificationEmailDTO();
					this.current_Signer.Visible = visible;
					this.current_Signer.Id = cn.Id;
					this.current_Signer.NumberID = cn.AccountNumber;
					this.current_Signer.SignerName = cn.Name;
					this.current_Signer.PhoneNumber =(cn.Contacts[0] != null) ?(cn.Contacts[0].MobilePhone != null)?cn.Contacts[0].MobilePhone:null:null;
					if(this.current_Signer.PhoneNumber != null){
						if(String.valueOf(this.current_Signer.PhoneNumber ).left(1) != '+' && String.valueOf(this.current_Signer.PhoneNumber ).left(2) != '00')
							this.current_Signer.PhoneNumber = '+34' + this.current_Signer.PhoneNumber ;
						//if Mobile phone has 00, replace it with +
						else if(String.valueOf(this.current_Signer.PhoneNumber ).left(2) == '00')
							this.current_Signer.PhoneNumber = '+34' + this.current_Signer.PhoneNumber.Right(this.current_Signer.PhoneNumber.length() -2);
					}
					this.current_Signer.DeviceName = null;
					this.current_Signer.eMail = (cn.Contacts[0] != null) ?(cn.Contacts[0].Email != null)?cn.Contacts[0].Email:null:null;
					this.current_Signer.sendSignedDoc = true;
					this.current_Signer.VerifyeMail = false;
					/*this.current_Signer.TypeOfID = cn.Tipo_de_Documento__c; */
					this.current_Signer.Language = 'es';
					this.current_Signer.SignatureType = 'emailandsms';
				}
				VS4SF_DocumentDTO.Signers signer = new VS4SF_DocumentDTO.Signers();
				signer.Visible = visible;
				signer.Id = cn.Id;
				signer.NotificationEmailMessage = new VS4SF_DocumentDTO.SignatureNotificationEmailDTO();
				signer.SignerName = cn.Name;
				//signer.Form = new VS4SF_DocumentDTO.Form();
				signer.NumberID = cn.AccountNumber;
				signer.DeviceName = null;
				signer.PhoneNumber =   (cn.Contacts[0] != null) ?(cn.Contacts[0].MobilePhone != null)?cn.Contacts[0].MobilePhone:null:null;
				if(signer.PhoneNumber != null ){
					if(String.valueOf(signer.PhoneNumber ).left(1) != '+' && String.valueOf(signer.PhoneNumber ).left(2) != '00')
						signer.PhoneNumber = '+34' + signer.PhoneNumber ;
					//if Mobile phone has 00, replace it with +
					else if(String.valueOf(signer.PhoneNumber ).left(2) == '00')
						signer.PhoneNumber = '+34' + signer.PhoneNumber.Right(signer.PhoneNumber.length() -2);
				}
				signer.Language = this.cx_language;
				signer.eMail =  (cn.Contacts[0] != null) ?(cn.Contacts[0].Email != null)?cn.Contacts[0].Email:null:null;
				signer.sendSignedDoc = true;
				signer.VerifyeMail = false;
			//	signer.TypeOfID = cn.Tipo_de_Documento__c;
				signer.SignatureType = 'emailandsms';
				this.available_Signers.add(signer);
				System.debug(this.available_Signers);
				this.available_Signers_Def = JSON.serialize(this.available_Signers);
				System.debug(this.available_Signers_Def);
			}
		}catch (Exception e){

		}

	}
	public PageReference doRedirect(){
		PageReference pageRef = new PageReference('/apex/VIDSingerForSalesforce_Step2?id='+ this.PageID );
		pageRef.setRedirect(true);
		return pageRef;
	}
	@RemoteAction
	global static String generateContract(String contractId, String pageName){
		PageReference  defaultPage = VS4SF_Utility.getPagRefFromPageName( contractId);
		if(defaultPage != null){
			defaultPage.getParameters().put('id', contractId); //passing in id for specific record
			Blob pageData; //variable to hold binary PDF data.

			if(!Test.isRunningTest()){ // for code coverage
				pageData = defaultPage.getContentAsPDF();
			} else {
				pageData = Blob.valueOf('This is a test.');
			}
			return EncodingUtil.base64Encode(pageData);
		}
		return null;
	}


	@AuraEnabled(cacheable=true)
	public static docsMapsResutl getRelatedFilesByRecordId(ID recordId) {
		System.debug(recordId);
		transient  docsMapsResutl mapResult = new docsMapsResutl();
		List<ContentDocumentLink> files = [SELECT ContentDocument.LatestPublishedVersionId , ContentDocumentId FROM ContentDocumentLink WHERE LinkedEntityId = :recordId];
		List<ID> fileIDs = new List<ID>();
		for (ContentDocumentLink docLink : files) {
			fileIDs.add(docLink.ContentDocumentId);
		}

		// Filter PDF files
		List<ContentVersion> docs = [SELECT Id, ContentDocumentId, FileExtension,VersionData, Title
		FROM ContentVersion WHERE ContentDocumentId IN : fileIDs ];
		Map<ID, String> mapIdTitle = new Map<ID, String>();
		Map<ID, String> mapIdContent = new Map<ID, String>();
		List<documentInfo> PlainList = new List<documentInfo>();
		Integer indexC = 0;
		for (ContentVersion docLink : docs)
		{
			documentInfo docInfo = new documentInfo();
			mapIdTitle.put(docLink.Id, docLink.Title);
			//mapIdContent.put(docLink.Id, EncodingUtil.base64Encode(docLink.VersionData)   );
			docInfo.theIndex = indexC;
			docInfo.theContentVersionId = docLink.Id;
			docInfo.theFileExtension = docLink.FileExtension;
			docInfo.theTitle = docLink.Title;
			//docInfo.theContent = EncodingUtil.base64Encode(docLink.VersionData);
			PlainList.add(docInfo);
			indexC++;
		}
		mapResult.mapDocInfo = mapIdTitle;
		mapResult.mapDocData = mapIdContent;
		mapResult.docPlainList = PlainList;
		return mapResult;
	}
	@RemoteAction
	global static String getVersionData(String contentVersionId){
		Blob returnString = null;
		try{
			// Filter PDF files
			ContentVersion docLink = [SELECT Id, ContentDocumentId, FileExtension,VersionData, Title
			FROM ContentVersion WHERE Id =: contentVersionId ];
			returnString = docLink.VersionData;
			System.debug(returnString);
		}catch(Exception e){
			System.debug(e.getMessage());
		}
		System.debug(returnString);

		return EncodingUtil.base64Encode(returnString);
	}
	@RemoteAction
	global static String sendPreviousMail(String fileName, ID objectId,String signerList, String draftContent) {
		String responseString = null;
		//System.debug(request);
		List<VS4SF_DocumentDTO.Signers> signers = (List<VS4SF_DocumentDTO.Signers>) JSON.deserialize(signerList, List<VS4SF_DocumentDTO.Signers>.class);
		//Map<String, Object> requestOne = (Map<String, Object>) JSON.deserializeUntyped(request);
		Set<ID> AccountId = VS4SF_Utility.getRelatedLookupIdsOfSObject(objectId,'Account');
		List<Account> relateContacts =(List<Account>) [SELECT Id,AccountNumber,	Name,	Phone, ( SELECT MobilePhone, Name, Email, BirthDate FROM Contacts ) FROM Account where Id IN :AccountId];
		String contactEmail  = (relateContacts[0].Contacts[0] != null) ? relateContacts[0].Contacts[0].MobilePhone :  relateContacts[0].Phone;
		if (draftContent != null) {
			String[]  recipients = new String[]{};

			EmailTemplate emailTemplate = [SELECT Id,
					Subject,
					Description,
					HtmlValue,
					DeveloperName,
					Body FROM EmailTemplate
			WHERE Name = 'VIDSigner_RevisionContrato'];
			List < String > sendTo = new List < String >();
			for(VS4SF_DocumentDTO.Signers signer: signers){
				sendTo.add(signer.eMail.trim());
			}

			emailSendingClass emailService = new emailSendingClass();

			emailService.to_Addresses =sendTo;
			emailService.templateId = emailTemplate.Id;
			emailService.targetObjectId = relateContacts[0].Contacts[0].Id;
			emailService.attBase64 = draftContent;
			emailService.attName = fileName;
			System.debug(emailService);
			emailService.sendMail();
			responseString = 'OK';
		}
		return responseString;
	}
	@future
	public static void insertLog(String docID ,ID objectId){
		String adminUserEmail = null;
		Boolean esProduccion = [SELECT IsSandbox, InstanceName FROM Organization LIMIT 1].IsSandbox;
		List<VIDSigner_Config__mdt> mcs = VIDSigner_Config__mdt.getall().values();
		for(VIDSigner_Config__mdt cf : mcs){
			if (!cf.Es_productivo__c == esProduccion) {
				adminUserEmail = cf.Correo_administrador__c;

			}

		}
		VIDSigner_Document__c monitor = new VIDSigner_Document__c();
		monitor.DocumentId__c = docID;
		monitor.NotifyToUser__c = UserInfo.getUserEmail();
		monitor.NotifyToAdmin__c = adminUserEmail;
		monitor.Contrato__c = objectId;
		monitor.Status__c = 'Enviado';
		System.debug(monitor);
		insert monitor;
		//sendPreviousMail(request,contactEmail , contactId, accountId, draftContent);
	}



	@RemoteAction
	global static String uploadDoc(ID objectId,String request)
	{
		String responseString = null;
		System.debug(request);
		//sendPreviousMail(request);
		HttpResponse response = VIDSignerIntegrationService.getHTTPResponse('Documents',request );
		System.debug('Response Documents');
		System.debug(response);
		responseString = response.getStatusCode() + ',' +response.getBody() ;
		if(response.getStatusCode() == 200){
			Map<String, Object> doc = (Map<String, Object>) JSON.deserializeUntyped(response.getBody());
			String docID = doc.get('DocGUI').toString();
			System.debug(docID);
			insertLog(docID ,objectId);
		}
		return responseString;
	}
	global static String getSignedDoc(String docGUID)
	{
		HttpResponse  response = null;
		String responseString = null;
		System.debug(docGUID);
		response = VIDSignerIntegrationService.getHTTPResponse(null,'getSignedDoc',docGUID);
		System.debug('Response Documents');
		System.debug(response);
		if(response.getStatusCode() == 200){
			responseString = response.getBody();
			Map<String, Object> doc = (Map<String, Object>) JSON.deserializeUntyped(responseString);
			responseString =  doc.get('DocContent').toString();

		}

		return responseString;
	}
// -----------------------------------------------------------------------------
// --------------------------- Page Structures ---------------------------------
// -----------------------------------------------------------------------------


	public class docsMapsResutl{
		@AuraEnabled
		public Map<ID, String> mapDocInfo {get;set;}
		@AuraEnabled
		public Map<ID, String> mapDocData {get;set;}
		public List<documentInfo>   docPlainList {get;set;}

		public docsMapsResutl(){
			this.mapDocData = new Map<ID, String>();
			this.mapDocInfo = new Map<ID, String>();
			this.docPlainList = new List<documentInfo>();
		}
	}
	public class documentInfo {
		public Integer theIndex {get;set;}
		public String theTitle {get;set;}
		public String theFileExtension {get;set;}
		public String theContent {get;set;}
		public String theContentVersionId {get; set;}
	}

	public void getAllConfig(){
		//Boolean esProduccion = [SELECT IsSandbox, InstanceName FROM Organization LIMIT 1].IsSandbox;
		Boolean esProduccion = false;
		List<cpqlab_2020__VIDSigner_Config__mdt> mcs =  cpqlab_2020__VIDSigner_Config__mdt.getall().values();
		for(cpqlab_2020__VIDSigner_Config__mdt cf : mcs){

			if (!cf.cpqlab_2020__Es_productivo__c == esProduccion) {
				this.config  =cf;
				this.cx_language =cf.cpqlab_2020__Language__c;
				this.cx_environment =cf.cpqlab_2020__environment__c;
				this.cx_subscription_user =cf.cpqlab_2020__subscription_user__c;
				this.cx_subscription_pass =cf.cpqlab_2020__subscription_pass__c;
				this.indPDF = cf.cpqlab_2020__PDF_Particular__c;
				this.empPDF = cf.cpqlab_2020__PDF_Empresas__c;
				this.NotificationURL = cf.cpqlab_2020__URL_de_Notificaciones__c;
			}

		}

	}

}