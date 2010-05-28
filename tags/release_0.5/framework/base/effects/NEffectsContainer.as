package base.effects
{
	import base.containers.BitArray;
	import base.containers.SearchFreeSlotContainer;
	import base.graphics.IGraphix;
	import base.modelview.IQuant;
	
	/**
	 * ...
	 * @author dmBreaker
	 */
	public class NEffectsContainer extends SearchFreeSlotContainer implements IQuant
	{
		// TODO: в контейнерах эффектов старые можно не удалять, а при создании
		// новых эффектов - сначала искать в ранее отработавших, и если не найден,
		// то создавать новый (если места нет - помещать не сначала, а с конца или, все же, сначала?)
		// НО, для этого нужно, чтобы эффекты поддерживали переинициализацию без выделения памяти
		// и при этом новые эффекты должны затирать самые старые
		// ============================================================
		public function NEffectsContainer(size:int = 64)
		{
			super( size );
		}
		// ============================================================
		//private var mSecondCounter:Number = 0;
		public function Quant( diff_ms:int ):void
		{
			var effect:NEffect;
			//var count:int = 0;

			ForEach(
				function ( obj:*, index:int ):void
				{
					effect = NEffect(obj);
					//if ( effect != null && effect.Completed )	// удаляем отработавшие сообщения
					if ( effect.Completed )	// удаляем отработавшие сообщения
					{
						effect.Dispose();
						ResetAt( index );
					}
					else
					{
						effect.Quant( diff_ms );
					}
					
					//++count;
				}
			);
			
			//mSecondCounter += diff_ms;
			//if ( mSecondCounter >= 1000 )
			//{
				//mSecondCounter -= 1000;
				//trace("Effects count:", count );
			//}
		}
		// ============================================================
		public function Draw( g:IGraphix, sx:Number = 0, sy:Number = 0 ):void
		{
			var effect:NEffect;

			g.AddOffset( sx, sy );	// добавим смещение
			ForEach( function ( obj:*, index:int ):void
			{
				effect = NEffect(obj);
				effect.Draw( g );

				//effect = NEffect(obj);
				//if ( effect != null && !effect.Completed )	// удаляем отработавшие сообщения
				//effect.Draw( g );
			} );
			g.AddOffset( -sx, -sy );	// восстановим смещение
		}
		// ============================================================
	}
	
}