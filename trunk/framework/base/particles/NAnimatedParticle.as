package base.particles
{
	import base.graphics.IGraphix;
	import base.graphics.NAnimatedBitmap;
	import base.graphics.NBitmapData;
	
	/**
	 * ...
	 * @author dmBreaker
	 */
	public class NAnimatedParticle extends NParticle
	{
		public var Image:NAnimatedBitmap;
		
		public function NAnimatedParticle()
		{
		}
		// ============================================================
		public function Draw( g:IGraphix, sx:Number, sy:Number ):void
		{
			g.DrawBitmapData( Image.GetNBD(), sx + ScreenPos.x - Image.mHalfWidth, sy + ScreenPos.y - Image.mHalfHeight, Alpha );
			//trace( "EFFECT: ", sx + ScreenPos.x - Image.HalfWidth, sy + ScreenPos.y - Image.HalfHeight );
			//trace( "EFFECT2: ", sx, ScreenPos.x, -Image.HalfWidth );
		}
		// ============================================================
		public function DrawFastNoAlpha( g:IGraphix, sx:Number, sy:Number ):void
		{
			g.DrawBitmapDataFast( Image.GetNBD(), sx + ScreenPos.x - Image.mHalfWidth, sy + ScreenPos.y - Image.mHalfHeight );
			//trace( "EFFECT: ", sx + ScreenPos.x - Image.HalfWidth, sy + ScreenPos.y - Image.HalfHeight );
			//trace( "EFFECT2: ", sx, ScreenPos.x, -Image.HalfWidth );
		}
		// ============================================================
		/* INTERFACE base.modelview.IQuant */
		public override function Quant(diff_ms:int):void
		{
			super.Quant( diff_ms );
			Image.Quant( diff_ms );
		}
	}
	
}