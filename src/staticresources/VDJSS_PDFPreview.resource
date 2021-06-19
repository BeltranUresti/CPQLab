var pdfImages = null,
pageNum = 0;
function renderPage(pageToRender) {
	/*var image = new Image();
	image.onload = function() {
		ctx.drawImage(image, 0, 0, canvas.width, canvas.height);
	};
	image.src = "data:image/png;base64,"+pdfImages[pageNum-1];*/
    if(!(pdfImageURLs[pageToRender])){
        $("#img-preview-document").css('display', 'block');
        $('#wating-preview-doc').show();
        renderPageLocal(pageToRender + 1);
       // setCurrenSignerPage(pageToRender + 1);
    }else{
        var defaultPage = new Image();
        defaultPage.onload = onLoadImage();
        defaultPage.src = pdfImageURLs[pageToRender];
        document.getElementById('canvas-preview-doc').src=pdfImageURLs[pageToRender];
    }
	// Update page counters
	document.getElementById('page_num').textContent = (pageNum + 1);
	document.getElementById('signature-page').value  = (pageToRender +1);
	signersList[currentSigner].Visible.Page = (pageToRender+1 );
	if (currentQuestion){
		if (formQuestionsList.length > 0){
			formQuestionsList[currentQuestion].Visible.Page = (pageToRender + 1);
		}
	}
	//pageNum = parseInt(pageToRender);
    console.log('render page: ' + pageNum);
	if (typeof pageToRender !== 'undefined') {
		//clearCanvas(pageToRender+1);
        //clearCanvasForm(pageToRender+1);
	}
}
function onPrevPage() {
	if (pageNum <= 0) {
	  return;
	}
    pageNum = parseInt(pageNum) - 1;
    console.log('render page prev: ' + pageNum);
	renderPage(pageNum);
	drawSquareShadow();
	drawSquareShadowQuestion();
}
document.getElementById('prev').addEventListener('click', onPrevPage);

function onNextPage() {
	if (pageNum >= (qtyPagesTotal-1) ) {
        console.log('render page Next: return '  + pageNum );
	  return;
	}
    pageNum = parseInt(pageNum) + 1;
	console.log('render page Next: ' + pageNum);
	renderPage(pageNum);
	drawSquareShadow();
	drawSquareShadowQuestion();
}
document.getElementById('next').addEventListener('click', onNextPage);
