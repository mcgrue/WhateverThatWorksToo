package net
{
	import flash.events.*;
	import flash.net.*;
	import flash.utils.*;
	
	import org.flixel.*;
	
	
	public class BaseHost extends PeerSocket
	{
		public var lobby:Lobby;
		
		public function BaseHost(lobby:Lobby)
		{
			this.lobby = lobby;
			super(Lobby.PEERING_SERVER);
		}
		
		
		public function onConnect(clients:Array, peer:NetStream):void {
			FlxG.log("Player connected: "+peer.farID);
			if (clients.length == lobby.size) {
				send("say", "Let's play!");
				FlxG.state = new LobbyState.gameState();
			}
		}
		
		public function key(type:String, keyCode:uint):void {
			FlxG.log(keyCode);
			FlxG.stage.dispatchEvent(new KeyboardEvent(type, true, false, 0, keyCode));
		}
	}
}