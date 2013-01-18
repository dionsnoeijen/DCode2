package com.positioners
{
	import com.tools.DynamicCenter;
	import flash.display.Sprite;
	import flash.events.Event;
	
	public class Pattern extends DynamicCenter
	{
		private var patternItems		:Array;
		private var pattern				:DynamicCenter;
		private var margin				:Number;
		private var extraSpace			:Number;
		private var angle				:String;
		
		public const HORIZONTAL			:String = 'horizontal';
		public const VERTICAL			:String = 'vertical';
		public const UP					:String = 'up';
		public const DOWN				:String = 'down';
		public const LEFT				:String = 'left';
		public const RIGHT				:String = 'right';
		
		public function Pattern():void
		{
			//Maak container voor eventueel eenvoudige selectie.
			pattern = new DynamicCenter();
			addChild(pattern);
		}
		
		public function updatePattern(pItems:Array, line:String = HORIZONTAL, direction:String = DOWN, m:Number = 0):void
		{
			//Verwijder alle children van de display list. 
			deletePattern();
			patternItems = pItems;
			margin = m;
			angle = line;
			
			//Plaats de nieuwe items op de stage.
			var i:int;
			for each(var patternItem:Array in patternItems)
			{
				if(angle == HORIZONTAL)
				{
					patternItem[0].x = extraSpace + (patternItem[0].visibleWidth * i);
					patternItem[0].vars.positionX = extraSpace + (patternItem[0].visibleWidth * i);
				
					extraSpace = margin * i;
					patternItem[0].x = (patternItem[0].visibleWidth + margin) * i;
					patternItem[0].vars.positionX = (patternItem[0].visibleWidth + margin) * i;
				}
				else
				{
					if(direction == DOWN)
					{
						extraSpace = margin * i;
						patternItem[0].y = (patternItem[0].visibleHeight + margin) * i;
					}
					else
					{	
						extraSpace = margin * i;
						patternItem[0].y = -((patternItem[0].visibleHeight + margin) * i);	
					}
				}
				pattern.addChild(patternItem[0]);
				
				i++;
			}
			i = 0;
			
			dispatchEvent(new Event(Event.COMPLETE));
		}
		
		public function deletePattern():void
		{
			var loopCount:int = pattern.numChildren;
			
			for(var i:int = 0 ; i < loopCount ; i++)
			{	
				pattern.removeChildAt(0);
			}
		}
		
		public function get visibleWidth():Number
		{
			var _visibleWidth:Number = 0;
			
			var loopCount:int = pattern.numChildren;
			
			if(angle == HORIZONTAL)
			{
				for(var i:int = 0 ; i < loopCount ; i++)
				{
					var amount:Number = patternItems[i][0].visibleWidth;
					_visibleWidth += amount + margin;	
				}
				
				_visibleWidth -= margin;
			}
			
			return _visibleWidth;
		}
		
		public function get visibleHeight():Number
		{
			var _visibleHeight:Number = 0;
			
			var loopCount:int = pattern.numChildren;
			
			if(angle != HORIZONTAL)
			{
				for(var i:int = 0 ; i < loopCount ; i++)
				{
					
					var amount:Number = patternItems[i][0].visibleHeight;
					_visibleHeight += amount + margin;		
				}
				
				_visibleHeight -= margin;
			}	
			
			return _visibleHeight;
		}
	}
}