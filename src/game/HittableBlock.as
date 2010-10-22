package game {
    import game.Player;
    
    import org.flixel.FlxObject;
    import org.flixel.FlxTileblock;
    
    public class HittableBlock extends FlxTileblock {
        
        public var is_bouncing:Boolean = false;
        public var orig_x:int;
        public var orig_y:int;
        
        public const GRAVITY:int = 640;
        public const JUMP_FORCE:int = 1280;
        
        public const MAX_BOUNCE_Y:int = 16;
        
        public function HittableBlock(X:int, Y:int, Width:uint, Height:uint) {
            super(X, Y, Width, Height);
            orig_x = X;
            orig_y = Y;
            
            acceleration.y = GRAVITY;
        }
        
        public function doBounce(inertia_x:int, intertia_y:int):void {
            if( is_bouncing ) {
                return;
            }
            
            velocity.y = -Math.abs(intertia_y);
            
            // bounce everyone atop of it.
            
            y = y-1;
            
            is_bouncing = true;
        }
        
        override public function preCollide(Contact:FlxObject):void {

            /*
            if( Contact is Player ) {
                
                var p:Player = Contact as Player;
                
                if( orig_y < p.y ) {
                    p.velocity.y = 0;
                    p.y = orig_y; 
                }
            }
            */
        }
        
        public override function update():void {
            if( is_bouncing ) {
                
                if( y < orig_y - MAX_BOUNCE_Y ) {
                    y = orig_y - MAX_BOUNCE_Y;
                    velocity.y = 0;
                }
                
                if( y >= orig_y ) {
                    y = orig_y;
                    velocity.y = 0;
                    is_bouncing = false;
                }
                
                super.update();
            }   
        } 
    }
}