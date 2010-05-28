package base.particles
{
	import base.graphics.IGraphix;
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
		public function Draw( g:IGraphix, sx:Number, sy:Number ):void
		{
			g.DrawBitmapData( Image, sx + ScreenPos.x, sy + ScreenPos.y, Alpha );
		}
		// ============================================================
		/* INTERFACE base.modelview.IQuant */
		public function Quant(diff_ms:int):void
		{
			super( diff_ms );
		}
	}
	
}