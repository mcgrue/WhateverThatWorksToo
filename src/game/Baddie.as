package game {
    import org.flixel.FlxObject;
    import org.flixel.FlxPoint;
    import org.flixel.FlxSprite;
    
    public class Baddie extends WrappingSprite {
        
        [Embed (source = "../../data/sprites/players.png")] private var playerSpritesheet:Class;
        
        private var _flip:Boolean;
        
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
        
        public function isFlipped():Boolean {
            return this._flip;
        }
        
        public function flip():void {
            this._flip = true;
            this.scale = new FlxPoint(1,-1);
        }
        
        public function die(): void {
            this.kill();
        }
        
        override public function preCollide(Contact:FlxObject):void {
            
            if( Contact is HittableBlock ) {
                
                var hb:HittableBlock = Contact as HittableBlock;
                
                if( hb.isDangerous() && !this.isFlipped() ) {
                    this.flip();
                }
            } else if( Contact is Player ) {
                if( this.isFlipped() ) {
                    this.die();
                } else {
                    var player:Player = Contact as Player;
                    player.die();
                }
                
            } else if( Contact is Baddie ) {
                
            }
            
            super.preCollide(Contact);
        }
        
    }
    
}