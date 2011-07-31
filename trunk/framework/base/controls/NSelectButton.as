package base.controls 
{
	import base.core.NCore;
	import base.graphics.BitmapGraphix;
	import base.managers.ResourceManager;
	import base.managers.SoundsPlayer;
	import base.types.NPoint;
	import base.utils.SimpleProfiler;
	import flash.display.BitmapData;
	
	/**
	 * ...
	 * @author dmbreaker
	 */
	public class NSelectButton extends NButton
	{
		// ============================================================
		public static var evtButtonSelect:String = "buttonselect";
		// ============================================================
		public var ImageScaleFactor:Number = 1;
		// ============================================================
		private var mIsSelected:Boolean = false;
		
		private var mRectImage:BitmapData;
		// ============================================================
		public function NSelectButton( name:String, text:String = null, images:* = null, rect:* = null, settings:* = null )
		{
			super( name, text, images, rect, settings );
		}
		// ============================================================
		override protected function InitImages(images:*):void 
		{
			super.InitImages(images);
			
			if ( images.pressed_rect && images.pressed_rect != undefined && images.pressed_rect != null )
			{
				mRectImage = RM.GetImage(images.pressed_rect);
			}
		}
		// ============================================================
		protected override function get State():int
		{
			if ( Enabled )
			{
				if ( !mIsSelected )
				{
					if ( !Focused && !IsMouseOver )
						return sButtonNormal;
					else if( Focused && IsMouseOver )
						return sButtonFocusedOver;
					else if( Focused )
						return sButtonFocused;
					else if( IsMouseOver )
						return sButtonOver;
				}
				else
					return sButtonPressed;
			}
			//else
			return sButtonDisabled;
		}
		// ============================================================
		public function get Selected():Boolean
		{
			return mIsSelected;
		}
		// ============================================================
		public function set Selected( v:Boolean ):void 
		{
			mIsSelected = v;
		}
		// ============================================================
		protected override function DoButtonClick():void
		{
			//super.DoButtonClick();
			if ( !mIsSelected )
			{
				mIsSelected = true;
				// TODO: желательна возможность настройки звука из XML
				SoundsPlayer.Play( NCore.Instance.MouseClickSampleName );
				DispatchNotification( NSelectButton.evtButtonSelect );
				Parent.OnCommand( this, NSelectButton.evtButtonSelect );
			}
		}
		// ============================================================
		override public function Draw(g:BitmapGraphix, diff_ms:int):void 
		{
		SimpleProfiler.Start("NSelectButtons");
			if ( HasImages )
			{
				var img:BitmapData = CurrentImage;
				
				var w:int = img.width * ImageScaleFactor;
				var h:int = img.height * ImageScaleFactor;
				
				var _x:Number = (Rect.Size.Width - w) * 0.5;
				var _y:Number = (Rect.Size.Height - h) * 0.5;
				if( ImageScaleFactor == 1 )
					g.DrawImageFast( CurrentImage, _x, _y );
				else
					g.DrawImageScaled( CurrentImage, _x+w/2, _y+h/2, 1, ImageScaleFactor, ImageScaleFactor );
				
				if ( mIsSelected )
				{
					img = mRectImage;
					_x = (Rect.Size.Width - img.width * ImageScaleFactor)*0.5;
					_y = (Rect.Size.Height - img.height * ImageScaleFactor)*0.5;
					
					if( ImageScaleFactor == 1 )
						g.DrawImageFast( mRectImage, _x, _y );
					else
						g.DrawImageScaled( mRectImage, _x+w/2, _y+h/2, 1, ImageScaleFactor, ImageScaleFactor );
				}
			}
			
			g.DrawText( mText, mFont, Rect, 0, 0 );
		SimpleProfiler.Stop("NSelectButtons");
		}
		// ============================================================
		override public function OnMouseIn():void 
		{
			//super.OnMouseIn();
		}
		// ============================================================
	}

}