package base.containers
{
	
	/**
	 * Список, позволяющий удалять свои элементы.
	 * Однопоточный. (Следить, чтобы в подметодах не производилось каких либо работ с этим списком)
	 * Список медленный!
	 * @author dmBreaker
	 */
	public class RemovableArray
	{
		private var mArray:Array = null;
		private var mCurrentIndex:int = -1;
		
		public function RemovableArray()
		{
			mArray = new Array();
		}
		// ============================================================
		public function Get( i:int ):*
		{
			return mArray[i];
		}
		// ============================================================
		public function Push( obj:* ):void
		{
			mArray.push( obj );
		}
		// ============================================================
		public function Clear():void
		{
			mArray = new Array();
		}
		// ============================================================
		public function RemoveCurrent():void
		{
			if ( mCurrentIndex < 0 )
				return;
			mArray[mCurrentIndex] = null;
			mArray = mArray.filter( function (obj:*, index:int, array:Array):Boolean { return obj != null; }, this );
			--mCurrentIndex;	// даже если будет -1 - не страшно
		}
		// ============================================================
		public function GetFirst():*
		{
			mCurrentIndex = 0;
			return mArray[mCurrentIndex];
		}
		// ============================================================
		public function GetNext():*
		{
			++mCurrentIndex;
			if ( mCurrentIndex >= mArray.length )
				return null;
			return mArray[mCurrentIndex];
		}
		// ============================================================
		public function GetCurrent():*
		{
			if ( mCurrentIndex < 0 )
				return null;	// объект не выбран
			return mArray[mCurrentIndex];
		}
		// ============================================================
		public function ForEach( func:Function ):void
		{
			mArray.forEach( function (obj:*, index:int, array:Array):void
			{
				func( obj );
			} );
		}
		// ============================================================
		public function ForEachReverse( func:Function ):void
		{
			for (var i:int = mArray.length-1; i >= 0; i--)
			{
				func( mArray[i] );
			}
		}
		// ============================================================
	}
	
}