package base.utils 
{
	import base.containers.AvDictionary;
	import base.types.NCell;
	import flash.geom.Point;
	/**
	 * ...
	 * @author dmbreaker
	 */
	public class ItemAttributes
	{
		// ============================================================
		private var mAttrs:AvDictionary = new AvDictionary();
		// ============================================================
		public function ItemAttributes() 
		{
			
		}
		// ============================================================
		public function GetAttr(name:String):String
		{
			var result:String = mAttrs.GetValue(name);
			if ( result )
				return result;
			else
				return "";
		}
		// ============================================================
		public function GetAttrInt(name:String):int
		{
			var result:String = GetAttr(name);
			if ( result )
				return int( result );
			else
				return int(0);
		}
		// ============================================================
		public function GetAttrNumber(name:String):Number
		{
			var result:String = GetAttr(name);
			if ( result )
				return Number( result );
			else
				return Number(0);
		}
		// ============================================================
		public function GetAttrCell(name:String):NCell
		{
			var result:String = GetAttr(name);
			if ( result )
			{
				var delim:int = result.indexOf(";");
				var c:int = int(result.substring(0, delim));
				var r:int = int(result.substring(delim + 1));
				
				return new NCell(r, c);
			}
			else
				return new NCell();
		}
		// ============================================================
		public function GetAttrPoint(name:String):Point
		{
			var result:String = GetAttr(name);
			if ( result )
			{
				var delim:int = result.indexOf(";");
				var x:int = int(result.substring(0, delim));
				var y:int = int(result.substring(delim + 1));
				
				return new Point(x, y);
			}
			else
				return new Point();
		}
		// ============================================================
		public function AddAttr(name:String, val:String):void
		{
			mAttrs.Add(name, val);
		}
		// ============================================================
		public function HasAttr(name:String):Boolean
		{
			return mAttrs.ContainsKey(name);
		}
		// ============================================================
		public function GetInternalDictionary():AvDictionary
		{
			return mAttrs;
		}
		// ============================================================
	}

}