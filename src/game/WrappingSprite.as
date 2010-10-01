package game {
        
    import org.flixel.FlxG;
    import org.flixel.FlxSprite;
    
    public class WrappingSprite extends FlxSprite {
        
        protected var leftBounds:int;
        protected var rightBounds:int;
        
        public var speed:int;
        
        /**
         * This is a base class for any sprite that needs to wrap around the screen when it goes out of
         * bounds. This kind of sprite watches for when it is off screen the resets it's X position to
         * the opposite site based on it's direction.
         *
         * @param X start X
         * @param Y start Y
         * @param SimpleGraphic Use for sprites with no animations
         * @param dir Direction, supports Right (1) and Left (0)
         * @param speed how many pixel sprite will move each update.
         */
        public function WrappingSprite(X:Number = 0, Y:Number = 0, dir:uint = RIGHT, speed:int = 1)
        {
            super(X, Y);
            this.leftBounds = 0;
            this.rightBounds = FlxG.width;
            
            this.speed = speed;
            
            facing = dir;
        }
        
        /**
         * This update methods analyzes the direction and x position of the instance to see if it should
         * be repositioned to the opposite side of the screen. If instance is facing right, it will restart
         * on the left of the screen. The opposite will happen for anything facing left.
         */
        override public function update():void {
            
            // Check to see if instance is out of bounds. If so, put it on the opposite side of the screen
            if (x >= (rightBounds - 4)) {
                
                x = leftBounds - (frameWidth-4);
                
            } else if (x <= (leftBounds - (frameWidth-4) )) {
                
                x = rightBounds - 4;
            }
                
            // Call update
            super.update();
        }
    }
}