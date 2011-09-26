/**
 * 	This thing is old and messy.
 *  TODO: Remove in DCode2.1
 */
package com.animation
{
	import com.tools.RandomNumber;
	
	import flash.events.Event;
	
	public class CircularMovement
	{
		public static const LEFT:String = 'left';
		public static const RIGHT:String = 'right';
		public static const RANDOM:String = 'random';
		
		public var dampen:Number = 0.95;
		
		public function CircularMovement(items:Array, direction:String = RANDOM):void
		{
			for each(var item:Array in items)
			{
				//See if motion can be applied
				if(!item[0].vars.lf)
				{
					item[0].addEventListener(Event.ENTER_FRAME, animate);
					//Init item variables
					item[0].vars.vx = item[0].x;
					item[0].vars.vy = item[0].y;
					item[0].vars.radius = Math.random() * RandomNumber.randomNumber(5, 10);
					item[0].vars.speed = Math.random() * RandomNumber.randomNumber(4, 5);
					item[0].vars.radian = 0;
					item[0].vars.degree = 0;
					item[0].vars.direction = direction;
					item[0].vars.lf = true;
				}
			}
		}
		
		private function animate(e:Event):void
		{
			/**
			 * Mysterious problem causing move back to original position occuring here.
			 */
			
			/*
			var item:Object = e.target;
			
			item.vars.degree += item.vars.speed;
			item.vars.radian = (item.vars.degree / 180) * Math.PI;
			
			item.vars.vx += Math.cos(item.vars.radian) * item.vars.radius;
			item.vars.vy -= Math.sin(item.vars.radian) * item.vars.radius;
			
			item.x = item.vars.vx;
			item.y = item.vars.vy;
			*/
			/*
			switch(item.vars.direction)
			{
				case LEFT:
					item.x = item.vars.vx + Math.cos(item.vars.radian) * item.vars.radius;
					item.y = item.vars.vy - Math.sin(item.vars.radian) * item.vars.radius;
					break;
				case RIGHT:
					item.x = item.vars.vx - Math.cos(item.vars.radian) * item.vars.radius;
					item.y = item.vars.vy + Math.sin(item.vars.radian) * item.vars.radius;
					break;
				case RANDOM:
					var r:Number = Math.random();
					if(r <= .5)
					{
						item.vars.direction = LEFT;
						item.x = item.vars.vx + Math.sin(item.vars.radian) * item.vars.radius;
						item.y = item.vars.vy - Math.cos(e.currentTarget.vars.radian) * item.vars.radius;
						//trace(r, LEFT);
					}
					else
					{
						item.vars.direction = RIGHT;
						item.x = item.vars.vx - Math.sin(item.vars.radian) / item.vars.radius;
						item.y = item.vars.vy + Math.cos(item.vars.radian) / item.vars.radius;
						//trace(r, RIGHT);
					}
					break;
				default:
					throw new Error('Class: CircularMovement  |  Method: animate  |  ERROR: No Direction');
			}
			*/
		}
		
		public function stopMovement(items:Array):void
		{
			//trace('CIRCULAR MOVEMENT STOPPING MOVEMENT');
			for each(var item:Array in items)
			{
				//trace('stop');
				item[0].removeEventListener(Event.ENTER_FRAME, animate);		
			}		
		}
		
		public function continueMovement(items:Array):void
		{
			//trace('CIRCULAR MOVEMENT CONTINUE MOVEMENT');
			for each(var item:Array in items)
			{
				item[0].addEventListener(Event.ENTER_FRAME, animate);			
			}
		}
	}
}