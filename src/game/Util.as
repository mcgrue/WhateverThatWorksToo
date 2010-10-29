package game
{
	import flash.utils.*;
	
	public class Util
	{
		public function Util()
		{
			
		}
		
		public static function instantiateClass(className:String, args:Array):* {
			var klass:Class = getDefinitionByName(className) as Class;
			// way to go adobe for creating such a great language.
			switch (args.length) {
				case 0:
					return new klass();
					break;
				case 1:
					return new klass(args[0]);
					break;
				case 2:
					return new klass(args[0], args[1]);
					break;
				case 3:
					return new klass(args[0], args[1], args[2]);
					break;
				case 4:
					return new klass(args[0], args[1], args[2], args[3]);
					break;
				case 5:
					return new klass(args[0], args[1], args[2], args[3], args[4]);
					break;
				case 6:
					return new klass(args[0], args[1], args[2], args[3], args[4], args[5]);
					break;
				default:
					throw new Error("wtf");
			}
		}
	}
}