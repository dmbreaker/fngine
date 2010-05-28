package base.modelview
{
	
	/**
	 * ...
	 * @author dmBreaker
	 */
	public class ItemsContainer
	{
		// ============================================================
		private var mItems:Array = new Array();
		// ============================================================
		public function ItemsContainer()
		{
			
		}
		// ============================================================
		internal function AddItem( item:* ):void
		{
			//var index:int = mItems.indexOf(null);
			//if( index < 0 )
			//	mItems[mItems.length] = item;
			//else
			//	mItems[index] = item;	// так нельзя, иначе после удаления объекты будут добавлсять на старые места и будут
										// ПОД контролами, а не над!
										
			mItems.push( item );
		}
		// ============================================================
		internal function RemoveItem( item:* ):void
		{
			var index:int = mItems.indexOf(item);
			if ( index >= 0 )
				mItems[index] = null;
		}
		// ============================================================
		internal function ForEach( func:Function ):void
		{
			mItems.forEach( function ( obj:*, index:int, array:Array ):void
			{
				if( obj )
				func( obj );
			} );
		}
		// ============================================================
		internal function get HasItems():Boolean
		{
			return mItems.length > 0;
		}
		// ============================================================
		internal function FindItemCompare( compare:Function ):*
		{
			var item:*;
			
			for (var i:int = 0; i < mItems.length; i++)
			{
				item = mItems[i];
				if( item )
				if ( compare( item ) )
					return item;
			}
			
			return null;
		}
		// ============================================================
		internal function FindItemCompareReverse( compare:Function ):*
		{
			var item:*;
			
			for (var i:int = mItems.length-1; i >= 0; i--)
			{
				item = mItems[i];
				if( item )
				if ( compare( item ) )
					return item;
			}
			
			return null;
		}
		// ============================================================
	}
	
}