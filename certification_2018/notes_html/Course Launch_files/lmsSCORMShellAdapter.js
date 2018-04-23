/* lmsSCORMShellAdapater.js
 * Copyright 20009 360training.com, INC all rights reserved
 * 
 */


var API_1484_11 ;
var API ;	
var IS_LS360_SCORM = false;
var NOT_INITIALIZED = "Not Initialized";
var RUNNING = "Running";
var TERMINATED = "Terminated";

//IDLE TIMER IMPLEMENTATION SPECIFICALLY FOR LS360 SCORM COURSES
var applicationSessionTimeOut = 25; //25 //IN TERMS OF MINUTES
var loggerInterimTimer = applicationSessionTimeOut - 5; //5; //IN TERMS OF MINUTES
var interval = 0;
var child_waiting_interval;
var max_timer_value = 2; ///2;
var timer_value =0 ;
var IDLE_TIMEOUT = 3600; //seconds
var _idleSecondsCounter = 0;
var _idleWindowCloseCounter = 0;
var _idleMinutes = 4;
var _idleSeconds = 60;
var isTerminate = false;


// constructor
function SCORMAdapter() {
  this.version = "1.0.1";
  this.currentState = NOT_INITIALIZED;
  this.Initialize = Initialize;
  this.initialize = Initialize;
  this.LMSInitialize = Initialize;
  this.Terminate = Terminate;
  this.terminate = Terminate;
  this.LMSFinish = Terminate;
  this.GetValue = GetValue;
  this.getValue = GetValue;
  this.LMSGetValue = GetValue;
  this.SetValue = SetValue;
  this.setValue = SetValue;
  this.LMSSetValue = SetValue;
  this.Commit = Commit;
  this.commit = Commit;
  this.LMSCommit = Commit;
  this.GetLastError = GetLastError;
  this.getLastError = GetLastError;
  this.LMSGetLastError = GetLastError;
  this.GetErrorString = GetErrorString;
  this.getErrorString = GetErrorString;
  this.LMSGetErrorString = GetErrorString;
  this.GetDiagnostic = GetDiagnostic;
  this.getDiagnostic = GetDiagnostic;
  this.LMSGetDiagnostic = GetDiagnostic;

  this.errorCodes = new Array();
  this.errorCodes[0]   = "No Error";
  this.errorCodes[101] = "General Exception";
  this.errorCodes[102] = "General Initialization Failure";
  this.errorCodes[103] = "Already Initialized";
  this.errorCodes[104] = "Content Instance Terminated";
  this.errorCodes[111] = "General Termination Failure";
  this.errorCodes[112] = "Termination Before Initialization";
  this.errorCodes[113] = "Termination After Termination";
  this.errorCodes[122] = "Retrieve Data Before Initialization";
  this.errorCodes[123] = "Retrieve Data After Termination";
  this.errorCodes[132] = "Store Data Before Initialization";
  this.errorCodes[133] = "Store Data After Termination";
  this.errorCodes[142] = "Commit Before Initialization";
  this.errorCodes[143] = "Commit After Termination";
  this.errorCodes[201] = "General Argument Error";
  this.errorCodes[301] = "General Get Failure";
  this.errorCodes[351] = "General Set Failure";
  this.errorCodes[391] = "General Commit Failure";
  this.errorCodes[401] = "Undefined Data Model Element";
  this.errorCodes[402] = "Unimplemented Data Model Element";
  this.errorCodes[403] = "Data Model Element Value Not Initialized";
  this.errorCodes[404] = "Data Model Element Is Read Only";
  this.errorCodes[405] = "Data Model Element Is Write Only";
  this.errorCodes[406] = "Data Model Element Type Mismatch";
  this.errorCodes[407] = "Data Model Element Value Out Of Range";
  this.errorCodes[408] = "Data Model Dependency Not Established";

  this.errorDiagnostic = new Array();
  this.errorDiagnostic[0]   = "No Error";
  this.errorDiagnostic[101] = "General Exception";
  this.errorDiagnostic[102] = "General Initialization Failure";
  this.errorDiagnostic[103] = "Already Initialized";
  this.errorDiagnostic[104] = "Content Instance Terminated";
  this.errorDiagnostic[111] = "General Termination Failure";
  this.errorDiagnostic[112] = "Termination Before Initialization";
  this.errorDiagnostic[113] = "Termination After Termination";
  this.errorDiagnostic[122] = "Retrieve Data Before Initialization";
  this.errorDiagnostic[123] = "Retrieve Data After Termination";
  this.errorDiagnostic[132] = "Store Data Before Initialization";
  this.errorDiagnostic[133] = "Store Data After Termination";
  this.errorDiagnostic[142] = "Commit Before Initialization";
  this.errorDiagnostic[143] = "Commit After Termination";
  this.errorDiagnostic[201] = "General Argument Error";
  this.errorDiagnostic[301] = "General Get Failure";
  this.errorDiagnostic[351] = "General Set Failure";
  this.errorDiagnostic[391] = "General Commit Failure";
  this.errorDiagnostic[401] = "Undefined Data Model Element";
  this.errorDiagnostic[402] = "Unimplemented Data Model Element";
  this.errorDiagnostic[403] = "Data Model Element Value Not Initialized";
  this.errorDiagnostic[404] = "Data Model Element Is Read Only";
  this.errorDiagnostic[405] = "Data Model Element Is Write Only";
  this.errorDiagnostic[406] = "Data Model Element Type Mismatch";
  this.errorDiagnostic[407] = "Data Model Element Value Out Of Range";
  this.errorDiagnostic[408] = "Data Model Dependency Not Established";
}

function Initialize() {
	return Initialize("");
}

function Initialize(parameter) {
  this.errorCode = 0;
  this.currentState = RUNNING;
  return "true";
}

function Terminate() {
//	window.close();
	return Terminate("");
}

function Terminate(parameter) {
  stopTimer();
  this.currentState = TERMINATED;
  var url = LMS_URL+"?method=terminate";
  var result = loadXMLDocSynchronously(url);
  this.errorCode = 0;
  isTerminate = true;
  window.close();
  return "true";
}


function GetValue(key) {
	
  var url = LMS_URL+"?method=getValue&key="+encodeURIComponent(key);
  var result = loadXMLDocSynchronously(url);
  this.errorCode = 0;
  return result;
}

function SetValue(key, value) {
	
    if ( this.currentState == RUNNING ) {
        //var url = LMS_URL+"?method=setValue&key="+encodeURIComponent(key)+"&value="+encodeURIComponent(value);
        //var result = loadXMLDocSynchronously(url);
		var parameters = "method=setValue&key=" + encodeURIComponent(key) + "&value=" + encodeURIComponent(value);
	    var result = loadXMLDocSynchronouslyPost(LMS_URL, parameters);
	  
	    this.errorCode = 0;
    }
    return "true";
}

function Commit(parameter) {
  var url = LMS_URL+"?method=commit&parameter="+encodeURIComponent(parameter);
  var result = loadXMLDocSynchronously(url);
  this.errorCode = 0;
  return "true";
}

function GetLastError() {
  return this.errorCode+"";
}

function GetErrorString(parameter) {
  return this.errorCodes[this.errorCode];
}

function GetDiagnostic(parameter) {
  return this.errorDiagnostic[this.errorCode];
}


/******************* BELOW THIS IS THE PROPRIETARY LMS COMMUNICATOIN LAYER *******************/
var LMS_URL = "scorm.do";

function createXMLHttpRequest(){
	var xmlHttp = null;
	if(typeof XMLHttpRequest != "undefined"){
		xmlHttp = new XMLHttpRequest();
	}
	else if(typeof window.ActiveXObject != "undefined"){
		try {
			xmlHttp = new ActiveXObject("Msxml2.XMLHTTP.4.0");
		}
		catch(e){
			try {
				xmlHttp = new ActiveXObject("MSXML2.XMLHTTP");
			}
			catch(e){
				try {
					xmlHttp = new ActiveXObject("Microsoft.XMLHTTP");
				}
				catch(e){
					xmlHttp = null;
				}
			}
		}
	}
	return xmlHttp;
}

function loadXMLDocSynchronously(url) {
	
	if(isTerminate)
		{
		alert("Your browser session has expired, please close all windows and re-login.");
		window.close();
		
		}
 	resetAndStartTimer();
	xmlhttp = createXMLHttpRequest();
	if (xmlhttp!=null) {
		
	    try{
        	xmlhttp.open("POST",url,false);
            xmlhttp.send(null);
        }catch(err){
            alert("Your browser session has expired, please close all windows and re-login.");
            window.close();
        }

		if (xmlhttp.readyState==4) {
			// if "OK"
			if (xmlhttp.status==200) {
				if ( xmlhttp.responseText == null || xmlhttp.responseText == "" ) {
					return "";
				}
				//Please enter your Username and Password below.
				var LoginMessageIndex =xmlhttp.responseText.indexOf("Please enter your Username and Password below.");
				if(LoginMessageIndex > 0) {
					alert("Your browser session has expired, please close all windows and re-login.");
					window.close();
				}
					
				result = eval( "(" + xmlhttp.responseText + ")" );
				this.errorCode = result.errorCode;
				if ( result == null || result.result == null ) {
					return "";
				}
				return result.result;
			}
			else 
			{
				alert("Your browser session has expired, please close all windows and re-login.");				
			}
		}
	}
	else {
		alert("Your browser does not support XMLHTTP.")
	}
}

function loadXMLDocSynchronouslyPost(url, parameters) {
	
	if(isTerminate) {
		alert("Your browser session has expired, please close all windows and re-login.");
		window.close();
		
	}
 	
	resetAndStartTimer();
	xmlhttp = createXMLHttpRequest();
	if (xmlhttp!=null) {
		
	    try{
			xmlhttp.open("POST", url, false);
			xmlhttp.setRequestHeader("Content-type", "application/x-www-form-urlencoded");
			xmlhttp.send(parameters);
        }catch(err){
            alert("Your browser session has expired, please close all windows and re-login.");
            window.close();
        }

		if (xmlhttp.readyState==4) {
			// if "OK"
			if (xmlhttp.status==200) {
				if ( xmlhttp.responseText == null || xmlhttp.responseText == "" ) {
					return "";
				}
				//Please enter your Username and Password below.
				var LoginMessageIndex =xmlhttp.responseText.indexOf("Please enter your Username and Password below.");
				if(LoginMessageIndex > 0) {
					alert("Your browser session has expired, please close all windows and re-login.");
					window.close();
				}
					
				result = eval( "(" + xmlhttp.responseText + ")" );
				this.errorCode = result.errorCode;
				if ( result == null || result.result == null ) {
					return "";
				}
				return result.result;
			}
			else 
			{
				alert("Your browser session has expired, please close all windows and re-login.");				
			}
		}
	}
	else {
		alert("Your browser does not support XMLHTTP.")
	}
}

function initAPI()
{	
	API_1484_11 = new SCORMAdapter();
    API = new SCORMAdapter();
    
    if(API.currentState == NOT_INITIALIZED)
    {
    	API.Initialize();    	
    }
    if(API_1484_11.currentState == NOT_INITIALIZED)
    {
    	API_1484_11.Initialize();
    }
	resetAndStartTimer();
}

initAPI();

/******************************************************************************
*
* BEGIN: This section of functions primarily deals with idle timer execution
*
******************************************************************************/
function startIdleTimer() {  
	
	IdleTimerKeepAlive();
	timer_value++;  
	if (timer_value >= max_timer_value){   
		stopTimer();
		overlay();
		var intTimer = 1000; //5 * 60 * 1000;
		interval=self.setInterval("countDown()",intTimer);
	}
	
} 
function stopTimer()
{
	if(interval != 0 )
	{
		interval=window.clearInterval(interval);
	    timer_value =0 ;
	}
}
function resetAndStartTimer()
{		
		var intTimer = loggerInterimTimer * 60 * 1000;
		stopTimer();
		interval=self.setInterval("startIdleTimer()",intTimer);
}
function IdleTimerKeepAlive() {
		var today = new Date();    
	    $.getJSON("view.do",  "vm=keepalive&ts="+today.getTime() , function(json){    	    	
	    });
}

/******************************************************************************
*
* END: This section of functions primarily deals with idle timer execution
*
******************************************************************************/

var timerWiindow = false;

function IdleReset()
{
timerWiindow=false;
_idleSecondsCounter=0;
_idleWindowCloseCounter=0;
_idleMinutes = 4;
_idleSeconds = 60;
timer_value =0;
overlay();
resetAndStartTimer();
IdleTimerKeepAlive();
}

function countDown() {
	
	
	_idleSeconds--;
		if (_idleSeconds == 0 && _idleMinutes == 0)
		{
				overlay();
				Terminate();
		}
			
			if (_idleSeconds == 0)	{
				_idleMinutes--;
				_idleSeconds = 59 ;
			}
			
			var timerSecond	=  _idleSeconds + "";
			if(timerSecond.length == 1)
				timerSecond = "0" + timerSecond;
				
			document.getElementById("spnMinutes").innerHTML = _idleMinutes + "";
			document.getElementById("spnSeconds").innerHTML = timerSecond + "";
}


