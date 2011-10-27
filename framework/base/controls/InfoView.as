package base.controls
{
	import base.ActionBlocks.NBlink;
	import base.graphics.BitmapGraphix;
	import base.managers.FontsManager;
	import base.graphics.ImageFont;
	import base.graphics.NBitmapData;
	import base.modelview.WidgetContainer;
	import base.types.*;
	import base.ActionBlocks.*;
	import base.utils.SimpleProfiler;

	import flash.display.BitmapData;
	import flash.events.Event;
	
	/**
	 * ...
	 * @author dmBreaker
	 */
	//@ uses RM
	public class InfoView extends Control
	{
		// ============================================================
		private static const TextHSX:Number = 0;
		private static const TextHSY:Number = 0;
		private static const TextDSX:Number = 0;
		private static const TextDSY:Number = 0;
		// ============================================================
		private var mTicker:Ticker;
		// ============================================================
		private var mBG:BitmapData;		// здесь будет фоновая картинка
		private var mScore:NText = new NText("idScore");
		private var mHeaderText:String = "";
		
		private var mHeaderBuff:NBitmapData;
		
		private var mBlink:NBlink = new NBlink( 300, 300 );
		
		private var mTickerBG:BitmapData;
		private var mTickerBGHLight:BitmapData;
		private var mTickerBGHalo:BitmapData;
		
		private var mFont:ImageFont;
		private var mDigitFont:ImageFont;
		// ============================================================
		public function InfoView( name:String, ticker:Ticker, headerText:String )
		{
			super( name );
			
			mTicker = ticker;
			mTicker.addEventListener( Ticker.TICKER_VALUE_CHANGED, OnValueChanged, false, 0, true );
			mTicker.addEventListener( Ticker.TICKER_ATTENTION, OnAttention, false, 0, true );
			
			mHeaderText = headerText;
			
			mFont = FontsManager.Instance.GetFont("TickerFont");
			mDigitFont = FontsManager.Instance.GetFont("TickerDigitFont");
			mFont.Kerning = -2;
			//mFont.HorizontalAlignment = 0;
			
			mTickerBG = RM.GetImage( "ticker_normal" );
			mTickerBGHLight = RM.GetImage( "ticker_hlight" );
			mTickerBGHalo = RM.GetImage( "ticker_halo" );
			
			Resize( mTickerBG.width, mTickerBG.height );
		}
		// ============================================================
		public function SetBlinkTimeMS( time_ms:int ):void
		{
			mBlink.Set( time_ms, time_ms );
		}
		// ============================================================
		public override function OnAdded( parent:WidgetContainer ):void
		{
			//super.OnAdded( parent );	// вроде должно работать и так
			AddWidget( mScore );
			
			PregenerateHeader( mHeaderText );
			
			mScore.Font = mDigitFont;
			mScore.HorAlign = 0;
			mScore.Resize( Width, 25 );
			
			MoveSubcontrols();
			
			//mScore.SetColorTransform( 100, 0, 0 );
		}
		// ============================================================
		public function set Text( txt:String ):void
		{
			mScore.Text = txt;
		}
		// ============================================================
		public override function Draw(g:BitmapGraphix, diff_ms:int):void
		{
		SimpleProfiler.Start( "InfoView" );
			var sx:Number = (mTickerBG.width - mHeaderBuff.width)*0.5;
			var sy:Number = (mTickerBG.height - mHeaderBuff.height - mScore.Height)*0.5;
			//var hsx:Number = sx + TextHSX;
			//var hsy:Number = sy + TextHSY;
			
			if ( mBlink.IsBlinkOn )
				g.DrawImageFast( mTickerBGHLight, 0, 0 );
			else
				g.DrawImageFast( mTickerBG, 0, 0 );
			
			super.Draw(g, diff_ms);
			
			g.DrawImageFast( mHeaderBuff, sx, sy );
			g.DrawImageFast( mTickerBGHalo, 0, 0 );
		SimpleProfiler.Stop( "InfoView" );
		}
		// ============================================================
		override public function OnRemoving():void
		{
			mTicker.removeEventListener( Ticker.TICKER_VALUE_CHANGED, OnValueChanged );
			super.OnRemoving();
		}
		// ============================================================
		private function OnValueChanged(e:Event):void
		{
			Text = mTicker.Get().toString();
		}
		// ============================================================\
		private function OnAttention(te:TickerEvent):void
		{
			mBlink.DoBlink( int(te.Data) );
		}
		// ============================================================\
		override public function MoveTo(x:Number, y:Number):void
		{
			super.MoveTo(x, y);
			
			MoveSubcontrols();
		}
		// ============================================================
		override public function ShiftMove(x:Number, y:Number):void
		{
			super.ShiftMove(x, y);
			
			MoveSubcontrols();
		}
		// ============================================================
		private function MoveSubcontrols():void
		{
			var sx:Number = (mTickerBG.width - mScore.Width)*0.5;
			var sy:Number = (mTickerBG.height - mHeaderBuff.height - mScore.Height)*0.5;
			var dsx:Number = sx + TextDSX;
			var dsy:Number = sy + TextDSY;
			
			mScore.Rect.Position.CopyFrom( Rect.Position );
			mScore.Rect.Position.offset( dsx, mScore.Height+dsy );
		}
		// ============================================================
		protected function PregenerateHeader( txt:String = null ):void
		{
			DisposeHeaderBuffer();
			if( txt )
			{
				var size:NSize = mFont.MeasureStringSize( txt );
				if ( !size.IsEmpty )
				{
					var rect:NRect = new NRect( 0, 0, size.Width, size.Height );
					mHeaderBuff = new NBitmapData( size.Width, size.Height );
					mHeaderBuff.DrawText( txt, mFont, rect, -1, -1 );
				}
			}
		}
		// ============================================================
		protected function DisposeHeaderBuffer():void
		{
			if ( mHeaderBuff )
			{
				mHeaderBuff.dispose();
				mHeaderBuff = null;
			}
		}
		// ============================================================
	}
	
}