package base.modelview
{
	import base.core.NScene;
	
	/**
	 * ...
	 * @author dmBreaker
	 */
	public interface IWidget extends IDraw
	{
		//function OnAdded( /*parent:IWidget*/ ):void;
		//function OnRemoving( /*parent:IWidget*/ ):void;
		function InitParent( parent:WidgetContainer, scene:NScene ):void;
		function OnAdded( parent:WidgetContainer ):void;
		function OnRemoving( /*parent:IWidget*/ ):void;
		
		function OnMouseClick( x:Number, y:Number ):void;
		function OnMouseMove( x:Number, y:Number ):void;
		function OnMouseDrag( x:Number, y:Number ):Boolean;
		function OnMouseDown( x:Number, y:Number ):void;
		function OnMouseUp( x:Number, y:Number ):void;
		function OnMouseIn():void;
		function OnMouseOut():void;
	}
	
}