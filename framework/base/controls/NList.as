package base.controls 
{
	import base.graphics.BitmapGraphix;
	import base.graphics.ImageFont;
	import base.managers.FontsManager;
	import base.modelview.WidgetContainer;
	import base.types.NRect;
	import base.utils.Methods;
	import flash.display.BitmapData;
	/**
	 * ...
	 * @author dmbreaker
	 */
	public class NList extends Control
	{
		// ============================================================
		// ============================================================
		protected var BGImage:BitmapData;
		protected var SelectedImage:BitmapData;
		protected var HasImages:Boolean = false;
		
		protected var mMarginHor:int = 0;
		protected var mMarginVer:int = 0;
		
		protected var mSelectedIndex:int = -1;
		
		protected var mLines:Vector.<String> = new Vector.<String>();	// list lines content
		protected var mMaxLines:int = 0;
		protected var mTextFont:ImageFont;
		protected var mSelectedTextFont:ImageFont;
		// ============================================================
		// ============================================================
		public function NList( name:String, images:*, rect:*=null, settings:*=null, parent:WidgetContainer = null ) 
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
			
			if ( settings )
			{
				if ( settings.margin_hor )
					mMarginHor = settings.margin_hor;
				
				if ( settings.margin_ver )
					mMarginVer = settings.margin_ver;
				
				if ( settings.font )
					mTextFont = FontsManager.Instance.GetFont(settings.font);
				
				if ( settings.font_selection )
					mSelectedTextFont = FontsManager.Instance.GetFont(settings.font_selection);
			}
			
			mMaxLines = (BGImage.height - 2 * mMarginVer) / SelectedImage.height;
		}
		// ============================================================
		// ============================================================
		protected function InitImages( images:* ):void
		{
			var back:BitmapData, slider:BitmapData;
			
			if ( !images || images["bg"] == undefined || images["selection"] == undefined )
				HasImages = false;
			else
			{
				HasImages = true;
				
				BGImage = GM(images["bg"]);
				SelectedImage = GM(images["selection"]);
			}
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
		public override function OnMouseDown(x:Number, y:Number):void
		{
			if ( x < mMarginHor || x > (Rect.Width-mMarginHor) )	// click not inside control
				return;
				
			y -= mMarginVer;
			if ( y < 0 || y >= (mMaxLines * SelectedImage.height) )
				return;
		
			var index:int = y / SelectedImage.height;
			if ( index != mSelectedIndex )
			{
				// Selection Changed
				mSelectedIndex = index;
			}
		}
		// ============================================================
		private var tempLineNRect:NRect = new NRect();
		override public function Draw(g:BitmapGraphix, diff_ms:int):void
		{
			if ( HasImages )
			{
				var img:BitmapData = BGImage;
				g.DrawImageFast( BGImage, 0, 0 );
				
				//рисуем селект:
				if ( mSelectedIndex >= 0 )
				{
					var selY:int = mMarginVer + mSelectedIndex * SelectedImage.height;
				
					g.DrawImageFast( SelectedImage,
													mMarginHor,
													selY
												);
				}
				
				// рисуем строки:
				var lineH:int;
				var count:int = mLines.length;
				for (var i:int = 0; i < count; i++) 
				{
					var line:String = mLines[i];
					if ( i == mSelectedIndex )
					{
						lineH = SelectedImage.height;
						tempLineNRect.Init(mMarginHor + 2, i*lineH + mMarginVer, Rect.Width - 2 * mMarginHor, lineH);
						g.DrawText( line, mSelectedTextFont, tempLineNRect, -1, 0 );
					}
					else
					{
						lineH = SelectedImage.height;
						tempLineNRect.Init(mMarginHor + 2, i*lineH + mMarginVer, Rect.Width - 2 * mMarginHor, lineH);
						g.DrawText( line, mTextFont, tempLineNRect, -1, 0 );
					}
					
				}
			}
		}
		// ============================================================
		// ============================================================
		public function AppendLine( text:String ):Boolean
		{
			if ( mLines.length < mMaxLines )
			{
				mLines.push( text );
				return true;
			}
			else
				return false;
		}
		// ============================================================
		public function RemoveLine( index:int ):Boolean
		{
			if ( index < 0 || index > mLines.length - 1)
				return false;
			else
			{
				mLines.splice( index, 1 );
				if ( mSelectedIndex > mLines.length - 1 )
					SelectLast();
				return true;
			}
		}
		// ============================================================
		public function SetLine(index:int, val:String):void
		{
			if ( index < 0 || index > mLines.length - 1)
				return;
			else
			{
				mLines[index] = val;
			}
		}
		// ============================================================
		public function Select( index:int ):Boolean
		{
			if ( index < mLines.length )
			{
				mSelectedIndex = index;
				return true;
			}
			else
				return false;
		}
		// ============================================================
		public function SelectFirst():void
		{
			if ( mLines.length < 1 )
				mSelectedIndex = -1;
			else
				mSelectedIndex = 0;
		}
		// ============================================================
		public function SelectLast():void
		{
			if ( mLines.length < 1 )
				mSelectedIndex = -1;
			else
				mSelectedIndex = mLines.length - 1;
		}
		// ============================================================
		public function GetLine( index:int ):String
		{
			if ( index >= 0 && index < mLines.length )
				return mLines[index];
			else
				return null;
		}
		// ============================================================
		public function GetSelectedLine():String
		{
			if ( mSelectedIndex >= 0 && mSelectedIndex < mLines.length )
				return mLines[mSelectedIndex];
			else
				return null;
		}
		// ============================================================
		public function SelectLine(line:String):void
		{
			var count:int = LinesCount;
			for (var i:int = 0; i < count; i++) 
			{
				if ( line == mLines[i] )
				{
					mSelectedIndex = i;
					return;
				}
			}
		}
		// ============================================================
		public function Clear():void
		{
			mLines.length = 0;
			mSelectedIndex = -1;
		}
		// ============================================================
		public function get SelectedIndex():int
		{
			return mSelectedIndex;
		}
		// ============================================================
		public function get LinesCount():int
		{
			return mLines.length;
		}
		// ============================================================
		// ============================================================
		// ============================================================
		public static function Create( el:XML, parent:WidgetContainer = null ):NList
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
					return new NList( id, images, rect, settings, parent );
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