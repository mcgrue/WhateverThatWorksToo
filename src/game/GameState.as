package game {
    
    import org.flixel.*;
	
	public class GameState extends FlxState {
        
        public var map:FlxTilemap;
        public var obs:FlxTilemap;
        
        public var map_group:FlxGroup = new FlxGroup();
        public var obs_group:FlxGroup = new FlxGroup();
        public var plr_group:FlxGroup = new FlxGroup();
            
        [Embed (source = "../../data/tilesets/mario.png")] private var marioTiles:Class;
        [Embed (source = "../../data/maps/mariobros.tmx", mimeType = "application/octet-stream")] private var marioMap:Class;
        
		public function GameState() {

		}
        
        override public function create():void {
            
            add(obs_group);
            add(map_group);
            add(plr_group);
                        
            var xml:XML = new XML( new marioMap );
            var mapxml:XMLList = xml.*;
            
            map = new FlxTilemap();
            map.startingIndex = 1;
            map.collideIndex = 1;
            map.loadMap(
                mapxml.(@name=="PlayingField").data,
                marioTiles,
                16, 16
            );
            
            obs = new FlxTilemap();
            obs.startingIndex = 1;
            obs.collideIndex = 2;
            obs.loadMap(
                mapxml.(@name=="Obstructions").data,
                marioTiles,
                16, 16
            );
            
            obs_group.add(obs);
            map_group.add(map);
            
            plr_group.add( new Player(4*16,9*16,1) );
            plr_group.add( new Player(11*16,9*16,2) );   
            
            super.create();
        }
        
        public function before_update(): void {
            
            FlxU.collide(plr_group, obs_group);
            FlxU.collide(plr_group, plr_group);
        }
        
        public function after_update(): void {
            
        }
               
        override public function update(): void {
            
            before_update();

            super.update();
            
            after_update();
        }
 	}
}