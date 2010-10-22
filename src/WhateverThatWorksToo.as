package
{
	import game.GameState;
	
	import net.*;
	
	import org.flixel.*;
	[SWF(width="512", height="512", backgroundColor="#FF00FF")]
	
	public class WhateverThatWorksToo extends FlxGame {
		
		public function WhateverThatWorksToo() {
			super(256,256, LobbyState.wrap(GameState), 2);
		}
	}
}