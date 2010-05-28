package base.types
{
	import flash.geom.Rectangle;
	
	/**
	 * ...
	 * @author dmBreaker
	 */
	public class NRelativeRect
	{
		// ============================================================
		//public var Position:NPoint;
		protected var Position:NPoint;
		public var Shift:NSize = new NSize();
		public var Size:NSize = new NSize();
		// ============================================================
		public function NRelativeRect( relPoint:NPoint, _shiftX:Number, _shiftY:Number, _width:Number = 0, _height:Number = 0 )
		{
			Position = relPoint;
			Size.Init( _width, _height );			
			Shift.Init( _shiftX, _shiftY );
		}
		// ============================================================
		public function ContainsPoint( pnt:NPoint ):Boolean
		{
			return ((pnt.x >= Left && pnt.x < Right) && (pnt.y >= Top && pnt.y < Bottom));
		}
		// ============================================================
		/*public function Init( _x:Number = 0, _y:Number = 0, _width:Number = 0, _height:Number = 0 ):void
		{
			Position.Init( _x, _y );
			Size.Init( _width, _height );
		}*/
		// ============================================================
		/*public function InitPosSize( pos:NPoint, size:NSize ):void
		{
			Position.CopyFrom( pos );
			Size.CopyFrom( size );
		}*/
		// ============================================================
		public function get Left():Number
		{
			return Position.x + Shift.Width;
		}
		// ============================================================
		public function get Right():Number
		{
			return Position.x + Size.Width + Shift.Width;
		}
		// ============================================================
		public function get Bottom():Number
		{
			return Position.y + Size.Height + Shift.Height;
		}
		// ============================================================
		public function get Top():Number
		{
			return Position.y + Shift.Height;
		}
		// ============================================================
		public function get Width():Number
		{
			return Size.Width;
		}
		// ============================================================
		public function get Height():Number
		{
			return Size.Height;
		}
		// ============================================================
		public function CopyFrom( rect:NRelativeRect ):void
		{
			Position.CopyFrom( rect.Position );
			Size.CopyFrom( rect.Size );
			Shift.CopyFrom( rect.Shift );
		}
		// ============================================================
		public function toString():String
		{
			return "[NRelativeRect: " + Position.toString() + "; Shift:" + Shift.toString() + "; " + Size.toString() + "]";
		}
		// ============================================================
		public function Clone():NRelativeRect
		{
			return new NRelativeRect( Position, Shift.Width, Shift.Height, Size.Width, Size.Height );
		}
		// ============================================================
	}
	
}