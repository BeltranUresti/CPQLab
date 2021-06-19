.msg-error {
	background-color: #ffffff;
	border: 1px solid #00bf71;
	text-align: left;
	padding: 10px;
	margin: 0 auto;
	margin-top: 10px;
	color:#434446;
	/* W3C */
	border-radius: 10px;
	/* Firefox */
	-moz-border-radius: 10px;
	/* Safari */
	-webkit-border-radius: 10px;
}

#msg-ok {
	background-color: #F4FDEF;
	border: 1px solid #66d9aa;
	text-align: left;
	padding: 10px;
	margin: 0 auto;
	margin-top: 10px;
	color:#00bf71;
	/* W3C */
	border-radius: 10px;
	/* Firefox */
	-moz-border-radius: 10px;
	/* Safari */
	-webkit-border-radius: 10px;
}

.field-error{
	background-color: #434446;
	color:#949494;
	/*border: 1px solid #FF0000 !important;*/
}


#preview-signature { 
	/* Equivale a las medidas 56x20 (factor de conversión: 0.2645833333333)*/
	/* dividimos por 2 para reescalar*/
	/*width: 105px;*/
	/*height: 37px;*/
	outline:2px solid #008f55;
	position: relative;
    /*left: 230px;
    top: 460px;*/
	z-index: 1000;
	background-color:#6FCF97;
	cursor:pointer;
}

/**/

#preview-form-question {
	/* Equivale a las medidas 56x20 (factor de conversión: 0.2645833333333)*/
	/* dividimos por 2 para reescalar*/
	outline:2px solid #008f55;
	position: relative;
	z-index: 1000;
	background-color:#6FCF97;
	cursor:pointer;
	/*height: 15px;
	width: 320px;*/
}

.ui-resizable {
	/*height: 100% !important;*/
	max-width: 100%
}
/**/
			
#preview-doc{
	/*  
		75x106px = 210x297cm
		dividimos por 2 para reescalar
	*/
	position:relative;
	/*width: 396px;*/
	/*height: 561px;*/
	margin: 0 auto 20px auto;
	background-color: #FFFFFF;
	display: block;
}

#btn-change-file{
	display: initial;
	z-index: 999;
	position: absolute;
	right: 10px;
	top: 10px;
	max-width: 24px;
	cursor: pointer;
}

#preview-doc canvas{
	/*  
		75x106px = 210x297cm
		dividimos por 2 para reescalar
	*/
	position:absolute;
	top:0; 
	left:0; 
	z-index:0;
	/*width: 396px;*/
	/*height: 561px;*/
}

#custom-pager{
	margin: 0 auto;
	margin-bottom:10px;
	
}

#custom-pager span{
	color:#FFFFFF;
}

.txt-info{
	width:80%;
	margin:0 auto;
	text-align:center;
	color:#FFFFFF;
}

.btn-download{
	border: none;
    border-radius: 5px;
    font-weight: 600;
    text-transform: uppercase;
	background-color:#00bf71;
	padding-top:15px;
	padding-bottom:15px;
	color: #FFFFFF;
	margin-top: 15px !important;
    -webkit-animation-delay: 2s;
}
.btn-download:hover{
	background-color: #008f55;
	color: #FFFFFF;
}

.downloadpage{
	min-height:100%;
	position: relative;
	width: 100%;
	text-align: center;
	color: white;
	background-color: #F6F6F6;
	/*overflow-y:auto !important;*/
}

.downloadpage h1 {
  font-size: 14px !important;
  font-weight: 700;
  color: #434446;
  margin-bottom: 20px;
  overflow-y: hidden !important;
}

#document-list{
	width:80%;
	padding: 10px;
	margin: auto;
	color: #434446;
}
.document-list-item{
	position: relative;
	font-size:14px;
	padding: 10px;
	text-align:left;
	border-radius: 5px;
	cursor:pointer;
	background-color:#FFFFFF;
	color: #434446;
	min-height: 20px;
	margin-top: 10px;
	/*box-shadow: 0 4px 8px 0 rgba(0, 0, 0, 0.2), 0 6px 20px 0 rgba(0, 0, 0, 0.19);*/
}
.document-list-item:hover{
	background-color:#cfcfd1;
}

.btn-download-file{
	position: absolute;
	top: 0;
	bottom: 0;
	right: 20px;
	margin: auto;
	max-width: 30px;
}

.btn-download-file:hover{
	color: #434446 !important;
	border-color: #434446 !important;
}

.file-name{
	line-height: 37px;
}

.nav-signers{
	cursor:pointer;
	font-weight:bold;
	margin-left: 10px;
	margin-right: 10px;
	font-size: 18px;
}

#div-signer-info{
	float:left;
	width:100%;
}
#div-preview-document{
	float:left;
	width:100%;
}
#sf-document-list{
    position: relative;

}
#div-questions-info{
	float:left;
	width:100%;
}
#div-separator-preview{
	display:block;
}

#validatedLogoDownload{
	max-height: 30px;
	margin: 15px auto;
	padding-left: 76px;
}

.privacy-div{
	padding-left: 20px;
	padding-right: 20px;
}

.privacy-h2{
	color: #00bf71;
	text-align: left;
}

.signature-number {
    color: black;
    position: absolute;
    left: 5px;
    top: 3px;
}

.question-number {
	color: black;
	position: absolute;
	left: 5px;
}

@-moz-document url-prefix() {
	#preview-signature {
		outline:none;
	}
	#preview-form-question {
		outline:none;
	}
}

@media (min-width: 1100px) {
	#div-signer-info{
		float:left;
		width:40%;
		padding-left:30px;
	}
	#div-preview-document{
		float:left;
		width:60%;
	}
	#div-questions-info{
		float: left;
		width: 40%;
		padding-left: 30px;
	}
	#div-separator-preview{
		display:none;
	}
	#wating-preview-doc{
		padding-left: 30px;
	}
	.modal-body {
		/*max-height: calc(100vh - 210px);*/
		/*max-height: 100vh;*/
		overflow-y: auto;
		width: 25%;
		margin: auto;
	}
	#login-logo {
		width: 8%;
	}
}

@media (min-width: 300px) {
	.btn-download{
		margin-top: 10px;
	}
}

/*
#form-send-body{
	overflow-y: auto;
}
#modal-preview-document{
	overflow-y: auto;
}
@media screen and (max-height: 768px) {
	#form-send-body{
		height:550px;
	}
	
	#modal-preview-document{
		height:600px;
	}
}
*/