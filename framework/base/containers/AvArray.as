package base.containers 
{
	/**
	 * ...
	 * @author dmbreaker
	 */
	public class AvArray extends Array
	{
		// ============================================================
		// ============================================================
		public function AvArray() 
		{
			var arr:Array = [];
			arr.length
		}
		// ============================================================
		public function get Size():int
		{
			return length;
		}
		// ============================================================
		public function set Size( value:int ):void
		{
			length = value;
		}
		// ============================================================
		public function Clear():void 
		{
			length = 0;
		}
		// ============================================================
		public function Add( item:* ):void 
		{
			push( item );
		}
		// ============================================================
		public function CloneFrom( arr:AvArray ):void 
		{
			Clear();
			this.splice(0, 0, arr);
		}
		// ============================================================
		public function CloneFormArray( arr:Array ):void 
		{
			Clear();
			this.splice(0, 0, arr);
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
				this[i] = value;
			}
		}
		// ============================================================
		public function SetAt( index:int, value:* ):void
		{
			this[index] = value;
		}
		// ============================================================
		public function GetAt( index:int ):*
		{
			return this[index];
		}
		// ============================================================
	}

}