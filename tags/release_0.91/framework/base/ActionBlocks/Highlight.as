package base.ActionBlocks
{
	
	/**
	 * 
	 * @author dmBreaker
	 */
	public class Highlight
	{
		// ============================================================
		private const HIGHLIGHT_VALUE:int = 128;
		private const HIGHLIGHT_DECREMENT:int = 9;
		// ============================================================
		protected var miHighlighted:int;		// текущее значение подсветки
		protected var mIsHighlighted:Boolean;	// включена ли подсветка

		protected var miMaxHighlightValue:int;	// максимальное значение подсветки (но не более 255)
		protected var miDecrementValue:int;		// значение, на которое будет уменьшаться подсветка
		
		// Для отрисовки в режиме подсветки - сохраняется цвет и режим отрисовки:
		private var mRestoreColor:int;
		private var mRestoreDrawMode:int;
		// ============================================================
		public function Highlight()
		{
			mIsHighlighted = false;
			miHighlighted = 0;

			miMaxHighlightValue = HIGHLIGHT_VALUE;
			miDecrementValue = HIGHLIGHT_DECREMENT;
		}
		// ============================================================
		public function SetConsts( max:int, decrement:int ):void
		{
			miMaxHighlightValue = max;
			miDecrementValue = decrement;
		}
		// ============================================================
		public function HighlightOn():void
		{
			mIsHighlighted = true;
			miHighlighted = Math.min( miMaxHighlightValue, 255 );
		}

		//////////////////////////////////////////////////////////////////////////
		//////////////////////////////////////////////////////////////////////////
		public function SetHighlighted():void
		{
			miHighlighted = Math.min( miMaxHighlightValue, 255 );
		}

		//////////////////////////////////////////////////////////////////////////
		//////////////////////////////////////////////////////////////////////////
		public function HighlightOff():void
		{
			mIsHighlighted = false;
		}

		//////////////////////////////////////////////////////////////////////////
		//////////////////////////////////////////////////////////////////////////
		public function get IsHighlighted():Boolean
		{
			return mIsHighlighted;
		}

		//////////////////////////////////////////////////////////////////////////
		//////////////////////////////////////////////////////////////////////////
		public function DecreaseHighlighting():void
		{
			if( !mIsHighlighted )
				miHighlighted = Math.max(0, miHighlighted - miDecrementValue);
		}

		//////////////////////////////////////////////////////////////////////////
		//////////////////////////////////////////////////////////////////////////
		//public function EnterHighlightMode( Graphics* g ):void
		//{
			//mRestoreColor = g->GetColor();
			//mRestoreDrawMode = g->GetDrawMode();
//
			//g->SetColor(Color(255,255,255,miHighlighted));
			//g->SetDrawMode(Graphics::DRAWMODE_ADDITIVE);
		//}

		//////////////////////////////////////////////////////////////////////////
		//////////////////////////////////////////////////////////////////////////
		//public function LeaveHighlightMode( Graphics* g ):void
		//{
			//g->SetDrawMode( mRestoreDrawMode );
			//g->SetColor( mRestoreColor );
		//}

		//////////////////////////////////////////////////////////////////////////
		//////////////////////////////////////////////////////////////////////////
		public function IsStillHighlighted():Boolean
		{
			return (miHighlighted >= 0) ? true : false;
		}
		// ============================================================
	}
	
}