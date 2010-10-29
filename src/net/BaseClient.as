package net
{
	import flash.events.*;
	import flash.net.*;
	import flash.utils.*;
	
	import game.*;

	
	import org.flixel.*;

	
	public class BaseClient extends PeerSocket
	{
		public var lobby:Lobby;
		
		public var status:FlxText;
		
		
		
		public function BaseClient(lobby:Lobby)
		{
			this.lobby = lobby;
			super(Lobby.PEERING_SERVER);
		}
		
				
		public function onConnect():void {
			FlxG.log("Joining: "+connection.farID);
			LobbyState.status.text = "Waiting for players...";
		}
		
		public function say(data:String):void {
			LobbyState.status.text = data;
			FlxG.log(data);
		}
		
		public function start():void {
			if (!Lobby.isHost) {
				FlxG.state = new ClientState(this);	
			}
			
		}
		
		public function syncnew(k:String, args:Array):void {
			FlxG.state.add(Util.instantiateClass(k, args));
		}
		
		public function test(o:Object):void {
			//if (!lobby.isHost) {
				//FlxG.log(group);
				var obj:FlxGroup = o as FlxGroup;
				FlxG.log(obj);
				//FlxG.state.add(o as FlxGroup);
			//}
		}
		
		public function onKey(event:KeyboardEvent):void {
			send("key", event.type, event.keyCode);
		}
	}
}