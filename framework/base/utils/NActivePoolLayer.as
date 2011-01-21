package base.utils 
{
	/**
	 * ...
	 * @author dmbreaker
	 */
	public class NActivePoolLayer 
	{
		// ============================================================
		// ============================================================
		private var mSafeAdd:Vector.<IActiveItem> = new Vector.<IActiveItem>();
		private var mItems:Vector.<IActiveItem> = new Vector.<IActiveItem>();
		// ============================================================
		// ============================================================
		public function NActivePoolLayer() 
		{
			
		}
		// ============================================================
		public function RemoveItems():void
		{
			var i:int;
			var count:int = mItems.length;
			for( i=0; i<count; i++ )
			{
				var item:IActiveItem = mItems[i];
				if( item )
					item.DisposeItem();
			}
			mItems.length = 0;

			// на всякий случай почистим и этот список:
			count = mSafeAdd.length;
			for( i=0; i<count; i++ )
			{
				var item:IActiveItem = mSafeAdd[i];
				if( item )
					item.DisposeItem();
			}
			mSafeAdd.length = 0;
		}
		// ============================================================
		public function Update( ms:int ):void
		{
			var i:int;
			var safe_count:int = mSafeAdd.length;
			if( safe_count )		// добавим новые итемы
			{
				for( i=0; i<safe_count; i++ )
					AddItemUnsafe( mSafeAdd[i] );
				mSafeAdd.length = 0;
			}

			var count:int = mItems.length;
			for( i=0; i<count; i++ )
			{
				var item:IActiveItem = mItems[i];
				if( item )
				{
					if( item.IsStarted() )
						item.UpdateItem( ms );
					else
					{
						item.DisposeItem();
						mItems[i] = null;
					}
				}
			}
		}
		// ============================================================
		public function Draw( g:BitmapGraphix ):void
		{
			var i:int;
			var count:int = mItems.length;
			for( i=0; i<count; i++ )
			{
				var item:IActiveItem = mItems[i];
				if( item && item.IsActiveItem )
					item.Draw(g);
			}
		}
		// ============================================================
		public function AddItem( mitem:IActiveItem ):void
		{
			var i:int;
			var count:int = mItems.length;
			for( i=0; i<count; i++ )
			{
				var item:IActiveItem = mItems[i];
				if( !item )	// если есть свободные позиции, то добавим сразу
				{
					mItems[i] = mitem;
					return;
				}
			}

			mSafeAdd.push( mitem );	// иначе поместим в список на безопасное добавление
		}
		// ============================================================
		public function HasStarted():Boolean
		{
			var i:int;
			var count:int = mItems.length;
			for( i=0; i<count; i++ )
			{
				var item:IActiveItem = mItems[i];
				if( item && item.IsActiveItem )
					return true;
			}

			return false;
		}

		// ============================================================
		protected function AddItemUnsafe( mitem:IActiveItem ):void
		{
			var i:int;
			var count:int = mItems.length;
			for( i=0; i<count; i++ )
			{
				var item:IActiveItem = mItems[i];
				if( !item )
				{
					mItems[i] = mitem;
					return;
				}
			}

			mItems.push( mitem );
		}
		// ============================================================
		// ============================================================
	}

}