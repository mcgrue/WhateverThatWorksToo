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
			if (!lobby.isHost) {
				FlxG.state = new ClientState(this);	
			}
			
		}
		
		public function onKey(event:KeyboardEvent):void {
			send("key", event.type, event.keyCode);
		}
	}
}