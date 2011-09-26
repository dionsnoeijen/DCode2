package com.tools {

	import flash.utils.Timer;
	import flash.utils.getTimer;

	public class BetterTimer 
	{
		public var _delay:Number;
		public var _lastTime:Number;
		public var _repeat:Number;
		public var _thisTime:Number = 0;
		public var timer:Timer;
		
		public function BetterTimer(delay:Number, repeat:uint=0):void 
		{
			_delay = delay;
			_repeat = repeat;
			timer = new Timer(delay,repeat);
		}

		public function start():void 
		{
			_lastTime = getTimer();
			timer.start();
		}
		
		public function pause():void 
		{
			timer.stop();
			_thisTime = getTimer() - _lastTime;
		}
		
		public function repeat(new_delay:Number):void 
		{
			_lastTime = getTimer();
			timer.delay = new_delay;
		}
		
		public function resume():void 
		{
			if (_thisTime > timer.delay) 
			{
				_thisTime = timer.delay;
			}
			timer.delay -= _thisTime;
			_lastTime = getTimer();
			timer.start();
			_thisTime = 0;
		}
	}
}