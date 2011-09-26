package com.controls
{
	import com.graphics.asset.*;
	import com.core.DynamicCenter;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	public class ScrollBar extends DynamicCenter
	{
		public static const SCROLL_MOVE:String = 'scroll_move';
		
		private var scrub:Asset;
		private var h:Number;
		private var c:uint;
		private var w:Number;
		
		private var _position:Number;
		
		public function ScrollBar(w:Number, h:Number, c:uint, sbH:Number = 80):void
		{
			this.w = w;
			this.h = h;
			this.c = c;
			
			this.ai.width = w;
			this.ai.height = sbH;
			this.ai.alpha = 1;
			this.ai.shape = AssetSetting.RNDRECT;
			
			this.scrub = new Asset(this.ai);
			this.scrub.makeButton(0x666666);
			this.scrub.addEventListener(MouseEvent.MOUSE_DOWN, scrubDown);
			
			this.addChild(this.scrub);
		}
		
		public function updateGraphics(h:Number):void
		{
			this.h = h;
		
			this.graphics.clear();
			this.graphics.lineStyle(1, c, 1, true);
			this.graphics.moveTo(w / 2, 0);
			this.graphics.lineTo(w / 2, h);
			
			//this.scrub.updateShapeSize();
		}
		
		private var difference:Number;
		public function scrubDown(e:MouseEvent):void
		{
			this.stage.addEventListener(MouseEvent.MOUSE_MOVE, scrubMove);
			this.stage.addEventListener(MouseEvent.MOUSE_UP, scrubUp);
			
			difference = this.mouseY - this.scrub.y;
		}
		
		public function scrubMove(e:MouseEvent):void
		{
			this.scrub.y = this.mouseY - difference;
			
			if(this.scrub.y < 0)
			{
				this.scrub.y = 0;
			}
			else if(this.scrub.y > (this.h - this.scrub.visibleHeight))
			{
				this.scrub.y = this.h - this.scrub.visibleHeight;
			}
			
			this.dispatchEvent(new Event(SCROLL_MOVE));
		}
		
		public function scrubUp(e:MouseEvent):void
		{
			this.stage.removeEventListener(MouseEvent.MOUSE_MOVE, scrubMove);
			this.stage.removeEventListener(MouseEvent.MOUSE_UP, scrubUp);
		}
		
		public function get position():Number
		{
			_position = (100 / (this.h - this.scrub.visibleHeight)) * this.scrub.y;
			
			return _position;		
		}
	}
}