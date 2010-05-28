package base.graphics
{
	import base.types.*;
	
	/**
	 * ...
	 * @author dmBreaker
	 */
	public class CharData
	{
		// ============================================================
		//public var Position:NPoint = new NPoint();
		//public var Size:NPoint = new NSize();
		public var Code:int;
		public var BitmapRect:NRect = new NRect();		/// область в битмапе
		public var PositionRect:NRect = new NRect();	/// область, используемая для позиционирования символа (координаты относительно рамки в битмапе) - на будущее
		
		// ============================================================
		public function CharData( code:int, bmpX:int, bmpY:int, bmpW:int = 0, bmpH:int = 0,
										posX:int = 0, posY:int = 0, posW:int = 0, posH:int = 0 )
		{
			Code = code;
			BitmapRect.Init( bmpX, bmpY, bmpW, bmpH );
			PositionRect.Init( posX, posY, posW, posH );
		}
		// ============================================================
		// ============================================================
	}
	
}