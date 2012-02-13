package base.types
{
	// готов
	import flash.geom.Point;
	

	public final class NPoint extends Point
	{
		// ============================================================
		public function NPoint( _x:Number = 0, _y:Number = 0 )
		{
			x = _x;
			y = _y;
		}
		// ============================================================
		public final function IntX():int
		{
			return int(x);
		}
		// ============================================================
		public final function IntY():int
		{
			return int(y);
		}
		// ============================================================
		public function Init( nx:Number, ny:Number ):void
		{
			x = nx;
			y = ny;
		}
		// ============================================================
		public function Reset():void
		{
			x = 0;
			y = 0;
		}
		// ============================================================
		public function CopyFrom( point:Point ):void
		{
			x = point.x;
			y = point.y;
		}
		// ============================================================
		public function CopyMulFrom( point:Point, mul:Number ):void
		{
			x = point.x * mul;
			y = point.y * mul;
		}
		// ============================================================
		public function SetPolar( value:Number, angle:Number ):void
		{
			x = value * Math.cos( angle );	// TODO: заменить быстрыми аппроксимациями
			y = value * Math.sin( angle );
		}
		// ============================================================
		public function Clone():NPoint
		{
			var pnt:NPoint = new NPoint();
			pnt.CopyFrom( this );
			return pnt;
		}
		// ============================================================
		public function CalcLength():Number
		{
			return Math.sqrt( x * x + y * y );
		}
		// ============================================================
		public function CalcSquareLength():Number
		{
			return ( x * x + y * y );
		}
		// ============================================================
		public function CopyMovedByVector( pos:NPoint, vec:NVec, vecMultiplier:Number ):void
		{
			x = pos.x + vec.x * vecMultiplier;
			y = pos.y + vec.y * vecMultiplier;
		}
		// ============================================================
		public function CalcDistanceTo( point:NPoint ):Number
		{
			return CalcXYLength( x - point.x, y - point.y );
		}
		// ============================================================
		public function CalcSquareDistanceTo( point:NPoint ):Number
		{
			return CalcXYSquareLength( x - point.x, y - point.y );
		}
		// ============================================================
		public function CopySubtraction( point:NPoint, minusPoint:NPoint ):void 
		{
			x = point.x - minusPoint.x;
			y = point.y - minusPoint.y;
		}
		// ============================================================
		public function CopyAddition( point:NPoint, plusPoint:NPoint ):void 
		{
			x = point.x + plusPoint.x;
			y = point.y + plusPoint.y;
		}
		// ============================================================
		public function CopyLeftNormal( point:NPoint ):void 
		{
			x = -point.y;
			y = point.x;
		}
		// ============================================================
		public function CopyRightNormal( point:NPoint ):void 
		{
			x = point.y;
			y = -point.x;
		}
		// ============================================================
		public function Add( point:NPoint ):void 
		{
			x += point.x;
			y += point.y;
		}
		// ============================================================
		public function Sub( point:NPoint ):void 
		{
			x -= point.x;
			y -= point.y;
		}
		// ============================================================
		// скалярное произведение:
		public function DotProduct( secondVec:NPoint ):Number
		{
			return x * secondVec.x + y * secondVec.y;
		}
		// ============================================================
		// скалярное произведение:
		public function DotProductVec2d( secondVec:NVec ):Number
		{
			return x * secondVec.x + y * secondVec.y;
		}
		// ============================================================
		/**
		 * 
		 * @param	vec
		 * @param	toVec_1 - единичный ветор, на который будет сделана проекция
		 */
		public function CopyProjection( vec:NPoint, toVec_1:NPoint ):void 
		{
			// Формула проецирования вектора a на вектор b: 
			// proj.x = ( dp / (b.x*b.x + b.y*b.y) ) * b.x;
			// proj.y = ( dp / (b.x*b.x + b.y*b.y) ) * b.y;
			// где dp = (a.x*b.x + a.y*b.y); (скалярное произведение вектора a на вектор b).
			// если вектор b единичный, то можно упростить до:
			// proj.x = dp*b.x;
			// proj.y = dp*b.y; 
			
			var dot:Number = vec.DotProduct( toVec_1 );
			x = toVec_1.x * dot;
			y = toVec_1.y * dot;
		}
		// ============================================================
		public function Multiply( mul:Number ):void 
		{
			x *= mul;
			y *= mul;
		}
		// ============================================================
		public function CopyRotated( pnt:NPoint, cos:Number, sin:Number ):void 
		{
			x = pnt.x * cos - pnt.y * sin;
			y = pnt.x * sin + pnt.y * cos;
		}
		// ============================================================
		// ============================================================
		// ============================================================
		public static function CalcXYLength( x:Number, y:Number ):Number
		{
			return Math.sqrt( x * x + y * y );
		}
		// ============================================================
		public static function CalcXYSquareLength( x:Number, y:Number ):Number
		{
			return x * x + y * y;
		}
		// ============================================================
		public static function CalcDistance( pnt1:NPoint, pnt2:NPoint ):Number
		{
			return CalcXYLength( pnt2.x - pnt1.x, pnt2.y - pnt1.y );
		}
		// ============================================================
		public function CopyVector( vec:NVec ):void 
		{
			x = vec.x;
			y = vec.y;
		}
		// ============================================================
		public function FromString( str:String ):Boolean
		{
			var arr:Array = str.split(";");
			if ( arr.length == 2 )
			{
				x = int(arr[0]);
				y = int(arr[1]);
				return true;
			}
			else
			{
				x = 0;
				y = 0;
				return false;
			}
		}
		// ============================================================
	}
	
}
