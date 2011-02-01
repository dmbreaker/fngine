package base.utils.settings 
{
	import base.core.NCore;
	/**
	 * ...
	 * @author dmbreaker
	 */
	public class NSerializer 
	{
		// ============================================================
		// ============================================================
		private var mParts:Array = new Array();
		private var mCurIndex:int = 0;
		private var mHeaders:Vector.<int> = new Vector.<int>();
		private var mHasDeserializationData:Boolean = false;
		// ============================================================
		// ============================================================
		public function NSerializer() 
		{
			
		}
		// ============================================================
		// ============================================================
		public function Clear():void
		{
			mParts.length = 0;
			mHeaders.length = 0;
			mCurIndex = 0;
			mHasDeserializationData = false;
		}
		// ============================================================
		public function PushClass(name:String):void 
		{
			mParts.push("Class:" + name);
			
			mHeaders.push(0);
		}
		// ============================================================
		public function PushInt(val:int):void 
		{
			mParts.push(val.toString());
			IncrementHead();
		}
		// ============================================================
		public function PushString(val:String):void 
		{
			mParts.push(val);
			IncrementHead();
		}
		// ============================================================
		public function PushBool(val:Boolean):void 
		{
			mParts.push(val.toString());
			IncrementHead();
		}
		// ============================================================
		public function PushNumber(val:Number):void 
		{
			mParts.push(val.toString());
			IncrementHead();
		}
		// ============================================================
		public function PushCompleteClass():void 
		{
			mParts.push("FieldsCount:" + GetHead().toString());
			RemoveHead();
		}
		// ============================================================
		// ============================================================
		private function IncrementHead():void
		{
			var index:int = mHeaders.length - 1;
			mHeaders[index] = int(mHeaders[index]) + 1;
		}
		// ============================================================
		private function RemoveHead():void 
		{
			mHeaders.pop();
		}
		// ============================================================
		private function GetHead():int
		{
			var index:int = mHeaders.length - 1;
			return mHeaders[index];
		}
		// ============================================================
		// ============================================================
		public function PopClass( name:String ):void
		{
			var str:String = GetNextString();
			var ar:Array = str.split(":");
			if ( ar.length != 2 || ar[0] != "Class" || ar[1] != name )
				trace("Wrong class '" + name + "', current data: '" + str + "'");
				
			mHeaders.push(0);
		}
		// ============================================================
		public function PopString():String
		{
			IncrementHead();
			return GetNextString();
		}
		// ============================================================
		public function PopInt():int
		{
			IncrementHead();
			return int(GetNextString());
		}
		// ============================================================
		public function PopNumber():Number
		{
			IncrementHead();
			return Number(GetNextString());
		}
		// ============================================================
		public function PopCompleteClass():void 
		{
			var str:String = GetNextString();
			var ar:Array = str.split(":");
			if ( ar.length != 2 || ar[0] != "FieldsCount" || int(ar[1]) != GetHead() )
				trace("Wrong fields count, current data: '" + str + "'");
			else
			{
				RemoveHead();
			}
		}
		// ============================================================
		// ============================================================
		private function GetNextString():String
		{
			if ( mCurIndex < mParts.length )
			{
				var next:String = mParts[mCurIndex];
				IncrementIndex();
				return next;
			}
			else
				return "__NONE__";
		}
		// ============================================================
		private function IncrementIndex():void
		{
			++mCurIndex;
		}
		// ============================================================
		// ============================================================
		public function DeserializeFrom( source:String ):void 
		{
			mCurIndex = 0;
			mParts = source.split("|");
			
			mHasDeserializationData = true;
		}
		// ============================================================
		// ============================================================
		public function Serialize():String
		{
			var result:String = "";
			
			var count:int = mParts.length;
			for (var i:int = 0; i < count; i++) 
			{
				var part:String = mParts[i];
				if ( i > 0 )
					result += "|";
					
				result += part;
			}
			
			return result;
		}
		// ============================================================
		// ============================================================
		// ============================================================
		public function get HasDeserializationData():Boolean
		{
			return mHasDeserializationData;
		}
		// ============================================================
		public function SaveData( name:String ):void
		{
			NCore.Saver.Save(name, Serialize());
		}
		// ============================================================
		public function LoadData( name:String ):void
		{
			var data:String = NCore.Saver.Get(name);
			if ( data )
			{
				Clear();
				DeserializeFrom( data );
			}
		}
		// ============================================================
	}

}