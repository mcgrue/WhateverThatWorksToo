package net
{
	import flash.events.*;
	import flash.net.*;
	
	public class Http
	{
		public function Http()
		{
		}
		
		protected static function request(method:String, url:String, payload:Object, onResponse:Function):void {
			var req:URLRequest = new URLRequest(url);
			req.method = method;
			var postData:URLVariables = new URLVariables();
			for (var key:String in payload) {
				postData[key] = payload[key];
			}
			req.data = postData;
			var loader:URLLoader = new URLLoader();
			loader.addEventListener(HTTPStatusEvent.HTTP_STATUS, function(statusEvent:HTTPStatusEvent):void {
				loader.addEventListener(Event.COMPLETE, function(event:Event):void {
					onResponse(statusEvent.status, loader.data);
				});	
				loader.addEventListener(IOErrorEvent.IO_ERROR, function(event:Event):void {
					onResponse(statusEvent.status, loader.data);
				});	
			});
			loader.load(req);
		}
		
		public static function get(url:String, onResponse:Function):void {
			request('GET', url, new Object(), onResponse);
		}
		
		public static function post(url:String, payload:Object, onResponse:Function):void {
			request('POST', url, payload, onResponse);
		}
	}
}