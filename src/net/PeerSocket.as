package net
{
	import flash.events.*;
	import flash.net.*;
	import flash.utils.*;
	
	public class PeerSocket
	{
		public const STATE_INIT:int 		= 0;
		public const STATE_READY:int 		= 1;
		public const STATE_CONNECTED:int 	= 2;
		public const STATE_LISTENING:int	= 3;
		
		public const STREAM_NAME:String = "PeerSocket";
		
		public var connectTimeout:uint 	= 1000;
		public var connection:NetConnection;
		
		private var readyCallback:Function = function():void {};
		private var state:int;
		
		private var sendStream:NetStream;
		private var hostStream:NetStream;
		private var clientStreams:Array = new Array();
		
		public function PeerSocket(peeringUri:String)
		{
			state = STATE_INIT;
			connection = new NetConnection();
			connection.addEventListener(NetStatusEvent.NET_STATUS, function(event:NetStatusEvent):void {
				switch (event.info.code) {
					case "NetConnection.Connect.Success":
						state = STATE_READY;
						readyCallback();
						break;
				}
			});
			connection.connect(peeringUri);
		}
		
		public function ready(callback:Function):void {
			switch (state) {
				case STATE_INIT:
					readyCallback = callback;
					break;
				case STATE_READY:
					callback();
					break;
				default:
					callback();
			}
		}
		
		public function listen(delegate:Object):void {
			sendStream = new NetStream(connection,NetStream.DIRECT_CONNECTIONS);
			sendStream.addEventListener(NetStatusEvent.NET_STATUS, function(event:NetStatusEvent):void{});
			sendStream.publish(STREAM_NAME);
			state = STATE_LISTENING;
			
			var internalDelegate:Object = new Object();
			internalDelegate.onPeerConnect = function(peer:NetStream):Boolean{
				var clientStream:NetStream = new NetStream(connection, peer.farID);
				clientStream.addEventListener(NetStatusEvent.NET_STATUS, function(event:NetStatusEvent):void{
					switch (event.info.code) {
						case "NetStream.Play.Reset":
							clientStreams.push(clientStream);
							delegate.onConnect(clientStreams, peer);
							break;
					}
				});
				clientStream.play(STREAM_NAME);
				clientStream.client = delegate;
				return true;
			};
			sendStream.client = internalDelegate;
		}
		
		public function connect(peerId:String, delegate:Object, onTimeout:Function):void {
			var retry:uint = setTimeout(onTimeout, connectTimeout);
			hostStream = new NetStream(connection, peerId);
			hostStream.addEventListener(NetStatusEvent.NET_STATUS, function(event:NetStatusEvent):void {
				trace(event.info.code);
				switch (event.info.code) {
					case "NetStream.Play.Reset":
						clearTimeout(retry);
						state = STATE_CONNECTED;
						delegate.onConnect();	
						break;
				}
			});
			hostStream.play(STREAM_NAME);
			hostStream.client = delegate;
			sendStream = new NetStream(connection, NetStream.DIRECT_CONNECTIONS);
			sendStream.addEventListener(NetStatusEvent.NET_STATUS, function(event:NetStatusEvent):void{});
			sendStream.publish(STREAM_NAME);
		}
		
		public function send(... args):void {
			sendStream.send.apply(null, args);
		}
	}
}