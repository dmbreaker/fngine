package base.utils
{
	public class Random
	{
		private static var seed: uint = 0xfefe;
		
		public function Random()
		{
		}
		
		public static function SetSeed( _seed:uint ):void
		{
			seed = _seed;
		}
		
		public static function getNumber( min: Number = 0, max: Number = 1 ): Number
		{
			return Math.random() * (max - min) + min;
			//var next:uint = getNextInt();
			//trace( "getNextInt(): " + next, min, max );
			//return min + getNextInt() / 0xf7777777 * ( max - min );
			//return min + next / 0xf7777777 * ( max - min );
		}
		
		private static function getNextInt(): uint
		{
			var lo: uint = 16807 * ( seed & 0xffff );
			var hi: uint = 16807 * ( seed >> 16 );
			
			lo += ( hi & 0x7fff ) << 16;
			lo += hi >> 15;
			
			if( lo > 0xf7777777 ) lo -= 0xf7777777;
			
			return seed = lo;
		}
	}
}