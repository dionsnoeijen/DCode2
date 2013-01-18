package com.positioners.ticker
{
	import com.debug.Print;
	import com.graphics.asset.*;
	import com.initial.GlobalStage;
	import com.positioners.ticker.tickercomp.DataRescource;
	
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageQuality;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.MouseEvent;

	public class Ticker extends Sprite
	{
		private var componentStream:Vector.<Asset>;
		private var data:DataRescource;
		
		public var debugging:Boolean = false;
		
		public function Ticker()
		{	
			// -------------------------
			//	Initialize the model
			// -------------------------
			this.data = new DataRescource();
			
			if(this.debugging)
				this.data.debugging = true;
			
			this.data.addEventListener(DataRescource.RESCOURCES_READY, this.init);
			this.componentStream = new Vector.<Asset>();
		}
		
		private function init(e:Event):void
		{	
			this.componentStream = this.data.data;
			// -------------------------
			//	Start the positioning
			// -------------------------
			this.streamVsStage();
			
			// -------------------------
			//	Stage Listeners
			// -------------------------
			GlobalStage.stageInstance.addEventListener(Event.RESIZE, stageResize);
			GlobalStage.stageInstance.addEventListener(Event.ENTER_FRAME, stageEnterFrame);
		}
		
		private function streamVsStage():void
		{
			// -------------------------
			//	If the stream width is smaller then stage, add to stream
			// -------------------------
			var stageCheck:Number = GlobalStage.stageInstance.stageWidth + this.data.widestObject;
			
			if(this.debugging)
				trace('StageWidth + Widest Object', stageCheck);
			
			if(this.streamWidth < stageCheck)
			{
				this.addToStream();
			}
			
			// -------------------------
			//	If this is the first run, and the stream is larger then stage, add components anyway.
			// -------------------------
			if(this.numChildren <= 0)
			{
				if(this.debugging)
					trace('First run, and stream width larger than stage');
				
				this.addToStream();
			}
			
		}
		
		private var copyKey:int = 0;
		private function addToStream():void
		{	
			if(this.debugging)
				trace('Add component to stream');
			
			// -------------------------
			//	Add a copy of an object to the end of the stream
			// -------------------------
			this.componentStream.push(this.data.specificCopy(copyKey));
			this.copyKey++;
			
			if(this.copyKey > this.data.dataLength - 1)
			{
				this.copyKey = 0;
			}
			this.sortAndAddStream();
			this.streamVsStage();
		}
		
		private function sortAndAddStream():void
		{
			// -------------------------
			//	Sort the x positions of the components and add to stage
			// -------------------------
			var prevX:Number = 0;
			for each(var component:Asset in this.componentStream)
			{
				component.addEventListener(MouseEvent.MOUSE_OVER, componentOver);
				component.addEventListener(MouseEvent.MOUSE_OUT, componentOut);
				component.x = prevX;
				
				prevX += component.visibleWidth;
				this.addChild(component);
			}
		}
		
		private function componentOver(e:MouseEvent):void
		{
			GlobalStage.stageInstance.removeEventListener(Event.ENTER_FRAME, stageEnterFrame);
		}
		
		private function componentOut(e:MouseEvent):void
		{
			GlobalStage.stageInstance.addEventListener(Event.ENTER_FRAME, stageEnterFrame);
		}
		
		private function get streamWidth():Number
		{
			// -------------------------
			//	Get the total stream width
			// -------------------------
			var streamWidth:Number = 0;
			for each(var component:Asset in this.componentStream)
			{
				streamWidth += component.visibleWidth;
			}	
			return streamWidth;
		}
		
		private function stageResize(e:Event):void
		{
			// -------------------------
			//	If the stage is resized, rethink your sins
			// -------------------------
			this.streamVsStage();
		}
		
		private function stageEnterFrame(e:Event):void
		{
			// -------------------------
			//	Animate all objects with one px per frame
			// -------------------------
			for each(var component:Asset in this.componentStream)
			{
				component.x -= 1;
			}
			
			// -------------------------
			//	Check if a component fell off stage, if so, take action
			// -------------------------
			var firstComponent:Asset = this.componentStream[0];
			var difference:Number = firstComponent.x * -1;
			if(difference >= firstComponent.width)
			{
				this.removeChild(this.componentStream.shift());
				this.streamVsStage();
				
				if(this.debugging)
					trace('Component Count:', this.componentStream.length);
			}
		}
	}
}