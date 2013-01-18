package com.debug
{
	import com.events.DebugEvent;
	import com.graphics.asset.Asset;
	
	import flash.events.Event;
	import flash.events.MouseEvent;

	public class Alert extends Asset
	{
		private var close:Asset;
		
		public function Alert(text:String, show:Boolean = true):void
		{
			if(show)
			{
				this.ai.width = 400;
				this.ai.height = 300;
				this.ai.color = 0xFFFFFF;
				this.ai.alpha = 1;
				this.ai.borderColor = 0xFF0000;
				this.ai.borderThickness = 2;
				super(this.ai);
				
				this.at.html = text;
				this.at.padding = 20;
				this.setText(this.at);
				
				this.ai.reset();
				this.ai.color = 0xFF0000;
				this.ai.alpha = 1;
				this.close = new Asset(this.ai);
				this.close.makeButton(0xCCCCCC);
				this.close.addEventListener(MouseEvent.MOUSE_DOWN, closeDown);
				
				this.addEventListener(MouseEvent.MOUSE_DOWN, thisDown);
				this.addEventListener(MouseEvent.MOUSE_UP, thisUp);
				
				this.addChild(this.close);
			}
		}
		
		private function closeDown(e:MouseEvent):void
		{
			dispatchEvent(new Event(DebugEvent.CLOSE_ALERT));
		}
		
		private function thisDown(e:MouseEvent):void
		{
			this.startDrag();
		}
		
		private function thisUp(e:MouseEvent):void
		{
			this.stopDrag();	
		}
	}
}