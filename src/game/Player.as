package game {
    
    import org.flixel.*;
    
    public class Player extends WrappingSprite {
        [Embed (source = "../../data/sprites/players.png")] private var playerSpritesheet:Class;
        
        public const MOVE_SPEED:int = 100;
        public const RUN_ACCEL:int = 700;
        public const RUN_DRAG:int = 300;
        
        public const GRAVITY:int = 900;
        public const JUMP_FORCE:int = 1100;
        
        public const JUMP_HOLD_FORCE:int = 150;
        public const MAX_VELOCITY:int = 320;
        
        public const IMPACT_MULTIPLIER:Number = 2; 
        
        public var playerIndex:int; 
        
        public var controls:Object = {
            1:{left:'LEFT', right:'RIGHT', up:'UP'},
            3:{left:'A', right:'D', up:'W'}
        };
        
        public function Player(X:Number=0, Y:Number=0, P:Number=1) {
            super(X, Y);
            loadGraphic( 
                playerSpritesheet, 
                true, true,
                16, 16
            );
            
            playerIndex = P;
            
            var f1:Number = {1:0, 2:2, 3:4, 4:6}[P];
            var f2:Number = (f1+1);
            
            addAnimation("idle", [f1, f2], 2);
            addAnimation("run", [f1, f2], 6);
            addAnimation("jump", [f2]);
            
            maxVelocity.y = MAX_VELOCITY;
            maxVelocity.x = MAX_VELOCITY;
            acceleration.y = GRAVITY;
        }
        
        public function die(): void {
            this.kill()
        }
        
        public function doInput(p:Number): void {
                        
            if( FlxG.keys.pressed(controls[p].left) ) {
                acceleration.x = -RUN_ACCEL;
                drag.x = 0;
            } else if ( FlxG.keys.pressed(controls[p].right) ) {
                acceleration.x = RUN_ACCEL;
                drag.x = 0;
            } else {
                acceleration.x = 0;
                drag.x = RUN_DRAG;
            }
            
            // If you're moving too quickly, stop accelerating
            if (velocity.x <= - MOVE_SPEED) {
                acceleration.x = Math.max(0, acceleration.x);
            } else if (velocity.x >= MOVE_SPEED) {
                acceleration.x = Math.min(0, acceleration.x);
            }
            
            // Jump
            if( FlxG.keys.justPressed(controls[p].up) && onFloor ) {
                velocity.y = - JUMP_FORCE;
            }
            
            // If you hold jump in the air, keep pushing him up a bit to have mario-style jumping
            if( FlxG.keys.pressed(controls[p].up) && velocity.y < 0 ) {
                velocity.y -= JUMP_HOLD_FORCE * FlxG.elapsed;
            }
            
            if( velocity.y > MAX_VELOCITY ) {
                velocity.y = MAX_VELOCITY;
            } else if( velocity.y < -MAX_VELOCITY ) {
                velocity.y = -MAX_VELOCITY;
            } 
            
            if( velocity.x > MAX_VELOCITY ) {
                velocity.x = MAX_VELOCITY;
            } else if( velocity.x < -MAX_VELOCITY ) {
                velocity.x = -MAX_VELOCITY;
            } 
        }
        
        public function doAnimation(p:Number): void {
            if( FlxG.keys.pressed(controls[p].left) ) {
                facing = LEFT;
            } else if( FlxG.keys.pressed(controls[p].right) ) {
                facing = RIGHT;
            }
            
            if (onFloor) {
                
                if( FlxG.keys.pressed(controls[p].left) || FlxG.keys.pressed(controls[p].right) ) {
                    play("run");
                } else {
                    play("idle");
                }
                
            } else {
                play("jump");
            }
        }
        
        override public function update(): void {
            doInput(playerIndex);
            doAnimation(playerIndex);
            super.update();
        }
        
        override public function preCollide(Contact:FlxObject):void {
            
            if( Contact is HittableBlock ) {
                
                var hb:HittableBlock = Contact as HittableBlock;
                
                if( y > (hb.originalY) && y <= (hb.originalY+16) ) {
                    hb.doBounce( velocity.x, velocity.y );
                    y = hb.originalY+16;
                    velocity.y = 0;
                }
                
            } else if( Contact is Player ) {
                Contact.velocity.x = -(Contact.velocity.x*IMPACT_MULTIPLIER);
                Contact.velocity.y = -(Contact.velocity.y*IMPACT_MULTIPLIER);
                this.velocity.x = -(this.velocity.x*IMPACT_MULTIPLIER);
                this.velocity.y = -(this.velocity.y*IMPACT_MULTIPLIER);
            }
            
            super.preCollide(Contact);
        }
    }
}