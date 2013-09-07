// JavaScript Document

var canvasCtx;
var canvas;
var canvasWidth=600;
var canvasHeight=400;
var guiGfx;
var photos;
var currentPhoto = 0;
var backgroundColor = "#ededed";

var assetsToLoad;
var loaded;

var waitInterval;
var animationCounter = 0;

function drawPhotoGallery(photoIndex)
{
	var startX = canvasWidth / 2 - (photos.photos.length*12) - 46;
	var startY = canvasHeight - 50;
//	var startY = 350;

	var i;
	
	var photoWidth;
	var photoHeight;

	canvasCtx.fillRect(0,0,canvasWidth,canvasHeight);
	
	var photo = photos.photos[photoIndex];
	var ratio;
	
	if (photo.width > canvasWidth) {
		ratio = canvasWidth / photo.width;
		if (photo.height * ratio > canvasHeight) ratio = canvasHeight / photo.height;
	} else {
		ratio = canvasHeight / photo.height;
		if (photo.width * ratio > canvasWidth) ratio = canvasWidth / photo.width;
	}
	
	var x = (canvasWidth - photo.width*ratio) / 2;
	var y = (canvasHeight - photo.height*ratio) / 2;

	/* draw the photo itself */
	canvasCtx.drawImage(photos.photos[photoIndex], x, y, photo.width*ratio, photo.height*ratio);

	/* draw the gui */
	roundRect(canvasCtx, startX, startY, photos.photos.length*25 + 90, 100, 10, "rgba(0,0,0,0.2)", "solid");
	
	canvasCtx.drawImage(guiGfx.left_arrow, startX, startY);
	
	for (i=0 ; i<photos.photos.length ; i++)
	{
		canvasCtx.drawImage(guiGfx.n[i], startX+i*25+40, startY);
	}
	
	canvasCtx.drawImage(guiGfx.ns[photoIndex], startX+40+(25*photoIndex), startY);
	
	canvasCtx.drawImage(guiGfx.right_arrow, startX+(photos.photos.length-1)*25+75, startY);	
	
	
}

function waitForPhotos()
{
	return (function() 
	{
//		alert(loaded);
		if (loaded == assetsToLoad) {
			drawPhotoGallery(currentPhoto);
			canvasCtx.globalAlpha += 0.1;			
			if (canvasCtx.globalAlpha == 1) {
				clearInterval(waitInterval);
			}
		}
		else {
			canvasCtx.fillStyle = backgroundColor;
			canvasCtx.fillRect(0,0,canvasWidth,canvasHeight);
		}
	});
}




function setupPhotoGallery(canvasName, w, h, sources)
{
	canvas = document.getElementById(canvasName);
	canvas.addEventListener('mousedown', mouseEvent, false);
 	canvas.addEventListener('mousemove', mouseEvent, false);
 	canvas.addEventListener('mouseup',   mouseEvent, false);
	
	canvasWidth = w;
	canvasHeight = h;
	canvasCtx = canvas.getContext('2d');
	
	canvasCtx.fillStyle=backgroundColor;
	canvasCtx.globalAlpha = 0;
	canvasCtx.strokeStyle="rgba(255,0,0,0.2)";
	canvasCtx.fillRect(0,0,canvasWidth,canvasHeight);
	
	guiGfx = new guiGraphics();
	
	photos = new loadPhotos(sources);
	
	assetsToLoad = 12 + photos.photos.length;
	loaded = 0;
	
	var funcRef = waitForPhotos();
	waitInterval = setInterval(funcRef, 30);
	
	
	//while(guiGfx.right_arrow.loaded == 0)
	//{
		
	//}
	

}

function mouseEvent (ev) {
  var x, y;

  // Get the mouse position relative to the canvas element.
  if (ev.layerX || ev.layerX == 0) { // Firefox
    x = ev.layerX;
    y = ev.layerY;
  } else if (ev.offsetX || ev.offsetX == 0) { // Opera
    x = ev.offsetX;
    y = ev.offsetY;
  }
  
  var elementOn = getElement(x,y);
  if (elementOn == "none") {
	  canvas.style.cursor = "default";
	  return;
  }
  
  canvas.style.cursor = "pointer";
  
  if (ev.type == "mousedown") {
	  if (elementOn == "left") {
		  if (--currentPhoto == -1) currentPhoto = photos.photos.length-1;
		  setPhoto(currentPhoto);
	  }
	  else if (elementOn == "right") {
		  if (++currentPhoto == photos.photos.length) currentPhoto = 0;
		  setPhoto(currentPhoto);
	  }
	  else if (elementOn == "0")
	  {
		  currentPhoto = 0;
		  setPhoto(currentPhoto);
	  }
	  else if (elementOn == "1")
	  {
		  currentPhoto = 1;
		  setPhoto(currentPhoto);
	  }
	  else if (elementOn == "2")
	  {
		  currentPhoto = 2;
		  setPhoto(currentPhoto);
	  }
	  else if (elementOn == "3")
	  {
		  currentPhoto = 3;
		  setPhoto(currentPhoto);
	  }
	  else if (elementOn == "4")
	  {
		  currentPhoto = 4;
		  setPhoto(currentPhoto);
	  }
  }
}

function getElement(x, y)
{
	var startX = canvasWidth / 2 - (photos.photos.length*12) - 46 - 17;
	var startY = 0;
	
	if (x >= startX+26 && x <= startX+46 &&
		y >= startY+(canvasHeight-40) && y <= startY+(canvasHeight-20)) return "left";
		 
	var i;
	for (i=0 ; i<photos.photos.length; i++)
	{
		if (x >= startX+65+i*25 && x <= startX+82+i*25 &&
			y >= startY+(canvasHeight-39) && y <= startY+(canvasHeight-21)) return "" + i;
	}

	if (x >= startX+(photos.photos.length-1)*25+100 && x<= startX+(photos.photos.length-1)*25+120 &&
		y >= startY+(canvasHeight-40) && y <= startY+(canvasHeight-20)) return "right";

/* // Paint elements
		
	canvasCtx.beginPath();
	canvasCtx.moveTo(startX+26, startY+360);
	canvasCtx.lineTo(startX+46, startY+360);
	canvasCtx.lineTo(startX+46, startY+380);
	canvasCtx.stroke();	

	for (i=0 ; i<5; i++)
	{
		canvasCtx.beginPath();
		canvasCtx.moveTo(startX+65 + i*25, startY+361);
		canvasCtx.lineTo(startX+82 + i*25, startY+361);
		canvasCtx.lineTo(startX+82 + i*25, startY+379);
		canvasCtx.stroke();	
	}
	canvasCtx.beginPath();
	canvasCtx.moveTo(startX+(photos.photos.length-1)*25+100, startY+360);
	canvasCtx.lineTo(startX+(photos.photos.length-1)*25+120, startY+360);
	canvasCtx.lineTo(startX+(photos.photos.length-1)*25+120,startY+ 380);
	canvasCtx.stroke();	
*/


	return "none";
}

function guiGraphics()
{
	this.right_arrow = new Image();
	this.right_arrow.onload = function() { loaded++; }
	this.right_arrow.src = "img/pg/right_arrow.png";

	this.left_arrow = new Image();
	this.left_arrow.onload = function() { loaded++; }
	this.left_arrow.src = "img/pg/left_arrow.png";
	
	this.n = new Object();
	this.ns = new Object();
	
	this.n[0] = new Image();
	this.n[0].onload = function() { loaded++ }
	this.n[0].src = "img/pg/1.png";
	this.ns[0] = new Image();
	this.ns[0].onload = function() { loaded++ }
	this.ns[0].src = "img/pg/1s.png";

	this.n[1] = new Image();
	this.n[1].onload = function() { loaded++ }
	this.n[1].src = "img/pg/2.png";
	this.ns[1] = new Image();
	this.ns[1].onload = function() { loaded++ }
	this.ns[1].src = "img/pg/2s.png";

	this.n[2] = new Image();
	this.n[2].onload = function() { loaded++ }
	this.n[2].src = "img/pg/3.png";
	this.ns[2] = new Image();
	this.ns[2].onload = function() { loaded++ }
	this.ns[2].src = "img/pg/3s.png";

	this.n[3] = new Image();
	this.n[3].onload = function() { loaded++ }
	this.n[3].src = "img/pg/4.png";
	this.ns[3] = new Image();
	this.ns[3].onload = function() { loaded++ }
	this.ns[3].src = "img/pg/4s.png";

	this.n[4] = new Image();
	this.n[4].onload = function() { loaded++ }
	this.n[4].src = "img/pg/5.png";
	this.ns[4] = new Image();
	this.ns[4].onload = function() { loaded++ }
	this.ns[4].src = "img/pg/5s.png";
}

function loadPhotos(srcs)
{
	this.photos = new Array();
	
	var i;
	for (i=0;i<srcs.length;i++) {
		this.photos[i] = new Image();
		this.photos[i].onload = function() { loaded++ }
		this.photos[i].src = srcs[i];
	}
}

function roundRect(ctx, x, y, width, height, radius, fill, stroke) {
  if (typeof stroke == "undefined" ) {
    stroke = true;
  }
  if (typeof radius === "undefined") {
    radius = 5;
  }
  ctx.beginPath();
  ctx.moveTo(x + radius, y);
  ctx.lineTo(x + width - radius, y);
  ctx.quadraticCurveTo(x + width, y, x + width, y + radius);
  ctx.lineTo(x + width, y + height - radius);
  ctx.quadraticCurveTo(x + width, y + height, x + width - radius, y + height);
  ctx.lineTo(x + radius, y + height);
  ctx.quadraticCurveTo(x, y + height, x, y + height - radius);
  ctx.lineTo(x, y + radius);
  ctx.quadraticCurveTo(x, y, x + radius, y);
  ctx.closePath();
  if (stroke) {
    ctx.stroke();
  }
  if (fill) {
    ctx.fill();
  }        
}


