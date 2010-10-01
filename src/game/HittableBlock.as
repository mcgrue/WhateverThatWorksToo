package game {
    import org.flixel.FlxTileblock;
    
    public class HittableBlock extends FlxTileblock {
        
        public var is_bouncing:Boolean = false;
        private var orig_x:int;
        private var orig_y:int;
        
        public const BOUNCE_Y:int = 8;
        
        public function HittableBlock(X:int, Y:int, Width:uint, Height:uint) {
            super(X, Y, Width, Height);
            orig_x = X;
            orig_y = Y;
        }
        
        public function doBounce():void {
            if( is_bouncing ) {
                return;
            }
            
            is_bouncing = true;
        }
        
        public override function update():void {
            if( is_bouncing ) {
                
                if( x == orig_x && y == orig_y ) {
                    is_bouncing = false;   
                }
            }   
        } 
    }
}