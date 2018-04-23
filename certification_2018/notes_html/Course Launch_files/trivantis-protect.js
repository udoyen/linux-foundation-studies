
		/*
 * Copyright (C) 2007 Trivantis Corporation
 */

	
function disableRC(e) {var k;var d=document;if(d.all) k=event.button;if(d.layers||d.getElementById&&!d.all) k=e.which;if (k==2||k==3) {return false;}};function disableCtrlK(e,A){var B;var C=false;if(A) { B=event.keyCode;e=event;}else B=e.charCode;if(e.keyCode==45) C=true;var D=String.fromCharCode(B).toLowerCase();if(e.ctrlKey&&(D=="c"||D=="a"||D=="u"||C)) {if(A) e.returnValue=false;else return false;}};function trivProtectContent(){var A=(window.is?is.ie10orLess:(navigator.appName.indexof("Microsoft Internet Explorer")>-1));var d=document;if(d.layers) {d.captureEvents(Event.MOUSEDOWN);d.captureEvents(Event.KEYPRESS|Event.KEYDOWN);};d.onmousedown=disableRC;d.oncontextmenu=function(){return false;};var B=function(e){return disableCtrlK(e,A);};if(A) d.onkeydown=B;else d.onkeypress=B;}
