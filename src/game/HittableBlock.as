package game {
    import org.flixel.FlxTileblock;
    
    public class HittableBlock extends FlxTileblock {
        public function HittableBlock(X:int, Y:int, Width:uint, Height:uint) {
            super(X, Y, Width, Height);
        }
    }
}