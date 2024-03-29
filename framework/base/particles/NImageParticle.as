﻿package base.particles
{
	import base.graphics.BitmapGraphix;
	import base.graphics.NBitmapData;
	
	/**
	 * ...
	 * @author dmBreaker
	 */
	// [Obsolete] - анимированный партикл может показывать однокадровые анимации
	public class NImageParticle extends NParticle
	{
		public var Image:NBitmapData;
		
		public function NImageParticle()
		{
			
		}
		// ============================================================
		public function Draw( g:BitmapGraphix, sx:Number, sy:Number ):void
		{
			g.DrawImage( Image, sx + ScreenPos.x, sy + ScreenPos.y, Alpha );
		}
		// ============================================================
		/* INTERFACE base.modelview.IQuant */
		public function Quant(diff_ms:int):void
		{
			super( diff_ms );
		}
	}
	
}