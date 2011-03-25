package base.controls
{
	import base.types.NPoint;
	/**
	 * ...
	 * @author dmbreaker
	 */
	public class NRoundControl extends Control
	{
		// ============================================================
		protected var mR:Number = 0;
		protected var mCenter:NPoint = new NPoint();
		// ============================================================
		public function NRoundControl( name:String, radius:Number )
		{
			super( name );
			mR = radius;
			IsClickable = true;
		}
		// ============================================================
		public function Init( centerX:Number, centerY:Number ):void 
		{
			mCenter.x = centerX;
			mCenter.y = centerY;
			
			Rect.Position.x = centerX - mR;
			Rect.Position.y = centerY - mR;
			Rect.Size.Width = mR * 2;
			Rect.Size.Height = mR * 2;
		}
		// ============================================================
		override public function InitPosition(x:Number, y:Number):void 
		{
			super.InitPosition(x, y);
			mCenter.x = x + mR;
			mCenter.y = y + mR;
		}
		// ============================================================
		override public function Contains(x:Number, y:Number):Boolean 
		{
			return super.Contains(x, y);
		}
		// ============================================================
		override public function ContainsRelative(x:Number, y:Number):Boolean 
		{
			var sqDist:Number = NPoint.CalcXYSquareLength( x-mR, y-mR );
			var sqR:Number = mR * mR;
			
			return (sqDist <= sqR);
		}
		// ============================================================
		override public function Resize(w:int, h:int):void 
		{
			var minLen:Number = (w > h) ? h : w;
			
			super.Resize(minLen, minLen);
			mR = minLen >> 1;
		}
		// ============================================================
	}

}