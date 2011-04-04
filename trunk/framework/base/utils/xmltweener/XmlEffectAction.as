package base.utils.xmltweener 
{
	import base.containers.AvDictionary;
	/**
	 * 'action' in XML
	 * @author dmbreaker
	 */
	public class XmlEffectAction
	{
		// ============================================================
		// ============================================================
		// enum eType
		public static const TypeMove:int = 0;
		public static const TypeCycle:int = 1;
		public static const TypePingpong:int = 2;
		public static const TypeWait:int = 3;
		public static const TypeSet:int = 4;
		public static const TypeSetImage:int = 5;
		public static const TypeSpline:int = 6;		// не реализовано

		// enum eParams
		public static const ParamX:int = 0;
		public static const ParamY:int = 1;
		public static const ParamAlpha:int = 2;
		public static const ParamScaleX:int = 3;
		public static const ParamScaleY:int = 4;
		public static const ParamAngle:int = 5;
		public static const Param1:int = 6;
		public static const Param2:int = 7;
		public static const Param3:int = 8;
		public static const Param4:int = 9;
		// ============================================================
		public static const ET_LINEAR:int = 0;
		public static const ET_SINE:int = 1;
		public static const ET_QUINT:int = 2;
		public static const ET_QUART:int = 3;
		public static const ET_QUAD:int = 4;
		public static const ET_EXPO:int = 5;
		public static const ET_ELASTIC:int = 6;
		public static const ET_CUBIC:int = 7;
		public static const ET_CIRC:int = 8;
		public static const ET_BOUNCE:int = 9;
		public static const ET_BACK:int = 10;
		// ============================================================
		public static const EST_EASE_IN:int = 0;
		public static const EST_EASE_OUT:int = 1;
		public static const EST_EASE_IN_OUT:int = 2;
		// ============================================================
		// ============================================================
		public var ID:String = "";
		public var Type:int = -1;			// eType
		public var EasingFunc:int = -1;		// linear, bounce, sine, ...
		public var EasingSubType:int = -1;	// in, out, inout
		public var Time:Number = 0;
		public var To:String = "";		// для других типов команд, вроде setimage

		public var FromValues:Vector.<Number> = new Vector.<Number>();
		public var ToValues:Vector.<Number> = new Vector.<Number>();
		public var Params:Vector.<String> = new Vector.<String>();	// изменяемые параметры
		public var ParamsDict:AvDictionary = new AvDictionary();	// изменяемые параметры
		// ============================================================
		// ============================================================
		public function XmlEffectAction() 
		{
			Time = 0;
			EasingFunc = ET_LINEAR;
			EasingSubType = EST_EASE_IN_OUT;
			Type = TypeMove;
		}
		// ============================================================
		// ============================================================
		protected function StringToType( type:String ):int
		{
			if( type == "move" )
				return TypeMove;
			else if( type == "cycle" )
				return TypeCycle;
			else if( type == "pingpong" )
				return TypePingpong;
			else if( type == "wait" )
				return TypeWait;
			else if( type == "set" )
				return TypeSet;
			else if( type == "setimage" )
				return TypeSetImage;
			else if( type == "spline" )
				return TypeSpline;

			return TypeMove;
		}
		// ============================================================
		protected function StringToEasingType( type:String ):int
		{
			if( type == "linear" )
				return ET_LINEAR;
			else if( type == "sine" )
				return ET_SINE;
			else if( type == "quint" )
				return ET_QUINT;
			else if( type == "quart" )
				return ET_QUART;
			else if( type == "quad" )
				return ET_QUAD;
			else if( type == "expo" )
				return ET_EXPO;
			else if( type == "elastic" )
				return ET_ELASTIC;
			else if( type == "cubic" )
				return ET_CUBIC;
			else if( type == "circ" )
				return ET_CIRC;
			else if( type == "bounce" )
				return ET_BOUNCE;
			else if( type == "back" )
				return ET_BACK;

			return ET_LINEAR;
		}
		// ============================================================
		protected function StringToEasingSubType( subtype:String ):int
		{
			if( subtype == "in" )
				return EST_EASE_IN;
			else if( subtype == "out" )
				return EST_EASE_OUT;
			if( subtype == "inout" )
				return EST_EASE_IN_OUT;

			return EST_EASE_IN;
		}
		// ============================================================
		protected function ParseVector( vect:String, theVector:Vector.<Number> ):void
		{
			theVector.length = 0;

			var aPos:int = 0;

			while (true)
			{
				var str:String = vect.substring(aPos);
				var commaPos:int = str.indexOf(",");
				if( commaPos != -1 )
					str = str.substring( 0, commaPos );

				var f:Number = 0;
				f = Number(str);

				theVector.push( f );
				aPos = vect.indexOf(",", aPos);
				if(aPos == -1)
					break;

				++aPos;
			}
		}
		// ============================================================
		protected function ParseStringsVector( vect:String, theVector:Vector.<String> ):void
		{
			theVector.length = 0;

			var aPos:int = 0;

			while (true)
			{
				var str:String = vect.substring(aPos);
				var commaPos:int = str.indexOf(",");
				if( commaPos != -1 )
					str = str.substring( 0, commaPos );
				theVector.push( str );
				aPos = vect.indexOf(",", aPos);
				if(aPos == -1)
					break;

				++aPos;
			}
			
			// приведем названия параметров к правильным:
			var count:int = theVector.length;
			for (var i:int = 0; i < count; i++) 
			{
				var result:String = "";
				var val:String = theVector[i];
				if ( val == "x" )
					result = "X";
				else if ( val == "y" )
					result = "Y";
				else if ( val == "alpha" )
					result = "Alpha";
				else if ( val == "scalex" )
					result = "ScaleX";
				else if ( val == "scaley" )
					result = "ScaleY";
				else if ( val == "angle" )
					result = "Angle";
				else if ( val == "param1" )
					result = "Param1";
				else if ( val == "param2" )
					result = "Param2";
				else if ( val == "param3" )
					result = "Param3";
				else if ( val == "param4" )
					result = "Param4";
				
				theVector[i] = result;
			}
		}
		// ============================================================
		public function Parse( node:XML ):void
		{
			Params.length = 0;
			FromValues.length = 0;
			ToValues.length = 0;

			ID = node.@id;

			var type:String = node.@type;
			var params:String = node.@params;
			var from:String = node.@from;
			var to:String = node.@to;
			var time:String = node.@time;

			// easing:
			var easing:XMLList = node.easing;
			var easing_type:String = easing.@type;
			var easing_subtype:String = easing.@subtype;

			Type = StringToType( type );

			var f:Number = Number(time);
			Time = f;
			
			EasingFunc = StringToEasingType( easing_type );
			EasingSubType = StringToEasingSubType( easing_subtype );

			if( params.length > 0 )
				ParseStringsVector( params, Params );
			if( from.length > 0 )
				ParseVector( from, FromValues );
			if( to.length > 0 )
			{
				if( Type == TypeSetImage )
				{
					To = to;
				}
				else
				{
					ParseVector( to, ToValues );
				}
			}
		}
		// ============================================================
		public function SetFromParam( param:String, value:Number ):void
		{
			var count:int = Params.length;
			for( var i:int=0; i<count; i++ )
			{
				if( param == Params[i] )
				{
					FromValues[i] = value;
					return;
				}
			}
		}
		// ============================================================
		public function SetToParam( param:String, value:Number ):void
		{
			var count:int = Params.length;
			for( var i:int=0; i<count; i++ )
			{
				if( param == Params[i] )
				{
					ToValues[i] = value;
					return;
				}
			}
		}
		// ============================================================
		// ============================================================
		// ============================================================
		// ============================================================
		// ============================================================
		// ============================================================
		// ============================================================
		// ============================================================
	}

}