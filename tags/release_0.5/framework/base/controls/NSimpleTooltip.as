package base.controls 
{
	import base.graphics.BitmapGraphix;
	import base.graphics.ImageFont;
	import base.graphics.NBitmapData;
	import base.managers.FontsManager;
	import base.tweening.NTweener;
	import base.types.*;
	import flash.geom.Rectangle;
	
	import mx.effects.easing.*;
	/**
	 * ...
	 * @author dmbreaker
	 */
	public class NSimpleTooltip extends NBaseTooltip
	{
		// ============================================================
		protected var mText:String;
		protected var mFont:ImageFont;
		
		protected var mBuffer:NBitmapData;
		public var ScaleFactor:Number = 1;
		public var Angle:Number = 0;
		public var Alpha:Number = 1;
		
		public static var TooltipFontName:String;
		private static var mInstance:NSimpleTooltip;
		// ============================================================
		public static function get Instance():NSimpleTooltip
		{
			if ( !mInstance )
				mInstance = new NSimpleTooltip( "", TooltipFontName );
				
			return mInstance;
		}
		// ============================================================
		public function NSimpleTooltip( name:String, font:* ) 
		{
			super( name );
			if ( font is String && String(font) )
				mFont = FontsManager.Instance.GetFont( font );
			else if ( font is ImageFont )
				mFont = font;
			else if ( !font )
				mFont = FontsManager.Instance.GetDefaultFont();
		}
		// ============================================================
		public function get Text():String
		{
			return mText;
		}
		// ============================================================
		override public function InitData(data:*):void 
		{
			if ( data is String )
				mText = data;
			else
				mText = data.text;

			var size:NSize = mFont.MeasureStringSize( mText );
			Resize( size.Width, size.Height );
			
			if ( mBuffer )
				mBuffer.dispose();
			mBuffer = new NBitmapData( size.Width+2, size.Height+2 );
			
			var r:NRect = new NRect( 0, 0, size.Width+2, size.Height+2 );
			var tr:NRect = new NRect( 1, 1, size.Width, size.Height );
			var dr:NRect = new NRect( 0, 0, size.Width+1, size.Height+1 );
			mBuffer.FillNRect( r, 0xff000000 );
			mBuffer.DrawNRect( dr, 0xffffffff );
			mBuffer.DrawText( mText, mFont, tr );
		}
		// ============================================================
		override public function Show(newPos:NPoint, cursorPos:NPoint):void 
		{
			InitPosition( newPos.x, newPos.y );
			NTweener.killTweensOf( this );
			//NTweener.to( this, 0.5, { Alpha:mMaxAlpha, Scale:maxScale, onComplete:onShowed, ease:Elastic.easeOut } );
			ScaleFactor = 0.2;
			Alpha = 0.2
			//Angle = -Math.PI*0.5;
			//NTweener.to( this, 0.5, { ScaleFactor:1, Angle:0, ease:NTweener.easeOut } );
			//NTweener.to( this, 0.3, { ScaleFactor:1, Alpha:0.9, ease:Bounce.easeOut } );
			ScaleFactor = 1;
			Alpha = 0.9;
			Visible = true;
		}
		// ============================================================
		override public function Hide():void 
		{
			NTweener.killTweensOf( this );
			Visible = false;
		}
		// ============================================================
		override public function Draw(g:BitmapGraphix, diff_ms:int):void 
		{
			if( mBuffer )
				g.DrawBitmapDataRot( mBuffer, Width*0.5, Height*0.5, Alpha, Angle, ScaleFactor );
				//g.DrawBitmapDataScaled( mBuffer, 0, 0, 1, ScaleFactor, ScaleFactor );
		}
		// ============================================================
	}

}