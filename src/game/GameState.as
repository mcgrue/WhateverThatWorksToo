package game {
    
	import org.flixel.FlxGroup;
	import org.flixel.FlxState;
	import org.flixel.FlxTilemap;
	
	public class GameState extends FlxState {
        
        public var map:FlxTilemap;
        public var obs:FlxTilemap;
        
        public var map_group:FlxGroup = new FlxGroup();
        public var obs_group:FlxGroup = new FlxGroup();
    
        [Embed (source = "../../data/tilesets/mario.png")] private var marioTiles:Class;
        [Embed (source = "../../data/maps/mariobros.tmx", mimeType = "application/octet-stream")] private var marioMap:Class;
        
		public function GameState() {

		}
        
        override public function create():void {
            add(obs_group);
            add(map_group);
                        
            var xml:XML = new XML( new marioMap );
            var mapxml:XMLList = xml.*;
            
            map = new FlxTilemap();
            map.startingIndex = 1;
            map.loadMap(
                mapxml.(@name=="PlayingField").data,
                marioTiles,
                16, 16
            );
            
            obs = new FlxTilemap();
            obs.startingIndex = 1;
            obs.loadMap(
                mapxml.(@name=="Obstructions").data,
                marioTiles,
                16, 16
            );
            
            obs_group.add(obs);
            map_group.add(map);
            
            
            
            super.create();
        }
	}
}