/********************************************************
* Author: josue.beltran 
* Date: 6/7/2020
* Project: CPQ_LAB
*------------------------------------------------------
* Comments:
*
*
********************************************************/

public with sharing class VS4SF_DocumentDTO {
/* public class Condition {
		public String Id {get;set;}
		public Integer Result {get;set;}
		public Condition(JSONParser parser) {
			while (parser.nextToken() != System.JSONToken.END_OBJECT) {
				if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
					String text = parser.getText();
					if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
						if (text == 'Id') {
							Id = parser.getText();
						} else if (text == 'Result') {
							Result = parser.getIntegerValue();
						} else {
							System.debug(LoggingLevel.WARN, 'Condition consuming unrecognized property: '+text);
							consumeObject(parser);
						}
					}
				}
			}
		}
	}

	public class CheckBoxes {
		public String Id {get;set;}
		public Title Title {get;set;}
		public Object Condition {get;set;}
		public Boolean Response {get;set;}

		public CheckBoxes(JSONParser parser) {
			while (parser.nextToken() != System.JSONToken.END_OBJECT) {
				if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
					String text = parser.getText();
					if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
						if (text == 'Id') {
							Id = parser.getText();
						} else if (text == 'Title') {
							Title = new Title(parser);
						} else if (text == 'Condition') {
							Condition = parser.readValueAs(Object.class);
						} else if (text == 'Response') {
							Response = parser.getBooleanValue();
						} else {
							System.debug(LoggingLevel.WARN, 'CheckBoxes consuming unrecognized property: '+text);
							consumeObject(parser);
						}
					}
				}
			}
		}
	}

	public class Position {
		public Integer PosX {get;set;}
		public Integer PosY {get;set;}
		public Integer SizeX {get;set;}
		public Integer Page {get;set;}

		public Position(JSONParser parser) {
			while (parser.nextToken() != System.JSONToken.END_OBJECT) {
				if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
					String text = parser.getText();
					if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
						if (text == 'PosX') {
							PosX = parser.getIntegerValue();
						} else if (text == 'PosY') {
							PosY = parser.getIntegerValue();
						} else if (text == 'SizeX') {
							SizeX = parser.getIntegerValue();
						} else if (text == 'Page') {
							Page = parser.getIntegerValue();
						} else {
							System.debug(LoggingLevel.WARN, 'Position consuming unrecognized property: '+text);
							consumeObject(parser);
						}
					}
				}
			}
		}
	}


	public class Groups_Z {
		public Title Title {get;set;}
		public Object RadioButtons {get;set;}
		public List<CheckBoxes> CheckBoxes {get;set;}
		public List<TextBoxes_Z> TextBoxes {get;set;}

		public Groups_Z(JSONParser parser) {
			while (parser.nextToken() != System.JSONToken.END_OBJECT) {
				if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
					String text = parser.getText();
					if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
						if (text == 'Title') {
							Title = new Title(parser);
						} else if (text == 'RadioButtons') {
							RadioButtons = parser.readValueAs(Object.class);
						} else if (text == 'CheckBoxes') {
							CheckBoxes = arrayOfCheckBoxes(parser);
						} else if (text == 'TextBoxes') {
							TextBoxes = arrayOfTextBoxes_Z(parser);
						} else {
							System.debug(LoggingLevel.WARN, 'Groups_Z consuming unrecognized property: '+text);
							consumeObject(parser);
						}
					}
				}
			}
		}
	}

	public class RadioButtons {
		public String Id {get;set;}
		public Title Title {get;set;}
		public List<Choices> Choices {get;set;}
		public Object Condition {get;set;}
		public Integer SelectedChoice {get;set;}

		public RadioButtons(JSONParser parser) {
			while (parser.nextToken() != System.JSONToken.END_OBJECT) {
				if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
					String text = parser.getText();
					if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
						if (text == 'Id') {
							Id = parser.getText();
						} else if (text == 'Title') {
							Title = new Title(parser);
						} else if (text == 'Choices') {
							Choices = arrayOfChoices(parser);
						} else if (text == 'Condition') {
							Condition = parser.readValueAs(Object.class);
						} else if (text == 'SelectedChoice') {
							SelectedChoice = parser.getIntegerValue();
						} else {
							System.debug(LoggingLevel.WARN, 'RadioButtons consuming unrecognized property: '+text);
							consumeObject(parser);
						}
					}
				}
			}
		}
	}
	public class Title {
		public String Text {get;set;}
		public Position Position {get;set;}

		public Title(JSONParser parser) {
			while (parser.nextToken() != System.JSONToken.END_OBJECT) {
				if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
					String text = parser.getText();
					if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
						if (text == 'Text') {
							Text = parser.getText();
						} else if (text == 'Position') {
							Position = new Position(parser);
						} else {
							System.debug(LoggingLevel.WARN, 'Title consuming unrecognized property: '+text);
							consumeObject(parser);
						}
					}
				}
			}
		}
	}
	*/
	public class VS4SF_DocumentRequestDTO
	{
		//	public String FileName {get;set;}
		//	public String DocContent {get;set;}
		public String IssuerName {get;set;}
		public List<Signers> Signers {get;set;}
		public Boolean OrderedSignatures {get;set;}
		//public Object AdditionalData {get;set;}
		//public Object DocusignInfo {get;set;}
		public Object NotificationURL {get;set;}
		//public Object Tag {get;set;}
		public VS4SF_DocumentRequestDTO()
		{

		}
	}
	/*
	public class VS4SF_DocumentResponseDTO
	{
		public String DocGUI {get;set;}
	}

	public class TextBoxes {
		public String Id {get;set;}
		public Title Title {get;set;}
		public Integer MaxLines {get;set;}
		public Object Condition {get;set;}
		public Title Response {get;set;}

		public TextBoxes(JSONParser parser) {
			while (parser.nextToken() != System.JSONToken.END_OBJECT) {
				if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
					String text = parser.getText();
					if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
						if (text == 'Id') {
							Id = parser.getText();
						} else if (text == 'Title') {
							Title = new Title(parser);
						} else if (text == 'MaxLines') {
							MaxLines = parser.getIntegerValue();
						} else if (text == 'Condition') {
							Condition = parser.readValueAs(Object.class);
						} else if (text == 'Response') {
							Response = new Title(parser);
						} else {
							System.debug(LoggingLevel.WARN, 'TextBoxes consuming unrecognized property: '+text);
							consumeObject(parser);
						}
					}
				}
			}
		}
	}

	public class Choices {
		public Title Title {get;set;}

		public Choices(JSONParser parser) {
			while (parser.nextToken() != System.JSONToken.END_OBJECT) {
				if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
					String text = parser.getText();
					if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
						if (text == 'Title') {
							Title = new Title(parser);
						} else {
							System.debug(LoggingLevel.WARN, 'Choices consuming unrecognized property: '+text);
							consumeObject(parser);
						}
					}
				}
			}
		}
	}

	public class Sections {
		public List<Groups> Groups {get;set;}

		public Sections(JSONParser parser) {
			while (parser.nextToken() != System.JSONToken.END_OBJECT) {
				if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
					String text = parser.getText();
					if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
						if (text == 'Groups') {
							Groups = arrayOfGroups(parser);
						} else {
							System.debug(LoggingLevel.WARN, 'Sections consuming unrecognized property: '+text);
							consumeObject(parser);
						}
					}
				}
			}
		}
	}

	public class Layout {
		public String FontFamily {get;set;}
		public String FontSize {get;set;}

		public Layout(JSONParser parser) {
			while (parser.nextToken() != System.JSONToken.END_OBJECT) {
				if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
					String text = parser.getText();
					if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
						if (text == 'FontFamily') {
							FontFamily = parser.getText();
						} else if (text == 'FontSize') {
							FontSize = parser.getText();
						} else {
							System.debug(LoggingLevel.WARN, 'Layout consuming unrecognized property: '+text);
							consumeObject(parser);
						}
					}
				}
			}
		}
	}

	public class Groups {
		public Title Title {get;set;}
		public Object RadioButtons {get;set;}
		public List<CheckBoxes> CheckBoxes {get;set;}
		public List<TextBoxes> TextBoxes {get;set;}

		public Groups(JSONParser parser) {
			while (parser.nextToken() != System.JSONToken.END_OBJECT) {
				if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
					String text = parser.getText();
					if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
						if (text == 'Title') {
							Title = new Title(parser);
						} else if (text == 'RadioButtons') {
							RadioButtons = parser.readValueAs(Object.class);
						} else if (text == 'CheckBoxes') {
							CheckBoxes = arrayOfCheckBoxes(parser);
						} else if (text == 'TextBoxes') {
							TextBoxes = arrayOfTextBoxes(parser);
						} else {
							System.debug(LoggingLevel.WARN, 'Groups consuming unrecognized property: '+text);
							consumeObject(parser);
						}
					}
				}
			}
		}
	}

	public class TextBoxes_Z {
		public String Id {get;set;}
		public Title Title {get;set;}
		public Integer MaxLines {get;set;}
		public Condition Condition {get;set;}
		public Title Response {get;set;}

		public TextBoxes_Z(JSONParser parser) {
			while (parser.nextToken() != System.JSONToken.END_OBJECT) {
				if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
					String text = parser.getText();
					if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
						if (text == 'Id') {
							Id = parser.getText();
						} else if (text == 'Title') {
							Title = new Title(parser);
						} else if (text == 'MaxLines') {
							MaxLines = parser.getIntegerValue();
						} else if (text == 'Condition') {
							Condition = new Condition(parser);
						} else if (text == 'Response') {
							Response = new Title(parser);
						} else {
							System.debug(LoggingLevel.WARN, 'TextBoxes_Z consuming unrecognized property: '+text);
							consumeObject(parser);
						}
					}
				}
			}
		}
	}

	public class UserNoticeDTO {
		public String UserNoticeName {get;set;}
		public Object UserNoticeObject {get;set;}
		public String UserNoticeType {get;set;} // ['RadioButtonSingleChoice', 'CheckBox'],
		public Integer PosX {get;set;}
		public Integer PosY {get;set;}
		public Integer SizeX {get;set;}
		public Integer Page {get;set;}
	} */
	public class StampCertificateDTO {
		public String CertificateGUI {get;set;}
		public String Pin  {get;set;}
		public StampCertificateDTO(){
			this.CertificateGUI = '';
		}
	}
	public class SignatureNotificationEmailDTO{
		public String eMailBody {get;set;}
		public String eMailSubject {get;set;}
		public  SignatureNotificationEmailDTO(){
			try{
				EmailTemplate tempID = [SELECT Id,HtmlValue,Name, Subject FROM EmailTemplate WHERE Name =: System.Label.VIDSIGNERTEMPLATE];
				this.eMailBody = tempID.HtmlValue;
				this.eMailSubject = tempID.Subject;
			}catch(Exception e){
				//this.eMailBody = null;
				//this.eMailSubject = null;
			}

		}
	}
	public class Visible {
		public Integer Page { get; set; }
		public Integer PosX { get; set; }
		public Integer PosY { get; set; }
		public Integer SizeX { get; set; }
		public Integer SizeY { get; set; }
		//public Object SignatureField { get; set; }
		//public Object Anchor { get; set; }

		public Visible () {

		}

	}

	public class Signers {
		public String Id {get;set;}
		public String SignerName {get;set;}
		public String TypeOfID {get;set;}
		public String NumberID {get;set;}
		public String SignatureType {get;set;}
		public String UserCertificateName  {get;set;}
		public StampCertificateDTO StampCertificate  {get;set;}
		public String DeviceName {get;set;}
		public String Language {get;set;}
		public Visible Visible {get;set;}
		public Boolean DocusignSigner {get;set;}
		public SignatureNotificationEmailDTO NotificationEmailMessage {get;set;}
		public Boolean VerifyeMail {get;set;}
		public Boolean sendSignedDoc {get;set;}
		public Boolean SkipSignatureEmail = false;
		/*public Boolean SendCentralizedSignerEmailNotification {get;set;}
		public String PictureURI {get;set;}
		public Object SignerGUI {get;set;}*/
		public String eMail {get;set;}
		//public UserNoticeDTO UserNotices {get;set;}
		public Boolean isDigitalIdUser {get;set;}
		public Object Form {get;set;}
		public String PhoneNumber {get;set;}
		public String AdditionalInfo {get;set;}
		public Signers(){

		}
	}
	/*
	public class Form {
		public Layout Layout {get;set;}
		public List<Sections> Sections {get;set;}
		public Form(){
			this.Layout = null;
		}

		public Form(JSONParser parser) {
			while (parser.nextToken() != System.JSONToken.END_OBJECT) {
				if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
					String text = parser.getText();
					if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
						if (text == 'Layout') {
							Layout = new Layout(parser);
						} else if (text == 'Sections') {
							Sections = arrayOfSections(parser);
						} else {
							System.debug(LoggingLevel.WARN, 'Form consuming unrecognized property: '+text);
							consumeObject(parser);
						}
					}
				}
			}
		}
	}

	public static void consumeObject(System.JSONParser parser) {
		Integer depth = 0;
		do {
			System.JSONToken curr = parser.getCurrentToken();
			if (curr == System.JSONToken.START_OBJECT ||
					curr == System.JSONToken.START_ARRAY) {
				depth++;
			} else if (curr == System.JSONToken.END_OBJECT ||
					curr == System.JSONToken.END_ARRAY) {
				depth--;
			}
		} while (depth > 0 && parser.nextToken() != null);
	}
	
	private static List<Sections> arrayOfSections(System.JSONParser p) {
		List<Sections> res = new List<Sections>();
		if (p.getCurrentToken() == null) p.nextToken();
		while (p.nextToken() != System.JSONToken.END_ARRAY) {
			res.add(new Sections(p));
		}
		return res;
	}
	private static List<Groups_Z> arrayOfGroups_Z(System.JSONParser p) {
		List<Groups_Z> res = new List<Groups_Z>();
		if (p.getCurrentToken() == null) p.nextToken();
		while (p.nextToken() != System.JSONToken.END_ARRAY) {
			res.add(new Groups_Z(p));
		}
		return res;
	}
	
	private static List<Groups> arrayOfGroups(System.JSONParser p) {
		List<Groups> res = new List<Groups>();
		if (p.getCurrentToken() == null) p.nextToken();
		while (p.nextToken() != System.JSONToken.END_ARRAY) {
			res.add(new Groups(p));
		}
		return res;
	}
	
	private static List<CheckBoxes> arrayOfCheckBoxes(System.JSONParser p) {
		List<CheckBoxes> res = new List<CheckBoxes>();
		if (p.getCurrentToken() == null) p.nextToken();
		while (p.nextToken() != System.JSONToken.END_ARRAY) {
			res.add(new CheckBoxes(p));
		}
		return res;
	}
	
	private static List<TextBoxes> arrayOfTextBoxes(System.JSONParser p) {
		List<TextBoxes> res = new List<TextBoxes>();
		if (p.getCurrentToken() == null) p.nextToken();
		while (p.nextToken() != System.JSONToken.END_ARRAY) {
			res.add(new TextBoxes(p));
		}
		return res;
	}
	
	private static List<Choices> arrayOfChoices(System.JSONParser p) {
		List<Choices> res = new List<Choices>();
		if (p.getCurrentToken() == null) p.nextToken();
		while (p.nextToken() != System.JSONToken.END_ARRAY) {
			res.add(new Choices(p));
		}
		return res;
	}
	private static List<TextBoxes_Z> arrayOfTextBoxes_Z(System.JSONParser p) {
		List<TextBoxes_Z> res = new List<TextBoxes_Z>();
		if (p.getCurrentToken() == null) p.nextToken();
		while (p.nextToken() != System.JSONToken.END_ARRAY) {
			res.add(new TextBoxes_Z(p));
		}
		return res;
	}
	
	
	
	private static List<RadioButtons> arrayOfRadioButtons(System.JSONParser p) {
		List<RadioButtons> res = new List<RadioButtons>();
		if (p.getCurrentToken() == null) p.nextToken();
		while (p.nextToken() != System.JSONToken.END_ARRAY) {
			res.add(new RadioButtons(p));
		}
		return res;
	} */
}