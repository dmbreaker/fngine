package base.controls 
{
	import base.graphics.BitmapGraphix;
	import base.graphics.NBitmapData;
	import base.types.NRect;
	import base.types.NSize;
	import base.managers.FontsManager;
	/**
	 * ...
	 * @author dmbreaker
	 */
	public class NMultilineTooltip extends NSimpleTooltip
	{
		// ============================================================
		private var Lines:Array = new Array();
		// ============================================================
		/*public function NMultilineTooltip( name:String ) 
		{
			super("");
		}*/
		// ============================================================
		public static var TooltipFontName:String;
		private static var mInstance:NMultilineTooltip;
		// ============================================================
		public static function get Instance():NMultilineTooltip
		{
			if ( !mInstance )
				mInstance = new NMultilineTooltip( "", TooltipFontName );
				
			return mInstance;
		}
		// ============================================================
		public function NMultilineTooltip( name:String, font:* ) 
		{
			super( name, font );
		}
		// ============================================================
		override public function InitData(data:*):void 
		{
			var w:Number = 0;
			var h:Number = 0;
			
			Lines = new Array();
			for each( var str:String in data )
			{
				var size:NSize = mFont.MeasureStringSize( str );
				
				if ( size.Width > w )
					w = size.Width;
				h += size.Height;
				
				Lines.push( {text:str, h:size.Height} );
			}

			Resize( w, h );
			
			if ( mBuffer )
				mBuffer.dispose();
			mBuffer = new NBitmapData( w+2, h+2 );
			
			var r:NRect = new NRect( 0, 0, w+2, h+2 );
			var tr:NRect = new NRect( 1, 1, w, h );
			var dr:NRect = new NRect( 0, 0, w+1, h+1 );
			mBuffer.FillNRect( r, 0xff000000 );
			mBuffer.DrawNRect( dr, 0xffffffff );
			
			var posY:Number = 1;
			for each( var item:* in Lines )
			{
				tr.Size.Height = Number(item.h);
				mBuffer.DrawText( item.text, mFont, tr );
				tr.Position.y += Number(item.h);
			}
		}
		// ============================================================
	}

}