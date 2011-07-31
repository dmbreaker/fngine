package base.graphics
{
	import flash.display.Graphics;
	import flash.geom.Rectangle;
	import flash.display.BitmapData;
	
	/**
	 * ...
	 * @author dmBreaker
	 */
	public interface IGraphix
	{
		function Clear():void;
		function DrawBitmapData( bmd:BitmapData, sx:Number, sy:Number, alpha:Number = 1 ):void;
		function DrawBitmapDataFast( bmd:BitmapData, sx:Number, sy:Number ):void;
		function DrawBitmapDataFastCentered(bmd:BitmapData, sx:Number, sy:Number):void;
		function DrawBitmapDataRot(bmd:BitmapData, sx:Number, sy:Number, alpha:Number = 1, angle:Number = 0, scaleFactor:Number = 1):void;
		function DrawBitmapDataScaled(bmd:BitmapData, sx:Number, sy:Number, alpha:Number = 1, scaleX:Number = 1, scaleY:Number = 1):void;
		
		function DrawBitmapDataCentered( bmd:BitmapData, sx:Number, sy:Number, alpha:Number = 1 ):void;
		function DrawBitmapDataPart( bmd:BitmapData, sx:Number, sy:Number, offx:Number = 0, offy:Number = 0, w:Number = 0, h:Number = 0 ):void;
		function FillRect( rect:Rectangle, color:int ):void;
		function DrawRect( rect:Rectangle, color:int ):void;
		function BlitOn( g:Graphics, sx:Number, sy:Number ):void;
		function SetOffset( x:Number, y:Number ):void;
		function ResetOffset():void;
		function AddOffset( x:Number, y:Number ):void;
		
		function Destroy():void;
	}
	
}