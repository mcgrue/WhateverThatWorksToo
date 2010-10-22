package game {
  
    import flash.display.*;
    import flash.utils.*;
	
    import org.flixel.*;
    import net.*;
	
	public class GameState extends FlxState {
        
        public var map:FlxTilemap;
        public var obs:FlxTilemap;
        
        public var mapGroup:FlxGroup = new FlxGroup();
        public var obstructionGroup:FlxGroup = new FlxGroup();
        public var objectsGroup:FlxGroup = new FlxGroup();
        public var playerGroup:FlxGroup = new FlxGroup();
        public static const obstructedTiles:Array = [4,17,18,19,33,34,35]; 
            
        [Embed (source = "../../data/tilesets/mario.png")] private var marioTiles:Class;
        [Embed (source = "../../data/sprites/hit_block.png")] private var hittableTile:Class;
        [Embed (source = "../../data/maps/mariobros.tmx", mimeType = "application/octet-stream")] private var marioMap:Class;
        
		public static var status:FlxText;
		public var lobby:Lobby;
		
		public function GameState() {
			
		}
        
        public static function isHittableBrick(idx:int): Boolean {
            return idx == 2;
        }
        
        public static function isObstructionTile(idx:int):Boolean {
            return obstructedTiles.indexOf(idx) >= 0;
        }
        
        override public function create():void {

			add(obstructionGroup);
			add(mapGroup);
			add(objectsGroup);
			add(playerGroup);
                        
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
            
            obstructionGroup.add(obs);
            
            for( var x:int = 0; x<obs.widthInTiles; x++ ) {
                for( var y:int = 0; y<obs.heightInTiles; y++ ) {
                    
                    if( isObstructionTile(obs.getTile(x,y)) ) {
                        obs.setTile(x, y, 2);
                    } else {
                        if( isHittableBrick(obs.getTile(x,y)) ) {
                            
                            var hb:HittableBlock = new HittableBlock(x*16, y*16, 16, 16);
                            hb.loadTiles(hittableTile, 16, 16);
                            
                            //hb.collideLeft = false;
                            //hb.collideRight = false;
                            objectsGroup.add(hb);
                            
                            map.setTile(x, y, 1);
                        }
                        
                        obs.setTile(x, y, 1);
                    }
                }    
           } 
            
            mapGroup.add(map);
            //map.visible = false;
            
			playerGroup.add( new Player(4*16,9*16,1) );
			playerGroup.add( new Player(11*16,9*16,3) );   

			var params:Object = LoaderInfo(this.root.loaderInfo).parameters;
			var players:Number;
			if (params.hasOwnProperty('players')) {
				players = int(params['players']);
			} else {
				players = 2;
			}
			
			status = new FlxText(5, 5, 400, "Connecting...");
			add(status);
			lobby = new Lobby(BaseClient, BaseHost, players);
			
            super.create();
        }
        
        public function before_update(): void {    
            FlxU.collide(playerGroup, obstructionGroup);
            FlxU.collide(playerGroup, playerGroup);
            FlxU.collide(playerGroup, objectsGroup);
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