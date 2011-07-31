package base.containers
{
	
	/**
	 * ...
	 * @author dmBreaker
	 */
	public class SearchFreeSlotContainer
	{
		// ============================================================
		protected var mObjectsMaxCount:int;
		protected var mObjects:Array = null;
		protected var mObjectsUsed:BitArray = null;
		// ============================================================
		public function SearchFreeSlotContainer(size:int)
		{
			Reinit( size );
		}
		// ============================================================
		private function Reinit( count:int ):void
		{
			mObjectsMaxCount = count;
			mObjectsUsed = new BitArray( count, BitArray.BITS_PER_ITEM_8 );

			mObjects = new Array( count );
			mObjectsUsed.SetAll( false );
		}
		// ============================================================
		public function ForEach( func:Function ):void
		{
			var obj:*;
			mObjectsUsed.ForEachTrue( function ( index:int ):void
			{
				func( mObjects[index], index );
			} );
		}
		// ============================================================
		public function RemoveAll():void
		{
			mObjects.length = 0;
			mObjects = new Array( mObjectsMaxCount );
			mObjectsUsed.SetAll( false );
		}
		// ============================================================
		public function Add( obj:* ):void
		{
			var index:int = mObjectsUsed.IndexOfFalse();
			if ( index != -1 )
			{
				mObjectsUsed.Set( index, true );
				mObjects[index] = obj;
			}
			else
				throw new Error( "No free slots in SearchUsedContainer" );
		}
		// ============================================================
		protected function ResetAt( index:int ):void
		{
			mObjects[index] = null;
			mObjectsUsed.Set( index, false );
		}
		// ============================================================
	}
	
}