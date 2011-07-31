package base.types 
{
	/**
	 * ...
	 * @author dmbreaker
	 */
	public class NSphere
	{
		// ============================================================
		public var Pos:NPoint = new NPoint();
		protected var mRadius:Number = 1;
		protected var mSquareRadius:Number;
		// ============================================================
		public function NSphere( x:Number=0, y:Number=0, r:Number=1 )
		{
			Pos.x = x;
			Pos.y = y;
			Radius = r;
		}
		// ============================================================
		public function HasContact( sphere:NSphere ):Boolean
		{
			var centerSqDist:Number = Pos.CalcSquareDistanceTo( sphere.Pos );
			var radiusSum:Number = mRadius + sphere.mRadius;
			if ( centerSqDist < radiusSum*radiusSum )
				return true;
			
			return false;
		}
		// ============================================================
		public function IsFullInside( sphere:NSphere ):Boolean
		{
			var centerSqDist:Number = Pos.CalcSquareDistanceTo( sphere.Pos );
			var radiusSum:Number = mRadius - sphere.mRadius;
			if ( centerSqDist < radiusSum*radiusSum )
				return true;
			
			return false;
		}
		// ============================================================
		public function get Radius():Number
		{
			return mRadius;
		}
		// ============================================================
		public function set Radius( value:Number ):void 
		{
			mRadius = value;
			mSquareRadius = mRadius * mRadius;
		}
		// ============================================================
		public function ContainsPoint( pnt:NPoint ):Boolean
		{
			var sqR:Number = NPoint.CalcXYSquareLength( pnt.x - Pos.x, pnt.y - Pos.y );
			return ( sqR <= mSquareRadius );
		}
		// ============================================================
	}

}