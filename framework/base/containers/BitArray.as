package base.containers
{
	
	/**
	 * ...
	 * @author dmBreaker
	 */
	public class BitArray
	{
		// ============================================================
		private const BITS_IN_INT:int = 32;
		
		public static const BITS_PER_ITEM_32:int = 32;
		public static const BITS_PER_ITEM_16:int = 16;
		public static const BITS_PER_ITEM_8:int = 8;
		// ============================================================
		private var mItems:Array;
		//private var :;
		private var mBitsPerElement:int;
		private var mBitToIntShift:int;
		private var mItemsCount:int;
		private var mBitsCount:int;
		
		private var mItemActiveBits:int;
		// ============================================================
		
		public function BitArray( bits_count:int, bits_per_item:int = BITS_PER_ITEM_32 )
		{
			switch ( bits_per_item )
			{
				case BITS_PER_ITEM_32:
					mBitsPerElement = bits_per_item;
					mBitToIntShift = 5;
					mItemActiveBits = 0xffffffff;
					break;
				case BITS_PER_ITEM_16:
					mBitsPerElement = bits_per_item;
					mBitToIntShift = 4;
					mItemActiveBits = 0xffff;
					break;
				case BITS_PER_ITEM_8:
					mBitsPerElement = bits_per_item;
					mBitToIntShift = 3;
					mItemActiveBits = 0xff;
					break;
			}
			
			mBitsCount = bits_count;
			var rest:int = bits_count % mBitToIntShift;
			mItemsCount = bits_count >> mBitToIntShift;
			if ( rest > 0 )
				++mItemsCount;
			
			mItems = new Array( mItemsCount );
		}
		// ============================================================
		public function SetAll( value:Boolean ):void
		{
			var mask:int;
			if ( value )
				mask = 0xffffffff;
			else
				mask = 0;
			
			for (var i:int = 0; i < mItemsCount; i++)
				mItems[i] = mask;
		}
		// ============================================================
		public function Set( index:int, value:Boolean ):void
		{
			if ( index >= mBitsCount )
			{
				throw new Error( "Set(): Out of BitArray range" );
				return;
			}

			var rest:int = index % mBitsPerElement;
			var int_index:int = index >> mBitToIntShift;
			var mask:int = 1 << rest;	// создаем маску
			if( value == true )
				mItems[int_index] |= mask;	// устанавливаем флаг
			else
				mItems[int_index] &= ~mask;	// сбрасываем флаг
		}
		// ============================================================
		public function Get( index:int ):Boolean
		{
			if ( index >= mBitsCount )
			{
				throw new Error( "Get(): Out of BitArray range" );
				return false;
			}

			var rest:int = index % mBitsPerElement;
			var int_index:int = index >> mBitToIntShift;
			var mask:int = 1 << rest;	// создаем проверочную маску
			
			return (mItems[int_index] & mask) != 0 ? true : false;
		}
		// ============================================================
		public function IndexOfTrue():int
		{
			var item:int;
			for (var i:int = 0; i < mItemsCount; i++)
			{
				item = int(mItems[i]);
				if ( (item & mItemActiveBits) != 0 )
				{
					return i * mBitsPerElement + BitIndexOf( item, true );
				}
			}
			
			return -1;	// all elements are "false"
		}
		// ============================================================
		public function IndexOfFalse():int
		{
			var item:int;
			for (var i:int = 0; i < mItemsCount; i++)
			{
				item = int(mItems[i]);
				if ( (item & mItemActiveBits) != (0xffffffff & mItemActiveBits) )
				{
					return i * mBitsPerElement + BitIndexOf( item, false );
				}
			}
			
			return -1;	// all elements are "true"
		}
		// ============================================================
		private function BitIndexOf( item:int, value:Boolean ):int
		{
			var i:int;
			if ( value )
			{
				for (i = 0; i < mBitsPerElement; i++)
				{
					if ( (item & (1 << i)) > 0 )
						return i;
				}
			}
			else	// value == false
			{
				for (i = 0; i < mBitsPerElement; i++)
				{
					if ( (item & (1 << i)) == 0 )
						return i;
				}
			}
			
			return -1;	// impossible
		}
		// ============================================================
		//public function GetNextIndexOfTrue( index:int ):int
		//{
			//var rest:int = index % mBitsPerElement;
			//var int_index:int = index >> mBitToIntShift;
			//
			//var item:int;
			//for (var i:int = int_index; i < mItemsCount; i++)
			//{
				//item = int(mItems[i]);
				//if ( (item & mItemActiveBits) != 0 )	// есть используемые элементы
				//{
					//return i * mBitsPerElement + BitIndexOf( item, true );
				//}
			//}
			//
			//return -1;	// all elements are "false"
		//}
		// ============================================================
		//public function GetNextIndexOfFalse( index:int ):int
		//{
			//var rest:int = index % mBitsPerElement;
			//var int_index:int = index >> mBitToIntShift;
			//
			//var item:int;
			//for (var i:int = int_index; i < mItemsCount; i++)
			//{
				//item = int(mItems[i]);
				//if ( (item & mItemActiveBits) != (0xffffffff & mItemActiveBits) )	// если не все элементы использованы
				//{
					//return i * mBitsPerElement + BitIndexOf( item, false );
				//}
			//}
			//
			//return -1;	// all elements are "false"
		//}
		// ============================================================
		// func - function( index:int )
		public function ForEachTrue( func:Function ):void
		{
			var item:int;
			var base_index:int;
			
			for (var i:int = 0; i < mItemsCount; i++)
			{
				item = int(mItems[i]);
				if ( (item & mItemActiveBits) != 0 )	// если есть "непустые" элементы в данном "кластере"
				{
					base_index = i * mBitsPerElement;

					for (var b:int = 0; b < mBitsPerElement; b++)	// перебираем все "непустые" элементы
					{
						if ( (item & (1 << b)) > 0 )	// если элемент "не пустой"
						{
							func( base_index + b );
						}
					}
				}
			}
		}
		// ============================================================
	}
	
}