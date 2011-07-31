package base.utils.xmltweener 
{
	/**
	 * ...
	 * @author dmbreaker
	 */
	public class EffectBlock
	{
		// ============================================================
		// ============================================================
		public var ID:String = "";
		public var Commands:Vector.<EffectCommand> = new Vector.<EffectCommand>();
		// ============================================================
		// ============================================================
		public function EffectBlock() 
		{
			
		}
		// ============================================================
		// ============================================================
		public function Parse( node:XML ):void
		{
			Commands.length = 0;

			if( node.@id )
			{
				ID = node.@id;

				for each(var cmd:XML in node..command )
				{
					//var name:String = cmd.name();
					//if( name == "command" )
					{
						var command:EffectCommand = new EffectCommand();
						command.Parse( XML(cmd) );
						Commands.push( command );
					}
				}
			}
			else
				ID = "";
		}
		// ============================================================
		public function Init( effect:XmlEffect ):void
		{
			for each(var cmd:EffectCommand in Commands)
			{
				var auto_id:int = effect.mCommandsMap.Size();

				cmd.ID = String(auto_id);
				effect.mCommandsMap.Add(cmd.ID, cmd);
				cmd.Init( effect );
			}
		}
		// ============================================================
		public function Execute():void
		{
			for each( var cmd:EffectCommand in Commands )
			{
				cmd.Execute();
			}
		}
		// ============================================================
		// ============================================================
	}

}