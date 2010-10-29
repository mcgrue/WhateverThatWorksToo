package net
{
	import org.flixel.*;
	
	public class Lobby
	{
		//static public const LOBBY_SERVER:String = "http://flixel-lobby.appspot.com";
		static public const LOBBY_SERVER:String = "http://localhost:8089";
		static public const PEERING_SERVER:String = "rtmfp://p2p.rtmfp.net/a4d4210ccbc2cf4999167b2e-073ac5fb603c"; // jeff lindsay's
		
		public var size:int;
		public var game:String;
		
		static public var client:BaseClient;
		static public var host:BaseHost;
		static public var isHost:Boolean = false;
		
		public function Lobby(clientClass:Class, hostClass:Class, size:int, game:String=null)
		{
			this.size = size;
			this.game = game;
			
			client = new clientClass(this);
			client.ready(function():void {
				FlxG.log("ClientID: "+client.connection.nearID);
				joinGame();
			});
			
			host = new hostClass(this);
		}
		
		public function joinGame():void {
			var payload:Object = {'id': client.connection.nearID};
			Http.post(joinUrl(), payload, function(status:int, data:String):void {
				switch (status) {
					case 200:
						var gameData:Array = data.split(',');
						client.connect(gameData[1], client, function():void { joinGame() });
						break;
					case 404:
						host.ready(function():void {
							FlxG.log("HostID: "+host.connection.nearID);
							hostGame();
						});
						break;
				}
				
			});
		}
		
		public function hostGame():void {
			host.ready(function():void {
				var payload:Object = {'id': host.connection.nearID};
				Http.post(hostUrl(), payload, function(status:int, data:String):void {
					if (status == 200) {
						game = data.split(',')[2];
						host.listen(host);	
						isHost = true;
						joinGame();
					}
				});
			});
		}
		
		private function joinUrl():String {
			var joinUrl:String = LOBBY_SERVER+"/join?players="+size;
			if (game) {
				joinUrl += "&game="+game;
			}
			return joinUrl;
		}
		
		private function hostUrl():String {
			return LOBBY_SERVER+"/host";
		}
	}
}