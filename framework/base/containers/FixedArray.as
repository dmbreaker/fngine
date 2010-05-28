package base.containers
{
	
	/**
	 * ...
	 * @author dmBreaker
	 */
	public class FixedArray
	{
		private var mArray:Array = null;
		public var Length:int = 0;
		public var MaxLength:int = 0;
		// ============================================================
		public function FixedArray( presize:int )
		{
			MaxLength = presize;
			mArray = new Array( presize );
			Clear();
		}
		// ============================================================
		public function Get( i:int ):*
		{
			if ( i >= Length )
				return null;
			return mArray[i];
		}
		// ============================================================
		public function Push( obj:* ):void
		{
			if ( Length >= MaxLength )
				return;
			mArray[Length] = obj;
			++Length;
		}
		// ============================================================
		public function Clear():void
		{
			for (var i:int = 0; i < MaxLength; i++)
			{
				mArray[i] = null;
			}
			Length = 0;
		}
		// ============================================================
		public function NullateAll():void
		{
			for (var i:int = 0; i < MaxLength; i++)
			{
				mArray[i] = null;
			}
			Length = MaxLength;
		}
		// ============================================================
		public function Set( i:int, obj:* ):void
		{
			if ( i < MaxLength )
			{
				if ( i >= Length )
				{
					Length = i + 1;
					mArray[i] = obj;
				}
			}
		}
		// ============================================================
	}
	
}