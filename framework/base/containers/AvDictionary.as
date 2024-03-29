package base.containers 
{
	import flash.utils.Dictionary;
	/**
	 * ...
	 * @author dmbreaker
	 */
	public class AvDictionary
	{
		// ============================================================
		protected var Data:Dictionary = new Dictionary();
		/// as3.collections.core.TypedDictionary
		// ============================================================
		public function AvDictionary() 
		{
			
		}
		// ============================================================
		/*public function SetType( type:Class ):void 
		{
			
		}*/
		// ============================================================
		// ============================================================
		public function Clear():void
		{
			Data = new Dictionary();
		}
		// ============================================================
		public function Add( key:*, value:* ):void 
		{
			Data[key] = value;
		}
		// ============================================================
		public function ContainsKey( key:* ):Boolean
		{
			return Data[key] != undefined;
		}
		// ============================================================
		public function GetData():Dictionary
		{
			return Data;
		}
		// ============================================================
		public function Remove(key:*):void
		{
			//if ( ContainsKey(key) )
			Data[key] = undefined;
		}
		// ============================================================
		public function CloneFrom( d:AvDictionary ):void
		{
			Clear();
			var src:Dictionary = d.GetData();
			for ( var key:Object in src )
			{
				Data[key] = src[key];
			}
		}
		// ============================================================
		public function ApplyFrom( d:AvDictionary ):void
		{
			var src:Dictionary = d.GetData();
			for ( var key:Object in src )
			{
				if( src[key] )
					Data[key] = src[key];
			}
		}
		// ============================================================
		/*public function TryGetValue(value:*, result):Boolean
		{
			
		}*/
		// ============================================================
		public function GetValue( id:* ):*
		{
			return Data[id];
		}
		// ============================================================
		public function SetValue( id:*, value:* ):void
		{
			Data[id] = value;
		}
		// ============================================================
		public function Size():int
		{
			return Data.length;
		}
		// ============================================================
	}

}