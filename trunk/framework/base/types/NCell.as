package base.types
{
	/**
	* ...
	*/
	public class NCell
	{
		// ============================================================
		private static const UNDEF_VALUE:int = -10000;
		// ============================================================
		public var Row:int;
		public var Column:int;
		// ============================================================
		public function NCell( row:int = 0, col:int = 0 )
		{
			Row = row;
			Column = col;
		}
		// ============================================================
		public function Clone():NCell
		{
			var copy:NCell = new NCell();
			copy.CopyFrom( this );
			return copy;
		}
		// ============================================================
		public function Init( row:int, column:int ):void
		{
			Row = row;
			Column = column;
		}
		// ============================================================
		public function Equals( cell:NCell ):Boolean
		{
			if ( Row == cell.Row && Column == cell.Column )
				return true;
			return false;
		}
		// ============================================================
		public function PartiallyEquals( cell:NCell ):Boolean
		{
			if ( Row == cell.Row && Column != cell.Column )
				return true;
			if ( Row != cell.Row && Column == cell.Column )
				return true;
				
			return false;
		}
		// ============================================================
		public function CopyFrom( cell:NCell ):void
		{
			Row = cell.Row;
			Column = cell.Column;
		}
		// ============================================================
		public function MakeUndefined():void
		{
			Row = UNDEF_VALUE;
			Column = UNDEF_VALUE;
		}
		// ============================================================
		public static function get Undefined():NCell
		{
			return new NCell( UNDEF_VALUE, UNDEF_VALUE);
		}
		// ============================================================
		public function IsUndefined():Boolean
		{
			return ( Row == UNDEF_VALUE && Column == UNDEF_VALUE );
		}
		// ============================================================
		//public function get FieldIndex():int
		//{
			//return Row * eFieldElements.COLUMNS + Column;
		//}
		// ============================================================
		public function GetShifted( shift:NCell ):NCell
		{
			return new NCell( Row + shift.Row, Column + shift.Column );
		}
		// ============================================================
		public function GetShiftedByRow( row_shift:int ):NCell
		{
			return new NCell( Row + row_shift, Column );
		}
		// ============================================================
		public function GetShiftedByColumn( col_shift:int ):NCell
		{
			return new NCell( Row, Column + col_shift );
		}
		// ============================================================
		public function AddShift( shift:NCell ):void
		{
			Row += shift.Row;
			Column += shift.Column;
		}
		// ============================================================
		public function Substract( shift:NCell ):void
		{
			Row -= shift.Row;
			Column -= shift.Column;
		}
		// ============================================================
		public function CopySubstraction( a:NCell, b:NCell ):void
		{
			Row = a.Row - b.Row;
			Column = a.Column - b.Column;
		}
		// ============================================================
		public function CopyAddition( a:NCell, b:NCell ):void
		{
			Row = a.Row + b.Row;
			Column = a.Column + b.Column;
		}
		// ============================================================
		/*public function GetPosition():NPoint
		{
			return new NPoint( Column * Consts.COLLAPSE_CANDY_HOR_DIAMETER, Row * Consts.COLLAPSE_CANDY_DIAMETER);
		}*/
		// ============================================================
		public function toString():String
		{
			return "[NCell: row=" + Row + " column=" + Column + "]";
		}
		// ============================================================
		
		
		
		
		
		
		
		
		
		// ============================================================
		//public static function GetFieldIndex( row:int, col:int ):int
		//{
			//return row * eFieldElements.COLUMNS + col;
		//}
		// ============================================================
	}
}