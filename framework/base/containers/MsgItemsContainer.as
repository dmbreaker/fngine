package base.containers
{
	import base.containers.de.polygonal.ds.ArrayedQueue;
	
	/**
	 * ...
	 * @author dmBreaker
	 */
	public class MsgItemsContainer extends ArrayedQueue
	{
		
		public function MsgItemsContainer(size:int)
		{
			super(size);
		}
		// ============================================================
		public function QuantMessages( diff_ms:int ):void
		{
			var message:IMsgItem;
			
			message = peek();
			while ( message != null && message.IsComplete )	// удаляем отработавшие сообщения
			{
				dequeue();
				message.Dispose();
				dispose();
				message = peek();
			}
			
			var cur_size:int = size;
			for (var i:int = 0; i < cur_size; i++)
			{
				message = getAt(i);
				message.Quant( diff_ms );
			}
		}
		// ============================================================
		public function RemoveAll():void
		{
			var msg:IMsgItem;
			
			msg = dequeue();
			while ( msg != null )
			{
				msg.Dispose();
				dispose();
				msg = dequeue();
			}
		}
		// ============================================================
	}
	
}