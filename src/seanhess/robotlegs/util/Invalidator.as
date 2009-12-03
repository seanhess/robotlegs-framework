package org.robotlegs.util
{
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.utils.Dictionary;
	import flash.utils.Timer;
	
	/**
	 * An interface to the static timer/invalidator
	 */
	public class Invalidator
	{
		protected static var invalid:Dictionary;
		protected static var timer:Timer;
		
		public function Invalidator()
		{
			if (!timer)
			{
				timer = new Timer(1,1);
				timer.addEventListener(TimerEvent.TIMER, onInvalidated);
				invalid = new Dictionary(true);
			}
		}
		
		public function invalidate(callback:Function):void
		{
			invalid[callback] = callback;
			
			if (!timer.running)
			{
				timer.reset();
				timer.start();
			}
		}
		
		public function uninvalidate(callback:Function):void
		{
			delete invalid[callback];
			
			// if it is empty then
			for each (var callback:Function in invalid)
			return;
			
			timer.stop();
		}
		
		/**
		 * Ah, yes, if some are added while we're finishing this! Bad!
		 */
		protected static function onInvalidated(event:Event):void
		{
			// save the old ones
			var currentlyInvalid:Dictionary = invalid;
			
			// reset it so it can start accepting new ones
			invalid = new Dictionary(true);
			timer.stop();
			
			// call everybody
			for each (var callback:Function in currentlyInvalid)
			callback();
			
		}
	}
}