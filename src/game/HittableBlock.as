package game {
    import game.Player;
    
    import org.flixel.FlxObject;
    import org.flixel.FlxSprite;
    
    public class HittableBlock extends FlxSprite {
        
        public var isBouncing:Boolean = false;
        public var originalX:int;
        public var originalY:int;
        
        public var storedXTicks:int;
        public var storedX:int;
        
        public const GRAVITY:int = 900;
        public const JUMP_FORCE:int = 1100;
        
        public const MAX_BOUNCE_Y:int = 16;
		
		[Embed (source = "../../data/sprites/hit_block.png")] private var hittableTile:Class;
        
        public function HittableBlock(X:int, Y:int, Width:uint, Height:uint) {
            super(X, Y);
            originalX = X;
            originalY = Y;
            
            acceleration.y = 0;
            
            loadGraphic(hittableTile,true,true,16,16);
            addAnimation("idle",[0]);
            
            addAnimation("bouncy",[1,0,2],30);
            play("bouncy");
            
            storedXTicks = 0;
            
            this.fixed = true;
        }
        
        public function doBounce(inertiaX:int, intertiaY:int):void {
            if( isBouncing ) {
                //play("bouncy");
                return;
            }
            
            velocity.y = -Math.abs(intertiaY);
            this.storedX = inertiaX;
            this.storedXTicks = 2;
            // bounce everyone atop of it.
            
            y = y-1;
            
            isBouncing = true;
        }
        
        override public function preCollide(Contact:FlxObject):void {

            if( Contact is Player ) {   
                var p:Player = Contact as Player;

                if( storedXTicks > 0 ) {
                    p.velocity.x += this.storedX;
                }
                
            } else {
                this.storedX = 0;
            }
            
        }
        
        public function isDangerous():Boolean {
            return (this.storedXTicks > 0);
        }
        
        public override function update():void {
            if( isBouncing ) {
                
                if( storedXTicks > 0 ) {
                    storedXTicks--;
                }
                
                if( y < originalY - MAX_BOUNCE_Y ) {
                    y = originalY - MAX_BOUNCE_Y;
                    velocity.y = 0;
                    acceleration.y = GRAVITY;
                }
                
                if( y >= originalY ) {
                    y = originalY;
                    velocity.y = 0;
                    acceleration.y = 0;
                    isBouncing = false;
                    //play("idle");
                }
            } else {
                velocity.y = 0;
                acceleration.y = 0;
            }   
            
            super.update();
        } 
    }
}