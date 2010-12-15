package base.types 
{
	/**
	 * ...
	 * @author dmbreaker
	 */
	public class PointI
	{
		// ============================================================
		// ============================================================
		public var x:int;
		public var y:int;
		// ============================================================
		// ============================================================
		public function PointI(_x:int = 0, _y:int = 0) 
		{
			x = _x;
			y = _y;
		}
		// ============================================================
		public function Init( nx:int, ny:int ):void
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
		public function CopyFrom( point:PointI ):void
		{
			x = point.x;
			y = point.y;
		}
		// ============================================================
		public function CopyMulFrom( point:PointI, mul:int ):void
		{
			x = point.x * mul;
			y = point.y * mul;
		}
		// ============================================================
		public function Clone():PointI
		{
			var pnt:PointI = new PointI();
			pnt.CopyFrom( this );
			return pnt;
		}
		// ============================================================
		public function CopySubtraction( point:PointI, minusPoint:PointI ):void 
		{
			x = point.x - minusPoint.x;
			y = point.y - minusPoint.y;
		}
		// ============================================================
		public function CopyAddition( point:PointI, plusPoint:PointI ):void 
		{
			x = point.x + plusPoint.x;
			y = point.y + plusPoint.y;
		}
		// ============================================================
		public function Add( point:PointI ):void 
		{
			x += point.x;
			y += point.y;
		}
		// ============================================================
		public function Sub( point:PointI ):void 
		{
			x -= point.x;
			y -= point.y;
		}
		// ============================================================
		public function Multiply( mul:int ):void 
		{
			x *= mul;
			y *= mul;
		}
		// ============================================================
		public function GetNPoint():NPoint
		{
			var np:NPoint = new NPoint();
			np.x = Number(x);
			np.y = Number(y);
			return np;
		}
		// ============================================================
		// ============================================================
	}

}