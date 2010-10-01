package game {
    
    import org.flixel.*;
	
	public class GameState extends FlxState {
        
        public var map:FlxTilemap;
        public var obs:FlxTilemap;
        
        public var map_group:FlxGroup = new FlxGroup();
        public var obs_group:FlxGroup = new FlxGroup();
        public var objects_group:FlxGroup = new FlxGroup();
        public var plr_group:FlxGroup = new FlxGroup();
        public static const obstructed_tiles:Array = [4,17,18,19,33,34,35]; 
            
        [Embed (source = "../../data/tilesets/mario.png")] private var marioTiles:Class;
        [Embed (source = "../../data/sprites/hit_block.png")] private var hittableTile:Class;
        [Embed (source = "../../data/maps/mariobros.tmx", mimeType = "application/octet-stream")] private var marioMap:Class;
        
		public function GameState() {

		}
        
        public static function is_hittable_brick(idx:int): Boolean {
            return idx == 2;
        }
        
        public static function is_obstruction_tile(idx:int):Boolean {
            return obstructed_tiles.indexOf(idx) >= 0;
        }
        
        override public function create():void {
            
            add(obs_group);
            add(map_group);
            add(objects_group);
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
                mapxml.(@name=="PlayingField").data,
                marioTiles,
                16, 16
            );
            
            obs_group.add(obs);
            
            for( var x:int = 0; x<obs.widthInTiles; x++ ) {
                for( var y:int = 0; y<obs.heightInTiles; y++ ) {
                    
                    if( is_obstruction_tile(obs.getTile(x,y)) ) {
                        obs.setTile(x, y, 2);
                    } else {
                        if( is_hittable_brick(obs.getTile(x,y)) ) {
                            
                            var hb:HittableBlock = new HittableBlock(x*16, y*16, 16, 16);
                            hb.loadTiles(hittableTile, 16, 16);
                            hb.collideLeft = false;
                            hb.collideRight = false;
                            objects_group.add(hb);
                            
                            map.setTile(x, y, 1);
                        }
                        
                        obs.setTile(x, y, 1);
                    }
                }    
           } 
            
            map_group.add(map);
            //map.visible = false;
            
            plr_group.add( new Player(4*16,9*16,1) );
            plr_group.add( new Player(11*16,9*16,3) );   
            
            super.create();
        }
        
        public function before_update(): void {
            
            FlxU.collide(plr_group, obs_group);
            FlxU.collide(plr_group, plr_group);
            FlxU.collide(plr_group, objects_group);
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