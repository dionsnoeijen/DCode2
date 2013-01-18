package
{
	import com.core.DynamicCenter;
	import com.debug.RedDot;
	import com.debug.WhatsUnderTheMouse;
	import com.events.AssetEvent;
	import com.graphics.asset.*;
	import com.greensock.TimelineMax;
	import com.greensock.TweenMax;
	import com.greensock.easing.*;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	[SWF(width="800", height="800", frameRate="30", backgroundColor="#CCCCCC")]
	public class DCode extends DynamicCenter
	{
		public function DCode()
		{
			// ------------------------
			//	Visual Debugging
			// ------------------------
			this.stage.addEventListener(MouseEvent.MOUSE_DOWN, this.stageDown);
			
			// ------------------------
			//	Give me some margin
			// ------------------------
			var margin:int = 20;
			
			// ------------------------
			//	Default Asset
			// ------------------------
			var defaultAsset:Asset = new Asset();
			defaultAsset.x = 50;
			defaultAsset.y = 50;
			this.addChild(defaultAsset);
			TweenMax.to(defaultAsset, 1, {alpha:1});
			
			// ------------------------
			//	Rectangular Asset with some default settings
			// ------------------------
			this.ai.shape = AssetSetting.RECT;
			this.ai.width = 100;
			this.ai.height = 100;
			this.ai.color = 0x666666;
			var rect:Asset = new Asset(this.ai);
			rect.x = defaultAsset.x + defaultAsset.visibleWidth + margin;
			rect.y = 50;
			this.addChild(rect);
			TweenMax.to(rect, 1, {alpha:1});
			
			// ------------------------
			//	Rectangular Asset with an image
			// 	Like this Asset resizes automatically to the image size.
			// ------------------------
			this.ai.image = '../images/t1.jpg';
			var imageRect:Asset = new Asset(this.ai);
			imageRect.alpha = 1;
			imageRect.addEventListener(AssetEvent.IMAGE_COMPLETE, this.imageRectComplete);
			imageRect.x = rect.x + rect.visibleWidth + margin;
			imageRect.y = 50;
			this.addChild(imageRect);
			TweenMax.to(imageRect, 1, {alpha:1});
			
			// ------------------------
			//	It's also possible to mask the image to the desired size.
			// ------------------------
			this.ai.mask = true;
			var croppedImageRect:Asset = new Asset(this.ai);
			croppedImageRect.addEventListener(AssetEvent.IMAGE_COMPLETE, this.croppedImageRectComplete);
			croppedImageRect.x = imageRect.x + 200 + margin;
			croppedImageRect.y = 50;
			this.addChild(croppedImageRect);
			TweenMax.to(croppedImageRect, 1, {alpha:1});
			
			// ------------------------
			//	Or change the reference point.
			// ------------------------
			var dynamicCenter:Asset = new Asset(this.ai);
			dynamicCenter.x = croppedImageRect.x + croppedImageRect.visibleWidth + margin;
			dynamicCenter.y = 50;
			dynamicCenter.setRegistration(50, 50);
			TweenMax.to(dynamicCenter, 1, {alpha:1});
			var dynamicCenterTimeline:TimelineMax = new TimelineMax({repeat:-1, yoyo:true, repeatDelay:2});
			dynamicCenterTimeline.append(TweenMax.to(dynamicCenter, 5, {rotation2:360, ease:Elastic.easeInOut}));
			this.addChild(dynamicCenter);
			
			var dot:RedDot = new RedDot(0, 0);
			dot.x = croppedImageRect.x + croppedImageRect.visibleWidth + margin + 50;
			dot.y = 100;
			this.addChild(dot);
			
			// ------------------------
			//	Or rectangles with rounded corners of course.
			// ------------------------
			this.ai.reset();
			this.ai.shape = AssetSetting.RNDRECT;
			this.ai.alpha = 1;
			this.ai.width = 100;
			this.ai.height = 100;
			this.ai.color = 0x0000FF;
			this.ai.customShapeSettings = [20];
			var roundedRectangle:Asset = new Asset(this.ai);
			roundedRectangle.x = dynamicCenter.x + dynamicCenter.visibleWidth + margin;
			roundedRectangle.y = 50;
			this.addChild(roundedRectangle);
			
			// ------------------------
			//	Circles
			// ------------------------
			this.ai.reset();
			this.ai.shape = AssetSetting.CIRC;
			this.ai.width = 100;
			this.ai.height = 100;
			this.ai.alpha = 1;
			var circle:Asset = new Asset(this.ai);
			circle.x = 50;
			circle.y = 170 + margin;
			this.addChild(circle);
			
			// ------------------------
			//	Elipses
			// ------------------------
			this.ai.height = 50;
			var elipse:Asset = new Asset(this.ai);
			elipse.x = circle.x + circle.visibleWidth + margin;
			elipse.y = 170 + margin;
			this.addChild(elipse);
			
			// ------------------------
			//	Any shape can contain images
			// ------------------------
			this.ai.mask = true;
			this.ai.image = '../images/t1.jpg';
			var elipseImage:Asset= new Asset(this.ai);
			elipseImage.x = elipse.x + elipse.visibleWidth + margin;
			elipseImage.y = 170 + margin;
			this.addChild(elipseImage);
			
			// ------------------------
			//	Donut, mmm
			// ------------------------
			this.ai.reset();
			this.ai.shape = AssetSetting.DONUT;
			this.ai.alpha = 1;
			this.ai.width = 100;
			this.ai.height = 100;
			var donut:Asset = new Asset(this.ai);
			donut.x = elipseImage.x + elipseImage.visibleWidth + margin + 50;
			donut.y = 170 + margin + 50;
			this.addChild(donut);
			
			// ------------------------
			//	Circle Segment
			// ------------------------
			this.ai.shape = AssetSetting.CIRCLE_SEGMENT;
			this.ai.customShapeSettings = [-90, 270];
			var circleSegment:Asset = new Asset(this.ai);
			circleSegment.x = donut.x + donut.visibleWidth + margin;
			circleSegment.y = 170 + margin + 50;
			this.addChild(circleSegment);
			var circleSegmentTimeline:TimelineMax = new TimelineMax({repeat:-1, yoyo:true, repeatDelay:0});
			circleSegmentTimeline.append(TweenMax.to(circleSegment, 10, {newCustom1:-90, ease:Linear.easeInOut}));
			
			// ------------------------
			//	Polygons
			// ------------------------
			this.ai.reset();
			this.ai.shape = AssetSetting.POLYGON;
			this.ai.color = 0x00FF00;
			this.ai.width = 100;
			this.ai.borderColor = 0xFF0000;
			this.ai.borderThickness = 2;
			this.ai.alpha = 1;
			this.ai.customShapeSettings = [36];
			var a:Asset = new Asset(this.ai);
			a.x = 100;
			a.y = 330 + margin;
			var aTimeline:TimelineMax = new TimelineMax({repeat:-1, yoyo:true, repeatDelay:1.5});
			aTimeline.append(TweenMax.to(a, 10, {newCustom0:3, ease:Linear.easeNone}));
			this.addChild(a);		
			
			// ------------------------
			//	Yep, segmented polygons.
			// ------------------------
			this.ai.shape = AssetSetting.POLYGON_SEGMENT;
			this.ai.color = 0x0FF00;
			this.ai.borderColor = 0xFF0000;
			this.ai.customShapeSettings = [-90, 270, 18];
			var b:Asset = new Asset(this.ai);
			b.x = a.x + a.visibleWidth + margin;
			b.y = 330 + margin;
			var bTimeline:TimelineMax = new TimelineMax({repeat:-1, yoyo:true, repeatDelay:0});
			bTimeline.append(TweenMax.to(b, 10, {newCustom1:-90, ease:Linear.easeInOut}));
			this.addChild(b);
		}
		
		private function imageRectComplete(e:Event):void
		{
			trace("VISIBLE WIDTH:", Asset(e.target).visibleWidth);		
		}
		
		private function croppedImageRectComplete(e:Event):void
		{
			trace("MASK WIDTH:", Asset(e.target).assetMask.width);
			trace("MASKED VISIBLE WIDTH:", Asset(e.target).visibleWidth);
		}
		
		private function stageDown(e:MouseEvent):void
		{
			WhatsUnderTheMouse.showMe(this.stage, this.mouseX, this.mouseY);	
		}
	}
}