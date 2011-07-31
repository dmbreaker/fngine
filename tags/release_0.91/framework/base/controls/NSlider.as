package base.controls 
{
	import base.graphics.BitmapGraphix;
	import base.modelview.WidgetContainer;
	import base.utils.Methods;
	import flash.display.BitmapData;
	/**
	 * ...
	 * @author dmbreaker
	 */
	public class NSlider extends Control
	{
		// ============================================================
		// ============================================================
		public static var CHANGED_COMMAND:String = "slider_changed";
		// ============================================================
		// ============================================================
		protected var BGImage:BitmapData;
		protected var SliderImage:BitmapData;
		protected var HasImages:Boolean = false;
		
		protected var mIsPressed:Boolean = false;
		
		protected var mValue:Number = 1;
		protected var mSliderHalfWidth:int;
		protected var mSliderHalfHeight:int;
		protected var mEdgeMargin:int = 0;
		// ============================================================
		// ============================================================
		public function NSlider( name:String, images:*, rect:*=null, settings:*=null, parent:WidgetContainer = null ) 
		{
			super( name );
			Parent = parent;
			
			InitImages( images );
			
			if( rect && HasImages )
			{
				rect.w = rect.w || BGImage.width;
				rect.h = rect.h || BGImage.height;
				
				Methods.CalcControlRectAndResize( rect, this, Parent );
			}
			
			if ( settings && settings.margin )
			{
				mEdgeMargin = settings.margin;
			}
		}
		// ============================================================
		// ============================================================
		protected function InitImages( images:* ):void
		{
			var back:BitmapData, slider:BitmapData;
			
			if ( !images || images["bg"] == undefined || images["slider"] == undefined )
				HasImages = false;
			else
			{
				HasImages = true;
				
				BGImage = GM(images["bg"]);
				SliderImage = GM(images["slider"]);
				
				mSliderHalfWidth = SliderImage.width * 0.5;
				mSliderHalfHeight = SliderImage.height * 0.5;
			}
		}
		// ============================================================
		public override function OnMouseDown(x:Number, y:Number):void
		{
			mIsPressed = true;
			
			var start:int = mEdgeMargin + mSliderHalfHeight;
			var end:int = Rect.Height - mEdgeMargin - mSliderHalfHeight;
			var length:int = end - start;
			
			var clickY:int = y;
			Value = 1 - Number(clickY - start)/Number(length);
		}
		// ============================================================
		override public function OnMouseDrag(x:Number, y:Number):Boolean
		{
			var start:int = mEdgeMargin + mSliderHalfHeight;
			var end:int = Rect.Height - mEdgeMargin - mSliderHalfHeight;
			var length:int = end - start;
			
			var clickY:int = y;
			Value = 1 - Number(clickY - start) / Number(length);
			
			return false;
		}
		// ============================================================
		public override function OnMouseUp(x:Number, y:Number):void
		{
			if ( mIsPressed )
			{
				Parent.OnCommand( this, CHANGED_COMMAND );
			}
			
			mIsPressed = false;
			
			/*if ( ContainsRelative( x, y ) )
			{
				Parent.OnCommand( this, "slider_changed" );
			}*/
		}
		// ============================================================
		public override function Resize(w:int, h:int):void
		{
			if ( Rect.Size.IsEmpty )	// если выставлен "автосайз"
			{
				w = w || BGImage.width;		// выставим размеры по картинке
				h = h || BGImage.height;
			}

			super.Resize(w, h);
		}
		// ============================================================
		override public function Draw(g:BitmapGraphix, diff_ms:int):void
		{
			if ( HasImages )
			{
				var img:BitmapData = BGImage;
				g.DrawBitmapDataFast( BGImage, 0, 0 );
				
				//рисуем слайдер
				var start:int = mEdgeMargin + mSliderHalfHeight;
				var end:int = Rect.Height - mEdgeMargin - mSliderHalfHeight;
				var length:int = end - start;
				
				g.DrawBitmapDataFastCentered( SliderImage,
												(BGImage.width >> 1),
												start + (1-mValue) * Number(length)
											);
			}
		}
		// ============================================================
		public function get Value():Number
		{
			return mValue;
		}
		// ============================================================
		public function set Value(val:Number):void 
		{
			if ( val > 1 )
				val = 1;
			if ( val < 0 )
				val = 0;
			mValue = val;
		}
		// ============================================================
		// ============================================================
		// ============================================================
		// ============================================================
		// ============================================================
		public static function Create( el:XML, parent:WidgetContainer = null ):NSlider
		{
			var rect:* = {};
			var settings:* = { halign:int(-1), valign:int(0) };
			var images:* = {};
			
			Methods.ApplyControlSettings( el, rect, settings, images, parent );
			
			var id:String = el.@id;
			
			try
			{
				if ( id )
				{
					return new NSlider( id, images, rect, settings, parent );
				}
			}
			catch( err:Error )
			{
				trace( "### Error:", err, err.getStackTrace() );
				return null;
			}
			
			return null;
		}
		// ============================================================
	}

}