﻿package base.managers
{
	import base.core.NCore;
	import base.graphics.NAnimatedBitmap;
	import base.graphics.NBitmapData;
	//import flash.display.DisplayObject;
	//import flash.display.IBitmapDrawable;
	//import flash.display.MovieClip;
	//import flash.media.Video;
	//import flash.net.NetConnection;
	//import flash.net.NetStream;
	//import flash.system.Security;
	//import flash.utils.ByteArray;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.geom.Point;
	import flash.display.BitmapDataChannel;
	
	import base.types.*;
	
	/**
	 * resource manager class
	 * @author dmBreaker
	 */
	public class ResourceManager 		// resource manager
	{
		// ============================================================
		protected static var mImages:* = new Object();
		protected static var mAnimations:* = new Object();
		// ============================================================
		public function ResourceManager() {}
		// ============================================================
		public static function GetImage( name:String ):BitmapData
		{
			var img:BitmapData = mImages[name] as BitmapData;
			if ( img == null )
			{
				var a:int = 0;
				CONFIG::release
				{
					throw new Error( "RM.GetImage( " + name + " ) - not found");
				}
			}
			return img;
		}
		// ============================================================
		public static function GetAnimation( name:String, throwable:Boolean = true ):NAnimatedBitmap
		{
			var animation:NAnimatedBitmap = new NAnimatedBitmap();
			var tmpAnimation:NAnimatedBitmap = mAnimations[name] as NAnimatedBitmap
			if ( tmpAnimation == null )
			{
				if( throwable )
					throw new Error( "RM.GetAnimation( " + name + " ) - not found");
				else
				{
					trace( "RM.GetAnimation( " + name + " ) - not found");
					return null;
				}
			}
			animation.CopyFrom( tmpAnimation );
			
			return animation;
		}
		// ============================================================
		public static function SaveImage( name:String, image:*, alpha:* = null ):void
		{
			mImages[name] = MixinAlpha( image as Bitmap, alpha as Bitmap );
			if ( mImages[name] == null )
			{
				trace( "image null:", name );
			}
		}
		// ============================================================
		/*public static function BitmapFromVideo( stillimage:ByteArray ):Bitmap
		{
		//  JUST THOUGHT: video.attachNetStream only after "NetStream.Play.Start" message
		
			Security.allowDomain("*");
			Security.allowInsecureDomain("*");
			
			var clientObject:Object = new Object();
			clientObject.onMetaData = metaDataListener;
			
			var nc:NetConnection = new NetConnection();
			nc.connect(null);
			var ns:NetStream = new NetStream(nc);
			//ns.checkPolicyFile = false;
			//nc.client = this;
			//ns.client = this;
			ns.client = clientObject;
			
			var video:Video = new Video();
			video.attachNetStream(ns);
			video.smoothing = true;
			ns.play(null);
			ns.appendBytesAction(NetStreamAppendBytesAction.RESET_BEGIN);
			ns.appendBytes(stillimage);
			
			//var allowAudio:Boolean = true;
			//var allowVideo:Boolean = true;
			//ns.publish("none");
			//ns.send("|RtmpSampleAccess", allowAudio, allowVideo);
			NCore.Instance.stage.addChild(video);
			
			var w:int = video.videoWidth ? video.videoWidth : video.width;
			var h:int = video.videoHeight ? video.videoHeight : video.height;
			var bmd:BitmapData = new BitmapData(w, h, true, 0);
			///bmd.draw(video);
			var bmp:Bitmap = new Bitmap(bmd);
			return bmp;
		}*/
		// ============================================================
		public static function metaDataListener(object:Object):void
		{
			var video:* = { };
			var duration:int = object.duration;
			trace(duration);
			video.width = object.width;
			video.height = object.height;
		}
		// ============================================================
		public static function SaveImageShadow( name:String, srcImage:String, blurX:int=8, blurY:int=8, blursCount:int=3 ):void
		{
			var src:BitmapData = GetImage( srcImage );
			if ( src )
			{
				var shadow:NBitmapData = new NBitmapData( src.width, src.height, true, 0 );
				shadow.lock();
				shadow.copyPixels( src, shadow.rect, new Point() );
				shadow.ShadowMe( blurX, blurY, blursCount );
				shadow.unlock();
				mImages[name] = shadow;
			}
			else
				trace( "shadow source image null:", name );
		}
		// ============================================================
		public static function SaveImageTransformAlpha( name:String, srcImage:String, alpha:Number, blurX:int=8, blurY:int=8, blursCount:int=3 ):void
		{
			var src:BitmapData = GetImage( srcImage );
			if ( src )
			{
				var shadow:NBitmapData = new NBitmapData( src.width, src.height, true, 0 );
				shadow.lock();
				shadow.copyPixels( src, shadow.rect, new Point() );
				shadow.BlurMe( blurX, blurY, blursCount );
				shadow.AlphaBlend(alpha);
				shadow.unlock();
				mImages[name] = shadow;
			}
			else
				trace( "shadow alpha source image null:", name );
		}
		// ============================================================
		public static function SaveBitmapData( name:String, image:BitmapData ):void
		{
			mImages[name] = image
			if ( mImages[name] == null )
			{
				trace( "image null (2):", name );
			}
		}
		// ============================================================
		public static function SaveImageMixed( name:String, image:*, alpha:*, imageTop:*, alphaTop:*=null ):void
		{
			mImages[name] = MixImages( image as Bitmap, alpha as Bitmap, imageTop as Bitmap, alphaTop as Bitmap );
			if ( mImages[name] == null )
			{
				trace( "image null:", name );
			}
		}
		// ============================================================
		public static function SaveAnimation( name:String, image:*, alpha:* = null, fsize:NSize = null, fcount:int = 1, time:Number = 1, settings:* = null ):void
		{
			var bmd:BitmapData = MixinAlpha( image as Bitmap, alpha as Bitmap );
			mAnimations[name] = new NAnimatedBitmap( bmd, fsize, fcount, time, settings );
		}
		// ============================================================
		public static function SaveStripe( name:String, image:*, settings:* = null, fcount:int = 0, alpha:* = null ):void
		{
			var bmd:BitmapData = MixinAlpha( image as Bitmap, alpha as Bitmap );
			mAnimations[name] = new NAnimatedBitmap( bmd, null, fcount, 1, settings );
		}
		// ============================================================
		public static function SaveAnimationShadow( name:String, srcAnim:String, blurX:int=8, blurY:int=8, blursCount:int=3 ):void
		{
			var src:NAnimatedBitmap = GetAnimation( srcAnim );
			var anim:NAnimatedBitmap = new NAnimatedBitmap();
			anim.CloneFrom( src );
			anim.ShadowEveryFrame( blurX, blurY, blursCount );
			mAnimations[name] = anim;
		}
		// ============================================================
		private static function MixinAlpha( image:Bitmap, alpha:Bitmap ):BitmapData
		{
			if ( alpha == null )		// если альфы нет
				return image.bitmapData;
			
			if ( image.width != alpha.width || image.height != alpha.height )
			{
				trace( "### ERROR: Image and alpha doesn't compatible!" );
				return null;
			}
			
			var bmd:BitmapData = image.bitmapData;
			var result:BitmapData;
			result = new BitmapData( bmd.width, bmd.height, true, 0 );	// чтобы всегда изображение содержало прозрачность
			result.draw( bmd );
			result.copyChannel( alpha.bitmapData, alpha.bitmapData.rect, new Point(), BitmapDataChannel.GREEN, BitmapDataChannel.ALPHA );
			return result;
		}
		// ============================================================
		private static function MixImages( imageBottom:Bitmap, alphaBottom:Bitmap, imageTop:Bitmap, alphaTop:Bitmap = null ):BitmapData
		{
			if ( imageBottom.width != imageTop.width || imageBottom.height != imageTop.height )
				return null;
			
			var bottom:BitmapData = MixinAlpha( imageBottom, alphaBottom );
			var top:BitmapData = MixinAlpha( imageTop, alphaTop );
			bottom.copyPixels( top, top.rect, new Point(), null, null, true );
			return bottom;
		}
		// ============================================================
		/*
		 * "Врисовывает" одно изображение в другое
		 */
		public static function MixInImage( bmdDest:BitmapData, bmdMixin:BitmapData, pos:NPoint ):BitmapData
		{
			var result:BitmapData;
			result = new BitmapData( bmdDest.width, bmdDest.height, true, 0 );	// чтобы всегда изображение содержало прозрачность
			result.draw( bmdDest );
			result.copyPixels( bmdMixin, bmdMixin.rect, pos, null, null, true );
			return result;
		}
		// ============================================================
		public static function MixInRes( destName:String, srcName:String, pos:NPoint ):void
		{
			var bmdDest:BitmapData = mImages[destName];
			var bmdMixin:BitmapData = mImages[srcName];
			var result:BitmapData;
			result = new BitmapData( bmdDest.width, bmdDest.height, true, 0 );	// чтобы всегда изображение содержало прозрачность
			result.draw( bmdDest );
			result.copyPixels( bmdMixin, bmdMixin.rect, pos, null, null, true );
			mImages[destName] = result;
		}
		// ============================================================
		// ============================================================
	}
	
}