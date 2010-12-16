package base.containers 
{
	/**
	 * ...
	 * @author dmbreaker
	 */
	public class AvArray extends Array
	{
		// ============================================================
		protected var mArr:Array = new Array();
		// ============================================================
		public function AvArray() 
		{
			mArr.length = 0;
		}
		// ============================================================
		public function get Size():int
		{
			return mArr.length;
		}
		// ============================================================
		public function set Size( value:int ):void
		{
			mArr.length = value;
		}
		// ============================================================
		public function Clear():void 
		{
			mArr.length = 0;
		}
		// ============================================================
		public function Add( item:* ):void 
		{
			mArr.push( item );
		}
		// ============================================================
		public function CloneFrom( arr:AvArray ):void 
		{
			Clear();
			mArr.splice(0, 0, arr.GetInternalArray());
		}
		// ============================================================
		public function CloneFromArray( arr:Array ):void 
		{
			Clear();
			mArr.splice(0, 0, arr);
		}
		// ============================================================
		internal function GetInternalArray():Array
		{
			return mArr;
		}
		// ============================================================
		public function GetClone():AvArray
		{
			var newArray:AvArray = new AvArray();
			newArray.CloneFrom( this );
			return newArray;
		}
		// ============================================================
		public function SetAll( value:* ):void 
		{
			var count:int = Size;
			for (var i:int = 0; i < count; i++) 
			{
				mArr[i] = value;
			}
		}
		// ============================================================
		public function SetAt( index:int, value:* ):void
		{
			mArr[index] = value;
		}
		// ============================================================
		public function GetAt( index:int ):*
		{
			return mArr[index];
		}
		// ============================================================
	}

}