package net
{
	import flash.events.*;
	import flash.net.*;
	import flash.utils.*;
	
	import org.flixel.*;
	import game.*;

	
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
			GameState.status.text = "Waiting for players...";
		}
		
		public function say(data:String):void {
			GameState.status.text = data;
			FlxG.log(data);
		}
		
		public function start():void {
			FlxG.stage.addEventListener(KeyboardEvent.KEY_DOWN, onKey);
			FlxG.stage.addEventListener(KeyboardEvent.KEY_UP, onKey);
		}
		
		public function onKey(event:KeyboardEvent):void {
			send("key", event.type, event.keyCode);
		}
	}
}