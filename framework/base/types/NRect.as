package base.types
{
	import flash.geom.Rectangle;
	
	/**
	 * ...
	 * @author dmBreaker
	 */
	public class NRect //extends Rectangle
	{
		// ============================================================
		public var Position:NPoint = new NPoint();
		public var Size:NSize = new NSize();
		private var mRect:Rectangle = new Rectangle();
		// ============================================================
		public function NRect( _x:Number = 0, _y:Number = 0, _width:Number = 0, _height:Number = 0 )
		{
			Position.Init( _x, _y );
			Size.Init( _width, _height );
		}
		// ============================================================
		/**
		 * Возвращает НЕ копию, а private member!
		 */
		public function get RectangleLinked():Rectangle
		{
			mRect.x = Position.x;
			mRect.y = Position.y;
			mRect.width = Size.Width;
			mRect.height = Size.Height;
			
			return mRect;
		}
		// ============================================================
		public function Init( _x:Number = 0, _y:Number = 0, _width:Number = 0, _height:Number = 0 ):void
		{
			Position.Init( _x, _y );
			Size.Init( _width, _height );
		}
		// ============================================================
		public function InitPosSize( pos:NPoint, size:NSize ):void
		{
			Position.CopyFrom( pos );
			Size.CopyFrom( size );
		}
		// ============================================================
		public function get Left():Number
		{
			return Position.x;
		}
		// ============================================================
		public function get Right():Number
		{
			return Position.x + Size.Width;
		}
		// ============================================================
		public function get Bottom():Number
		{
			return Position.y + Size.Height;
		}
		// ============================================================
		public function get Top():Number
		{
			return Position.y;
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
		public function CopyFrom( rect:NRect ):void
		{
			Position.CopyFrom( rect.Position );
			Size.CopyFrom( rect.Size );
		}
		// ============================================================
		public function toString():String
		{
			return "[NRect: " + Position.toString() + "; " + Size.toString() + "]";
		}
		// ============================================================
		public function Clone():NRect
		{
			var r:NRect = new NRect();
			r.CopyFrom( this );
			return r;
		}
		// ============================================================
		/**
		 * Изменяет координаты точки так, чтобы точка находилась внутри прямоугольника
		 */
		public function MovePointIn( pnt:NPoint ):void
		{
			var maxx:Number = Position.x + Size.Width;
			var maxy:Number = Position.y + Size.Height;
			var minx:Number = Position.x;
			var miny:Number = Position.y;
			
			if ( pnt.x >= maxx ) pnt.x = maxx - 1;
			if ( pnt.y >= maxy ) pnt.y = maxy - 1;
			if ( pnt.x < minx ) pnt.x = minx;
			if ( pnt.y < miny ) pnt.y = miny;
		}
		// ============================================================
		public function Contains( x:int, y:int ):Boolean
		{
			if ( x >= Position.x && x < Position.x + Size.Width )
				if ( y >= Position.y && y < Position.y + Size.Height )
					return true;

			return false;
		}
		// ============================================================
	}
	
}