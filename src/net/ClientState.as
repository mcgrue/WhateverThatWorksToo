package net
{
	import flash.display.*;
	import flash.utils.*;
	import flash.events.*;
	
	import org.flixel.*;
	
	public class ClientState extends FlxState {
		public var status:FlxText;
		public var client:BaseClient;
		
		public function ClientState(client:BaseClient) {
			this.client = client;
			
			status = new FlxText(5, 5, 400, "Client state!");
			add(status);
		
			FlxG.stage.addEventListener(KeyboardEvent.KEY_DOWN, client.onKey);
			FlxG.stage.addEventListener(KeyboardEvent.KEY_UP, client.onKey);
		}
	}
}