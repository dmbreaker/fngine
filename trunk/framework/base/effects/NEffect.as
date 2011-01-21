package base.effects
{
	import base.graphics.BitmapGraphix;
	import base.graphics.IGraphix;
	import base.modelview.IQuant;
	import base.types.*;
	import base.utils.IActiveItem;
	
	/**
	 * ...
	 * @author dmBreaker
	 */
	public class NEffect implements IActiveItem //implements IQuant
	{
		public var Pos:NPoint = new NPoint();
		protected var mIsCompleted:Boolean = false;
		// ============================================================
		public function NEffect( posX:Number, posY:Number )
		{
			Pos.x = posX;
			Pos.y = posY;
		}
		// ============================================================
		/* INTERFACE base.modelview.IQuant */
		internal function Quant(diff_ms:int):void
		{
			if ( Completed )
				return;
				
			InternalQuant( diff_ms );
		}
		// ============================================================
		/**
		 * Эффекты должны переопределять данный метод, чтобы базовый класс мог регулировать обновления потомков
		 */
		protected function InternalQuant(diff_ms:int):void
		{
		}
		// ============================================================
		public function Draw( g:IGraphix ):void
		{
			if ( Completed )
				return;
				
			InternalDraw( g );
		}
		// ============================================================
		/**
		 * Эффекты должны переопределять данный метод, чтобы базовый класс мог регулировать отрисовку потомков
		 */
		protected function InternalDraw( g:IGraphix ):void
		{
			
		}
		// ============================================================
		public function get Completed():Boolean
		{
			return mIsCompleted;
		}
		// ============================================================
		public function SetCompleted():void
		{
			mIsCompleted = true;
		}
		// ============================================================
		public function Dispose():void
		{
			
		}
		// ============================================================
		public function get IsActiveItem():Boolean
		{
			return false;
		}
		// ============================================================
		public function StartItem():void
		{
			
		}
		// ============================================================
		public function UpdateItem(ms:int):void
		{
			Quant(ms);
		}
		// ============================================================
		public function DrawItem(g:BitmapGraphix):void
		{
			Draw(g);
		}
		// ============================================================
		public function DisposeItem():void 
		{
			Dispose();
		}
		// ============================================================
	}
	
}