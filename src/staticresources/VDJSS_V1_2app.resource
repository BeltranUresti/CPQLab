var signersList = [];
var formQuestionsList = [];
//Tomamos como referencia un A4 cuyas dimensiones son 210x297
//Los valores de imagen que devuelve el servicio de renderización son 1240x1754
//La relación de conversion sera 210/1240 o 297/1754 que es lo mismo: 0.1693548387096774
var pdfNumPage;
var pixelToMMFactor;
var scale;
var pageWmm;
var pageHmm;
var signatureWmm;
var signatureHmm;
var signaturePosXmm;
var signaturePosYmm;
var questionWmm;
var questionHmm;
var questionPosXmm;
var questionPosYmm;
var pageWpixels;
var pageHpixels;
var signatureWpixels;
var signatureHpixels;
var signaturePosXpixels;
var signaturePosYpixels;
var questionWpixels;
var questionHpixels;
var questionPosXpixels;
var questionPosYpixels;
var currentSigner;
var currentQuestion;
var existEmailAndSMS = false;
var existStamp = false;
var existCentralized = false;
var signatureChannles;
var currentSignerPage;
var issuerName;
// 0: None
// 1: EsPublico
// 2: TSystem
var registryType=0;
var annotationData;
var registryBookCodes;

function initVIDClientForSalesforce () {

    //If click in download bottom then it is true;
    var downloadOpen = false;
    var detectBrowser = detectIE();
    var windowWidth = $(window).width();
    var windowHeight = $(window).height();

    signatureChannels = { signatureChannel: 'emailandsms'};

    document.querySelector('#subscription-pass').addEventListener('keypress', function (e) {
        var key = e.which || e.keyCode;
        if (key === 13) { // 13 is enter
            $('#btn-login').trigger('click');
        }
    });

    document.querySelector('#subscription-user').addEventListener('keypress', function (e) {
        var key = e.which || e.keyCode;
        if (key === 13) { // 13 is enter
            $('#btn-login').trigger('click');
        }
    });

    function detectIE() {
        var ua = window.navigator.userAgent;

        var msie = ua.indexOf('MSIE ');
        if (msie > 0) {
            // IE 10 or older => return version number
            return parseInt(ua.substring(msie + 5, ua.indexOf('.', msie)), 10);
        }

        var trident = ua.indexOf('Trident/');
        if (trident > 0) {
            // IE 11 => return version number
            var rv = ua.indexOf('rv:');
            return parseInt(ua.substring(rv + 3, ua.indexOf('.', rv)), 10);
        }

        var edge = ua.indexOf('Edge/');
        if (edge > 0) {
            // Edge (IE 12+) => return version number
            return parseInt(ua.substring(edge + 5, ua.indexOf('.', edge)), 10);
        }

        // other browser
        return false;
    }


    $("#btn-send").click(function () {
        var msg = validateSigner();
        if (msg !== "") {
            $("#msg-error").html(msg);
            $("#msg-error").show();
        } else {
            $('#sending-modal').modal('show');
            $("#btn-send").hide();
            $("#img-sending").show();
            $("#msg-error").html("");
            $("#msg-error").hide();
            cleanFieldsErrorClass();

            var QuestionsForm = {};

            var Layout = {};
            Layout.FontFamily = "Times-Roman";
            Layout.FontSize = "11";
            QuestionsForm.Layout = Layout;

            var Sections = [];
            var Groups = [];
            var InnerGroup = {};
            var InnerSection = {};

            InnerGroup.Title = null;
            InnerGroup.RadioButtons = null;
            InnerGroup.TextBoxes = null;


            var CheckBoxes = [];
            formQuestionsList.map(function(question) {
                var Question = {};
                Question.Title = {};
                Question.Id = '_' + Math.random().toString(36).substr(2, 9);
                Question.Title.Text = question.title;

                var Position = {};
                Position.Page = parseInt(question.Visible.Page);
                Position.PosX = parseInt(question.Visible.PosX);
                Position.PosY = parseInt(question.Visible.PosY);
                Position.SizeX = parseInt(question.Visible.SizeX);
                Position.SizeY = parseInt(question.Visible.SizeY);
                Position.Anchor = "";
                Question.Title.Position = Position;

                CheckBoxes.push(Question);
            });

            InnerGroup.CheckBoxes = CheckBoxes;
            Groups.push(InnerGroup);

            InnerSection.Groups = Groups;
            Sections.push(InnerSection);

            QuestionsForm.Sections = Sections;

            //Add questions' form to first signer
            if (CheckBoxes.length > 0 && CheckBoxes[0].Title.Text !== "" && (signersList[0].SignatureType === "bio" ||  signersList[0].SignatureType === "emailandsms")){
                signersList[0].Form = QuestionsForm;
            }
            signersList = signersList.filter(function(e) { return e.checked === true; });

            for(var i = 0; i < signersList.length; i++){
                    delete signersList[i].checked;
                    delete signersList[i].Id;

            }

            var signersInfo = UTF8ToB64(JSON.stringify(signersList));
            console.log('***SEND MESSAGE****');
            console.log(JSON.stringify(signersList));
            let jsonData =  JSON.stringify({FileName: encodeURIComponent($.trim($("#file-name").val().toString())) ,
                Signers:signersList,OrderedSignatures:true,IssuerName:$("#issuer-name").val(),NotificationURL:'https://htdev-portalholidaytelecom.cs84.force.com/services/apexrest/',
                DocContent:encodeURIComponent($("#file-b64-content").val())});

            //const theData =  "environment=" + $("#environment").val() + "&subscription-user=" + $("#subscription-user").val() + "&subscription-pass=" + $("#subscription-pass").val() + "&file-b64-content=" + encodeURIComponent($("#file-b64-content").val()) + "&file-name=" + encodeURIComponent($.trim($("#file-name").val().toString())) + "&signers=" + signersInfo + "&signatures-ordered=" + $("#signatures-ordered").is(':checked') + "&issuer-name=" + $("#issuer-name").val()+"&registry-type="+registryType+"&registry-addition-data="+getRegistryAdditionData()+"&NotificationURL=https://htdev-portalholidaytelecom.cs84.force.com/services/apexrest/";
           console.log(jsonData);
            $.ajax({
               // url: "https://cors-anywhere.herokuapp.com/https://sendto.vidsigner.net/uploadfile.php",
                url:"https://cors-anywhere.herokuapp.com/https://pre-vidsignercloud.validatedid.com/api/documents",
                type: 'POST',
                async: true,
                cache: false,
                dataType: 'json',
                contentType: "application/json",
                //data : "environment="+$("#environment").val()+"&subscription-user="+$("#subscription-user").val()+"&subscription-pass="+$("#subscription-pass").val()+"&file-b64-content="+encodeURIComponent($("#file-b64-content").val())+"&file-name="+$("#file-name").val()+"&signer-name="+$("#signer-name").val()+"&signer-id-type="+$("#signer-id-type").val()+"&signer-id="+$("#signer-id").val()+"&signer-email="+$("#signer-email").val()+"&device="+$("#device").val()+"&signature-page="+$("#signature-page").val()+"&signature-x="+$("#signature-x").val()+"&signature-y="+$("#signature-y").val()+"&signature-width="+$("#signature-width").val()+"&signature-height="+$("#signature-height").val(),
                //data : '{"environment":"'+$("#environment").val()+'","subscription-user":"'+$("#subscription-user").val()+'","subscription-pass":"'+$("#subscription-pass").val()+'","file-b64-content":"'+encodeURIComponent($("#file-b64-content").val())+'","file-name":"'+$("#file-name").val()+'","signers":"'+signersInfo+'"}',  $("#file-name").val()
                //data: "environment=" + $("#environment").val() + "&subscription-user=" + $("#subscription-user").val() + "&subscription-pass=" + $("#subscription-pass").val() + "&file-b64-content=" + encodeURIComponent($("#file-b64-content").val()) + "&file-name=" + encodeURIComponent($.trim($("#file-name").val().toString())) + "&signers=" + signersInfo + "&signatures-ordered=" + $("#signatures-ordered").is(':checked') + "&issuer-name=" + $("#issuer-name").val()+"&registry-type="+registryType+"&registry-addition-data="+getRegistryAdditionData()+"&notification-url=https://htdev-portalholidaytelecom.cs84.force.com/services/apexrest/",
                data:jsonData,
                beforeSend: function(xhr) {
                    xhr.setRequestHeader("Authorization", "Basic QVVUQU5BQ1JNU3Vic2NyaXB0aW9uRGVtbzpaTnBlYVk2TXQ3RjQ4NmI3bjY3cQ==") //Some characters have been replaced for security but this is a true BASE64 of "username:password"
                },
                success: function (data) {
                    if (data === "error_captcha") {

                    } else {
                        clearFullCanvas();
                        clearFullQuestionsCanvas();
                        //Limpiamos las preguntas que se hayan creado en el formulario asignado al primer firmante y limpiamos el input
                        if (signersList[0]){
                            delete signersList[0].Form;
                        }
                        formQuestionsList = [];
                        $("#question-title").val("");
                        if ($(window).width() > 1100) {
                            /*$('#myModal-dialog').css('width', '600px');*/
                        }
                        if($("#save-signers-data").is(':checked')){
                            saveCookie('vid-save-signers-data', '1');
                        }else{
                            saveCookie('vid-save-signers-data', '0');
                        }
                        if ($("#save-signers-data").is(':checked')) {
                            //Limpiamos los datos del certificado y Pin
                            $.each(signersList, function (index, signer) {
                                if (signer.StampCertificate !== null && signer.StampCertificate != undefined) {
                                    signer.StampCertificate.Pin = "";
                                }
                            });
                            signersInfo = UTF8ToB64(JSON.stringify(signersList));
                            saveCookie('vid-signers-v2', signersInfo);
                            if ($("#signatures-ordered").is(':checked')) {
                                saveCookie('vid-signatures-ordered', '1');
                            } else {
                                saveCookie('vid-signatures-ordered', '0');
                            }
                            saveCookie('vid-issuername', $("#issuer-name").val());
                            saveCookie('vid-t-system-document-type', $("#t-system-document-types").val());
                        }
                        $("#btn-send").show();
                        $("#img-sending").hide();
                        $('#sending-modal').modal('hide');
                        $("#result-content").html(data);
                        $("#form-send-body").hide();
                        $("#result-body").show();
                        if (windowWidth > 1024){
                            $(".modal-body").css('width', '25%');
                        }
                        if (windowWidth <= 1024){
                            $(".modal-body").css('width', '50%');
                        }
                        if (windowWidth <= 768){
                            $(".modal-body").css('width', '50%');
                        }
                        if (windowWidth <= 480){
                            $(".modal-body").css('width', '100%');
                        }
                    }
                },
                error: function (xhr, ajaxOptions, thrownError) {
                    $("#btn-send").show();
                    $("#img-sending").hide();
                    $('#sending-modal').modal('hide');
                    jQuery("#btn-login").css("display", "block");
                    jQuery("#img-validating-login").css("display", "none");
                    alert('Error: ' + thrownError);
                }
            });
        }

    });


    $("#signatures-ordered").change(function() {
        if(this.checked) {
            $('#button-with-icon-span').css('color', '#434446');
            $('.tooltip-container').css('cursor', 'pointer');
            $('.btn-add-questions-form').css('pointer-events', 'auto');
        }
        else {
            $('#button-with-icon-span').css('color', '#aaadb3');
            $('.tooltip-container').css('cursor', 'no-drop');
            $('.btn-add-questions-form').css('pointer-events', 'none');
            formQuestionsList = [];
            $("#question-title").val("");
            if (signersList[0].Form){
                delete signersList[0].Form;
            }
            clearFullQuestionsCanvas();
        }
    });

    $("#send-email-notification").change(function() {
        if(this.checked) {
            $('#div-email-body').show();
            $('#div-email-subject').show();
            $('#div-issuer-name').show();
            $('#div-signer-language').show();
        }
        else {
            $('#div-email-body').hide();
            $('#div-email-subject').hide();
            $('#div-issuer-name').hide();
            $('#div-signer-language').hide();
            signersList[currentSigner].SendCentralizedSignerEmailNotification = false;
            signersList[currentSigner].sendEmailNotification = false;
            signersList[currentSigner].NotificationEmailMessage = null;
        }
    });

    $("#file-path").click(function () {

        $('#file-to-upload').trigger('click');
    });

    $("#btn-update").click(function () {
        $("#btn-update").css('display', 'none');
        $('#document-list').html('<img src="img/spinner.gif" style="width:100px;" alt="Reloading...">');
        $.ajax({
            url: "https://sendto.vidsigner.net/download.php",
            type: 'POST',
            async: true,
            cache: false,
            data: "environment=" + $("#environment").val() + "&subscription-user=" + $("#subscription-user").val() + "&subscription-pass=" + $("#subscription-pass").val(),
            success: function (data) {
                $("#btn-update").css('display', 'inline');
                if (data === "403") {
                    $("#document-list-msg-error").html($("#errortoreload").html());
                    $("#document-list-msg-error").show();
                } else {
                    var response = $.isNumeric(data);
                    if (response && data !== "404") {
                        $("#document-list-msg-error").html($("#errortoreload").html());
                        $("#document-list-msg-error").show();
                    } else {
                        if (data === "404") {
                            $('#document-list').html('<h4>' + $("#erroremptylist").html() + '</h4>');
                        } else {
                            try {
                                var signedDocuments = JSON.parse(data);
                                if (signedDocuments !== null && signedDocuments.length > 0) {
                                    signedDocumentsText = '';
                                    $.each(signedDocuments, function (index, doc) {
                                        signedDocumentsText = signedDocumentsText.concat('<div id="doc-' + index + '" class="document-list-item" onclick="javascript: return downloadDocumentFromList(\'' + doc.DocGUI + '\',\'' + doc.FileName + '\',\'' + index + '\');"><span class="file-name">' + doc.FileName + '</span><img class="btn-download-file" id="btn-download-file-' + index + '" src="svg/sendTo-download.svg" alt="Download file"><img id="downloading-' + index + '" width="40px;" src="./img/spinner.gif" style="float:right; margin-right:6px; display:none;"><img id="downloaded-' + index + '" width="40px;" src="./img/downloaded.png" style="float:right; display:none"></div><br/>');
                                    });
                                    $('#document-list').html(signedDocumentsText);
                                }

                            } catch (e) {
                                $("#document-list-msg-error").html($("#errortoreload").html());
                                $("#document-list-msg-error").show();
                            }
                        }
                    }
                }

            },
            error: function (xhr, ajaxOptions, thrownError) {
                $("#btn-update").css('display', 'inline');
                $("#document-list-msg-error").html($("#errortoreload").html());
                $("#document-list-msg-error").show();
            }
        });
    });

    $('#myModal').on('show.bs.modal', function (e) {
        $('#environment').val(getCookie('vid-env'));
        $('#subscription-user').val(getCookie('vid-subscription-user'));
        $('#subscription-pass').val(getCookie('vid-subscription-pass'));
    });

    $('#myModal').on('hidden.bs.modal', function (e) {
        cleanFieldsValues();
        cleanFieldsErrorClass();
        
        if (downloadOpen === false) {
            $("#subscription-user").val("");
            $("#subscription-pass").val("");
            $("#environment").val("");
        }
        

        $("#btn-send").show();
        $("#img-sending").hide();
        $("#result-content").html("");
        $("#form-send-body").show();
        $("#result-body").hide();

        hideSignerPanel();
        hideTSystemPanel();
        hideEsPublicoPanel();
        hideNewFormPanel();
        showLoginPanel();

    });

    $("#file-path").click(function () {

        $('#file-to-upload').trigger('click');
    });

    $("#filedrag").click(function () {
        try {
            $('#file-to-upload').trigger('click');
        } catch (e) {
            alert(e);
        }
    });

    isValidNIF = function (value) {

        var validChars = 'TRWAGMYFPDXBNJZSQVHLCKET';
        var nifRexp = /^[0-9]{8}[TRWAGMYFPDXBNJZSQVHLCKET]{1}$/i;
        var nieRexp = /^[XYZ]{1}[0-9]{7}[TRWAGMYFPDXBNJZSQVHLCKET]{1}$/i;
        var str = value.toString().toUpperCase();

        if (!nifRexp.test(str) && !nieRexp.test(str)) {
            return false;
        }
        var nie = str
            .replace(/^[X]/, '0')
            .replace(/^[Y]/, '1')
            .replace(/^[Z]/, '2');

        var letter = str.substr(-1);
        var charIndex = parseInt(nie.substr(0, 8)) % 23;

        if (validChars.charAt(charIndex) === letter) {
            return true;
        }

        return false;
    };

    $( "#preview-doc" ).mousedown(function() {
        clearSignature();
        clearQuestion();
    });

    $( "#preview-doc" ).mouseup(function() {
        drawSquareShadow();
        if(formQuestionsList.length > 0){
            drawSquareShadowQuestion();
        }
    });

    $("#preview-signature").draggable(
        {
            containment: "#preview-doc",
            drag: function () {
                /*var offset = $(this).offset();
                 var xPos = offset.left;
                 var yPos = offset.top;
                 $('#posX').text('x: ' + xPos);
                 $('#posY').text('y: ' + yPos);
                 */

                var $this = $(this);
                var thisPos = $this.offset();
                var parentPos = $("#preview-doc").offset();
                //Multiplicamos por 2 porque está todo escalado a la mitad
                var xPos = parseInt("" + (thisPos.left - parentPos.left) * pixelToMMFactor) * scale;
                var yPos = parseInt("" + (thisPos.top - parentPos.top) * pixelToMMFactor) * scale;
                $('#signature-x').val(xPos);
                $('#signature-y').val(yPos);

                if (signersList.length > 0 && currentSigner < signersList.length && signersList[currentSigner] !== null) {
                    signersList[currentSigner].Visible.PosX = xPos;
                    signersList[currentSigner].Visible.PosY = yPos;
                }
            }
        }).resizable(
        {
            containment: "#preview-doc",
            maxWidth: pageWpixels,
            maxHeight: pageHpixels,
            resize: function (event, ui) {
                //Dividimos entre 3 para mantener la proporcion 3:1
                ui.size.height = parseInt("" + (ui.size.width / 3));
                //Multiplicamos por 2 porque está todo escalado a la mitad
                var newWidth = parseInt("" + ((ui.size.width) * pixelToMMFactor)) * scale;
                $("#signature-width").val(newWidth);
                $("#signature-height").val(parseInt(newWidth / 3));

                if (signersList.length > 0 && currentSigner < signersList.length && signersList[currentSigner] !== null) {
                    signersList[currentSigner].Visible.SizeX = $("#signature-width").val();
                    signersList[currentSigner].Visible.SizeY = $("#signature-height").val();
                }
            }
        }
    );

    $("#preview-form-question").draggable(
        {
            containment: "#preview-doc",
            drag: function () {
                var $this = $(this);
                var thisPos = $this.offset();
                var parentPos = $("#preview-doc").offset();
                //Multiplicamos por 2 porque está todo escalado a la mitad
                var xPos = parseInt("" + (thisPos.left - parentPos.left) * pixelToMMFactor) * scale;
                var yPos = parseInt("" + (thisPos.top - parentPos.top) * pixelToMMFactor) * scale;
                $('#question-x').val(xPos);
                $('#question-y').val(yPos);

                if (formQuestionsList.length > 0 && currentQuestion < formQuestionsList.length && formQuestionsList[currentQuestion] !== null) {
                    formQuestionsList[currentQuestion].Visible.PosX = xPos;
                    formQuestionsList[currentQuestion].Visible.PosY = yPos;
                }
            }
        }).resizable(
        {
            containment: "#preview-doc",
            maxWidth: pageWpixels,
            maxHeight: pageHpixels,
            handles: "e, w",
            resize: function (event, ui) {
                //Multiplicamos por 2 porque está todo escalado a la mitad
                var newWidth = parseInt("" + ((ui.size.width) * pixelToMMFactor)) * scale;
                $("#question-width").val(newWidth);
                if (formQuestionsList.length > 0 && currentQuestion < formQuestionsList.length && formQuestionsList[currentQuestion] !== null) {
                    formQuestionsList[currentQuestion].Visible.SizeX = $("#question-width").val();
                    formQuestionsList[currentQuestion].Visible.SizeY = $("#question-height").val();
                }
            }
        }
    );

    $("#btn-ok-preview").click(function () {
        //$('#preview-document').modal('hide');
    });

    $("#btn-change-file").click(function () {
        clearFullCanvas();
    });

    $("#btn-login").click(function () {
        $("#msg-error").html('');
        $("#msg-error").hide();
        $("#document-list-msg-error").html('');
        $("#document-list-msg-error").hide();
        $("#msg-error-renderization").html('');
        $("#msg-error-renderization").hide();
        var msg = "";
        $("#environment").removeClass("field-error");
        $("#subscription-user").removeClass("field-error");
        $("#subscription-pass").removeClass("field-error");

        if ($("#environment").val() === "") {
            msg = msg + "<span>"+$("#errorenvironmentrequired").html()+"</span><br/>";
            $("#environment").addClass("field-error");
        }

        if ($("#subscription-user").val() === "") {
            msg = msg + "<span>"+$("#errorsubscriptionrequired").html()+"</span><br/>";
            $("#subscription-user").addClass("field-error");
        }

        if ($("#subscription-pass").val() === "") {
            msg = msg + "<span>"+$("#errorpassrequired").html()+"</span><br/>";
            $("#subscription-pass").addClass("field-error");
        }
        if (msg !== "") {
            $("#msg-error").html(msg);
            $("#msg-error").show();
        } else {
            $("#btn-login").css('display', 'none');
            $("#img-login").css('display', 'inline');

            if (downloadOpen === true) {
                doDonwload();
            } else {
                $.ajax({
                    url: 'https://sendto.vidsigner.net/registryconfiguration.php',
                    type: 'POST',
                    async: true,
                    cache: false,
                    data: "action=0&environment=" + $("#environment").val() + "&subscription-user=" + $("#subscription-user").val() + "&subscription-pass=" + $("#subscription-pass").val(),
                    success: function (data) {
                        var registryConfiguration = JSON.parse(data);
                        if (registryConfiguration.status === 200) {
                            annotationData=undefined;
                            additionRegistryData="";
                            registryType = registryConfiguration.registryType;
                            if(registryType === 1){
                                hideLoginPanel();
                                showEsPublicoPanel();
                                $("#div-t-system-document-types").hide();
                                $("#div-add-registration-number").hide();
                            }else if(registryType === 2){
                                $options='<option value="">' + $("#msgselectdocumenttype").html() + '</option>';
								if(registryConfiguration.tSystemDocumentTypes.length > 0){
									for(var t=0; t < registryConfiguration.tSystemDocumentTypes.length; t++){
										$options=$options + '<option value="'+registryConfiguration.tSystemDocumentTypes[t].GUID+'">'+registryConfiguration.tSystemDocumentTypes[t].DocumentType+'</option>';
									}
                                }
                                $optionsBookCodes='<option value="">' + $("#msgselectbookcode").html() + '</option>';
								if(registryConfiguration.tSystemBookCodes.length > 0){
                                    registryBookCodes = registryConfiguration.tSystemBookCodes;
									for(var t=0; t < registryConfiguration.tSystemBookCodes.length; t++){
										$optionsBookCodes=$optionsBookCodes + '<option value="'+registryConfiguration.tSystemBookCodes[t].Code+'">'+registryConfiguration.tSystemBookCodes[t].Description+'</option>';
									}
                                }
                                $('#t-system-book').editableSelect('clear');
                                $('#t-system-book').editableSelect('destroy');
                                $("#t-system-book").html($optionsBookCodes);                                
                                $('#t-system-book').editableSelect({filter:false});
                                $("#t-system-book").val($("#msgselectbookcode").html());
                                hideLoginPanel();
                                showTSystemPanel();
                                $("#t-system-document-types").html($options);
                                var tSystemDocumentType = getCookie('vid-t-system-document-type');
                                if(tSystemDocumentType!=null && tSystemDocumentType!=undefined){
                                    $("#t-system-document-types").val(tSystemDocumentType);
                                }else{
                                    $("#t-system-document-types").val(tSystemDocumentType);
                                }
                                $("#div-t-system-document-types").show();
                                $("#div-add-registration-number").show();
                            }else{
                                $("#div-t-system-document-types").hide();
                                $("#div-add-registration-number").hide();
                                doLogin();
                            }
                        }else if (registryConfiguration.status === 403) {
                            $("#btn-login").css('display', 'inline');
                            $("#img-login").css('display', 'none');
                            $("#msg-error").html($("#erroraccessdata").html());
                            $("#msg-error").show();
                        } else {
                            $("#btn-login").css('display', 'inline');
                            $("#img-login").css('display', 'none');
                            $("#msg-error").html($("#erroraccessdata").html());
                            $("#msg-error").show();
                        }
                    },
                    error: function (xhr, ajaxOptions, thrownError) {
                        $("#btn-login").css('display', 'inline');
                        $("#img-login").css('display', 'none');
                        $("#msg-error").html($("#errortoprocesslogin").html());
                        $("#msg-error").show();
                    }
                });
            }
        }
    });

    $("#btn-registry-ok").click(function () {
        $("#msg-error").html('');
        $("#msg-error").hide();
        var msg = "";
        $("#t-system-book").removeClass("field-error");
        $("#t-system-annotation-number").removeClass("field-error");
        $("#espublico-annotation-number").removeClass("field-error");
        var annotationNumber="";
        if(registryType === 1){
            annotationNumber = $("#espublico-annotation-number").val();
            if (annotationNumber === "") {
                msg = msg + "<span>"+$("#errorannotationrequired").html()+"</span><br/>";
                $("#espublico-annotation-number").addClass("field-error");
            }
        }else if(registryType === 2){
            if (getRegistryBookCodeByDescription($("#t-system-book").val()) == "") {
                msg = msg + "<span>"+$("#errorbookrequired").html()+"</span><br/>";
                $("#t-system-book").addClass("field-error");
            }
            annotationNumber = $("#t-system-annotation-number").val();
            if (annotationNumber === "") {
                msg = msg + "<span>"+$("#errorannotationrequired").html()+"</span><br/>";
                $("#t-system-annotation-number").addClass("field-error");
            }
        }
        if (msg !== "") {
            $("#msg-error").html(msg);
            $("#msg-error").show();
        } else {
            $("#btn-registry-ok").css('display', 'none');
            $("#img-registry-ok").css('display', 'inline');
            $.ajax({
                url: "https://sendto.vidsigner.net/registryconfiguration.php",
                type: 'POST',
                async: true,
                cache: false,
                data: "action=1&environment=" + $("#environment").val() + "&subscription-user=" + $("#subscription-user").val() + "&subscription-pass=" + $("#subscription-pass").val() + "&registry-type=" + registryType  + "&annotation-number=" + annotationNumber + "&book=" + getRegistryBookCodeByDescription($("#t-system-book").val()),
                success: function (data) {
                    //Si el registro es de tipo T-System, guardamos el dato del libro
                    if(registryType === 2){
                        saveCookie('vid-t-system-book', getRegistryBookCodeByDescription($("#t-system-book").val()));
                    }
                    var response = JSON.parse(data);
                    if(response.status === 200){
                        annotationData=response.annotationData; 
                        doLogin();
                    }else{
                        $("#btn-registry-ok").css('display', 'inline');
                        $("#img-registry-ok").css('display', 'none');
                        $("#msg-error").html($("#errortoloadregisterdata").html());
                        $("#msg-error").show();    
                    }
                },
                error: function (xhr, ajaxOptions, thrownError) {
                    $("#btn-registry-ok").css('display', 'inline');
                    $("#img-registry-ok").css('display', 'none');
                    $("#msg-error").html($("#errortoloadregisterdata").html());
                    $("#msg-error").show();
                }
            });
        }
    });

    $("#btn-send-home").click(function () {
        downloadOpen = false;
        $('#myModal').modal('show');
        $("#header-box").css('visibility', 'hidden');
        showNewSignerPanel();
        hideNewFormPanel();
        $("#canvas-doc-form").css('display', 'none');
        $("#preview-form-question").css('display', 'none');
        $("#canvas-doc").css('display', 'inherit');
        $("#preview-signature").css('display', 'inherit');
        /**Recuperamos otra vez la cookie por si no ha querido hacer reload en la página*/
        var orderedSignatures = getCookie('vid-signatures-ordered');
        if (typeof orderedSignatures !== 'undefined' && orderedSignatures !== ""){
            if (orderedSignatures === '0') {
                $('.btn-add-questions-form').css('pointer-events', 'none');
                $('#button-with-icon-span').css('color', '#aaadb3');
            } else {
                $('.btn-add-questions-form').css('pointer-events', 'auto');
                $('#button-with-icon-span').css('color', '#434446');
            }
        }
        else {
            /**La cookie no existe y por lo tanto se pone la creación de form desactivada por defecto */
            $('.btn-add-questions-form').css('pointer-events', 'none');
            $('.tooltip-container').css('cursor', 'no-drop');
            $('#button-with-icon-span').css('color', '#aaadb3');
        }
    });

    $(".close").click(function () {
        $(".modal-body").css("width", "");
        $("#header-box").css('visibility', 'visible');
        $("#canvas-doc").css('display', 'inherit');
        $("#preview-signature").css('display', 'inherit');
        $("#canvas-doc-form").css('display', 'none');
        $("#preview-form-question").css('display', 'none');
        $("#question-title").val("");
        showNewSignerPanel();
        clearFullCanvas();
        clearFullQuestionsCanvas();
    });

    $("#btn-ok-preview-privacy").click(function () {
        if (windowWidth > 1024){
            $(".modal-body").css('width', '25%');
        }
        if (windowWidth <= 1024){
            $(".modal-body").css('width', '50%');
        }
        if (windowWidth <= 768){
            $(".modal-body").css('width', '50%');
        }
        if (windowWidth <= 480){
            $(".modal-body").css('width', '100%');
        }
    });

    $("#btn-ok-preview-legal").click(function () {
        if (windowWidth > 1024){
            $(".modal-body").css('width', '25%');
        }
        if (windowWidth <= 1024){
            $(".modal-body").css('width', '50%');
        }
        if (windowWidth <= 768){
            $(".modal-body").css('width', '50%');
        }
        if (windowWidth <= 480){
            $(".modal-body").css('width', '100%');
        }
    });

    $("#btn-close").click(function () {
        if (windowWidth > 1024){
            $(".modal-body").css('width', '25%');
        }
        if (windowWidth <= 1024){
            $(".modal-body").css('width', '50%');
        }
        if (windowWidth <= 768){
            $(".modal-body").css('width', '50%');
        }
        if (windowWidth <= 480){
            $(".modal-body").css('width', '100%');
        }
        $("#header-box").css('visibility', 'visible');
        $("#canvas-doc").css('display', 'inherit');
        $("#preview-signature").css('display', 'inherit');
        $("#canvas-doc-form").css('display', 'none');
        $("#preview-form-question").css('display', 'none');
        $("#question-title").val("");
        showNewSignerPanel();
        clearFullCanvas();
        clearFullQuestionsCanvas();
    });

    $(".footer-links").click(function () {
        $(".modal-body").css('width', '100%');
        $(".modal-body").css('max-height', 'none');
    });

    $("#btn-download").click(function () {
        downloadOpen = true;
        $('#myModal').modal('show');
        $("#header-box").css('visibility', 'hidden');
    });

    $("#btn-return").click(function () {
        $('#document-list').html('');
        $('html, body').css('overflowY', 'hidden');
        $("#downloadpage").hide();
        $("#header").show();
        $("#header-box").css('visibility', 'visible');
        if (windowWidth > 1024){
            $(".modal-body").css('width', '25%');
        }
        if (windowWidth <= 1024){
            $(".modal-body").css('width', '50%');
        }
        if (windowWidth <= 768){
            $(".modal-body").css('width', '50%');
        }
        if (windowWidth <= 480){
            $(".modal-body").css('width', '100%');
        }
    });

    $("#btn-add-question").click(function () {
        //Save current question data and add empty question
        $("#msg-error").html("");
        $("#msg-error").hide();
        cleanFieldsErrorClass();
        var msg = validateQuestions();
        if (msg !== "") {
            $("#msg-error").html(msg);
            $("#msg-error").show();
        } else {

            saveQuestionData();
            $("#question-title").val("");
            $("#preview-form-question").css("width", questionWpixels + "px");
            $("#preview-form-question").css("height", questionHpixels + "px");
            $("#preview-form-question").css("left", questionPosXpixels + "px");
            $("#preview-form-question").css("top", questionPosYpixels + "px");

            //$("#page_num").val('1');
            $('#question-x').val(questionPosXmm);
            $('#question-y').val(questionPosYmm);
            $("#question-width").val(questionWmm);
            $("#question-height").val(questionHmm);

            addFormQuestion();
        }
    });

    $("#btn-remove-question").click(function () {
        if (currentQuestion === 0) {
            $("#question-title").val("");
        }
        if (formQuestionsList.length > 1) {
            //Se comprueba si la pregunta actual es mayor de 1, si lo es se muestra la anterior; si es la primera y hay más en el array se muestra la primera de todas
            if (currentQuestion > 1){
                clearQuestion();
                formQuestionsList.splice(currentQuestion, 1);
                currentQuestion = currentQuestion - 1;
                $("#current-question").html(currentQuestion + 1);
                $("#question-number").html(currentQuestion + 1);
                $("#num-questions").html(formQuestionsList.length);

                //Cargamos los datos de la pregunta anterior
                loadCurrentQuestionData(currentQuestion);
            }
            else {
                clearQuestion();
                formQuestionsList.splice(currentQuestion, 1);
                currentQuestion = 0;
                $("#current-question").html(1);
                $("#question-number").html(1);
                $("#num-questions").html(formQuestionsList.length);

                //Cargamos los datos del primer firmante
                loadCurrentQuestionData(0);
            }
        }
    });

    $(".btn-add-signer").click(function () {
        //Save current signer data and add empty signer
        $("#msg-error").html("");
        $("#msg-error").hide();
        cleanFieldsErrorClass();
        var msg = validateSigner();
        if (msg !== "") {
            $("#msg-error").html(msg);
            $("#msg-error").show();
        } else {
            $(".btn-add-questions-form").css('display', 'none');

            saveSignerData();

            $('#div-certificates').hide();
            $("#div-user-certificates").hide();
            $('#div-pin').hide();            
            $('#div-phone-number').hide();
            $('#div-email-body').hide();
            $('#div-email-subject').hide();
            $('#div-issuer-name').hide();
            $("#send-email-notification").prop('checked', false);

            if (SignatureChannelIsEmpty(signatureChannles.SignatureChannels) || existSignatureChannel(signatureChannles.SignatureChannels, "bio")) {
                $('#div-devices').show();
            } else {
                $('#div-devices').hide();
            }

            $("#signer-name").val("");
            $("#signer-id-type").val("");
            $("#signer-id").val("");
            $("#signer-email").val("");
            $("#device").val(-1);
            $("#signature-type").val("none");
            $("#signer-language").val("");
            $("#phone-number").val("");
            $("#email-subject").val("");
            $("#email-body").val("");
            $("#certificates").val("");
            $("#signer-id-pin").val("");
            $('#user-certificates').prop('selectedIndex',0);

            $("#preview-signature").css("width", signatureWpixels + "px");
            $("#preview-signature").css("height", signatureHpixels + "px");
            $("#preview-signature").css("left", signaturePosXpixels + "px");
            $("#preview-signature").css("top", signaturePosYpixels + "px");

            $("#page_num").val('1');
            $('#signature-x').val(signaturePosXmm);
            $('#signature-y').val(signaturePosYmm);
            $("#signature-width").val(signatureWmm);
            $("#signature-height").val(signatureHmm);

            addSigner();
        }
    });

    $("#btn-remove-signer").click(function () {
        $("#msg-error").html("");
        $("#msg-error").hide();
        cleanFieldsErrorClass();
        if (signersList.length > 1) {
            $('#remove-signer-confirm').modal('show');
        }
    });

    $(".btn-add-questions-form").click(function () {
        $("#msg-error").html("");
        $("#msg-error").hide();
        cleanFieldsErrorClass();
        var msg = validateSigner();
        if (msg !== "") {
            $("#msg-error").html(msg);
            $("#msg-error").show();
        }
        else {
            if (currentQuestion) {
                if (formQuestionsList.length > 0) {
                    $("#page_num").html(formQuestionsList[currentQuestion].Visible.Page);
                }
            }
            currentSignerPage = signersList[currentSigner].Visible.Page;
            $('#btn-add-questions-form').modal('hide');
            hideNewSignerPanel();
            showNewFormPanel();
            $("#canvas-doc-form").css('display', 'inherit');
            $("#preview-form-question").css('display', 'inherit');
            $("#canvas-doc").css('display', 'none');
            $("#preview-signature").css('display', 'none');
            if (formQuestionsList.length === 0){
                addFormQuestion();
            }
        }
    });

    $(".btn-add-signer-form").click(function () {
        clearFullCanvas();
        drawSquareShadow();
        signersList[currentSigner].Visible.Page = currentSignerPage;
        $("#page_num").html(signersList[currentSigner].Visible.Page);
        hideNewFormPanel();
        showNewSignerPanel();
        $("#canvas-doc").css('display', 'inherit');
        $("#preview-signature").css('display', 'inherit');
        $("#canvas-doc-form").css('display', 'none');
        $("#preview-form-question").css('display', 'none');
    });

    $("#btn-remove-yes").click(function () {
        if (currentSigner === 1) {
            /**IE no permite usar display initial, por eso se comprueba el navegador préviamente */
            if (detectBrowser === false){
                $(".btn-add-questions-form").css('display', 'initial');
            }
            else {
                $(".btn-add-questions-form").css('display', '');
            }
        }
        if (signersList.length > 1) {
            //Se comprueba si el firmante actual es mayor de 1, si lo es se muestra el anterior; si es el primero y hay más en el array se muestra el primero de todos
            if (currentSigner > 1){
                clearSignature();
                signersList.splice(currentSigner, 1);
                currentSigner = currentSigner - 1;
                $("#current-signer").html(currentSigner + 1);
                $("#signature-number").html(currentSigner + 1);
                $("#num-signers").html(signersList.length);

                //Cargamos los datos del firmante anterior
                loadCurrentSignerData(currentSigner);
                $('#remove-signer-confirm').modal('hide');
            }
            else {
                clearSignature();
                signersList.splice(currentSigner, 1);
                currentSigner = 0;
                $("#current-signer").html(1);
                $("#signature-number").html(1);
                $("#num-signers").html(signersList.length);

                //Cargamos los datos del primer firmante
                loadCurrentSignerData(0);
                $('#remove-signer-confirm').modal('hide');
            }
        }
    });

    $("#btn-remove-no").click(function () {
        $('#remove-signer-confirm').modal('hide');
    });


    $("#next-signer").click(function () {
        console.log('ON NEXT SIGNER');
        console.log(signersList);

        if (currentSigner < (signersList.length - 1)) {
            $(".btn-add-questions-form").css('display', 'none');
            $("#msg-error").html("");
            $("#msg-error").hide();
            cleanFieldsErrorClass();
            var msg = validateSigner();
            if (msg !== "") {
                $("#msg-error").html(msg);
                $("#msg-error").show();
            } else {
                currentSigner = currentSigner + 1;
                loadCurrentSignerData(currentSigner);
                $("#current-signer").html(currentSigner + 1);
                $("#signature-number").html(currentSigner + 1);
                drawSquareShadow();
            }
        }
    });

    $("#signature-number").addClass("signature-number");

    $("#prev-signer").click(function () {
        console.log('ON PREV');
        if (signersList.length > 1 && currentSigner > 0) {
            $("#msg-error").html("");
            $("#msg-error").hide();
            cleanFieldsErrorClass();
            var msg = validateSigner();
            if (msg !== "") {
                $("#msg-error").html(msg);
                $("#msg-error").show();
            } else {
                if (currentSigner === 1) {
                    $(".btn-add-questions-form").css('display', 'initial');
                }
                currentSigner = currentSigner - 1;
                loadCurrentSignerData(currentSigner);
                $("#current-signer").html(currentSigner + 1);
                $("#signature-number").html(currentSigner + 1);
                drawSquareShadow();
            }
        }
    });

    $("#next-question").click(function () {


        if (currentQuestion < (formQuestionsList.length - 1)) {
            $("#msg-error").html("");
            $("#msg-error").hide();
            cleanFieldsErrorClass();
            var msg = validateQuestions();
            if (msg !== "") {
                $("#msg-error").html(msg);
                $("#msg-error").show();
            } else {
                currentQuestion = currentQuestion + 1;
                loadCurrentQuestionData(currentQuestion);
                $("#current-question").html(currentQuestion + 1);
                $("#question-number").html(currentQuestion + 1);
                drawSquareShadowQuestion();
            }
        }
    });

    $("#question-number").addClass("question-number");

    $("#prev-question").click(function () {
        if (formQuestionsList.length > 1 && currentQuestion > 0) {
            $("#msg-error").html("");
            $("#msg-error").hide();
            cleanFieldsErrorClass();
            var msg = validateQuestions();
            if (msg !== "") {
                $("#msg-error").html(msg);
                $("#msg-error").show();
            } else {
                currentQuestion = currentQuestion - 1;
                loadCurrentQuestionData(currentQuestion);
                $("#current-question").html(currentQuestion + 1);
                $("#question-number").html(currentQuestion + 1);
                drawSquareShadowQuestion();
            }
        }
    });

    $("#signer-name").focusout(function () {
        saveSignerData();
        $("#signer-name").removeClass("field-error");
    });
    $("#signer-id-type").focusout(function () {
        saveSignerData();
        $("#signer-id-type").removeClass("field-error");
    });
    $("#signer-id").focusout(function () {
        saveSignerData();
        $("#signer-id").removeClass("field-error");
    });
    $("#signer-email").focusout(function () {
        saveSignerData();
        $("#signer-email").removeClass("field-error");
    });
    $("#device").focusout(function () {
        saveSignerData();
        $("#device").removeClass("field-error");
    });
    $("#signature-type").focusout(function () {
        saveSignerData();
        $("#signature-type").removeClass("field-error");
    });
    $("#signer-language").focusout(function () {
        saveSignerData();
        $("#signer-language").removeClass("field-error");
    });
    $("#phone-number").focusout(function () {
        saveSignerData();
        $("#phone-number").removeClass("field-error");
    });
    $("#email-subject").focusout(function () {
        saveSignerData();
        $("#email-subject").removeClass("field-error");
    });
    $("#email-body").focusout(function () {
        saveSignerData();
        $("#email-body").removeClass("field-error");
    });
    $("#add-this-signer").change(function () {
        signersList[currentSigner].checked = $("#add-this-signer").is(':checked');
    });

    $("#send-signed-doc").change(function () {
        saveSignerData();
        $("#send-signed-doc").removeClass("field-error");
    });
    $("#add-registration-number").change(function () {
        saveSignerData();
        $("#add-registration-number").removeClass("field-error");
    });
    $("#user-certificates").change(function () {
        saveSignerData();
        if($("#user-certificates")[0].selectedIndex !== 0) {
            signersList[currentSigner].NumberID = $("#user-certificates").val();
            signersList[currentSigner].UserCertificateName = $("#user-certificates option:selected").text();
            $("#signer-name").val(signersList[currentSigner].UserCertificateName);
            $("#signer-id").val(signersList[currentSigner].NumberID);
            signersList[currentSigner].SignerName = signersList[currentSigner].UserCertificateName;
        }
        $("#user-certificates").removeClass("field-error");
    });
    $("#issuer-name").focusout(function () {
        saveSignerData();
        $("#issuer-name").removeClass("field-error");
    });
    $("#certificates").focusout(function () {
        saveSignerData();
        $("#certificates").removeClass("field-error");
    });
    $("#signer-id-pin").focusout(function () {
        saveSignerData();
        $("#signer-id-pin").removeClass("field-error");
    });
    $("#question-title").focusout(function () {
        saveQuestionData();
        $("#question-title").removeClass("field-error");
    });
    $("#signature-type").change(function () {
        if ($("#signature-type").val() === "emailandsms") {
            $("#div-issuer-name").show();
            $("#div-phone-number").show();
            $("#div-email-subject").show();
            $("#div-email-body").show();
            $("#div-devices").hide();
            $("#div-pin").hide(); //Esconder campo del código pin
            $("#div-certificates").hide();
            $("#div-signer-language").show();
            $("#div-user-certificates").hide();
            $("#div-signer-id-type").show();
            $("#div-signer-id").show();
            $("#div-send-email-notification").hide();
            $("#send-email-notification").prop('checked', false);
            if (currentSigner === 0){
                if (detectBrowser === false){
                    $(".btn-add-questions-form").css('display', 'initial');
                }
                else {
                    $(".btn-add-questions-form").css('display', '');
                }
            }
            loadSignerLanguage("emailandsms");
            delete signersList[currentSigner].DeviceName;
            delete signersList[currentSigner].StampCertificate;
            delete signersList[currentSigner].AdditionalInfo;
            delete signersList[currentSigner].SendCentralizedSignerEmailNotification;
            delete signersList[currentSigner].UserCertificateName;
        } else if ($("#signature-type").val() === "stamp") {
            signersList[currentSigner].NotificationEmailMessage = null;
            $("#div-devices").hide(); //Esconder el selector de los dispositivos
            $("#div-certificates").show(); //Mostrar el selector de los certificados
            $("#div-pin").show(); //Mostrar campo del código pin
            $("#div-issuer-name").hide();
            $("#div-phone-number").hide();
            $("#div-email-subject").hide();
            $("#div-email-body").hide();
            $("#div-signer-language").hide();
            $("#div-user-certificates").hide();
            $("#div-signer-id-type").show();
            $("#div-signer-id").show();
            $("#div-send-email-notification").hide();
            $("#send-email-notification").prop('checked', false);
            if (currentSigner === 0){
                if (detectBrowser === false){
                    $(".btn-add-questions-form").css('display', 'initial');
                }
                else {
                    $(".btn-add-questions-form").css('display', '');
                }
            }
            $(".btn-add-questions-form").css('display', 'none');
            delete signersList[currentSigner].Language;
            delete signersList[currentSigner].PhoneNumber;
            delete signersList[currentSigner].NotificationEmailMessage;
            delete signersList[currentSigner].DeviceName;
            delete signersList[currentSigner].AdditionalInfo;
            delete signersList[currentSigner].SendCentralizedSignerEmailNotification;
        } else if ($("#signature-type").val() === "mobile") {
            $("#div-devices").hide(); //Esconder el selector de los dispositivos
            $("#div-user-certificates").show(); //Mostrar el selector de los certificados
            $("#div-pin").hide();
            $("#div-phone-number").hide();
            $("#div-issuer-name").hide();
            $("#div-email-subject").hide();
            $("#div-email-body").hide();
            $("#div-signer-language").hide();
            $("#div-signer-id-type").show();
            $("#div-signer-id").show();
            $("#div-certificates").hide();
            $("#div-send-email-notification").show();
            $(".btn-add-questions-form").css('display', 'none');
            loadSignerLanguage("mobile");
            delete signersList[currentSigner].DeviceName;
            delete signersList[currentSigner].PhoneNumber;
            delete signersList[currentSigner].StampCertificate;
            delete signersList[currentSigner].AdditionalInfo;
        } else if ($("#signature-type").val() === "bio") {
            signersList[currentSigner].StampCertificate = null;
            $("#div-issuer-name").hide();
            $("#phone-number").val("");
            $("#div-phone-number").hide();
            $("#email-subject").val("");
            $("#div-email-subject").hide();
            $("#email-body").val("");
            $("#div-email-body").hide();
            $("#div-devices").show();
            $("#div-pin").hide(); //Esconder campo del código pin	
            $("#div-certificates").hide(); //Esconder el campo del certificado
            $("#div-signer-language").show();
            $("#div-user-certificates").hide();
            $("#div-signer-id-type").show();
            $("#div-signer-id").show();
            $("#div-send-email-notification").hide();
            $("#send-email-notification").prop('checked', false);
            if (currentSigner === 0){
                if (detectBrowser === false){
                    $(".btn-add-questions-form").css('display', 'initial');
                }
                else {
                    $(".btn-add-questions-form").css('display', '');
                }
            }
            loadSignerLanguage("bio");
            delete signersList[currentSigner].NotificationEmailMessage;
            delete signersList[currentSigner].PhoneNumber;
            delete signersList[currentSigner].StampCertificate;
            delete signersList[currentSigner].AdditionalInfo;
            delete signersList[currentSigner].SendCentralizedSignerEmailNotification;
            delete signersList[currentSigner].UserCertificateName;
        } else if ($("#signature-type").val() === "none") {
            signersList[currentSigner].StampCertificate = null;
            $("#div-issuer-name").hide();
            $("#phone-number").val("");
            $("#div-phone-number").hide();
            $("#email-subject").val("");
            $("#div-email-subject").hide();
            $("#email-body").val("");
            $("#div-email-body").hide();
            $("#div-devices").hide();
            $("#div-pin").hide(); //Esconder campo del código pin
            $("#div-certificates").hide(); //Esconder el campo del certificado
            $("#div-user-certificates").hide();
            $("#div-signer-id-type").show();
            $("#div-signer-id").show();
            $("#div-send-email-notification").hide();
            $("#send-email-notification").prop('checked', false);
            if (currentSigner === 0){
                if (detectBrowser === false){
                    $(".btn-add-questions-form").css('display', 'initial');
                }
                else {
                    $(".btn-add-questions-form").css('display', '');
                }
            }
            //El BIO siempre existe, con lo que si hay más canales, hay que ocultar por defecto, sino hay que mostrar.
            if(existEmailAndSMS || existStamp){
                $("#div-signer-language").hide();
            }else{
                $("#div-signer-language").show();
            }
            loadSignerLanguage("");
        }
        $("#signature-type").removeClass("field-error");
    });

    $('#btn-finish-upload').click(function(){
        showSignerPanel();
        cleanFieldsValues();
        cleanFieldsErrorClass();
        //Si el envío es a EsPublico
        if(registryType === 1){
            $("#result-content").html("");
            $("#result-body").hide();
            hideSignerPanel();
            showEsPublicoPanel();
            $("#form-send-body").show();
        }
        //Si el envío es a TSystem
        else if(registryType === 2){
            $("#result-content").html("");
            $("#result-body").hide();
            hideSignerPanel();
            showTSystemPanel();
            $("#form-send-body").show();
        }
        //Si el envío es normal
        else{
            $('#myModal').modal('hide');
        }
        $("#header-box").css('visibility', 'visible');
        if (windowWidth > 1024){
            $(".modal-body").css('width', '25%');
        }
        if (windowWidth <= 1024){
            $(".modal-body").css('width', '50%');
        }
        if (windowWidth <= 768){
            $(".modal-body").css('width', '50%');
        }
        if (windowWidth <= 480){
            $(".modal-body").css('width', '100%');
        }
    });

    doLogin = function(){
        $.ajax({
            url: 'https://sendto.vidsigner.net/login.php',
            type: 'POST',
            async: true,
            cache: false,
            data: "environment=" + $("#environment").val() + "&subscription-user=" + $("#subscription-user").val() + "&subscription-pass=" + $("#subscription-pass").val(),
            success: function (data) {
                var response = $.isNumeric(data);
                if (response) {
                    //Por si venimos de un registro
                    $("#btn-registry-ok").css('display', 'inline');
                    $("#img-registry-ok").css('display', 'none');
                    $("#btn-login").css('display', 'inline');
                    $("#img-login").css('display', 'none');
                    if (data === "403") {
                        $("#msg-error").html($("#erroraccessdata").html());
                        $("#msg-error").show();
                    } else {
                        $("#msg-error").html($("#errortoloaddevicelist").html());
                        $("#msg-error").show();
                    }
                } else {
                    signersList = [];

                    try {
                        var devicesText = '<option value="">' + $("#selectdevice").html() + '</option><option value="null">' + $("#devicenotassigned").html() + '</option>';
                        if (data !== '') {
                            var devices = JSON.parse(data);
                            if (devices !== null && devices.length > 0) {
                                $.each(devices, function (index, device) {
                                    devicesText = devicesText.concat('<option value="' + device.DeviceName + '">' + device.DeviceDescription + '</option>');
                                });
                            }
                        }
                        $("#device").html(devicesText);
                        //Cargamos la lista de canales de firma
                        $.ajax({
                            url: "https://sendto.vidsigner.net/signaturechannels.php",
                            type: 'POST',
                            async: true,
                            cache: false,
                            data: "environment=" + $("#environment").val() + "&subscription-user=" + $("#subscription-user").val() + "&subscription-pass=" + $("#subscription-pass").val(),
                            success: function (data) {
                                $("#btn-registry-ok").css('display', 'inline');
                                $("#img-registry-ok").css('display', 'none');
                                $("#btn-login").css('display', 'inline');
                                $("#img-login").css('display', 'none');
                                $(".modal-body").css('width', '100%');
                                if (data !== '') {
                                    existEmailAndSMS = false;
                                    existStamp = false;
                                    existCentralized = false;
                                    signatureChannles = JSON.parse(data);

                                    //Cargamos opción "none" por defecto
                                    var signatureTypeText = '<option value="none">' + $("#selectsignaturetype").html() + '</option>';

                                    //Comprobamos que la suscripción tenga los canales habilitados (check para suscripciones antiguas)
                                    if (existSignatureChannel(signatureChannles.SignatureChannels, "emailandsms") || existSignatureChannel(signatureChannles.SignatureChannels, "bio") || existSignatureChannel(signatureChannles.SignatureChannels, "stamp") || existSignatureChannel(signatureChannles.SignatureChannels, "mobile")) {
                                        //Si existe firma remota mostramos la opción en el selector
                                        if (existSignatureChannel(signatureChannles.SignatureChannels, "emailandsms")) {
                                            existEmailAndSMS = true;
                                            signatureTypeText = signatureTypeText + '<option value="emailandsms">' + $("#signatureremote").html() + '</option>';
                                        }
                                        //Si existe firma bio mostramos la opción en el selector
                                        if (existSignatureChannel(signatureChannles.SignatureChannels, "bio")) {
                                            existEmailAndSMS = true;
                                            signatureTypeText = signatureTypeText + '<option value="bio">' + $("#signatureany").html() + '</option>';
                                        }

                                        //Si existe firma stamp mostramos la opción en el selector
                                        if (existSignatureChannel(signatureChannles.SignatureChannels, "stamp")) {
                                            existStamp = true;
                                            signatureTypeText = signatureTypeText + '<option value="stamp">' + $("#signaturestamp").html() + '</option>';
                                            $.ajax({
                                                url: "https://sendto.vidsigner.net/stampcertificates.php",
                                                type: 'POST',
                                                async: true,
                                                cache: false,
                                                data: "environment=" + $("#environment").val() + "&subscription-user=" + $("#subscription-user").val() + "&subscription-pass=" + $("#subscription-pass").val(),
                                                success: function (data) {
                                                    $("#btn-login").css('display', 'inline');
                                                    $("#img-login").css('display', 'none');
                                                    if (data !== '') {
                                                        var stampcertificates = JSON.parse(data);
                                                        var certificateText = '<option value="">' + $("#selectcertificate").html() + '</option>';

                                                        //Recorrer el array de stampcertificates y mostrar los certificados
                                                        if (stampcertificates !== null && stampcertificates.length > 0) {
                                                            $.each(stampcertificates, function (index, certificate) {
                                                                certificateText = certificateText + '<option value="' + certificate.CertificateGUID + '">' + certificate.Description + ' (' + certificate.ExpirationDate + ')' + '</option>';
                                                            });
                                                        }
                                                    }
                                                    $("#certificates").html(certificateText);
                                                    if ($("#signature-type").val() === "stamp") {
                                                        if (signersList[currentSigner].StampCertificate !== null) {
                                                            if (signersList[currentSigner].StampCertificate.CertificateGUI !== "") {
                                                                $("#certificates").val(signersList[currentSigner].StampCertificate.CertificateGUI);
                                                            }
                                                        }
                                                    }
                                                }
                                            });
                                        }

                                        //Si existe firma centralizada mostramos la opción en el selector
                                        if (existSignatureChannel(signatureChannles.SignatureChannels, "mobile")) {
                                            existCentralized = true;
                                            signatureTypeText = signatureTypeText + '<option value="mobile">' + $("#signaturecentralized").html() + '</option>';
                                            $.ajax({
                                                url: 'https://sendto.vidsigner.net/usercertificates.php',
                                                type: 'POST',
                                                async: true,
                                                cache: false,
                                                data: "environment=" + $("#environment").val() + "&subscription-user=" + $("#subscription-user").val() + "&subscription-pass=" + $("#subscription-pass").val(),
                                                success: function (data) {
                                                    $("#btn-login").css('display', 'inline');
                                                    $("#img-login").css('display', 'none');
                                                    if (data !== '') {
                                                        var usercertificates = JSON.parse(data);
                                                        var userCertificatesText = '<option value="">' + $("#selectusercertificate").html() + '</option>';

                                                        //Recorrer el array de usuarios y mostrarlos
                                                        if (usercertificates !== null && usercertificates.length > 0) {
                                                            $.each(usercertificates, function (index, certificate) {
                                                                userCertificatesText = userCertificatesText + '<option value="' + certificate.legalid + '">' + certificate.username + '</option>';
                                                            });
                                                        }
                                                    }
                                                    $("#user-certificates").html(userCertificatesText);
                                                    //asignar un valor inicial si está guardado en las cookies
                                                    if ($("#signature-type").val() === "mobile") {
                                                        if (signersList[currentSigner].NumberID !== null) {
                                                            $("#user-certificates").val(signersList[currentSigner].NumberID);
                                                        }
                                                    }
                                                }
                                            });
                                        }
                                    }
                                    //Si es una suscripción antigua sin canales habilitados, se le carga la firma bio por defecto
                                    else {
                                        signatureTypeText = signatureTypeText + '<option value="bio">' + $("#signatureany").html() + '</option>';
                                    }

                                    //Asignamos los diferentes tipos de firma cargadas al selector
                                    $("#signature-type").html(signatureTypeText);
                                    $("#div-signature-type").show();
                                    $("#div-devices").hide();
                                    $("#div-issuer-name").hide();
                                    $("#div-phone-number").hide();
                                    $("#div-email-subject").hide();
                                    $("#div-email-body").hide();
                                    $("#div-certificates").hide();
                                    $("#div-pin").hide();

                                    saveCookie('vid-env', $("#environment").val());
                                    saveCookie('vid-subscription-user', $("#subscription-user").val());
                                    saveCookie('vid-subscription-pass', $("#subscription-pass").val());

                                    issuerName = getCookie('vid-issuername');
                                    $("#issuer-name").val(getCookie('vid-issuername'));

                                    var vidSignaturesOrdered = getCookie('vid-signatures-ordered');
                                    if (vidSignaturesOrdered === "1") {
                                        $("#signatures-ordered").prop('checked', true);
                                    } else {
                                        $("#signatures-ordered").removeAttr('checked');
                                    }
                                    var vidSaveSignersData = getCookie('vid-save-signers-data');
                                    if (vidSaveSignersData == "1") {
                                        $("#save-signers-data").prop('checked', true);
                                    } else {
                                        $("#save-signers-data").removeAttr('checked');
                                    }
                                    var signersInfo = getCookie('vid-signers-v2');
                                    if(registryType===1 || registryType===2){
                                        if(signersInfo !== "" && signersInfo !== null && typeof signersInfo !== "undefined"){
                                            signersInfo = JSON.parse(B64ToUTF8(signersInfo))
                                        }
                                        var signersInfoString = JSON.stringify(getSignerFromAnnotationData(signersInfo));
                                        signersInfo = UTF8ToB64(signersInfoString);
                                    }
                                    if (signersInfo !== null && signersInfo !== "") {
                                        signersList = JSON.parse(B64ToUTF8(signersInfo));
                                        if (signersList.length > 0) {
                                            //Borramos aquellos datos que no sean congruentes
                                            clearSignerList(existEmailAndSMS);
                                            currentSigner = 0;
                                            loadCurrentSignerData(currentSigner);
                                            $("#current-signer").html(1);
                                            $("#signature-number").html(1);
                                            $("#num-signers").html(signersList.length);
                                            $("#current-question").html(1);
                                            $("#num-questions").html(formQuestionsList.length);
                                        } else {
                                            $("#signer-name").val("");
                                            $("#signer-id-type").val("");
                                            $("#signer-id").val("");
                                            $("#signer-email").val("");
                                            $("#device").val("");
                                            $("#signature-type").val("none");
                                            loadSignerLanguage("");
                                            $("#signer-language").val("");
                                            $("#phone-number").val("");
                                            $("#email-subject").val("");
                                            $("#email-body").val("");
                                            $("#issuer-name").val("");
                                            $("#send-signed-doc").removeAttr('checked');
                                            $("#certificates").val("");
                                            $("#signer-id-pin").val("");

                                            $("#question-title").val("");

                                            addSigner();
                                        }
                                        if (formQuestionsList.length > 0) {
                                            currentQuestion = 0;
                                            loadCurrentQuestionData(currentQuestion);
                                        }
                                        else {
                                            //console.log('no hay preguntas guardadas');
                                        }

                                        } else {
                                        $("#signer-name").val("");
                                        $("#signer-id-type").val("");
                                        $("#signer-id").val("");
                                        $("#signer-email").val("");
                                        $("#device").val("");
                                        $("#signature-type").val("none");
                                        loadSignerLanguage("");
                                        $("#signer-language").val("");
                                        $("#phone-number").val("");
                                        $("#email-subject").val("");
                                        $("#email-body").val("");
                                        $("#issuer-name").val("");
                                        $("#send-signed-doc").removeAttr('checked');
                                        $("#certificates").val("");
                                        $("#signer-id-pin").val("");

                                        $("#question-title").val("");

                                        addSigner();
                                    }
                                    hideLoginPanel();
                                    hideTSystemPanel();
                                    hideEsPublicoPanel();
                                    hideNewFormPanel();
                                    showSignerPanel();
                                    $('#div-btn-send').css('display', 'none');
                                } else {
                                    if (windowWidth > 1024){
                                        $(".modal-body").css('width', '25%');
                                    }
                                    if (windowWidth <= 1024){
                                        $(".modal-body").css('width', '50%');
                                    }
                                    if (windowWidth <= 768){
                                        $(".modal-body").css('width', '50%');
                                    }
                                    if (windowWidth <= 480){
                                        $(".modal-body").css('width', '100%');
                                    }
                                    $("#btn-login").css('display', 'inline');
                                    $("#img-login").css('display', 'none');
                                    //$("#msg-error").html($("#errortochecksubscriptionsignaturechannels").html());
                                    $("#msg-error").html($("#erroraccessdata").html());
                                    ''
                                    $("#msg-error").show();
                                }
                            },
                            error: function (xhr, ajaxOptions, thrownError) {
                                $("#btn-registry-ok").css('display', 'inline');
                                $("#img-registry-ok").css('display', 'none');
                                $("#btn-login").css('display', 'inline');
                                $("#img-login").css('display', 'none');
                                //$("#msg-error").html($("#errortochecksubscriptionsignaturechannels").html());
                                $("#msg-error").html($("#erroraccessdata").html());
                                $("#msg-error").show();
                            }
                        });
                    } catch (e) {
                        $("#btn-registry-ok").css('display', 'inline');
                        $("#img-registry-ok").css('display', 'none');
                        $("#btn-login").css('display', 'inline');
                        $("#img-login").css('display', 'none');
                        $("#msg-error").html($("#errortoprocesslogin").html());
                        $("#msg-error").show();
                    }
                }
            },
            error: function (xhr, ajaxOptions, thrownError) {
                $("#btn-registry-ok").css('display', 'inline');
                $("#img-registry-ok").css('display', 'none');
                $("#btn-login").css('display', 'inline');
                $("#img-login").css('display', 'none');
                $("#msg-error").html($("#errortoprocesslogin").html());
                $("#msg-error").show();
            }
        });
    };

    doDonwload = function(){
        $.ajax({
            url: 'https://sendto.vidsigner.net/download.php',
            type: 'POST',
            async: true,
            cache: false,
            data: "environment=" + $("#environment").val() + "&subscription-user=" + $("#subscription-user").val() + "&subscription-pass=" + $("#subscription-pass").val(),
            success: function (data) {
                $("#btn-login").css('display', 'inline');
                $("#img-login").css('display', 'none');
                if (data === "403") {
                    $("#msg-error").html($("#erroraccessdata").html());
                    $("#msg-error").show();
                } else {
                    var response = $.isNumeric(data);
                    if (response && data !== "404") {
                        $("#document-list-msg-error").html($("#errortoreload").html());
                        $("#document-list-msg-error").show();
                    } else {
                        if (data === "404") {
                            $('#document-list').html('<h4>' + $("#erroremptylist").html() + '</h4>');
                        } else {
                            try {
                                var signedDocuments = JSON.parse(data);
                                if (signedDocuments !== null && signedDocuments.length > 0) {
                                    signedDocumentsText = '';
                                    $.each(signedDocuments, function (index, doc) {
                                        signedDocumentsText = signedDocumentsText.concat('<div id="doc-' + index + '" class="document-list-item" onclick="javascript: return downloadDocumentFromList(\'' + doc.DocGUI + '\',\'' + scapeFileName(doc.FileName) + '\',\'' + index + '\');"><span class="file-name">' + doc.FileName + '</span><img class="btn-download-file" id="btn-download-file-' + index + '" src="svg/sendTo-download.svg" alt="Download file"><img id="downloading-' + index + '" width="40px;" src="./img/spinner.gif" style="float:right; margin-right:6px; display:none;"><img id="downloaded-' + index + '" width="40px;" src="./img/downloaded.png" style="float:right; display:none"></div>');
                                    });
                                    $('#document-list').html(signedDocumentsText);
                                }
                                saveCookie('vid-env', $("#environment").val());
                                saveCookie('vid-subscription-user', $("#subscription-user").val());
                                saveCookie('vid-subscription-pass', $("#subscription-pass").val());

                            } catch (e) {
                                $("#document-list-msg-error").html($("#errortoreload").html());
                                $("#document-list-msg-error").show();
                            }
                        }
                        $("#header").hide();
                        $('html, body').css('overflowY', 'auto');
                        $("#downloadpage").show();
                        $('#myModal').modal('hide');
                    }
                }

            },
            error: function (xhr, ajaxOptions, thrownError) {
                $("#btn-login").css('display', 'inline');
                $("#img-login").css('display', 'none');
                $("#msg-error").html($("#errorloginprocess").html());
                $("#msg-error").show();
            }
        });
    };

    getSignerFromAnnotationData = function(signersInfoFromCookies){
        var device="";
        var sendSignedDoc=false;
        var sendEmailNotification=false;
        var additionalInfo=false;
        var visible = {};
        var langauge="";
        visible.Page = 1;
        visible.PosX = 10;
        visible.PosY = 10;
        visible.SizeX = 60;
        visible.SizeY = 20;
        visible.anchor = null;
        var email="";
        if(signersInfoFromCookies !== null && signersInfoFromCookies !== null && typeof signersInfoFromCookies !== "undefined" && signersInfoFromCookies.length > 0){
            if(signersInfoFromCookies[0].DeviceName !== null && typeof signersInfoFromCookies[0].DeviceName !== "undefined"){
                device=signersInfoFromCookies[0].DeviceName;
            }
            if(signersInfoFromCookies[0].sendSignedDoc !== null && typeof signersInfoFromCookies[0].sendSignedDoc !== "undefined"){
                sendSignedDoc=signersInfoFromCookies[0].sendSignedDoc;
            }
            if(signersInfoFromCookies[0].sendEmailNotification !== null && typeof signersInfoFromCookies[0].sendEmailNotification !== "undefined"){
                sendEmailNotification=signersInfoFromCookies[0].sendEmailNotification;
            }
            if(signersInfoFromCookies[0].Visible !== null && typeof signersInfoFromCookies[0].Visible !== "undefined"){
                visible=signersInfoFromCookies[0].Visible;
            }
            if(signersInfoFromCookies[0].Language !== null && signersInfoFromCookies[0].Language !== "" && typeof signersInfoFromCookies[0].Language !== "undefined"){
                langauge = signersInfoFromCookies[0].Language;
            }
            if(signersInfoFromCookies[0].AdditionalInfo!==null && signersInfoFromCookies[0].AdditionalInfo!=="" && typeof signersInfoFromCookies[0].AdditionalInfo !== "undefined"){
                additionalInfo = true;
            }
        }
        var signersAnnotationList=[];
        
        var signerAnnotation={};
        if(registryType === 1){
            signerAnnotation.TypeOfID = "NIF";
            signerAnnotation.NumberID = annotationData.solicitor.nif;
            signerAnnotation.SignerName = annotationData.solicitor.name;
            signerAnnotation.DeviceName = device;
            signerAnnotation.SignatureType = "bio";
            signerAnnotation.Language = langauge;
            signerAnnotation.sendSignedDoc = sendSignedDoc;
            if(annotationData.solicitor.email !== null && annotationData.solicitor.email !== "" && typeof annotationData.solicitor.email !== "undefined"){
                signerAnnotation.eMail = annotationData.solicitor.email;
            }else{
                signerAnnotation.eMail = email;
            }
            signerAnnotation.PhoneNumber = annotationData.solicitor.mobile;  
            signerAnnotation.Visible = visible;
            signerAnnotation.AdditionalInfo = "";
            if(annotationData.deputy !== null && typeof annotationData.deputy !== "undefined"){
                if(annotationData.deputy.name !== ""){
                    signerAnnotation.SignerName = annotationData.deputy.name;
                }
                if(annotationData.deputy.nif !== ""){
                    signerAnnotation.NumberID = annotationData.deputy.nif;
                }
                if(annotationData.deputy.mobile !== ""){
                    signerAnnotation.PhoneNumber = annotationData.deputy.mobile;
                }
                if(annotationData.deputy.email !== ""){
                    signerAnnotation.eMail = annotationData.deputy.email;
                }
            }            
            signersAnnotationList.push(signerAnnotation);
        }else if(registryType === 2){
            signerAnnotation.TypeOfID = "NIF";
            signerAnnotation.NumberID = annotationData.solicitor.nif;
            signerAnnotation.SignerName = annotationData.solicitor.name;
            signerAnnotation.DeviceName = device;
            signerAnnotation.SignatureType = "bio";
            signerAnnotation.Language = langauge;
            signerAnnotation.sendSignedDoc = sendSignedDoc;
            if(annotationData.solicitor.email !== null && annotationData.solicitor.email !== "" && typeof annotationData.solicitor.email !== "undefined"){
                signerAnnotation.eMail = annotationData.solicitor.email;
            }else{
                signerAnnotation.eMail = email;
            }
            signerAnnotation.PhoneNumber = annotationData.solicitor.mobile;            
            signerAnnotation.Visible = visible;
            if(additionalInfo){
                signerAnnotation.AdditionalInfo = "REG - " + annotationData.annotationcode;
            }else{
                signerAnnotation.AdditionalInfo = "";
            }
            if(annotationData.deputy !== null && typeof annotationData.deputy !== "undefined"){
                if(annotationData.deputy.name !== ""){
                    signerAnnotation.SignerName = annotationData.deputy.name;
                }
                if(annotationData.deputy.nif !== ""){
                    signerAnnotation.NumberID = annotationData.deputy.nif;
                }
                if(annotationData.deputy.mobile !== ""){
                    signerAnnotation.PhoneNumber = annotationData.deputy.mobile;
                }
                if(annotationData.deputy.email !== ""){
                    signerAnnotation.eMail = annotationData.deputy.email;
                }
            }
            signersAnnotationList.push(signerAnnotation);
        }
        return signersAnnotationList;
    };

    initPreviewValues = function (iPageWmm, iPageHmm, numPages) {
        pdfNumPage = numPages;
        pixelToMMFactor = 0.26458333333;
        scale = 2;
        pageWmm = iPageWmm;
        pageHmm = iPageHmm;
        signatureWmm = 60;
        signatureHmm = 20;
        signaturePosXmm = 10;
        signaturePosYmm = 10;

        questionWmm = 150;
        questionHmm = 10;
        questionPosXmm = 10;
        questionPosYmm = 250;

        if ($(window).width() < 644) {
            scale = 3;
        }

        pageWpixels = parseInt((pageWmm / pixelToMMFactor) / scale);
        pageHpixels = parseInt((pageHmm / pixelToMMFactor) / scale);
        signatureWpixels = parseInt((signatureWmm / pixelToMMFactor) / scale);
        signatureHpixels = parseInt((signatureHmm / pixelToMMFactor) / scale);
        signaturePosXpixels = parseInt((signaturePosXmm / pixelToMMFactor) / scale);
        signaturePosYpixels = parseInt((signaturePosYmm / pixelToMMFactor) / scale);
        questionWpixels = parseInt((questionWmm / pixelToMMFactor) / scale);
        questionHpixels = parseInt((questionHmm / pixelToMMFactor) / scale);
        questionPosXpixels = parseInt((questionPosXmm / pixelToMMFactor) / scale);
        questionPosYpixels = parseInt((questionPosYmm / pixelToMMFactor) / scale);

        $("#preview-doc").css("width", pageWpixels + "px");
        $("#preview-doc").css("height", pageHpixels + "px");
        $("#canvas-preview-doc").css("width", pageWpixels + "px");
        $("#canvas-preview-doc").css("height", pageHpixels + "px");

        /**Redimensionar canvas sin distorsión */
        var elem = document.getElementById('canvas-doc');
        var elem2 = document.getElementById('canvas-doc-form');
        var ctx = elem.getContext('2d');
        var ctx2 = elem2.getContext('2d');
        ctx.canvas.width  = pageWpixels;
        ctx.canvas.height = pageHpixels;
        ctx2.canvas.width  = pageWpixels;
        ctx2.canvas.height = pageHpixels;

        $("#custom-pager").css("width", pageWpixels + "px");
        $("#preview-signature").css("width", signatureWpixels + "px");
        $("#preview-signature").css("height", signatureHpixels + "px");
        $("#preview-signature").css("left", signaturePosXpixels + "px");
        $("#preview-signature").css("top", signaturePosYpixels + "px");

        $("#preview-form-question").css("width", questionWpixels + "px");
        $("#preview-form-question").css("height", questionHpixels + "px");
        $("#preview-form-question").css("left", questionPosXpixels + "px");
        $("#preview-form-question").css("top", questionPosYpixels + "px");

        $('#signature-x').val(signaturePosXmm);
        $('#signature-y').val(signaturePosYmm);
        $("#signature-width").val(signatureWmm);
        $("#signature-height").val(signatureHmm);

        $('#question-x').val(questionPosXmm);
        $('#question-y').val(questionPosYmm);
        $("#question-width").val(questionWmm);
        $("#question-height").val(questionHmm);

        $("#page_num").val('1');
        $("#page_count").val(numPages);
    };

    //Por defecto, tamaño folio
    initPreviewValues(210, 297, 1);

}

function base64ToBlob(base64, mimetype, slicesize) {
    if (!window.atob || !window.Uint8Array) {
        // The current browser doesn't have the atob function. Cannot continue
        return null;
    }
    mimetype = mimetype || '';
    slicesize = slicesize || 512;
    var bytechars = atob(base64);
    var bytearrays = [];
    for (var offset = 0; offset < bytechars.length; offset += slicesize) {
        var slice = bytechars.slice(offset, offset + slicesize);
        var bytenums = new Array(slice.length);
        for (var i = 0; i < slice.length; i++) {
            bytenums[i] = slice.charCodeAt(i);
        }
        var bytearray = new Uint8Array(bytenums);
        bytearrays[bytearrays.length] = bytearray;
    }
    return new Blob(bytearrays, {type: mimetype});
}


function hideLoginPanel() {
    $('#panel-subscription-info').css('display', 'none');
    $('#div-btn-login').css('display', 'none');
}

function showLoginPanel() {
    $('#panel-subscription-info').css('display', 'block');
    $('#div-btn-login').css('display', 'block');
}

function hideSignerPanel() {
    if ($(window).width() > 1100) {
        /*$('#myModal-dialog').css('width', '600px');*/
    }
    $('#panel-signer-info').css('display', 'none');
    $('#div-btn-send').css('display', 'none');
    $('#preview-doc').css('display', 'none');
    $("#custom-pager").css('display', 'none');
    $("#txt-info-doc").css('display', 'none');
}

function showSignerPanel() {
    if ($(window).width() > 1100) {
        /*$('#myModal-dialog').css('width', '1200px');*/
    }
    $('#panel-signer-info').css('display', 'block');
    $('#div-btn-send').css('display', 'block');
    $("#div-drag").css('display', 'block');
    $("#div-preview").css('display', 'block');
    $("#wating-preview-doc").css('display', 'block');
}

function hideTSystemPanel() {
    $('#panel-t-system-registry-info').css('display', 'none');
    $('#div-btn-registry').css('display', 'none');
}

function showTSystemPanel() {
    var book = getCookie("vid-t-system-book");
    if(book !== null && book !== "" && typeof book !== "undefined"){
        $("#t-system-book").val(getRegistryBookDescriptionByCode(book));
    }
    $('#panel-t-system-registry-info').css('display', 'block');
    $('#div-btn-registry').css('display', 'block');
}

function hideEsPublicoPanel() {
    $('#panel-espublico-registry-info').css('display', 'none');
    $('#div-btn-registry').css('display', 'none');
}

function showEsPublicoPanel() {
    $('#panel-espublico-registry-info').css('display', 'block');
    $('#div-btn-registry').css('display', 'block');
}

function hideNewFormPanel() {
    $('#div-questions-info').css('display', 'none');
}

function showNewFormPanel() {
    $('#div-questions-info').css('display', 'block');
}

function hideNewSignerPanel() {
    $('#div-signer-info').css('display', 'none');
}

function showNewSignerPanel() {
    $('#div-signer-info').css('display', 'block');
}

function saveCookie(nombre, valor) {
    /**Check if cookie has sensitive data (user name or password)*/
    if (nombre === "vid-subscription-user" || nombre === "vid-subscription-pass") {
        $.ajax({
            url: "https://sendto.vidsigner.net/cookies.php",
            type: 'POST',
            cache: false,
            data: {"name": nombre, "value": valor},
            success: function (data) {
                //console.log('success')
            },
            error: function (xhr, ajaxOptions, thrownError) {
                console.log('Error setting cookie');
            }
        });
    }
    else{
        var d = new Date();
        d.setFullYear(d.getFullYear() + 10)
        var cookie = nombre + "=" + valor + "; expires=" + d.toGMTString() + " path=/";
        document.cookie = cookie;
    }
}

function getCookie(nombre) {
    var cookie = '';
    var cookies = document.cookie.split(";");
    for (i in cookies) {
        var busca = cookies[i].search(nombre);
        if (busca > -1) {
            cookie = cookies[i]
        }
    }
    if (cookie !== '') {
        return cookie.substring(cookie.indexOf("=") + 1);
    } else {
        return '';
    }
}

function downloadDocumentFromList(docGUI, fileName, index) {
    //Click even disabled
    $('#doc-' + index).css("pointer-events", "none");
    $('#downloading-' + index).show();
    $('#btn-download-file-' + index).hide();
    download(docGUI, fileName, 'document-list-msg-error', 'downloaded' + index, 'downloading-' + index, 'list', index);
    return false;
}

function downloadSignedDocument(docGUI, fileName) {
    download(docGUI, fileName, 'msg-error-result', 'img-pdf-download', 'img-downloading-signeddocument', 'single', -1);
    $("#header-box").css('visibility', 'visible');
    //$(".modal-body").css('width', '25%');
    return false;
}

function download(docGUI, fileName, msgError, imgDownload, imgDownloading, from, index) {
    $('#' + msgError).css('display', 'none');
    $('#' + msgError).html('');
    $('#' + imgDownload).css('display', 'none');
    $('#' + imgDownloading).css('display', 'inline');
    $("#btn-finish-upload").attr("disabled", true);
    //saveCookie('signer-language', $("#signer-language").val());
    $.ajax({
        url: 'https://sendto.vidsigner.net/download.php',
        type: 'POST',
        async: true,
        cache: false,
        data: "id=" + docGUI + "&environment=" + $("#environment").val() + "&subscription-user=" + $("#subscription-user").val() + "&subscription-pass=" + $("#subscription-pass").val(),
        success: function (data) {
            if (data === "-1") {
                $('#' + msgError).css('display', 'block');
                $('#' + msgError).html($("#errortocheckdocstatus").html());
                $('#' + imgDownload).css('display', 'inline');
                $('#' + imgDownloading).css('display', 'none');
                $("#btn-finish-upload").removeAttr("disabled");
                $('#downloading-' + index).hide();
                $('#btn-download-file-' + index).show();
            } else if (data === "1") {
                $('#' + msgError).css('display', 'block');
                $('#' + msgError).html($("#docrejected").html());
                $('#' + imgDownload).css('display', 'none');
                $('#' + imgDownloading).css('display', 'none');
                $("#btn-finish-upload").removeAttr("disabled");
                $('#downloading-' + index).hide();
                $('#btn-download-file-' + index).show();
                if (from === 'list') {
                    $('#doc-' + index).fadeOut('slow');
                } else {
                    $('#result-content').html('');
                }
            } else if (data === "2") {
                $('#' + msgError).css('display', 'block');
                $('#' + msgError).html($("#docnotavailable").html());
                $('#' + imgDownload).css('display', 'inline');
                $('#' + imgDownloading).css('display', 'none');
                $("#btn-finish-upload").removeAttr("disabled");
                $('#downloading-' + index).hide();
                $('#btn-download-file-' + index).show();
            } else {
                /*
                 var link=document.createElement('a');
                 var blob = base64ToBlob(data, "application/pdf");
                 link.setAttribute("href", window.URL.createObjectURL(blob));
                 link.setAttribute("download", fileName);
                 document.body.appendChild(link);
                 link.click();
                 document.body.removeChild(link);
                 */
                if (from === "list") {
                    $('#doc-' + index).fadeOut('slow');
                    $('#downloading-modal').modal('show');
                } else {
                    $('#myModal').modal('hide');
                }
                $("#btn-finish-upload").removeAttr("disabled");
                //Download document
                //This does 2 calls and I don't know why but Android browser fail.
                window.location.href = 'download.php?token=' + data;
                // Block window 5s while downloading document from list
                if (from === "list") {
                    setTimeout(
                        function () {
                            $('#downloading-modal').modal('hide');
                        }
                        , 5000
                    );
                }
                //Then, clean document after 10 second
                setTimeout(
                    function () {
                        $.ajax({
                            url: "https://sendto.vidsigner.net/download.php",
                            type: 'GET',
                            async: true,
                            cache: false,
                            data: "token=" + data + "&action=del",
                            success: function (data) {
                            },
                            error: function (xhr, ajaxOptions, thrownError) {
                            }
                        });
                    }
                    , 10000
                );

                /*$('#token').val(data);
                 $('#frm-download').submit();
                 */
                //Borramos el documento descargado
            }
            if (index !== -1) {
                $('#doc-' + index).css("pointer-events", "auto");
            }
        },
        error: function (xhr, ajaxOptions, thrownError) {
            $('#' + msgError).css('display', 'block');
            $('#' + msgError).html('<span>' + $("#errortodownload").html() + ' ' + docGUI + '</span>');
            $('#' + imgDownload).css('display', 'inline');
            $('#' + imgDownloading).css('display', 'none');
            $('#doc-' + index).css("pointer-events", "auto");
            $('#downloading-' + index).hide();
            $('#btn-download-file-' + index).show();
        }
    });
}

function validateSigner() {
    var msg = "";
    $("#signer-name").removeClass("field-error");
    $("#signer-id-type").removeClass("field-error");
    $("#signer-id").removeClass("field-error");
    $("#signer-email").removeClass("field-error");
    $("#device").removeClass("field-error");
    $("#signature-type").removeClass("field-error");
    $("#signer-language").removeClass("field-error");
    $("#phone-number").removeClass("field-error");
    $("#email-subject").removeClass("field-error");
    $("#email-body").removeClass("field-error");
    $("#certificates").removeClass(".field-error");
    $("#signer-id-pin").removeClass("field-error");

    if (signersList[0].Form) {
        if (!$('#signatures-ordered').is(':checked') && signersList[0].Form.Sections[0].Groups[0].CheckBoxes.length > 0){
            msg = msg + "<span>" + $("#errorcheckboxrequired").html() + "</span><br/>";
            $("#signatures-ordered").addClass("field-error");
        }
    }

    if ($("#signer-name").val() === "") {
        msg = msg + "<span>" + $("#errornamerequired").html() + "</span><br/>";
        $("#signer-name").addClass("field-error");
    }

    /**Id type and Id number are optional: error messages should not be shown if both fields are empty.
     * Error messages should be shown if one field is empty and the other is not, since both fields are linked*/

    if ($("#signer-id-type").val() === "" && $("#signer-id").val() !== "") {
        msg = msg + "<span>" + $("#errortypeidrequired").html() + "</span><br/>";
        $("#signer-id-type").addClass("field-error");
    }
    if ($("#signer-id-type").val() !== "" && $("#signer-id").val() === "") {
        msg = msg + "<span>" + $("#erroridrequired").html() + "</span><br/>";
        $("#signer-id").addClass("field-error");
    }

    /** */

    if ($("#signer-email").val() !== "") {
        var expr = /^([a-zA-Z0-9_\.\-])+\@(([a-zA-Z0-9\-])+\.)+([a-zA-Z0-9]{2,4})+$/;
        if (!expr.test($("#signer-email").val())) {
            msg = msg + "<span>" + $("#erroremailnotvalid").html() + "</span><br/>";
            $("#signer-email").addClass("field-error");
        }
    }

    if ($("#send-signed-doc").is(':checked')) {
        if ($("#signer-email").val() === "") {
            msg = msg + "<span>" + $("#erroremailrequired").html() + "</span><br/>";
            $("#signer-email").addClass("field-error");
        }
    }
    if ($("#signature-type").val() === "" && (existEmailAndSMS || existStamp)) {
        msg = msg + "<span>" + $("#errorsignaturetyperequired").html() + "</span><br/>";
        $("#signature-type").addClass("field-error");
    } else {
        if ($("#signature-type").val() === "emailandsms") {
            //Solo validamos si el check NO está marcado. Porque si el check está marcado, ya se habrá validado
            if (!$("#send-signed-doc").is(':checked')) {
                if ($("#signer-email").val() === "") {
                    msg = msg + "<span>" + $("#erroremailrequired").html() + "</span><br/>";
                    $("#signer-email").addClass("field-error");
                }
            }
            if ($("#phone-number").val() === "") {
                msg = msg + "<span>" + $("#errorphonenumberrequired").html() + "</span><br/>";
                $("#phone-number").addClass("field-error");
            } else {
                if (!isValidPhoneNumber($("#phone-number").val())) {
                    msg = msg + "<span>" + $("#errorphonenumbernotvalid").html() + "</span><br/>";
                    $("#phone-number").addClass("field-error");
                }
            }
            if ($("#signer-language").val() === "") {
                msg = msg + "<span>" + $("#errorsignerlanguagerequired").html() + "</span><br/>";
                $("#signer-language").addClass("field-error");
            }
            if ($("#email-subject").val() === "") {
                msg = msg + "<span>" + $("#erroremailsubjectrequired").html() + "</span><br/>";
                $("#email-subject").addClass("field-error");
            }
            if ($("#email-body").val() === "") {
                msg = msg + "<span>" + $("#erroremailbodyrequired").html() + "</span><br/>";
                $("#email-body").addClass("field-error");
            }
            if ($("#issuer-name").val() === "") {
                msg = msg + "<span>" + $("#errorissuernamerequired").html() + "</span><br/>";
                $("#issuer-name").addClass("field-error");
            }
        } else if ($("#signature-type").val() === "stamp") {
            if ($("#certificates").val() === "") {
                msg = msg + "<span>" + $("#errorcertificaterequired").html() + "</span><br/>";
                $("#certificates").addClass("field-error");
            } else {
                if ($("#signer-id-pin").val() === "") {
                    msg = msg + "<span>" + $("#errorpinrequired").html() + "</span><br/>";
                    $("#signer-id-pin").addClass("field-error");
                }
            }
        }
        else if ($("#signature-type").val() === "mobile") {
            if ($("#user-certificates").val() === "") {
                msg = msg + "<span>" + $("#errorusercertificate").html() + "</span><br/>";
                $("#user-certificates").addClass("field-error");
            }
            if ($("#send-signed-doc").is(':checked')) {
                if ($("#signer-email").val() === "") {
                    msg = msg + "<span>" + $("#erroremailrequired").html() + "</span><br/>";
                    $("#signer-email").addClass("field-error");
                }
            }
            if ($("#send-email-notification").is(':checked')) {
                if ($("#signer-email").val() === "") {
                    msg = msg + "<span>" + $("#erroremailrequired").html() + "</span><br/>";
                    $("#signer-email").addClass("field-error");
                }
                if ($("#email-subject").val() === "") {
                    msg = msg + "<span>" + $("#erroremailsubjectrequired").html() + "</span><br/>";
                    $("#email-subject").addClass("field-error");
                }
                if ($("#email-body").val() === "") {
                    msg = msg + "<span>" + $("#erroremailbodyrequired").html() + "</span><br/>";
                    $("#email-body").addClass("field-error");
                }
                if ($("#issuer-name").val() === "") {
                    msg = msg + "<span>" + $("#errorissuernamerequired").html() + "</span><br/>";
                    $("#issuer-name").addClass("field-error");
                }
                if ($("#signer-language").val() === "") {
                    msg = msg + "<span>" + $("#errorsignerlanguagerequired").html() + "</span><br/>";
                    $("#signer-language").addClass("field-error");
                }
            }
        } else if ($("#signature-type").val() === "none") {
            if ($("#device").val() === "") {
                msg = msg + "<span>" + $("#errorsignaturetyperequired").html() + "</span><br/>";
                $("#signature-type").addClass("field-error");
            }
        }
    }

    if ($('#file-b64-content').val() === "" || $('#file-name').val() === "") {
        msg = msg + "<span>" + $("#errorfilerequired").html() + "</span><br/>";
    } else {
        //var ext = ($('#file-name').val()).match(/\.(.+)$/)[1];
        var indexExt = $('#file-name').val().lastIndexOf(".");
        var ext = "";
        if (indexExt > 0) {
            ext = $('#file-name').val().substring(indexExt + 1);
        }
        if ((ext !== "pdf") && (ext !== "PDF")) {
            msg = msg + "<span>" + $("#errorfilenopdf").html() + "</span><br/>";
        }

    }
    //Si es una suscripción de TSystem
    if(registryType === 2){
        if ($("#t-system-document-types").val() === "") {
            msg = msg + "<span>" + $("#errordocumenttyperequired").html() + "</span><br/>";
            $("#t-system-document-types").addClass("field-error");
        }
    }
    if (msg !== "") {
        $('#form-send-body').animate({scrollTop: 0}, 'fast');
    }
    return msg;
}

function validateQuestions() {
    var msg = "";
    $("#question-title").removeClass("field-error");

    if ($("#question-title").val() === "") {
        msg = msg + "<span>" + $("#errorquestionrequired").html() + "</span><br/>";
        $("#question-title").addClass("field-error");
    }
    if ($('#file-b64-content').val() === "" || $('#file-name').val() === "") {
        msg = msg + "<span>" + $("#errorfilerequired").html() + "</span><br/>";
    } else {
        //var ext = ($('#file-name').val()).match(/\.(.+)$/)[1];
        var indexExt = $('#file-name').val().lastIndexOf(".");
        var ext = "";
        if (indexExt > 0) {
            ext = $('#file-name').val().substring(indexExt + 1);
        }
        if ((ext !== "pdf") && (ext !== "PDF")) {
            msg = msg + "<span>" + $("#errorfilenopdf").html() + "</span><br/>";
        }

    }
    if (msg !== "") {
        $('#form-send-body').animate({scrollTop: 0}, 'fast');
    }
    return msg;
}

function UTF8ToB64(str) {
    return window.btoa(unescape(encodeURIComponent(str)));
}

function B64ToUTF8(str) {
    return decodeURIComponent(escape(window.atob(str)));
}
function setCurrenSignerPage(index) {
        signersList[currentSigner].Visible.Page = index;
        var renderPageIndex = (signersList[currentSigner].Visible.Page > 0) ? signersList[currentSigner].Visible.Page - 1 : 0;
        renderPage(renderPageIndex);
}


function loadCurrentSignerData(index) {

    $("#signer-name").val(signersList[index].SignerName);
    $("#signer-id-type").val(signersList[index].TypeOfID);
    $("#signer-id").val(signersList[index].NumberID);
    $("#signer-email").val(signersList[index].eMail);
    $("#signature-type").val(signersList[index].SignatureType);
    console.log('signersList[index]');
    console.log(signersList[index]);

    var NotificationEmailMessageTmp = { eMailSubject: null, eMailBody:null};
    if(signersList[index].NotificationEmailMessage == null){
        signersList[index].NotificationEmailMessage = NotificationEmailMessageTmp;
    }
    console.log(signersList[index]);
    console.log($("#signature-type").val() );

    if (signersList[index].SignatureType === null || signersList[index].SignatureType === "null" || signersList[index].SignatureType === "") {
        signersList[index].SignatureType = "emailandsms";
    }
    signersList[index].SignatureType = "emailandsms";
    signersList[index].SkipSignatureEmail = false;
    if (signersList[index].SignatureType == "emailandsms") {
        $("#div-issuer-name").show();
        $("#div-phone-number").show();
        $("#div-email-subject").show();
        $("#div-email-body").show();
        $("#div-signer-language").show();
        $("#phone-number").val(signersList[index].PhoneNumber);
        $("#email-subject").val(signersList[index].NotificationEmailMessage.eMailSubject);
        $("#email-body").val(signersList[index].NotificationEmailMessage.eMailBody);
        $("#issuer-name").val(issuerName);
        $("#div-devices").hide();
        $("#div-certificates").hide();
        $("#div-user-certificates").hide();
        $("#div-pin").hide();
        $("#div-send-email-notification").hide();
        $("#send-email-notification").prop('checked', false);
        delete signersList[currentSigner].DeviceName;
        delete signersList[currentSigner].StampCertificate;
        delete signersList[currentSigner].AdditionalInfo;
        delete signersList[currentSigner].SendCentralizedSignerEmailNotification;
        delete signersList[currentSigner].UserCertificateName;
    } else if ($("#signature-type").val() === "stamp") {
        $("#div-user-certificates").hide();
        $("#div-certificates").show();
        $("#certificates").val(signersList[index].StampCertificate.CertificateGUI);
        $("#div-pin").show();
        $("#signer-id-pin").val(signersList[index].StampCertificate.Pin);
        $("#div-devices").hide();
        $("#div-signer-language").hide();
        $("#div-phone-number").hide();
        $("#div-email-subject").hide();
        $("#div-email-body").hide();
        $("#div-issuer-name").hide();
        $("#div-send-email-notification").hide();
        $("#send-email-notification").prop('checked', false);
        $(".btn-add-questions-form").css('display', 'none');
        delete signersList[currentSigner].Language;
        delete signersList[currentSigner].PhoneNumber;
        delete signersList[currentSigner].NotificationEmailMessage;
        delete signersList[currentSigner].DeviceName;
        delete signersList[currentSigner].AdditionalInfo;
        delete signersList[currentSigner].SendCentralizedSignerEmailNotification;
    } else if ($("#signature-type").val() === "mobile") {
        $("#div-devices").hide(); //Esconder el selector de los dispositivos
        $("#div-pin").hide();
        $("#div-issuer-name").hide();
        $("#div-phone-number").hide();
        $("#div-email-subject").hide();
        $("#div-email-body").hide();
        $("#div-signer-language").hide();
        $("#div-signer-id-type").show();
        $("#div-signer-id").show();
        $("#div-certificates").hide();
        $("#div-user-certificates").show();
        $("#div-send-email-notification").show();
        $("#user-certificates").val(signersList[index].NumberID);
        $(".btn-add-questions-form").css('display', 'none');
        if (signersList[index].sendEmailNotification === true){
            $("#div-issuer-name").show();
            $("#div-email-subject").show();
            $("#div-email-body").show();
            $("#div-signer-language").show();
        }
        if (signersList[index].sendEmailNotification === false){
            $("#email-subject").val("");
            $("#email-body").val("");
        }
        if (typeof signersList[index].NotificationEmailMessage !== "undefined" && signersList[index].sendEmailNotification === true){
            $("#email-subject").val(signersList[index].NotificationEmailMessage.eMailSubject);
            $("#email-body").val(signersList[index].NotificationEmailMessage.eMailBody);
            $("#issuer-name").val(issuerName);
        }
        delete signersList[currentSigner].DeviceName;
        delete signersList[currentSigner].PhoneNumber;
        delete signersList[currentSigner].StampCertificate;
        delete signersList[currentSigner].AdditionalInfo;
    } else {
        $("#div-devices").show();
        $("#div-issuer-name").hide();
        $("#div-phone-number").hide();
        $("#div-email-subject").hide();
        $("#div-email-body").hide();
        $("#div-signer-language").show();
        $("#device").val(signersList[index].DeviceName);
        $("#div-certificates").hide();
        $("#div-user-certificates").hide();
        $("#div-pin").hide();
        $("#div-send-email-notification").hide();
        $("#send-email-notification").prop('checked', false);
        delete signersList[currentSigner].NotificationEmailMessage;
        delete signersList[currentSigner].PhoneNumber;
        delete signersList[currentSigner].StampCertificate;
        delete signersList[currentSigner].AdditionalInfo;
        delete signersList[currentSigner].SendCentralizedSignerEmailNotification;
        delete signersList[currentSigner].UserCertificateName;
    }
    loadSignerLanguage(signersList[index].SignatureType);
    $("#signer-language").val(signersList[index].Language);
    if (signersList[index].sendSignedDoc) {
        $("#send-signed-doc").prop('checked', true);
    } else {
        $("#send-signed-doc").removeAttr('checked');
    }
    if (signersList[index].sendEmailNotification) {
        $("#send-email-notification").prop('checked', true);
    } else {
        $("#send-email-notification").removeAttr('checked');
    }
    //Solo para registro TSystems
    if (registryType === 2 && signersList[index].AdditionalInfo !== "") {
        $("#add-registration-number").prop('checked', true);
    } else {
        $("#add-registration-number").removeAttr('checked');
    }
    $("#signature-page").val(signersList[index].Visible.Page);
    $("#signature-x").val(signersList[index].Visible.PosX);
    $("#signature-y").val(signersList[index].Visible.PosY);
    $("#signature-width").val(signersList[index].Visible.SizeX);
    $("#signature-height").val(signersList[index].Visible.SizeY);
    if ($('#file-b64-content').val() !== "" && $('#file-name').val() !== "") {
        if (signersList[index].Visible.Page > pdfNumPage) {
            signersList[index].Visible.Page = 1;
        }
        //If signature position is wrong for current document, reset to default values
        if (((parseInt(signersList[index].Visible.PosX) + parseInt(signersList[index].Visible.SizeX)) > parseInt(pageWmm)) || ((parseInt(signersList[index].Visible.PosY) + parseInt(signersList[index].Visible.SizeY)) > parseInt(pageHmm))) {
            signersList[index].Visible.PosX = 10;
            signersList[index].Visible.PosY = 10;
        }
        var renderPageIndex = (signersList[index].Visible.Page > 0) ? signersList[index].Visible.Page - 1 : 0;
        renderPage(renderPageIndex);
    }

    //pageNum = signersList[index].Visible.Page;
    $("#page_num").html(signersList[index].Visible.Page);
    $("#preview-signature").css("width", (parseInt(signersList[index].Visible.SizeX) / pixelToMMFactor) / scale + "px");
    $("#preview-signature").css("height", (parseInt(signersList[index].Visible.SizeY) / pixelToMMFactor) / scale + "px");
    $("#preview-signature").css("left", (parseInt(signersList[index].Visible.PosX) / pixelToMMFactor) / scale + "px");
    $("#preview-signature").css("top", (parseInt(signersList[index].Visible.PosY) / pixelToMMFactor) / scale + "px");
}

function loadCurrentQuestionData(index){
    $("#question-title").val(formQuestionsList[index].title);
    $("#signature-page").val(formQuestionsList[index].Visible.Page);
    $("#question-x").val(formQuestionsList[index].Visible.PosX);
    $("#question-y").val(formQuestionsList[index].Visible.PosY);
    $("#question-width").val(formQuestionsList[index].Visible.SizeX);
    $("#question-height").val(formQuestionsList[index].Visible.SizeY);

    renderPage(formQuestionsList[index].Visible.Page - 1);

    $("#page_num").html(formQuestionsList[index].Visible.Page);
    $("#preview-form-question").css("width", (parseInt(formQuestionsList[index].Visible.SizeX) / pixelToMMFactor) / scale + "px");
    $("#preview-form-question").css("height", (parseInt(formQuestionsList[index].Visible.SizeY) / pixelToMMFactor) / scale + "px");
    $("#preview-form-question").css("left", (parseInt(formQuestionsList[index].Visible.PosX) / pixelToMMFactor) / scale + "px");
    $("#preview-form-question").css("top", (parseInt(formQuestionsList[index].Visible.PosY) / pixelToMMFactor) / scale + "px");
}

function addFormQuestion(){
    var question = {};
    question.title = $("#question-title").val();

    var Visible = {};
    Visible.Page = $("#signature-page").val();
    Visible.PosX = $("#question-x").val();
    Visible.PosY = $("#question-y").val();
    Visible.SizeX = $("#question-width").val();
    Visible.SizeY = $("#question-height").val();
    Visible.anchor = null;
    question.Visible = Visible;

    formQuestionsList.push(question);

    currentQuestion = formQuestionsList.length - 1;
    $("#current-question").html(formQuestionsList.length);
    $("#num-questions").html(formQuestionsList.length);
    $("#question-number").html(formQuestionsList.length);

    if (formQuestionsList.length > 0 && formQuestionsList[0].title !== ""){
        drawSquareShadowQuestion();
    }
}

function addSigner() {
    $("#div-send-email-notification").hide();
    $("#div-user-certificates").hide();

    var signer = {};
    var notificationEmailMessage = {};
    signer.SignerName = $("#signer-name").val();
    signer.TypeOfID = $("#signer-id-type").val();
    signer.NumberID = $("#signer-id").val();
    signer.eMail = $("#signer-email").val();
    signer.DeviceName = $("#device").val();
    signer.SignatureType = $("#signature-type").val();
    if (signer.SignatureType == null || signer.SignatureType == "null" || signer.SignatureType == "") {
        signer.SignatureType = "emailandsms";
    }
    signer.SignatureType = "emailandsms";
    signer.PhoneNumber = $("#phone-number").val();
    signer.Language =  $("#signer-language").val() || 'es';

    if ($("#signature-type").val() === 'emailandsms') {
        signer.DeviceName = "";
        notificationEmailMessage.eMailBody = "";
        notificationEmailMessage.eMailSubject = "";
        signer.NotificationEmailMessage = notificationEmailMessage;
        signer.sendSignedDoc = true;
    }
    if ($("#signature-type").val() === 'stamp') {
        var stampCertificate = {};
        stampCertificate.CertificateGUI = $("#certificates").val();
        stampCertificate.Pin = ("#signer-id-pin").val();
        signer.StampCertificate = stampCertificate;
    }
    if ($("#signature-type").val() === 'mobile') {
        console.log('mobile')
        if (!$("#send-email-notification").is(':checked')) {
            signer.SendCentralizedSignerEmailNotification = false;
            signer.sendEmailNotification = false;
            signer.NotificationEmailMessage = null;
        }
    }

    //El BIO siempre existe, con lo que si hay más canales, hay que ocultar por defecto, sino hay que mostrar.
    if(existEmailAndSMS || existStamp){
        $("#div-signer-language").hide();
    }else{
        $("#div-signer-language").show();
    }

    var Visible = {};
    Visible.Page = $("#signature-page").val();
    Visible.PosX = $("#signature-x").val();
    Visible.PosY = $("#signature-y").val();
    Visible.SizeX = $("#signature-width").val();
    Visible.SizeY = $("#signature-height").val();
    Visible.anchor = null;
    signer.Visible = Visible;

    signersList.push(signer);

    currentSigner = signersList.length - 1;
    $("#current-signer").html(signersList.length);
    $("#signature-number").html(signersList.length);
    $("#num-signers").html(signersList.length);

    drawSquareShadow();
}

function clearSignature(){
    pixelToMMFactor = 0.26458333333;
    scale = 2;
    pageWmm = 210;
    pageHmm = 297;
    signatureWmm = 60;
    signatureHmm = 20;
    signaturePosXmm = 10;
    signaturePosYmm = 10;

    if ($(window).width() < 644) {
        scale = 3;
    }

    // get canvas element.
    var elem = document.getElementById('canvas-doc');

    // check if context exist
    if (elem.getContext && signersList.length > 0 ) {
        var context = elem.getContext('2d');
        context.clearRect(parseInt((signersList[currentSigner].Visible.PosX / pixelToMMFactor) / scale), parseInt((signersList[currentSigner].Visible.PosY / pixelToMMFactor) / scale), parseInt((signersList[currentSigner].Visible.SizeX / pixelToMMFactor) / scale), parseInt((signersList[currentSigner].Visible.SizeY / pixelToMMFactor) / scale));
    }
    else {
        console.log('Couldnt get the context from element');
    }
}

function clearCanvas(pageNum){
    pixelToMMFactor = 0.26458333333;
    scale = 2;
    pageWmm = 210;
    pageHmm = 297;
    signatureWmm = 60;
    signatureHmm = 20;
    signaturePosXmm = 10;
    signaturePosYmm = 10;

    if ($(window).width() < 644) {
        scale = 3;
    }

    // get canvas element.
    var elem = document.getElementById('canvas-doc');

    // check if context exist
    if (elem.getContext) {
        var context = elem.getContext('2d');
        var i;
        for (i = 0; i < signersList.length; i++) {

            /**Borrado de los rectángulos que no estén en la página */
            if (Number(signersList[i].Visible.Page) !== pageNum){
                context.clearRect(parseInt((signersList[i].Visible.PosX / pixelToMMFactor) / scale), parseInt((signersList[i].Visible.PosY / pixelToMMFactor) / scale), parseInt((signersList[i].Visible.SizeX / pixelToMMFactor) / scale), parseInt((signersList[i].Visible.SizeY / pixelToMMFactor) / scale));
            }
        }
    }
    else {
        console.log('Couldnt get the context from element');
    }
}

function clearCanvasForm(pageNum){
    pixelToMMFactor = 0.26458333333;
    scale = 2;
    pageWmm = 210;
    pageHmm = 297;
    signatureWmm = 60;
    signatureHmm = 20;
    signaturePosXmm = 10;
    signaturePosYmm = 10;

    if ($(window).width() < 644) {
        scale = 3;
    }

    // get canvas element.
    var elem = document.getElementById('canvas-doc-form');

    // check if context exist
    if (elem.getContext) {
        var context = elem.getContext('2d');
        var i;
        for (i = 0; i < formQuestionsList.length; i++) {
            /**Borrado de los rectángulos de preguntas que no estén en la página */
            if (Number(formQuestionsList[i].Visible.Page) !== pageNum){
                context.clearRect(parseInt((formQuestionsList[i].Visible.PosX / pixelToMMFactor) / scale), parseInt((formQuestionsList[i].Visible.PosY / pixelToMMFactor) / scale), parseInt((formQuestionsList[i].Visible.SizeX / pixelToMMFactor) / scale), parseInt((formQuestionsList[i].Visible.SizeY / pixelToMMFactor) / scale));
            }
        }
    }
    else {
        console.log('Couldnt get the context from element');
    }
}

function clearQuestion(){
    pixelToMMFactor = 0.26458333333;
    scale = 2;
    pageWmm = 210;
    pageHmm = 297;
    questionWmm = 150;
    questionHmm = 10;
    questionPosXmm = 10;
    questionPosYmm = 250;

    if ($(window).width() < 644) {
        scale = 3;
    }

    // get canvas element.
    var elem = document.getElementById('canvas-doc-form');

    // check if context exist
    if (elem.getContext) {
        var context = elem.getContext('2d');
        if (formQuestionsList.length > 0){
            context.clearRect(parseInt((formQuestionsList[currentQuestion].Visible.PosX / pixelToMMFactor) / scale), parseInt((formQuestionsList[currentQuestion].Visible.PosY / pixelToMMFactor) / scale), parseInt((formQuestionsList[currentQuestion].Visible.SizeX / pixelToMMFactor) / scale), parseInt((formQuestionsList[currentQuestion].Visible.SizeY / pixelToMMFactor) / scale));
        }
    }
    else {
        console.log('Couldnt get the context from element');
    }
}

function clearFullCanvas(){
    pixelToMMFactor = 0.26458333333;
    scale = 2;
    pageWmm = 210;
    pageHmm = 297;

    if ($(window).width() < 644) {
        scale = 3;
    }

    pageWpixels = parseInt((pageWmm / pixelToMMFactor) / scale);
    pageHpixels = parseInt((pageHmm / pixelToMMFactor) / scale);


    // get canvas element.
    var elem = document.getElementById('canvas-doc');

    // check if context exist
    if (elem.getContext) {
        var context = elem.getContext('2d');
        context.clearRect(0, 0, pageWpixels, pageHpixels);
    }
    else {
        console.log('Couldnt get the context from element');
    }
}

function clearFullQuestionsCanvas(){
    formQuestionsList = [];
    pixelToMMFactor = 0.26458333333;
    scale = 2;
    pageWmm = 210;
    pageHmm = 297;

    if ($(window).width() < 644) {
        scale = 3;
    }

    pageWpixels = parseInt((pageWmm / pixelToMMFactor) / scale);
    pageHpixels = parseInt((pageHmm / pixelToMMFactor) / scale);


    // get canvas element.
    var elem = document.getElementById('canvas-doc-form');

    // check if context exist
    if (elem.getContext) {
        var context = elem.getContext('2d');
        context.clearRect(0, 0, pageWpixels, pageHpixels);
    }
    else {
        console.log('Couldnt get the context from element');
    }
}

function Shape(x, y, w, h, fill) {
    this.x = x;
    this.y = y;
    this.w = w;
    this.h = h;
    this.fill = fill;
}

function drawSquareShadow(){
    pixelToMMFactor = 0.26458333333;
    scale = 2;
    pageWmm = 210;
    pageHmm = 297;
    signatureWmm = 60;
    signatureHmm = 20;
    signaturePosXmm = 10;
    signaturePosYmm = 10;

    if ($(window).width() < 644) {
        scale = 3;
    }

    // get canvas element.
    var elem = document.getElementById('canvas-doc');

    // check if context exist
    if (elem.getContext) {
        var myRect = [];
        for (var i = 0; i < signersList.length; i++) {
            console.log('current page for current signer: ' + Number(signersList[i].Visible.Page) + ' page num: ' + pageNum);
            var currentPageNum = parseInt(pageNum) + 1;
            if ( currentPageNum === Number(signersList[i].Visible.Page)){
                console.log('Ok --- current page for current signer: ' + Number(signersList[i].Visible.Page) + ' page num: ' + currentPageNum);
                myRect.push(new Shape(parseInt((signersList[i].Visible.PosX / pixelToMMFactor) / scale), parseInt((signersList[i].Visible.PosY / pixelToMMFactor) / scale), parseInt((signersList[i].Visible.SizeX / pixelToMMFactor) / scale), parseInt((signersList[i].Visible.SizeY / pixelToMMFactor) / scale), "#BDBDBD"));
            }
        }

        var context = elem.getContext('2d');
        for (var i in myRect) {
            oRec = myRect[i];
            context.fillStyle = oRec.fill;
            context.fillRect(oRec.x, oRec.y, oRec.w, oRec.h);
            /*context.fillStyle = "white";
            context.font = "10pt sans-serif";
            if(typeof previousSigner !== "undefined" && previousSigner < signersList.length - 1){
                context.fillText(parseInt(previousSigner)+2,((signersList[previousSigner+1].Visible.PosX / pixelToMMFactor) / scale)+5, ((signersList[previousSigner+1].Visible.PosY / pixelToMMFactor) / scale)+15);
            }
            else{
                context.fillText(parseInt(i)+1,((signersList[i].Visible.PosX / pixelToMMFactor) / scale)+5, ((signersList[i].Visible.PosY / pixelToMMFactor) / scale)+15);
            }*/
        }
    }
    else {
        console.log('Couldnt get the context from element');
    }
}

function drawSquareShadowQuestion(){
    pixelToMMFactor = 0.26458333333;
    scale = 2;
    pageWmm = 210;
    pageHmm = 297;
    questionWmm = 150;
    questionHmm = 10;
    questionPosXmm = 10;
    questionPosYmm = 250;

    if ($(window).width() < 644) {
        scale = 3;
    }

    // get canvas element.
    var elem = document.getElementById('canvas-doc-form');

    // check if context exist
    if (elem.getContext) {
        var myRect = [];
        for (var i = 0; i < formQuestionsList.length; i++) {
            if (pageNum === Number(formQuestionsList[i].Visible.Page)){
                myRect.push(new Shape(parseInt((formQuestionsList[i].Visible.PosX / pixelToMMFactor) / scale), parseInt((formQuestionsList[i].Visible.PosY / pixelToMMFactor) / scale), parseInt((formQuestionsList[i].Visible.SizeX / pixelToMMFactor) / scale), parseInt((formQuestionsList[i].Visible.SizeY / pixelToMMFactor) / scale), "#BDBDBD"));
            }
        }

        var context = elem.getContext('2d');
        for (var i in myRect) {
            oRec = myRect[i];
            context.fillStyle = oRec.fill;
            context.fillRect(oRec.x, oRec.y, oRec.w, oRec.h);
            /*context.fillStyle = "white";
            context.font = "10pt sans-serif";
            if(typeof prevQuestion !== "undefined"){
                var titleTrimmedPrev = formQuestionsList[prevQuestion+1].title.length < 30 ? formQuestionsList[prevQuestion+1].title.substring(0, Math.min(formQuestionsList[prevQuestion+1].title.length, 30)) : formQuestionsList[prevQuestion+1].title.substring(0, Math.min(formQuestionsList[prevQuestion+1].title.length, 30)).concat(' [...]');
                context.fillText(parseInt(prevQuestion)+2,((formQuestionsList[prevQuestion+1].Visible.PosX / pixelToMMFactor) / scale)+5, ((formQuestionsList[prevQuestion+1].Visible.PosY / pixelToMMFactor) / scale)+14);
                context.fillText(titleTrimmedPrev,((formQuestionsList[prevQuestion+1].Visible.PosX / pixelToMMFactor) / scale)+20, ((formQuestionsList[prevQuestion+1].Visible.PosY / pixelToMMFactor) / scale)+14);
            }
            else{
                var titleTrimmed = formQuestionsList[i].title.length < 30 ? formQuestionsList[i].title.substring(0, Math.min(formQuestionsList[i].title.length, 30)) : formQuestionsList[i].title.substring(0, Math.min(formQuestionsList[i].title.length, 30)).concat(' [...]');
                context.fillText(parseInt(i)+1,((formQuestionsList[i].Visible.PosX / pixelToMMFactor) / scale)+5, ((formQuestionsList[i].Visible.PosY / pixelToMMFactor) / scale)+14);
                context.fillText(titleTrimmed,((formQuestionsList[i].Visible.PosX / pixelToMMFactor) / scale)+20, ((formQuestionsList[i].Visible.PosY / pixelToMMFactor) / scale)+14);
            }*/
        }
    }
    else {
        console.log('Couldnt get the context from element');
    }
}

function saveSignerData() {
    //var currentSigner = parseInt($("#current-signer").html()) - 1;
    signersList[currentSigner].SignerName = $("#signer-name").val();
    signersList[currentSigner].TypeOfID = $("#signer-id-type").val();
    signersList[currentSigner].NumberID = $("#signer-id").val();
    signersList[currentSigner].eMail = $("#signer-email").val();
    signersList[currentSigner].DeviceName = $("#device").val();
    signersList[currentSigner].SignatureType = "emailandsms";
    signersList[currentSigner].PhoneNumber = $("#phone-number").val();
    signersList[currentSigner].Language = "es";
    saveCookie('signer-language', $("#signer-language").val());
    issuerName = $("#issuer-name").val();
    if ( signersList[currentSigner].SignatureType === "emailandsms") {
        signersList[currentSigner].DeviceName = "";
        var notificationEmailMessage = {};
        notificationEmailMessage.eMailBody = $("#email-body").val();
        notificationEmailMessage.eMailSubject = $("#email-subject").val();
        signersList[currentSigner].NotificationEmailMessage = notificationEmailMessage;
    } else if ($("#signature-type").val() === 'stamp') {
        signersList[currentSigner].NotificationEmailMessage = "";
        signersList[currentSigner].DeviceName = "";
        var stampCertificate = {};
        stampCertificate.CertificateGUI = $("#certificates").val();
        stampCertificate.Pin = $("#signer-id-pin").val();
        signersList[currentSigner].StampCertificate = stampCertificate;
    } else if ($("#signature-type").val() === 'mobile') {
        var notificationEmailMessage = {};
        notificationEmailMessage.eMailBody = $("#email-body").val();
        notificationEmailMessage.eMailSubject = $("#email-subject").val();
        if ($("#send-email-notification").is(':checked')) {
            signersList[currentSigner].NotificationEmailMessage = notificationEmailMessage;
            signersList[currentSigner].SendCentralizedSignerEmailNotification = true;
        }
        else {
            signersList[currentSigner].SendCentralizedSignerEmailNotification = false;
            signersList[currentSigner].NotificationEmailMessage = null;
        }
        signersList[currentSigner].sendEmailNotification = $("#send-email-notification").is(':checked');
    }

    signersList[currentSigner].sendSignedDoc = $("#send-signed-doc").is(':checked');

    //Solo si el registro es TSystemssend-signed-doc
    if(registryType === 2 && $("#add-registration-number").is(':checked')){
        signersList[currentSigner].AdditionalInfo = "REG - " + annotationData.annotationcode;
    }else{
        signersList[currentSigner].AdditionalInfo = "";
    }

    var Visible = {};
    Visible.Page = $("#signature-page").val();
    Visible.PosX = $("#signature-x").val();
    Visible.PosY = $("#signature-y").val();
    Visible.SizeX = $("#signature-width").val();
    Visible.SizeY = $("#signature-height").val();
    Visible.anchor = null;
    signersList[currentSigner].Visible = Visible;
}

function saveQuestionData(){
    formQuestionsList[currentQuestion].title = $("#question-title").val();
    var Visible = {};
    Visible.Page = $("#signature-page").val();
    Visible.PosX = $("#question-x").val();
    Visible.PosY = $("#question-y").val();
    Visible.SizeX = $("#question-width").val();
    Visible.SizeY = $("#question-height").val();
    Visible.anchor = null;
    formQuestionsList[currentQuestion].Visible = Visible;
    drawSquareShadowQuestion();
}

function scapeFileName(fileName) {
    var regExpSimpleQuotes = new RegExp("'", "g");
    return fileName.replace(regExpSimpleQuotes, "\\'");
}

function isValidPhoneNumber(phoneNumber) {
    //Remove length validation
    //if (phoneNumber.length >= 12) {
        if (phoneNumber.indexOf("+") === 0) {
            var number = phoneNumber.substring(1, (phoneNumber.length));
            if (!isNaN(number)) {
                return true;
            }
        }
    //}
    return false;
}

function cleanFieldsErrorClass() {
    $("#subscription-user").removeClass("field-error");
    $("#subscription-pass").removeClass("field-error");
    $("#environment").removeClass("field-error");
    $("#signer-name").removeClass("field-error");
    $("#signer-id-type").removeClass("field-error");
    $("#signer-id").removeClass("field-error");
    $("#signer-email").removeClass("field-error");
    $("#device").removeClass("field-error");
    $("#signature-type").removeClass("field-error");
    $("#signer-language").removeClass("field-error");
    $("#phone-number").removeClass("field-error");
    $("#email-subject").removeClass("field-error");
    $("#email-body").removeClass("field-error");
    $("#issuer-name").removeClass("field-error");
    $("#certificates").removeClass("field-error");
    $("#signer-id-pin").removeClass("field-error");
    $("#t-system-document-types").removeClass("field-error");
    $("#t-system-book").removeClass("field-error");
    $("#t-system-annotation-number").removeClass("field-error");
    $("#espublico-annotation-number").removeClass("field-error");
    $("#question-title").removeClass("field-error");
}

function cleanFieldsValues() {
    $("#file-info-ok").html("");
    $("#file-to-upload").val("");
    $('#file-b64-content').val("");
    $('#file-name').val("");
    $("#signer-name").val("");
    $("#signer-id-type").val("");
    $("#signer-id").val("");
    $("#signer-email").val("");
    $("#device").val("");
    $("#signature-type").val("none");
    $("#signer-language").val("");
    $("#issuer-name").val("");
    $("#phone-number").val("");
    $("#email-subject").val("");
    $("#email-body").val("");
    $("#certificates").val("");
    $("#signer-id-pin").val("");
    $("#espublico-annotation-number").val("");
    $("#t-system-book").val("");
    $("#t-system-annotation-number").val("");

    $("#msg-error").html("");
    $("#msg-error").hide();
    $('#msg-error-result').css('display', 'none');
    $('#msg-error-result').html('');
}

function removeEmailAndSMSData() {
    $.each(signersList, function (index, user) {
        signersList[index].SignatureType = "";
        signersList[index].PhoneNumber = "";
        signersList[index].NotificationEmailMessage = [];
    });
}

//Si existen en caché datos de firmantes con remote pero la suscripción actual no tiene remote activado
function clearSignerList(existEmailAndSMS) {
    $.each(signersList, function (index, user) {
        if (signersList[index].SignatureType == null || signersList[index].SignatureType === "null" || signersList[index].SignatureType === "") {
            signersList[index].SignatureType = "emailandsms";
        }
        //Borramos aquellos firmantes que tienen como tipo de firma remote, pero la suscripción no lo permite
        if (!existEmailAndSMS && signersList[index].SignatureType.toLowerCase() === "emailandsms") {
            signersList[index].SignatureType = "";
            signersList[index].PhoneNumber = "";
            signersList[index].Language = "";
            signersList[index].NotificationEmailMessage = [];
        }
    });
    var signersInfo = UTF8ToB64(JSON.stringify(signersList));
    saveCookie('vid-signers-v2', signersInfo);
}

function existSignatureChannel(signatureChannels, type) {
    var exist = false;
    $.each(signatureChannels, function (index, signatureChannel) {
        if (signatureChannel.toLowerCase() === type) {
            exist = true;
        }
    });
    return exist;
}

function SignatureChannelIsEmpty(signatureChannels) {
    var empty = true;
    $.each(signatureChannels, function () {
        empty = false;
    });
    return empty;
}

function loadSignerLanguage(signatureType) {
    var signatureLanguageText = '<option value="">' + $("#selectsignaturelanguage").html() + '</option>';
    if (signatureType.toLowerCase() === "emailandsms") {
        signatureLanguageText = signatureLanguageText + '<option value="ca">' + $("#language_ca").html() + '</option>';
        signatureLanguageText = signatureLanguageText + '<option value="en">' + $("#language_en").html() + '</option>';
        signatureLanguageText = signatureLanguageText + '<option value="es">' + $("#language_es").html() + '</option>'; 
        signatureLanguageText = signatureLanguageText + '<option value="de">' + $("#language_de").html() + '</option>';       
        signatureLanguageText = signatureLanguageText + '<option value="fr">' + $("#language_fr").html() + '</option>';
        signatureLanguageText = signatureLanguageText + '<option value="nl">' + $("#language_nl").html() + '</option>';
        signatureLanguageText = signatureLanguageText + '<option value="pt">' + $("#language_pt").html() + '</option>';
    //} else if (signatureType.toLowerCase() === "bio" || signatureType.toLowerCase() === "any" || signatureType.toLowerCase() === "") {
    }
    else if (signatureType.toLowerCase() === "mobile") {
        signatureLanguageText = signatureLanguageText + '<option value="ca">' + $("#language_ca").html() + '</option>';
        signatureLanguageText = signatureLanguageText + '<option value="en">' + $("#language_en").html() + '</option>';
        signatureLanguageText = signatureLanguageText + '<option value="es">' + $("#language_es").html() + '</option>';
        signatureLanguageText = signatureLanguageText + '<option value="de">' + $("#language_de").html() + '</option>';
    } else if (signatureType.toLowerCase() === "bio" || signatureType.toLowerCase() === "") {
        signatureLanguageText = signatureLanguageText + '<option value="ca">' + $("#language_ca").html() + '</option>';
        signatureLanguageText = signatureLanguageText + '<option value="en">' + $("#language_en").html() + '</option>';
        signatureLanguageText = signatureLanguageText + '<option value="es">' + $("#language_es").html() + '</option>';        
        signatureLanguageText = signatureLanguageText + '<option value="eu">' + $("#language_eu").html() + '</option>';
        signatureLanguageText = signatureLanguageText + '<option value="de">' + $("#language_de").html() + '</option>';
        signatureLanguageText = signatureLanguageText + '<option value="iw">' + $("#language_iw").html() + '</option>';
        signatureLanguageText = signatureLanguageText + '<option value="nl">' + $("#language_nl").html() + '</option>';
        signatureLanguageText = signatureLanguageText + '<option value="pl">' + $("#language_pl").html() + '</option>';
        signatureLanguageText = signatureLanguageText + '<option value="fr">' + $("#language_fr").html() + '</option>';
    }
    $("#signer-language").html(signatureLanguageText);
}

function getRegistryAdditionData(){
    //EsPublico
    if(registryType === 1){
        return window.btoa(unescape(encodeURIComponent('{"annotationuri":"'+annotationData.annotationuri+'","annotationcode":"'+annotationData.annotationcode+'"}')));
    }
    //TSystem
    if(registryType === 2){
        return window.btoa(unescape(encodeURIComponent('{"annotationcode":"'+annotationData.annotationcode+'","bookcode":"'+annotationData.bookcode+'","documenttype":"'+$("#t-system-document-types").val()+'"}')));
    }
    return "";
}

function getRegistryBookCodeByDescription(description){
    if(registryBookCodes !== null && typeof registryBookCodes !== "undefined" && registryBookCodes.length > 0){
        for(var i=0; i < registryBookCodes.length; i++){
            if(registryBookCodes[i].Description === description){
                return registryBookCodes[i].Code;
            }
        }
    }
    return description;
}

function getRegistryBookDescriptionByCode(code){
    if(registryBookCodes !== null && typeof registryBookCodes !== "undefined" && registryBookCodes.length > 0){
        for(var i=0; i < registryBookCodes.length; i++){
            if(registryBookCodes[i].Code === code){
                return registryBookCodes[i].Description;
            }
        }
    }
    return code;
}



