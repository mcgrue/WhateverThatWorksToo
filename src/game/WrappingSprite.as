package game {
        
    import org.flixel.FlxG;
    import org.flixel.FlxSprite;
    
    public class WrappingSprite extends FlxSprite {
        
        protected var leftBounds:int;
        protected var rightBounds:int;
        
        public static var wrapBuffer:int = 4;
        
        public function WrappingSprite(X:Number = 0, Y:Number = 0) {
            super(X, Y);
            this.leftBounds = 0;
            this.rightBounds = FlxG.width;
        }
        
        override public function update():void {
            
            if (x >= (rightBounds - wrapBuffer)) {
                
                x = leftBounds - (frameWidth-wrapBuffer);
                
            } else if (x <= (leftBounds - (frameWidth-wrapBuffer) )) {
                
                x = rightBounds - wrapBuffer;
            }

            super.update();
        }
    }
}