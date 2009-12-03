package seanhess.robotlegs.util
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	
	import org.robotlegs.util.Invalidator;

	
	[Event(name="call", type="flash.events.Event")]
	public class Listen extends EventDispatcher
	{
		protected var v:Invalidator = new Invalidator();
		
		protected var _target:IEventDispatcher;
		protected var _type:String;
		
		public var event:Event; // lame... this will have to be casted... 
		
		public function set target(value:IEventDispatcher):void
		{
			_target = value;
			v.invalidate(listen);
		}
		
		public function set type(value:String):void
		{
			_type = value;
			v.invalidate(listen);
		}
		
		protected function listen():void
		{
			if (_target && _type)
			{
				_target.addEventListener(_type, onEvent, false, 0, true);
			}
		}
		
		protected function onEvent(event:Event):void
		{
			this.event = event;
			dispatchEvent(new Event("call"));
		}
	}
}