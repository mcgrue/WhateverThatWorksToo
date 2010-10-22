package game {
    import org.flixel.FlxSprite;
    import org.flixel.FlxObject;
    
    public class Baddie extends WrappingSprite {
        
        [Embed (source = "../../data/sprites/players.png")] private var playerSpritesheet:Class;
        
        public function Baddie(X:Number=0, Y:Number=0, SimpleGraphic:Class=null) {
            super(X, Y);
            loadGraphic( 
                playerSpritesheet, 
                true, true,
                16, 16
            );
            
            addAnimation("idle", [6,7], 2);
            addAnimation("run", [6,7], 6);
            addAnimation("jump", [7]);
            
            velocity.x = -20;
            acceleration.y = 100;
            
            play("run");
        }
        
        override public function update(): void {
            super.update();
        }
        
        override public function preCollide(Contact:FlxObject):void {
            
            if( Contact is HittableBlock ) {
                
            } else if( Contact is Player ) {
                
            } else if( Contact is Baddie ) {
                
            }
            
            super.preCollide(Contact);
        }
        
    }
    
}