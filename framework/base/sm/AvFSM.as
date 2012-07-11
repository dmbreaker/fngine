package base.sm 
{
	import base.containers.AvDictionary;
	import flash.utils.Dictionary;
	/**
	 * Final State Machine
	 * @author dmbreaker
	 */
	public class AvFSM 
	{
		// ============================================================
		// ============================================================
		private var InitialState:AvState = null;
		private var CurrentState:AvState = null;
		//private var NextState:AvState = null;
		
		private var States:AvDictionary = new AvDictionary();	// <String, AvState>
		private var FSMTable:AvDictionary = new AvDictionary();	// <String, AvDictionary<String, String>>
		private var Events:Vector.<String> = new Vector.<String>();
		// ============================================================
		// ============================================================
		public function AvFSM() 
		{
			
		}
		// ============================================================
		// ============================================================
		public function Init(initState:AvState):void
		{
			InitialState = initState;
			Reset();
		}
		// ============================================================
		public function Reset():void
		{
			CurrentState = InitialState;
			// ...
		}
		// ============================================================
		/*
		 * Adds one of possible states to FSM
		 */
		public function AppendState(state:AvState):void
		{
			States.Add(state.ID, state);
		}
		// ============================================================
		/*
		 * Adds event transition to FSM.
		 * If nextStateID equals "" (empty string) that means no transition required and state is the same,
		 * but OnHandle is called anyway.
		 */
		public function AddTransition(event:String, curStateID:String, nextStateID:String):void
		{
			var result:* = FSMTable.GetValue(curStateID);
			
			var dict:AvDictionary = null;
			if ( result == undefined )
			{
				dict = new AvDictionary();
				FSMTable.Add( event, dict );
			}
			else
				dict = result as AvDictionary;
				
			dict.Add(event, nextStateID);
		}
		// ============================================================
		public function Update(ms:int):void
		{
			Process();
			
			if ( CurrentState )
				CurrentState.DoUpdate(ms);
		}
		// ============================================================
		public function HandleEvent(event:String):void
		{
			Events.push(event);
		}
		// ============================================================
		public function Process():void
		{
			if ( !CurrentState ) return;	// FSM not initilized
			if ( Events.length == 0 ) return;	// nothing to do here
			
			var events:Vector.<String> = Events.concat();	// copy of events
			Events.length = 0;
			
			for ( var event:String in events )
			{
				CurrentState.DoHandle(event);	// call it anyway
				
				if ( FSMTable.ContainsKey(CurrentState.ID) )
				{
					var transitions:AvDictionary = FSMTable.GetValue(CurrentState.ID);
					if ( transitions.ContainsKey(event) )
					{
						var nextStateID:String = transitions.GetValue(event);
						var nextState:AvState = States.GetValue(nextStateID);
						
						CurrentState.DoExit();
						nextState.DoEnter();
						CurrentState = nextState;
					}
				}
			}
		}
		// ============================================================
	}

}