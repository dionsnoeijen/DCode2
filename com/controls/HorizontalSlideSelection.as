package com.controls
{
	import com.graphics.asset.Asset;
	import com.greensock.TweenMax;
	import com.tools.FindClosest;
	
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.MouseEvent;

	public class HorizontalSlideSelection extends Sprite
	{
		private var bg				:Asset;
		private var fg				:Asset;
		private var padding			:Number;
		private var steps			:Number;
		private var stepSize		:Number;
		private var stepPositions	:Array;
		
		private var bgComplete		:Boolean;
		private var fgComplete		:Boolean;
		public var debugging		:Boolean = false;
		
		public static const CHANGE:String = 'change';
		
		public function HorizontalSlideSelection(bgPath:String = null,
												 fgPath:String = null,
												 bgAlpha:Number = 1,
												 fgAlpha:Number = 1,
												 steps:Number = 5,
											     bgWidth:Number = 10, 
											     bgHeight:Number = 10, 
												 fgWidth:Number = 10,
												 fgHeight:Number = 10,
											     bgColor:uint = 0xFFFFFF, 
											     fgColor:uint = 0xFFFFFF,
												 padding:Number = 2
											     ):void
		{
			this.padding = padding;
			this.steps = steps;
			
			this.bg = new Asset(Asset.RECT, bgWidth, bgHeight, bgColor, bgAlpha);
			this.fg = new Asset(Asset.RECT, fgWidth, fgHeight, fgColor, fgAlpha);
			
			if(bgPath)
			{
				this.bg.setImage(bgPath, Asset.ASSET_TO_IMAGE);
				this.bg.addEventListener(Event.COMPLETE, bgImageComplete);
			}
			else
			{
				this.bgComplete = true;
				if(this.bgComplete && this.fgComplete)
					this.startBuild();
			}
			
			if(fgPath)
			{
				this.fg.setImage(fgPath, Asset.ASSET_TO_IMAGE);
				this.fg.addEventListener(Event.COMPLETE, fgImageComplete);
			}
			else
			{
				this.fgComplete = true;
				if(this.fgComplete && this.bgComplete)
					this.startBuild();
			}
		}
		
		private function bgImageComplete(e:Event):void
		{
			this.bgComplete = true;
			if(this.bgComplete && this.fgComplete)
				this.startBuild();
		}
		
		private function fgImageComplete(e:Event):void
		{
			this.fgComplete = true;
			if(this.fgComplete && this.bgComplete)
				this.startBuild();
		}
		
		private var maxX:Number;
		private function startBuild():void
		{		
			this.addChild(this.bg);
			
			this.stepSize = (this.bg.visibleWidth - (2 * padding)) / this.steps;
			
			if(debugging)
			{
				trace('STEP SIZE:', this.stepSize, 'FG WIDTH:', this.fg.visibleWidth, 'BG WIDTH:', this.bg.visibleWidth);
			}
			
			this.stepPositions = new Array();
			
			for(var i:int = 0 ; i < this.steps ; i++)
			{
				var val:Number = i * this.stepSize;
				if(val <= 0)
				{
					val = this.padding;
				}
				
				this.stepPositions.push(val);
				
				if(debugging)
				{
					trace(val);
				}
			}
			
			this.maxX = (this.bg.visibleWidth - this.fg.visibleWidth) - (padding * 2);
			this.fg.addEventListener(MouseEvent.MOUSE_DOWN, fgDown);
			this.fg.x = this.fg.y = this.padding;
			this.addChild(this.fg);
		}
		
		private var startX:Number;
		private function fgDown(e:MouseEvent):void
		{
			this.startX = this.fg.mouseX;
			this.stage.addEventListener(MouseEvent.MOUSE_MOVE, stageMove);
			this.stage.addEventListener(MouseEvent.MOUSE_UP, stageUp);
		}
		
		private function stageMove(e:MouseEvent):void
		{
			this.fg.x = (this.mouseX - this.startX);		
			
			if(this.fg.x < 2)
			{
				this.fg.x = 2;
			}
			else if(this.fg.x > this.maxX)
			{
				this.fg.x = this.maxX;
			}
		}
		
		private function stageUp(e:MouseEvent):void
		{
			this.stage.removeEventListener(MouseEvent.MOUSE_MOVE, stageMove);
			this.stage.removeEventListener(MouseEvent.MOUSE_UP, stageUp);
			this.moveToClosest();
		}
		
		private var closestValue:Number;
		private function moveToClosest():void
		{
			var fgPos:Number = this.fg.x;
			
			closestValue = FindClosest.number(this.stepPositions, fgPos);
			
			this.dispatchEvent(new Event(CHANGE));
			
			TweenMax.to(this.fg, .3, {x:closestValue});
		}
		
		public function get position():int
		{
			var pos:int = 0;
			
			if(this.stepPositions)
			{
				for(pos ; pos <= this.stepPositions.length ; pos++)
				{
					if(this.closestValue == Number(this.stepPositions[pos]))
					{
						break;
					}
				}
			}
			return pos;
		}
	}
}