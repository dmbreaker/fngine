package base.utils
{
	
	/**
	 * ...
	 * @author dmBreaker
	 */
	public class RandomUnique 
	{
		// ============================================================
		private var mMaxCount:int;
		private var mElements:Array;
		private var mNotUsedElements:Array;
		private var mNotUsedCount:int;
		// ============================================================
		public function RandomUnique()
		{
		}
		//////////////////////////////////////////////////////////////////////////
		//////////////////////////////////////////////////////////////////////////
		public function Init( elements:Array ):void
		{
			var count:int = elements.length;
			mMaxCount = count;
			mElements = new Array(mMaxCount);
			mNotUsedElements = new Array(mMaxCount);

			for (var i:int = 0; i < count; i++) 
			{
				mElements[i] = elements[i];
				mNotUsedElements[i] = mElements[i];
			}

			mNotUsedCount = count;
		}

		//////////////////////////////////////////////////////////////////////////
		//////////////////////////////////////////////////////////////////////////
		public function ResetState():void
		{
			var count:int = mElements.length;
			for (var i:int = 0; i < count; i++) 
			{
				mNotUsedElements[i] = mElements[i];
			}
			
			mNotUsedCount = count;
		}

		//////////////////////////////////////////////////////////////////////////
		//////////////////////////////////////////////////////////////////////////
		public function GetRandomValue():int
		{
			var index:int = int(Math.random() * mNotUsedCount + 0.5);
			return RemoveUsedIndex( index );
		}
		//////////////////////////////////////////////////////////////////////////
		//////////////////////////////////////////////////////////////////////////
		private function RemoveUsedIndex( exclude_index:int ):int
		{
			if( mNotUsedCount > 1 )
			{
				var value:int = mNotUsedElements[exclude_index];

				var i:int = exclude_index+1;
				var j:int = exclude_index;

				while( i<mNotUsedCount )
				{
					mNotUsedElements[j] = mNotUsedElements[i];
					++i;
					++j;
				}
				--mNotUsedCount;
				trace( "random: " + value + ", lst: " + mNotUsedCount );
				return value;
			}
			else
			{
				var index:int = FindIndexByValue( mNotUsedElements[exclude_index] );
				ResetState();
				return RemoveUsedIndex( index );
			}
		}

		//////////////////////////////////////////////////////////////////////////
		//////////////////////////////////////////////////////////////////////////
		private function FindIndexByValue( value:int ):int
		{
			var count:int = mElements.length;
			for (var i:int = 0; i < count; i++) 
			{
				if( mElements[i] == value )
					return i;
			}

			return -1;
		}
	}
	
}