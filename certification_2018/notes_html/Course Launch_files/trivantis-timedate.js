
		/*
 * Copyright (C) 2007 Trivantis Corporation
 */

	
function FormatDS(A) {return A.toLocaleDateString();};function FormatTS(A) {if (is.ns) {var B=A.getMinutes();if (B<10) B="0"+B;var C=A.getHours();var D='AM';if (C>=12) {D='PM';if (C>12) C-=12;}else if (C==0) C=12;if (C<10) C=' '+C;return C+':'+B+' '+D;}else {var E=A.toLocaleTimeString();if (E.length>3) {idx=E.lastIndexOf(':');if (idx>=0) {var F=E.substring(0,idx);if (E.length>=idx+3) F=F+E.substring(idx+3,E.length);E=F;}};idx=E.lastIndexOf(' ');if (idx>0&&idx==E.length-4) E=E.substring(0,E.length-4);return E;}};function FormatETS(A) {var B=A % 1000;A-=B;A/=1000;var C=A % 60;A-=C;A/=60;var D=A % 60;A-=D;A/=60;var E=A;if(E<10) E="0"+E;if(D<10) D="0"+D;if(C<10) C="0"+C;return E+':'+D+':'+C;};function CalcTD(f,A) {var B=0;if(f==1) B+=24*60*60*1000*A;else if(f==2) B+=60*1000*A;else if(f==4) B+=1000*A;return B;};
