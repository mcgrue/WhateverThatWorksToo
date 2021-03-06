package game {
  
    import flash.display.*;
    import flash.utils.*;
    
    import mx.events.PropertyChangeEvent;
    import mx.utils.*;
    
    import net.*;
    
    import org.flixel.*;
	
	public class GameState extends FlxState {
        
        public var map:FlxTilemap;
        public var obs:FlxTilemap;
        
        public var mapGroup:FlxGroup = new FlxGroup();
        public var obstructionGroup:FlxGroup = new FlxGroup();
        public var objectsGroup:FlxGroup = new FlxGroup();
        public var playerGroup:FlxGroup = new FlxGroup();
        public var baddieGroup:FlxGroup = new FlxGroup();
        
        public static const obstructedTiles:Array = [4,17,18,19,33,34,35]; 
            
        [Embed (source = "../../data/tilesets/mario.png")] private var marioTiles:Class;
        [Embed (source = "../../data/maps/mariobros.tmx", mimeType = "application/octet-stream")] private var marioMap:Class;
        
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
            add(baddieGroup);
                        
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
                            var hb:HittableBlock = syncnew(HittableBlock, x*16, y*16, 16, 16);

                            //hb.collideRight = false;
                            //hb.collideLeft = false;
                            objectsGroup.add(hb);
                            
                            map.setTile(x, y, 1);
                        }

                        obs.setTile(x, y, 1);
                    }
                }
           }
            
            mapGroup.add(map);
            //map.visible = false;
            
			playerGroup.add(syncnew(Player, 4*16,9*16,1) );
			playerGroup.add(syncnew(Player, 11*16,9*16,3) );   

            baddieGroup.add( syncnew(Baddie, 13*16, 16*2) );
			
            super.create();
        }
		
		static public function syncnew(klass:Class, ... args):* {
			if (Lobby.isHost) { Lobby.host.send('syncnew', getQualifiedClassName(klass), args); }
			return Util.instantiateClass(getQualifiedClassName(klass), args);
		} 
        
        public function before_update(): void {    
            FlxU.collide(playerGroup, obstructionGroup);
            FlxU.collide(playerGroup, playerGroup);
            FlxU.collide(playerGroup, objectsGroup);
            FlxU.collide(playerGroup, baddieGroup);

            FlxU.collide(baddieGroup, obstructionGroup);
            FlxU.collide(baddieGroup, objectsGroup);
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