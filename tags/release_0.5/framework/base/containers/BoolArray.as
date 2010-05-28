package base.containers
{
	import flash.utils.ByteArray;
	
	/**
	 * ...
	 * @author dmBreaker
	 */
	public class BoolArray
	{
		// ============================================================
		private var mItems:ByteArray;
		//private var :;
		private var mBitsPerElement:int;
		private var mBitToIntShift:int;
		private var mItemsCount:int;
		private var mBitsCount:int;
		
		private var mItemActiveBits:int;
		// ============================================================
		
		public function BoolArray( bits_count:int )
		{
			mBitsPerElement = 8;	// ByteArray потому что
			mBitToIntShift = 3;
			mItemActiveBits = 0xff;
			
			mBitsCount = bits_count;
			var rest:int = bits_count % mBitToIntShift;
			mItemsCount = bits_count >> mBitToIntShift;
			if ( rest > 0 )
				++mItemsCount;
			
			mItems = new ByteArray( mItemsCount );
		}
		// ============================================================
		public function SetAll( value:Boolean ):void
		{
			var mask:int;
			if ( value )
				mask = 0xff;
			else
				mask = 0;
			
			mItems.position = 0;
			for (var i:int = 0; i < mItemsCount; i++)
			{
				mItems.writeByte( mask );
			}
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
			
			mItems.position = int_index;
			var byte:int = mItems.readByte();
			mItems.position = int_index;
			
			if ( value == true )
				mItems.writeByte( byte | mask );	// устанавливаем флаг
			else
				mItems.writeByte( byte & ~mask );	// сбрасываем флаг
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
			
			mItems.position = int_index;
			var byte:int = mItems.readByte();
			
			return (byte & mask) != 0 ? true : false;
		}
		// ============================================================
		public function IndexOfTrue():int
		{
			var byte:int;
			for (var i:int = 0; i < mItemsCount; i++)
			{
				mItems.position = i;
				byte = mItems.readByte();
				
				if ( (byte & mItemActiveBits) != 0 )
				{
					return i * mBitsPerElement + BitIndexOf( byte, true );
				}
			}
			
			return -1;	// all elements are "false"
		}
		// ============================================================
		public function IndexOfFalse():int
		{
			var byte:int;
			for (var i:int = 0; i < mItemsCount; i++)
			{
				mItems.position = i;
				byte = mItems.readByte();
				
				if ( (byte & mItemActiveBits) != (0xff & mItemActiveBits) )
				{
					return i * mBitsPerElement + BitIndexOf( byte, false );
				}
			}
			
			return -1;	// all elements are "true"
		}
		// ============================================================
		private function BitIndexOf( byte:int, value:Boolean ):int
		{
			var i:int;
			if ( value )
			{
				for (i = 0; i < mBitsPerElement; i++)
				{
					if ( (byte & (1 << i)) > 0 )
						return i;
				}
			}
			else	// value == false
			{
				for (i = 0; i < mBitsPerElement; i++)
				{
					if ( (byte & (1 << i)) == 0 )
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
			var byte:int;
			var base_index:int;
			
			for (var i:int = 0; i < mItemsCount; i++)
			{
				mItems.position = i;
				byte = mItems.readByte();
				
				if ( (byte & mItemActiveBits) != 0 )	// если есть "непустые" элементы в данном "кластере"
				{
					base_index = i * mBitsPerElement;

					for (var b:int = 0; b < mBitsPerElement; b++)	// перебираем все "непустые" элементы
					{
						if ( (byte & (1 << b)) > 0 )	// если элемент "не пустой"
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