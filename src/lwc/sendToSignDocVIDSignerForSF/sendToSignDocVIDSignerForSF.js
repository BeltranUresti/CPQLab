import VDJSS_spinner2 from '@salesforce/resourceUrl/VDJSS_spinner2';
import VDJSS_sendToCross from '@salesforce/resourceUrl/VDJSS_sendToCross';
import VDJSS_sendToleftarrow from '@salesforce/resourceUrl/VDJSS_sendToleftarrow';
import VDJSS_sendTorightarrow from '@salesforce/resourceUrl/VDJSS_sendTorightarrow';
import VDJSS_validated_white from '@salesforce/resourceUrl/VDJSS_validated_white';
import artVIDSigner from   '@salesforce/resourceUrl/vidsignerLWC';
import LIBTESTERPDF from '@salesforce/resourceUrl/PDFTESTER';
import fscroller from '@salesforce/resourceUrl/fscroller';
import WORKERTESTER from '@salesforce/resourceUrl/WORKERTESTER';
import VDJSS_Interact from '@salesforce/resourceUrl/VDJSS_Interact';
import getSignerList from '@salesforce/apex/VDSingerPDFViewerController.getSignerList';
import { loadStyle,loadScript} from 'lightning/platformResourceLoader';
import { CurrentPageReference } from 'lightning/navigation';
import { fireEvent, registerListener, unregisterAllListeners } from 'c/pubsub';
import {api, LightningElement, track, wire} from 'lwc';


var defaultPage;
let globalThis = window;
var filePageWmm = 210;
var filePageHmm = 297;
var files;
var PagesContent = [];
var pdfDoc = null;
var pageRendering = false;
var  pageNumPending = null;
var maxCanvasWidth = 400;
var pdf = null;
var canvasWidth=0;
var canvasHeight=0;
var qtyPagesTotal =0;
var gtyGenered =0;
var pageStarts=new Array();
pageStarts[0]=0;
let pdfImageURLs = null;
var pdfImages = null, pageNum = 0;
var  canvas = null,ctx;
let selectedSigner;



function dragMoveListener (event){
    var target = event.target
    console.log('dragAndDrop');
    console.log(target);
    // keep the dragged position in the data-x/data-y attributes
    var x = (parseFloat(target.getAttribute('data-x')) || 0) + event.dx
    var y = (parseFloat(target.getAttribute('data-y')) || 0) + event.dy

    // translate the element
    target.style.transform = 'translate(' + x + 'px, ' + y + 'px)'

    // update the posiion attributes
    target.setAttribute('data-x', x)
    target.setAttribute('data-y', y)
}

export default class SendToSignDocVidSignerForSf extends LightningElement {
    @api interact_Local;
    @api recordId;
    @track dragMouseDownBind;
    all_backgrounds = [];
    @track movementsSinger = [];
    @track logoBlanco = VDJSS_validated_white;
    @track allPages = [];
    @track selectedSignersList = [];
    @track remitente = {SignerName: '', eMail: '',PhoneNumber: '', Id :'IDRemi' };
    @api xhrAvailable = false;
    @api canvasObj ={};
    @track isPanelOpen = false;
    @api loadNewDoc = false;
    @api fileB64Content;
    @track currentStep = 'step-1';
    @track listOfSingers = [];
    @track previewDocument = false;
    @track watingPreviewDoc = false;
    @api canvasPreviewDocSRC;
     __pdfjs;
     @track noAdd = false;
     @api myPdfWorker;
     @api myWorkerPort;
    @track page = 0;
    perpage = 5;
    @track pages = [];
    set_size = 5;
    @track pageWpixels;
    @track pageHpixels;
    @track signatureWpixels;
    @track signatureHpixels;
    @track signaturePosXpixels;
    @track signaturePosYpixels;
    @track isLoading =false;
    @track answerState = false;

    @wire(CurrentPageReference) pageRef;

    steps = [
        { label: 'Seleccionar documento', value: 'step-1' },
        { label: 'Agregar destinatarios', value: 'step-2' },
        { label: 'Enviar a firmas', value: 'step-3' }
    ];

    @wire(getSignerList, { objectID: '$recordId' })
    getSigners({ data, error })
    {
        console.log('Data: ' + data + this.recordId);
        if (data) {
            try {
                let numLabel = 0;
                let retList = JSON.parse(data);
                this.listOfSingers = Array.from(retList);
                this.listOfSingers.forEach(function (signer) {
                    numLabel = numLabel + 1;
                    signer.Num = numLabel;
                    signer.checked = false;
                });
                console.log(this.listOfSingers );
            } catch (e) {
                console.log(e);
            }
        }else if(error){
            console.log(error);
        }
    }



    scale = 1;

   @track fondoVidSigner;
   @track addDocument = artVIDSigner + '/vidsignerLWC/ICONOS/Crear.png';
   @track logoWhite = VDJSS_validated_white;
   @track toLeftArrow = VDJSS_sendToleftarrow;

    handleAnswerButtonClick() {
        this.answerState = !this.answerState;
    }

    constructor(){
            super();
            //register dragover event to the template
            //this.template.addEventListener('dragover', this.handleDragOver.bind(this));
       // this.template.addEventListener('drop', this.handleDrop.bind(this));
        this.all_backgrounds.push(artVIDSigner + '/vidsignerLWC/VIDSignerArt/VIDsigner-Default2.png');
        this.all_backgrounds.push(artVIDSigner + '/vidsignerLWC/VIDSignerArt/VIDsigner-2.png');
        this.all_backgrounds.push(artVIDSigner + '/vidsignerLWC/VIDSignerArt/Remote_Signature.png');
        this.all_backgrounds.push(artVIDSigner + '/vidsignerLWC/VIDSignerArt/Recurso-26.png');
        this.all_backgrounds.push(artVIDSigner + '/vidsignerLWC/VIDSignerArt/Recurso-8-1.png');
        this.all_backgrounds.push(artVIDSigner + '/vidsignerLWC/VIDSignerArt/Recurso2.png');
        this.all_backgrounds.push(artVIDSigner + '/vidsignerLWC/VIDSignerArt/Firma_Cualificada_Entornos_Presenciales_3.png');
        this.all_backgrounds.push(artVIDSigner + '/vidsignerLWC/VIDSignerArt/Firma_Cualificada_Entornos_Presenciales.png');

    }
    handleDrop(event) {
        console.log('inside handle drop');
        if (event.stopPropagation) {
            event.stopPropagation();
        }
        event.preventDefault();
    }
    handleViewSigner(event){

            var itemId = event.target.accessKey;
            console.log(itemId);
            console.log(this.listOfSingers);
            var returned = this.findById(this.listOfSingers, itemId,null,null);
            returned.checked = true;
            this.noAdd = true;

    }
    handleUnselect(event){
        console.log(event.target.dataset.id);
        let itemId =event.target.accessKey || event.target.dataset.id;
        if(event.target.dataset.id.substr(0,3) === 'New')
        {
            this.findByIdAndDelete(this.listOfSingers,itemId );
        }else{
            let returned = this.findById(this.listOfSingers, itemId,null,null);
            returned.checked = false;
        }
        this.noAdd = false;

    }
    handleSaveSigner(event){
        let itemId =event.target.dataset.id;
        let returned = this.findById(this.listOfSingers, itemId,null,null);
        if(event.target.dataset.id.substr(0,3) === 'New')
        {
            returned.Id = event.target.accessKey + '-000ITEM';
            returned.checked = false;
        }
        this.noAdd = false;
    }
    handleOnselect(event) {
        let selectedItemValue = event.detail.value;
        if(selectedItemValue ==='SignersList'){
            this.toggleFilter(null);
        }
        if(selectedItemValue === 'Local'){
                this.loadNewDoc = true;
        }
        if(selectedItemValue === 'Attachment'){

        }
    }
    renderButtons = () => {
        this.template.querySelectorAll('button.btn-pager').forEach((but) => {
            but.style.backgroundColor = this.page === parseInt(but.dataset.id, 10) ? 'white' : but.style.backgroundColor;
            but.style.color = this.page === parseInt(but.dataset.id, 10) ? '#00bf71':  but.style.color;
        });
    }
    get pagesList() {
        let mid = Math.floor(this.set_size / 2) + 1;
        if (this.page > mid) {
            return this.pages.slice(this.page - mid, this.page + mid - 1);
        }
        return this.pages.slice(0, this.set_size);
    }
    setPages = (data) => {
        let numberOfPages = Math.ceil(data.length);
        for (let index = 1; index <= numberOfPages; index++) {
            this.pages.push(index);
        }
    }
    get hasPrev() {
        return this.page > 2;
    }
    get hasNext() {
        return this.page < (this.pages.length )
    }
    onNext = () => {

        ++this.page;
        this.renderPage(this.page );

    }
    onPrev = () => {

        --this.page;
        this.renderPage(this.page );

    }
    onPageClick = (e) => {
        this.page = Number(e.target.dataset.id) - 1;
        this.renderPage(this.page );
    }
    handleStep(event){
        this.currentStep = event.target.value;
       console.log( event.target.value);
       if(this.currentStep ===1){
           this.pagesList =[];
           this.previewDocument = false;
           this.watingPreviewDoc = false;
           this.canvasPreviewDocSRC = null;
       }
    }
    //when drag is start this method fires
    handleDragStart(event) {
        event.dataTransfer.dropEffect = 'move';

        //retrieve AccountId from div
        selectedSigner = event.target.dataset.item;
        //console.log('event.target.dataset.item=' + event.target.dataset.item);

        //loop the array, match the AccountId and retrieve the account record


        //fire an event to the subscribers
        fireEvent(this.pageRef, 'selectedSignerDrop', selectedSigner);
    }
    handleDragOver(event){
        event.dataTransfer.dropEffect = 'move';
        event.preventDefault();
    }
    connectedCallback() {
        this.Init();

        this.fondoVidSigner = this.all_backgrounds[Math.floor(Math.random()*this.all_backgrounds.length)];
        Promise.all([
            loadStyle(this, artVIDSigner + '/vidsignerLWC/CSS/SFDC_ONE.css'),
            loadStyle(this, artVIDSigner + '/vidsignerLWC/CSS/PDNDA.css'),
            loadStyle(this, artVIDSigner + '/vidsignerLWC/CSS/Canvas.css'),
            loadStyle(this, artVIDSigner + '/vidsignerLWC/CSS/CanvasItem.css'),
            loadStyle(this, artVIDSigner + '/vidsignerLWC/CSS/ main.30db117f.css'),
            loadScript(this, artVIDSigner + '/vidsignerLWC/RUNTIME/document-viewer-page-6b517690.js'),
            loadScript(this, artVIDSigner + '/vidsignerLWC/RUNTIME/runtime_editor-50ece447.js'),
            loadScript(this, artVIDSigner + '/vidsignerLWC/RUNTIME/vendor-volatile-f5e64066.js'),
            loadScript(this, artVIDSigner + '/vidsignerLWC/RUNTIME/vendor-edf3bffb.js'),
            loadScript(this, artVIDSigner + '/vidsignerLWC/RUNTIME/editor-3d0b8100.js')
        ]).then(() => {
            console.log('StylesLoaded');


        });
    }
    disconnectedCallback() {
        // unsubscribe from selectedAccountDrop event
        unregisterAllListeners(this);
    }
    drag(event){
        event.dataTransfer.setData("divId", event.target.dataset.id);
       // event.dataTransfer.dropEffect = 'move';
    }

    allowDrop(event){
        if(event.stopPropagation){
            event.stopPropagation();
        }
        event.preventDefault();
        console.log('inside handle allowdrop 2');

    }
    drop(event){
        event.stopPropagation();
        event.preventDefault();
        console.log('inside handle drop 2');
        var divId = event.dataTransfer.getData("divId");
       // var draggedElement = this.template.querySelector('#' +divId);
        console.log(divId);
      var draggedElement= this.template.querySelector(`[data-id='${divId}']`).cloneNode(true);
        // var draggedElement = window.document.createElement('div');
        var b2 = document.createElement("button");
        b2.innerHTML = draggedElement.dataset.name;
       b2.onclick = function(e){
           this.template.querySelector(`[data-id='${newId}']`).removeEventListener('mousedown',this.dragMouseDownBind);
           const randomColor = Math.floor(Math.random()*16777215).toString(16);
           console.log('color');
           e.target.style.backgroundColor = "#" + randomColor;
           color.innerHTML = "#" + randomColor;
         let origElement =  this.template.querySelector(`[data-badge='${divId}']`);
         origElement.style.backgroundColor = "#" + randomColor + "!important";
         console.log(origElement);
       }.bind(this);
        console.log(draggedElement);
        draggedElement.classList.add('preview-signature');
        draggedElement.classList.add('draggable');
        event.target.appendChild(draggedElement);
        let newId = "NewDiv" + divId;
       draggedElement.dataset.id = newId;
       // this.template.querySelector(`[data-id='${newId}']`).appendChild(b2);

        this.moveElement(draggedElement);



     // draggedElement.style.left = (draggedElement.offsetLeft + event.clientX)  + 'px';
     // draggedElement.style.top = (draggedElement.offsetTop + event.clientY)  + 'px';
    }
    handleDropDoc(event){
        console.log('inside handle drop');
        if(event.stopPropagation){
            event.stopPropagation();
        }
        event.preventDefault();

    }


    handleDragOverDoc(event){
        console.log('inside handle drag doc');
        event.dataTransfer.dropEffect = 'move';
        event.preventDefault();
    }
    handleSelectedSignerDrop(singerInfo){
        console.log('SignerInfo :' + singerInfo);
    }
    Draggable(element){
        let isDrawing = false;

        // initial mouse X and Y for `mousedown`
        var mouseX;
        var mouseY;

        // element X and Y before and after move
        var elementX = 0;
        var elementY = 0;

        // mouse button down over the element
        element.addEventListener('mousedown', onMouseDown);

        /**
         * Listens to `mousedown` event.
         *
         * @param {Object} event - The event.
         */
        function onMouseDown(event) {
            mouseX = event.clientX;
            mouseY = event.clientY;
            isDrawing = true;
        }

        // mouse button released
        window.addEventListener('mouseup', onMouseUp);

        /**
         * Listens to `mouseup` event.
         *
         * @param {Object} event - The event.
         */
        function onMouseUp(event) {
            if (isDrawing === true) {
                elementX = parseInt(element.style.left) || 0;
                elementY = parseInt(element.style.top) || 0;
                isDrawing = false;
            }
        }

        // need to attach to the entire document
        // in order to take full width and height
        // this ensures the element keeps up with the mouse
        element.addEventListener('mousemove', onMouseMove);

        /**
         * Listens to `mousemove` event.
         *
         * @param {Object} event - The event.
         */
        function onMouseMove(event) {
            if (isDrawing === true) {
                var deltaX = event.clientX - mouseX;
                var deltaY = event.clientY - mouseY;
                element.style.left = elementX + deltaX + 'px';
                element.style.top = elementY + deltaY + 'px';
            }
        }
    }





  renderedCallback() {


      /*     this.template.querySelectorAll('div.draggable').forEach((but) => {
               this.moveElement(but);
         });
*/


     /* let container = this.template.querySelector('div.bckValidated');
      console.log(this.fondoVidSigner);
      container.style.backgroundImage = `url(${this.fondoVidSigner})`;
      container.style.backgroundRepeat ='no-repeat';*/
   let panelHeader =  this.template.querySelector('[data-pheader="panelHeader"]');
      console.log('panelHeader');
      console.log(panelHeader);
      panelHeader.style.backgroundImage =`url(${this.logoBlanco})`;
      panelHeader.style.backgroundSize ='20%';
      panelHeader.style.backgroundRepeat ='no-repeat';
      panelHeader.style.backgroundPosition ='left';
      panelHeader.style.background



  }



// this function is used later in the resizing and gesture demos


  @track   Resource = {    VDJSS_spinner2:VDJSS_spinner2,
                    VDJSS_sendToCross: VDJSS_sendToCross
    };
    handleAddNewSigner(event){
        let newSigner = new Object();

        //newSigner.Visible= {SizeY:20,SizeX:60,SignatureField:null,PosY:4,PosX:66,Page:0,Anchor:null};
        newSigner.Visible=null;
        newSigner.VerifyeMail = true;
            newSigner.UserNotices=null;
            newSigner.UserCertificateName=null;
            newSigner.TypeOfID='NIF';
            newSigner.StampCertificate=null;
            newSigner.SkipSignatureEmail=false;
            newSigner.SignerName=null;
            newSigner.SignerGUI=null;
            newSigner.SignatureType='emailandsms';
            newSigner.sendSignedDoc=true;
            newSigner.SendCentralizedSignerEmailNotification=null;
            newSigner.PictureURI=null;
            newSigner.PhoneNumber=null;
            newSigner.NumberID=null;
            newSigner.checked=true;
            newSigner.NotificationEmailMessage=null;
            newSigner.Language='es';
            newSigner.isDigitalIdUser=null;
            newSigner.Id='NewSigner';
            newSigner.Form=null;
            newSigner.eMail=null;
            newSigner.DocusignSigner=null;
            newSigner.DeviceName=null;
            newSigner.AdditionalInfo=null;
        console.log(JSON.stringify(newSigner));
        this.listOfSingers.push(newSigner);

        console.log( this.listOfSingers);
        this.noAdd = true;
    }
   handleChangeSigner(event){
       let currentId =  event.target.dataset.id;
       let field =  event.target.dataset.field;
       let returned = this.findById(this.listOfSingers,currentId ,null,null);
       if(returned !== null){
           returned[field] = event.target.value;
       }
   }

    handleAddSigner(event){


      let  pixelToMMFactor = 0.26458333333,
        scale = 2,
        pageWmm = 210,
        pageHmm = 297,
        signatureWmm = 60,
        signatureHmm = 20,
        signaturePosXmm = 10,
        signaturePosYmm = 10;


        if (window.width < 644) {
            scale = 3;
        }

        this.pageWpixels = parseInt((pageWmm / pixelToMMFactor) / scale);
        this.pageHpixels = parseInt((pageHmm / pixelToMMFactor) / scale);
        this.signatureWpixels = parseInt((signatureWmm / pixelToMMFactor) / scale);
        this.signatureHpixels = parseInt((signatureHmm / pixelToMMFactor) / scale);
        this.signaturePosXpixels = parseInt((signaturePosXmm / pixelToMMFactor) / scale);
        this.signaturePosYpixels = parseInt((signaturePosYmm / pixelToMMFactor) / scale);

        console.log('Entro: ' +event.target.accessKey );
        let signerId =    event.target.accessKey;
        let returned = this.findById(this.selectedSignersList,signerId,null,null);
        if(returned === null || returned === undefined ){
            this.selectedSignersList.push({Id:signerId,Name:event.target.name});
        }
    }
    findById(o, id, fieldName, fieldValue) {
        if(o.Id){
            if( o.Id.toString() === id ){
                if(fieldName){
                    o[fieldName] = fieldValue;
                }
                return o;
            }
        }
        var result, p;

        for (p in o) {
            if( o.hasOwnProperty(p) &&  o[p] != null && (typeof o[p] === 'object' || o[p] instanceof Array) ) {
                result = this.findById(o[p], id,  fieldName, fieldValue);
                if(result){
                    return result;
                }
            }
        }
        return result;
    }
    findByIdAndDelete(o, id) {
        if( o.Id === id ){
            return o;
        }
        var result, p;
        var index = 0;
        for (p in o) {
            if( o.hasOwnProperty(p) &&  o[p] != null && (typeof o[p] === 'object' || o[p] instanceof Array) ) {
                result = this.findByIdAndDelete(o[p], id);
                if(result){
                    o.splice(index,1);
                    return o;
                }
                index++;
            }

        }
        return result;
    }

    $id(id) {
        return document.getElementById(id);
    }
    // output information
    pagex;
    Output(msg) {
        var m = this.$id("messages");
        m.innerHTML = msg + m.innerHTML;
    }
moveElementHandler(e){
       this.moveElement(  e.target);
}
    moveElementHandler1(e){

        let newSigner = new Object();

        newSigner.Visible=null;
        newSigner.VerifyeMail = true;
        newSigner.UserNotices=null;
        newSigner.UserCertificateName=null;
        newSigner.TypeOfID='NIF';
        newSigner.StampCertificate=null;
        newSigner.SkipSignatureEmail=false;
        newSigner.SignerName=null;
        newSigner.SignerGUI=null;
        newSigner.SignatureType='emailandsms';
        newSigner.sendSignedDoc=true;
        newSigner.SendCentralizedSignerEmailNotification=null;
        newSigner.PictureURI=null;
        newSigner.PhoneNumber=null;
        newSigner.NumberID=null;
        newSigner.checked=true;
        newSigner.NotificationEmailMessage=null;
        newSigner.Language='es';
        newSigner.isDigitalIdUser=null;
        newSigner.Id='NewSigner';
        newSigner.Form=null;
        newSigner.eMail=null;
        newSigner.DocusignSigner=null;
        newSigner.DeviceName=null;
        newSigner.AdditionalInfo=null;
        console.log(JSON.stringify(newSigner));
        this.selectedSignersList.push(newSigner);
    }
    moveElement(elmnt){
        var xPos = 0;
        var yPos = 0;
    var mousePosition;
    var offset = [0,0];
    var div;
    var isDown = false;
    var thisElem =  elmnt;
    var closeDragBind;
    var mouseMoveBind;
    this.dragMouseDownBind = dragMouseDown2.bind(this);
    var objOptions;
        closeDragBind = closeDragElement.bind(this);
    elmnt.addEventListener('mousedown', this.dragMouseDownBind);
        elmnt.addEventListener('mouseup', closeDragBind);
    function  dragMouseDown2(e) {
        objOptions = this.findById(this.movementsSinger, elmnt.dataset.id,null,null);
        console.log('objOptions');
        console.log(objOptions);
        if(!objOptions){
            console.log('No encontro el set');
            var closestElement = elmnt.closest('div.defaultPageBg--41277748');
            objOptions = new Object();
            objOptions.Id  = elmnt.dataset.id;
            objOptions.ParentId = closestElement.dataset.id;
            objOptions.Page = closestElement.dataset.index;
            objOptions.IsDown = true;
            objOptions.IsOff = false;
            objOptions.offset = [ 0, 0];
           this.movementsSinger.push(objOptions);
        }
        e = e || window.event;
        isDown = true;
        objOptions.IsDown = true;
        offset = [
            e.clientX - elmnt.offsetLeft,
            e.clientY -   elmnt.offsetTop
        ];
        objOptions.offset =  offset;
        closeDragBind = closeDragElement.bind(this);
        mouseMoveBind = mousemove.bind(elmnt);
        elmnt.closest('div.defaultPageBg--41277748').addEventListener('mousemove',mouseMoveBind);
        elmnt.closest('div.defaultPageBg--41277748').addEventListener('mouseup',closeDragBind );
    }

    function mousemove(e) {
        console.log('mousemove');
        e.preventDefault();
        if (objOptions.IsDown === true) {
            mousePosition = {
                x: e.clientX,
                y: e.clientY
            };
            console.log(offset);
            console.log('mousemove isdown');
            thisElem.classList.add("preview-signature");
           xPos = (mousePosition.x  - (offset[0] ) )+ 'px';
         yPos = (mousePosition.y   -  (offset[1]) )+ 'px';
            objOptions.offset = [xPos ,yPos];
            this.style.top = yPos;
            this.style.left = xPos;
            setTranslate(xPos,yPos, thisElem);
           let currSigner = this.findById(this.listOfSingers, objOptions.Id ,null,null);
            currSigner.Visible.SizeY =20;
            currSigner.Visible.SizeX = 60;
            currSigner.Visible.SignatureField =null;
            currSigner.Visible.PosY= objOptions.offset[1];
            currSigner.Visible.PosX= objOptions.offset[0];
            currSigner.Visible.Page=objOptions.Page + 1;
        }else{
            console.log('mousemove not isdown');
        }
    }
    function setTranslate(xPos, yPos, el) {
            el.style.transform = "translate3d(" + xPos + "px, " + yPos + "px, 0)";
        }
    function closeDragElement(e) {
        // stop moving when mouse button is released:
        isDown = false;
        objOptions.IsDown = false;
        offset = [xPos ,yPos];
        //this.template.removeEventListener('mousemove',mousemove,true);
        this.template.querySelectorAll('div.defaultPageBg--41277748').forEach((but) => {
            but.removeEventListener('mousemove',mousemove);
        });

        this.template.querySelectorAll('div.preview-signature').forEach((elem2) => {
           //elem2.removeEventListener('mousedown',dragMouseDownBind,true);
        });
    }

}

    dragElement(elmnt) {
        var pos1 = 0, pos2 = 0, pos3 = 0, pos4 = 0;
        const position = { x: 0, y: 0 };
            // otherwise, move the DIV from anywhere inside the DIV:
        elmnt.addEventListener('mousedown', dragMouseDown);
        elmnt.addEventListener('mouseup', closeDragElement);

        function  dragMouseDown(e) {
            e = e || window.event;
            e.preventDefault();
            e.stopPropagation();
            // get the mouse cursor position at startup:
            pos3 =elmnt.offsetLeft;
            pos4 = elmnt.offsetTop;
          window.addEventListener('mouseup', closeDragElement);
            // call a function whenever the cursor moves:
           window.addEventListener('mousemove',  elementDrag.bind(this));

        }

        function  elementDrag(e) {
            e = e || window.event;
            e.preventDefault();
            e.stopPropagation();
            // calculate the new cursor position:
            pos1 = pos3 - e.clientX;
            pos2 = pos4 - e.clientY;
            pos3 =elmnt.offsetLeft;
            pos4 = elmnt.offsetTop;
            // set the element's new position:
            elmnt.style.top = (elmnt.offsetTop - pos2) + "px";
            elmnt.style.left = (elmnt.offsetLeft - pos1) + "px";

        }

        function  closeDragElement() {
            // stop moving when mouse button is released:

            window.removeEventListener('mousemove',  elementDrag);

        }
    }
    // file drag hover
    FileDragHover(e)  {
       // if (e.cancelable) {
        console.log('grag over' + e.type);
            e.stopPropagation();
            e.preventDefault();
            e.target.className = (e.type === "dragover" ? "slds-file-selector__dropzone slds-file-selector__dropzone_integrated slds-has-drag slds-has-drag-over" : "slds-file-selector__dropzone slds-file-selector__dropzone_integrated slds-has-drag");
        //}
    }

    // file selection
    FileSelectHandler(e) {
        // cancel event and hover styling
        this.FileDragHover(e);
        // fetch FileList object
        var files = e.target.files || e.dataTransfer.files;
        console.log(files);
        // process all File objects
        for (var i = 0; i<files.length; i++) {
          this.ParseFile(files[i]);

        }

    }

    Init() {

        // is XHR2 available?
        window.dragMoveListener = dragMoveListener;
        var xhr = new XMLHttpRequest();
        if (xhr.upload) {
            // file drop
            this.xhrAvailable = true;

        }
    }
    addImage(){
        this.previewDocument = true;
        let container = this.template.querySelector('div.image-cont.flex-container');
        container.appendChild(defaultPage);
    }

 ParseFile(file) {
    // clearCanvas(1);
    var error = false;
    //var ext = (file.name).match(/\.(.+)$/)[1];
    var indexExt = (file.name).lastIndexOf(".");
    var ext = "";
    if (indexExt > 0) {
        ext = (file.name).substring(indexExt + 1);
    }
    if ((ext != "pdf") && (ext != "PDF") && (ext != "png") && (ext != "jpg")) {
        error = true;
    }
    if (!error) {
        var sizeStr = "";
        var sizeKB = file.size / 1024;
        var sizeLimitExceeded = false;
        if (parseInt(sizeKB) > 1024) {
            var sizeMB = sizeKB / 1024;
            sizeStr = sizeMB.toFixed(2) + " MB";
            if (sizeMB.toFixed(2) > 20) {
                sizeLimitExceeded = true;
            }
        } else {
            sizeStr = sizeKB.toFixed(2) + " KB";
        }
        if (!sizeLimitExceeded) {
            pageNum = 0;
            this.watingPreviewDoc = true;

            var reader = new FileReader();
            reader.onload = function (fileLoadedEvent) {
                var base64 = fileLoadedEvent.target.result;
                var fileContent = reader.result;
                console.log('reader result---->');
                console.log(fileContent);
                console.log( encodeURIComponent(fileContent.substring((fileContent.indexOf(",")) + 1)));
               var data = fileContent.substring((fileContent.indexOf(",")) + 1);

               (async () => {
                    const rawResponse = await fetch('https://cors-anywhere.herokuapp.com/https://sendto.vidsigner.net/renderization.php', {
                        method: 'POST',
                        headers: {
                            'Accept': 'application/x-www-form-urlencoded',
                            'Content-Type': 'application/x-www-form-urlencoded',
                            'X-Requested-With': 'XMLHttpRequest'
                        },
                        body: 'environment=PRE&subscription-user=AUTANACRMSubscriptionDemo&subscription-pass=ZNpeaY6Mt7F486b7n67q&file-b64-content=' + encodeURIComponent(data)
                    });
                    const content = await rawResponse.json();
                    console.log(content);
                    var dataObject =content ;
                    console.log(dataObject);
                    pdfImageURLs = dataObject.DocPageRendered;
                   let pdfNumPage = pdfImageURLs.length;
                   for (let i = 0; i < pdfImageURLs.length; i++){
                       this.allPages.push({Id: i + 'Page',pageData:
                       "data:image/png;base64," +   pdfImageURLs[i]});
                   }


                   this.setPages(pdfImageURLs);
                    //Con esto miramos el tamaño de las páginas del PDF
                   defaultPage = new Image();
                    defaultPage.onload = function () {

                        this.renderPage(0);

                    }.bind(this);
                    defaultPage.src = "data:image/png;base64," +  pdfImageURLs[0];
                })();

                //base64 =  base64.substring((base64.indexOf(",")) + 1);
               // this.renderAllPages(base64);


            }.bind(this);

            reader.readAsDataURL(file);


        } else {
            //$("#msg-error").html('<span>El archivo excede el tamaño máximo permitido (20 MB)</span>');

        }
    } else {
        //$("#msg-error").html('<span>El documento seleccionado no es un PDF.</span>');

    }
}
waitTillDone (){
    return new Promise(function(resolve, reject){
        var intervalId = setInterval(function(){
            let total = parseInt(qtyPagesTotal);
            let createdPages = parseInt(gtyGenered);
            console.log('pageNumPending: ' + pageNumPending);
            if( pageNumPending != null) {
                return;
            }else{

                clearInterval(intervalId);
                resolve('TODAS RENDERIZADAS');

            }

        }, 1000);
    });
}

async renderAllPages(Data)
{
        let dataT = Data;
        try{
            pdfImages = [];
            pdfImageURLs = [];
            gtyGenered = 0;
            pdfjsLib.disableWorker = true;
            pdf = await  pdfjsLib.getDocument({data:dataT,worker:this.myPdfWorker}).promise;

                qtyPagesTotal = pdf.numPages;
                console.log('obtuvo document');
                console.log(pdf);
                this.renderPageLocal(1);
                //this.queueRenderPage(0);
                // const esperar = await this.waitTillDone();
                //this.wenAllDone();



        }catch(e){
            console.log(' Error loading pdf'+ e.toString());
        }
}
wenAllDone() {
    console.log('CUMPLIDAS PROMESA');
    let pdfNumPage = pdfImageURLs.length;
    // document.getElementById('page_count').textContent = qtyPagesTotal;
    // $("#custom-pager").css('display', 'block');
    //$('#div-btn-send').css('display', 'block');
    //Con esto miramos el tamaño de las páginas del PDF
    /* var defaultPage = new Image();
     defaultPage.onload =onLoadImage(defaultPage, 0);
     defaultPage.src = pdfImageURLs[0];
     document.getElementById('canvas-preview-doc').src = pdfImageURLs[0];*/
    this.renderPage(0);


}

renderPage(pageToRender) {
        console.log(pdfImageURLs);
    if(!(pdfImageURLs[pageToRender])){
        this.renderPageLocal(pageToRender + 1);
    }else{
        this.canvasPreviewDocSRC = "data:image/png;base64," +   pdfImageURLs[pageToRender] ;
        //var canvasContainer = this.template.querySelector('div.tester');
        //var canvas1 = this.template.querySelector('canvas.donut');
        //canvasContainer.appendChild(canvas1);
        this.currentStep = 2;
        this.previewDocument = true;
        this.watingPreviewDoc = false;

    }

}


 async renderPageLocal(num)
{
    pageRendering = true;
    //pageNum = num;
    // Using promise to fetch the page
    // Update page counters
    // document.getElementById('page_num').textContent = num;
    console.log('get page:' + num, pdf);
    let page = await pdf.getPage(num);

        console.log(' pdf.getPage  :'  );
        console.log(page);
        //clearFullCanvas();
        // Wait for rendering to finish
        var scale1 = 1.5;
        var viewport = page.getViewport({scale:scale1});
        var canvasContainer = this.template.querySelector('div.tester');
        // Prepare canvas using PDF page dimensions
    console.log('canvasContainer');
    console.log(canvasContainer);

        var canvas1 = this.template.querySelector('canvas.donut');
        canvas1.height = viewport.height;
        canvas1.width = viewport.width;
    canvasContainer.appendChild(canvas1);
    console.log('canvas1');
    console.log(canvas1);
    console.log( canvasContainer);
        // Render PDF page into canvas context
    var context =  canvas1.getContext('2d');
        var renderContext = {
            canvasContext: context ,
            viewport: viewport};

        console.log(renderContext);
        await  page.render(renderContext).promise;
            console.log('Page rendered');
           /* pageRendering = false;
            if (pageNumPending !== null) {
                // New page rendering is pending
               // this.renderPageLocal(pageNumPending);
                pageNumPending = null;
            }
            pdfImages[num-1] = ctx.getImageData(0, 0, canvas.width, canvas.height);
            ctx.clearRect(0, 0, canvas.width, canvas.height);
            ctx.putImageData(pdfImages[num-1], 0, 0 );
            pdfImageURLs[num-1]  = ctx.canvas.toDataURL();
            /*	if(num==1){
                    gtyGenered = qtyPagesTotal;
                }else{
                    gtyGenered++;
                }
            gtyGenered++;

            console.log('pdfImages DEFINICION');
            console.log(pdfImages);
            // calculate the width of the final display canvas
            if (canvas.width > maxCanvasWidth) {
                maxCanvasWidth = canvas.width;
            }
            // calculate the accumulated with of the final display canvas
            canvasHeight += canvas.height;
            // save the "Y" starting position of this pages[i]
            pageStarts[num] = pageStarts[num-1] + canvas.height;
            //console.log("pre-rendered page " + pageNum + num);
            console.log('resuelve proesa');
            /*     var defaultPage = new Image();
                 defaultPage.onload = onLoadImage();
                 defaultPage.src = pdfImageURLs[num-1];*/
           // this.canvasPreviewDocSRC =pdfImageURLs[num-1];



}

/**
 * If another page rendering in progress, waits until the rendering is
 * finised. Otherwise, executes rendering immediately.
 */
queueRenderPage(num) {
    if (pageRendering===true) {
        pageNumPending = num;
    } else {
        this.renderPageLocal(num + 1);
    }
}
    toggleFilter(event) {

        if (this.isPanelOpen) {
            this.isPanelOpen = false;
        } else {
            this.isPanelOpen = true;
        }
        this.tooglePanel(null);
    }

    tooglePanel(event) {

        let panelShape = this.template.querySelector('[data-id="panelContainerTools"]');
        const filterClasses = String(panelShape.classList);


        if (filterClasses.includes('slds-is-open')) {
            panelShape.classList.remove('slds-is-open');
        } else {
            panelShape.classList.add('slds-is-open');
        }
        console.log(JSON.stringify(this.listOfSingers));
        console.log(JSON.stringify(this.movementsSinger));
    }

}
function renderPDF(url, canvasContainer, options) {
        console.log('reader');
    var options = options || { scale: 1 };

    function renderPage1(page) {
        console.log('reader - pages render');
        var viewport = page.getViewport(options.scale);
        var canvas = document.createElement('canvas');
        var ctx = canvas.getContext('2d');
        var renderContext = {
            canvasContext: ctx,
            viewport: viewport
        };

        canvas.height = viewport.height;
        canvas.width = viewport.width;

        canvasContainer.appendChild(canvas);

        page.render(renderContext);
    }

    function renderPages1(pdfDoc) {
        console.log('reader - pages');
        for(var num = 1; num <= pdfDoc.numPages; num++)
            pdfDoc.getPage(num).then(renderPage1);
    }

   pdfjsLib.disableWorker = true;
    pdfjsLib.getDocument({data:url}).then(renderPages1);

}
function addEvents(grid, id) {
    let g = (id !== undefined ? 'grid' + id + ' ' : '');

    grid.on('added removed change', function(event, items) {
        let str = '';
        items.forEach(function(item) { str += ' (' + item.x + ',' + item.y + ' ' + item.w + 'x' + item.h + ')'; });
        console.log(g + event.type + ' ' + items.length + ' items (x,y w h):' + str );
    });

    grid.on('enable', function(event) {
        let grid = event.target;
        console.log(g + 'enable');
    });

    grid.on('disable', function(event) {
        let grid = event.target;
        console.log(g + 'disable');
    });

    grid.on('dragstart', function(event, el) {
        let node = el.gridstackNode;
        let x = el.getAttribute('gs-x'); // verify node (easiest) and attr are the same
        let y = el.getAttribute('gs-y');
        console.log(g + 'dragstart ' + el.textContent + ' pos: (' + node.x + ',' + node.y + ') = (' + x + ',' + y + ')');
    });

    grid.on('drag', function(event, el) {
        let node = el.gridstackNode;
        let x = el.getAttribute('gs-x'); // verify node (easiest) and attr are the same
        let y = el.getAttribute('gs-y');
        // console.log(g + 'drag ' + el.textContent + ' pos: (' + node.x + ',' + node.y + ') = (' + x + ',' + y + ')');
    });

    grid.on('dragstop', function(event, el) {
        let node = el.gridstackNode;
        let x = el.getAttribute('gs-x'); // verify node (easiest) and attr are the same
        let y = el.getAttribute('gs-y');
        console.log(g + 'dragstop ' + el.textContent + ' pos: (' + node.x + ',' + node.y + ') = (' + x + ',' + y + ')');
    });

    grid.on('dropped', function(event, previousWidget, newWidget) {
        if (previousWidget) {
            console.log(g + 'dropped - Removed widget from grid:', previousWidget);
        }
        if (newWidget) {
            console.log(g + 'dropped - Added widget in grid:', newWidget);
        }
    });

    grid.on('resizestart', function(event, el) {
        let node = el.gridstackNode;
        let w = el.getAttribute('gs-w');  // verify node (easiest) and attr are the same
        let h = el.getAttribute('gs-h');
        console.log(g + 'resizestart ' + el.textContent + ' size: (' + node.w + 'x' + node.h + ') = (' + w + 'x' + h + ')');
    });

    grid.on('resize', function(event, el) {
        let node = el.gridstackNode;
        let w = el.getAttribute('gs-w');  // verify node (easiest) and attr are the same
        let h = el.getAttribute('gs-h');
        // console.log(g + 'resize ' + el.textContent + ' size: (' + node.w + 'x' + node.h + ') = (' + w + 'x' + h + ')');
    });

    grid.on('resizestop', function(event, el) {
        let node = el.gridstackNode;
        let w = el.getAttribute('gs-w'); // verify node (easiest) and attr are the same
        let h = el.getAttribute('gs-h');
        console.log(g + 'resizestop ' + el.textContent + ' size: (' + node.w + 'x' + node.h + ') = (' + w + 'x' + h + ')');
    });
}