package net
{
	import flash.display.*;
	import flash.utils.*;
	
	import game.GameState;
	
	import org.flixel.*;
	
	public class LobbyState extends FlxState {

		public static var status:FlxText;
		public static var gameState:Class;
		
		public var lobby:Lobby;
		
		public function LobbyState() {
		}
		
		override public function create():void {
			status = new FlxText(5, 5, 400, "Connecting...");
			add(status);
			
			var params:Object = LoaderInfo(this.root.loaderInfo).parameters;
			var players:Number;
			if (params.hasOwnProperty('players')) {
				players = int(params['players']);
			} else {
				players = 2;
			}
			
			lobby = new Lobby(BaseClient, BaseHost, players);
            			
			super.create();
		}
        
        override public function update(): void {
            
            if( FlxG.keys.pressed('Q') ) {
                FlxG.state = new GameState();
            }
        }
        
		public static function wrap(State:Class):Class {
			gameState = State;
			return LobbyState;
		} 
	}
}