package game {
    import game.Player;
    
    import org.flixel.FlxObject;
    import org.flixel.FlxTileblock;
    
    public class HittableBlock extends FlxTileblock {
        
        public var isBouncing:Boolean = false;
        public var originalX:int;
        public var originalY:int;
        
        public const GRAVITY:int = 900;
        public const JUMP_FORCE:int = 1100;
        
        public const MAX_BOUNCE_Y:int = 16;
        
        public function HittableBlock(X:int, Y:int, Width:uint, Height:uint) {
            super(X, Y, Width, Height);
            originalX = X;
            originalY = Y;
            
            acceleration.y = GRAVITY;
        }
        
        public function doBounce(inertiaX:int, intertiaY:int):void {
            if( isBouncing ) {
                return;
            }
            
            velocity.y = -Math.abs(intertiaY);
            
            // bounce everyone atop of it.
            
            y = y-1;
            
            isBouncing = true;
        }
        
        override public function preCollide(Contact:FlxObject):void {

            /*
            if( Contact is Player ) {
                
                var p:Player = Contact as Player;
                
                if( originalY < p.y ) {
                    p.velocity.y = 0;
                    p.y = originalY; 
                }
            }
            */
        }
        
        public override function update():void {
            if( isBouncing ) {
                
                if( y < originalY - MAX_BOUNCE_Y ) {
                    y = originalY - MAX_BOUNCE_Y;
                    velocity.y = 0;
                }
                
                if( y >= originalY ) {
                    y = originalY;
                    velocity.y = 0;
                    isBouncing = false;
                }
                
                super.update();
            }   
        } 
    }
}