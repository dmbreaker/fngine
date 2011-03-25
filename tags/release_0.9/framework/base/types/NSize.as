package base.types
{
	
	/**
	 * ...
	 * @author dmBreaker
	 */
	public class NSize
	{
		// ============================================================
		public var Width:Number;
		public var Height:Number;
		// ============================================================
		public function NSize( w:Number = 0, h:Number = 0 )
		{
			Width = w;
			Height = h;
		}
		// ============================================================
		public final function IntWidht():int
		{
			return int(Width);
		}
		// ============================================================
		public final function IntHeight():int
		{
			return int(Height);
		}
		// ============================================================
		public function Init( nw:Number, nh:Number ):void
		{
			Width = nw;
			Height = nh;
		}
		// ============================================================
		public function Reset():void
		{
			Width = 0;
			Height = 0;
		}
		// ============================================================
		public function get IsEmpty():Boolean
		{
			return (Width == 0 || Height == 0);
		}
		// ============================================================
		public function CopyFrom( size:NSize ):void
		{
			Width = size.Width;
			Height = size.Height;
		}
		// ============================================================
		public function toString():String 
		{
			return "(w=" + Width + ", h=" + Height + ")";
		}
		// ============================================================
		public function get CellsCount():int
		{
			return int(Width) * int(Height);
		}
		// ============================================================
		public function Multiply( multiplier:Number ):void
		{
			Width *= multiplier;
			Height *= multiplier;
		}
		// ============================================================
	}
	
}