package base.types
{
	
	/**
	 * ...
	 * @author dmBreaker
	 */
	public class NGridSize
	{
		// ============================================================
		public var Columns:int;
		public var Rows:int;
		// ============================================================
		public function NGridSize( r:int = 0, c:int = 0 )
		{
			Columns = c;
			Rows = r;
		}
		// ============================================================
		public function Init( nr:int, nc:int ):void
		{
			Columns = nc;
			Rows = nr;
		}
		// ============================================================
		public function Reset():void
		{
			Columns = 0;
			Rows = 0;
		}
		// ============================================================
		public function get IsEmpty():Boolean
		{
			return (Columns == 0 || Rows == 0);
		}
		// ============================================================
		public function CopyFrom( size:NGridSize ):void
		{
			Columns = size.Columns;
			Rows = size.Rows;
		}
		// ============================================================
		public function toString():String 
		{
			return "(r=" + Rows + ", c=" + Columns + ")";
		}
		// ============================================================
		public function get CellsCount():int
		{
			return Rows * Columns;
		}
		// ============================================================
	}
	
}