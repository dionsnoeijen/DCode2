package com.graphics
{
	import com.core.DynamicFilter;
	import com.data.GlobalDataContainer;
	import com.graphics.asset.Asset;
	import com.greensock.TweenMax;
	import com.greensock.easing.*;
	import com.greensock.plugins.*;
	import com.tools.Bookmark;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import com.graphics.asset.Asset;
	
	public class SlideViewer extends Sprite
	{	
		public var loadingWhat				:String;
		public var currentPosition			:int;
		public var total					:int;
		public var resizing 				:Boolean = true;
		
		private var viewerContainer			:Sprite;
		private var viewer					:Sprite;
		private var counter					:Number;
		private var foundPrevLoaded			:Boolean;
		private var updateWidth				:Number;
		private var updateHeight			:Number;
		
		private var flvPlayers				:Array;			
		
		private var countLoaded				:int;
		private var allowLayoutResize		:Boolean;
		
		public static const NO_NEXT			:String = 'no_next';
		public static const NO_PREV			:String = 'no_prev';
		public static const NEXT_PREV		:String = 'next_prev';
		public static const SLIDE_CLOSE		:String = 'slide_close';
		
		public var current					:Asset;
		public var bg						:Asset;
		
		public var pH						:Number;
		
		private var _slidesActive			:Boolean;
		
		public function SlideViewer():void
		{	
			TweenPlugin.activate([MotionBlurPlugin]);
			
			this.viewerContainer = new Sprite();
			this.viewer = new Sprite();
			
			this._slidesActive = false;
			
			this.viewerContainer.addChild(viewer);
			this.addChild(viewerContainer);
		}
		
		private var fade:Boolean;
		public function updateViewer(imagePaths:Array, width:Number, height:Number, autoFadeIn:Boolean = true):void
		{	
			/**
			 *
			 * Load external images or get them from 
			 * GlobalDataContainer
			 *
			 */
			
			this.fade = autoFadeIn;
			
			if(this.fade)
			{
				this.alpha = 0;
			}
			this.allowLayoutResize = false;
			this.pH = height;
			
			this._slidesActive = true;
			this.total = imagePaths.length;
			this.deleteViewer(false);
			
			var placeTheseImages:Array = new Array();
			this.foundPrevLoaded = false;
			
			updateWidth = width;
			updateHeight = height;
			
			allowLayoutResize = false;
			flvPlayers = new Array();
			
			if(this.loadingWhat == null)
			{
				this.loadingWhat = 'slide_viewer';
			}
			
			//Init the GlobalDataContainer.vars.loaded array.
			if(!GlobalDataContainer.vars.loaded)
			{
				GlobalDataContainer.vars.loaded = new Array();
			}
			
			//Existing loaded elements found?
			for each(var compare:Array in GlobalDataContainer.vars.loaded)
			{
				if(compare[1] == loadingWhat)
				{
					placeTheseImages.push(compare[0]);
					foundPrevLoaded = true;
					allowLayoutResize = true;
				}
			}
			
			if(!foundPrevLoaded)
			{	
				for each(var imagePath:String in  imagePaths)
				{
					var selector:int = GlobalDataContainer.vars.loaded.length;
					GlobalDataContainer.vars.loaded.push([new Asset(Asset.RECT, width, height, 0xFFFFFF, 0, true), this.loadingWhat]);
					GlobalDataContainer.vars.loaded[selector][0].addEventListener(Event.COMPLETE, imageLoadingComplete);				
					
					//See if we are dealing with a flv or image
					var checkImagePath:String = imagePath.substr(imagePath.length - 3, 3); 
					if(checkImagePath == 'flv' || checkImagePath == 'FLV' || checkImagePath == 'f4v')
					{
						GlobalDataContainer.vars.loaded[selector][0].setVideo(imagePath);
						GlobalDataContainer.vars.loaded[selector][0].name = 'flv';
						
						flvPlayers.push(GlobalDataContainer.vars.loaded[selector]);
					}
					else if(checkImagePath == 'swf')
					{
						GlobalDataContainer.vars.loaded[selector][0].setSwf(imagePath);
					}
					else
					{
						GlobalDataContainer.vars.loaded[selector][0].setImage(imagePath, Asset.NO_LEADING, Asset.ALIGN_RIGHT);
						GlobalDataContainer.vars.loaded[selector][0].name = 'bmp';
					}
					
					placeTheseImages.push(GlobalDataContainer.vars.loaded[selector][0]);	
				}
				
				dispatchEvent(new Event(NO_PREV));
			}
			
			//Place selected images
			this.placeImages(placeTheseImages);
		}
		
		private function imageLoadingComplete(e:Event):void
		{
			this.countLoaded++;
			if(countLoaded == total)
			{
				this.allowLayoutResize = true;
				this.countLoaded = 0;
				dispatchEvent(new Event(Event.COMPLETE));
				this.showPrevNextButtons();
				if(this.fade)
				{
					TweenMax.to(this, 1, {alpha:1});	
				}
			}
		}
		
		private function placeImages(imageArray:Array):void
		{
			//Plaats de geselecteerde afbeeldingen achter elkaar.
			var i:int = 0;
			for each(var image:Asset in imageArray)
			{
				image.x = i == 0 ? 0 : image.width * i;
				this.viewer.addChild(image);
				i++;
			}
			
			if(this.foundPrevLoaded)
			{
				this.resizeViewer(updateWidth, updateHeight);
			}
		}
		
		private var loopCount:int;
		public function deleteViewer(fancy:Boolean):void
		{
			this.wait = 0;
			this.loopCount = this.viewer.numChildren;
			
			if(!fancy)
			{
				for(var i:int = 0 ; i < loopCount ; i++)
				{	
					this.viewer.removeChildAt(0);
				}
			}
			else
			{
				for(var j:int = loopCount - 1 ; j >= 0 ; j--)
				{
					TweenMax.to(this.viewer.getChildAt(j), .3, {x:0, onComplete:moveDown, onCompleteParams:[this.viewer.getChildAt(j)]});
				}
			}
			this.currentPosition = 0;
			this.counter = 0;
			this.viewer.x = 0;
		}
		
		private var wait:int;
		private function moveDown(c:Asset):void
		{
			this.wait++;
			if(this.wait == this.loopCount)
			{
				for(var j:int = loopCount - 1 ; j >= 0 ; j--)
				{
					var delayTotal:Number = (loopCount - 1) * .1;
					var delay:Number = j * .1;
					TweenMax.to(this.viewer.getChildAt(j), .5, {delay:delayTotal - delay, y:this.pH, onComplete:rc, onCompleteParams:[this.viewer.getChildAt(j)], ease:Back.easeInOut});
				}
				
				this.wait = 0;
			}
		}
		
		private function rc(c:Asset):void
		{
			this.wait++;
			
			this.allowLayoutResize = false;
			this.viewer.removeChild(c);
			c.y = 0;
			this._slidesActive = false;
			
			if(this.wait == this.loopCount)
			{
				dispatchEvent(new Event(SLIDE_CLOSE));
			}
		}
		
		public function next(sw:Number, sh:Number):void
		{
			var totalChildren:int = this.viewer.numChildren;
			if(counter < (totalChildren - 1))
			{
				this.resizeViewer(sw, sh, 'next');
				
				TweenMax.to(viewer.getChildAt(counter), 1, {x:-(Asset(viewer.getChildAt(counter)).visibleWidth), ease:Back.easeInOut});
				TweenMax.to(viewer.getChildAt(counter + 1), 1, {x:0, ease:Back.easeInOut});
				
				this.counter++;
				this.currentPosition = counter;
				
				this.pauseAllFlvPlayers();
				
				if(viewer.getChildAt(counter).name == 'flv')
				{
					current = Asset(viewer.getChildAt(counter));
					current.videoPlay();
				}
				else
				{
					current = null;
				}
			}
			
			if(counter == (totalChildren - 1))
			{
				dispatchEvent(new Event(NO_NEXT));
			}
		}
		
		public function prev(sw:Number, sh:Number):void
		{
			if(counter > 0)
			{
				resizeViewer(sw, sh, 'prev');
				
				TweenMax.to(viewer.getChildAt(counter), 1, {x:Asset(viewer.getChildAt(counter)).visibleWidth, ease:Back.easeInOut});
				TweenMax.to(viewer.getChildAt(counter - 1), 1, {x:0, ease:Back.easeInOut});
				
				counter--;
				
				currentPosition = counter;
				
				this.pauseAllFlvPlayers();
				
				if(viewer.getChildAt(counter).name == 'flv')
				{
					current = Asset(viewer.getChildAt(counter));
					current.videoPlay();
				}
				else
				{
					current = null;
				}
			}
			
			if(counter == 0)
			{
				dispatchEvent(new Event(NO_PREV));			
			}
		}
		
		public function pauseAllFlvPlayers():void
		{
			for each(var player:Asset in flvPlayers)
			{
				player.videoPause();	
			}
		}
		
		public function resizeViewer(newStageWidth:Number, newStageHeight:Number, sel:String = 'neutral'):void
		{	
			this.pH = newStageHeight;
			var selector:int;
			
			if(sel == 'neutral')
			{
				selector = counter;
			}	
			else if(sel == 'next')
			{	
				selector = counter + 1;
			}
			else if(sel == 'prev')
			{
				selector = counter - 1;
			}
			
			//Resize
			if(resizing)
			{
				if(allowLayoutResize || viewer.numChildren > 0)
				{
					//trace('SlideViewer() selector:', selector);
					Asset(viewer.getChildAt(selector)).resizeAsset(newStageWidth, newStageHeight);	
				}
			}
			//Move images in front or at the end of active image
			var loopCount:Number = this.viewer.numChildren;
			
			for(var i:int = 0 ; i < loopCount ; i++)
			{
				if(i > counter)
				{
					this.viewer.getChildAt(i).x = Asset(this.viewer.getChildAt(counter)).visibleWidth;
				}
				else if(i < counter)
				{
					this.viewer.getChildAt(i).x = -(Asset(this.viewer.getChildAt(i)).visibleWidth);
				}
			} 
		}
		
		private function showPrevNextButtons():void
		{
			dispatchEvent(new Event(NEXT_PREV));		
		}
		
		public function get slidesActive():Boolean
		{
			return this._slidesActive;
		}
	}
}