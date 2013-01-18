package com.positioners.ticker.tickercomp
{
	import com.events.AssetEvent;
	import com.events.ModelEvent;
	import com.graphics.asset.*;
	import com.greensock.TweenMax;
	import com.initial.Model;
	
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.net.URLRequest;
	import flash.net.navigateToURL;
	
	public class DataRescource extends Model
	{
		private var _data:Vector.<Asset>;
		private var paths:Array;
		private var _dataLength:int;
		
		private var brandPathList:XMLList;
		
		public static const RESCOURCES_READY:String = 'rescources_ready';
		
		public function DataRescource()
		{	
			// -------------------------
			//	Get the xml
			// -------------------------
			this.getData('tickerData');
			this.addEventListener(ModelEvent.DATA_LOADED, this.thisLoaded);
			
			// -------------------------
			//	Initialize
			// -------------------------
			this._data = new Vector.<Asset>();
			this.paths = new Array();
		}
		
		private function thisLoaded(e:Event):void
		{
			this.brandPathList = new XMLList(this.xml.brands);
			
			// -------------------------
			//	Create
			// -------------------------
			var i:int = 0;
			for each(var path:String in this.brandPathList.brand.@src)
			{
				this.paths.push(new Array(path));
				
				var ai:AssetInitializer = new AssetInitializer();
				this._data.push(new Asset());
				this._data[i].addEventListener(AssetEvent.IMAGE_COMPLETE, this.imageLoaded);
				this._data[i].setImage(path, AssetSetting.ASSET_TO_IMAGE);
				this._data[i].name = String(i);
				
				i++;
			}
			var j:int;
			for each(var link:String in this.brandPathList.brand.@link)
			{
				this.paths[j].push(link);
				j++;
			}			
			this._dataLength = this._data.length;	
		}
		
		private var preloadCounter:int = 0;
		private function imageLoaded(e:Event):void
		{
			var image:Asset = Asset(e.currentTarget);
			TweenMax.to(image, 0, {colorMatrixFilter:{colorize:0xFFFFFF, amount:1}});
			
			image.addEventListener(MouseEvent.MOUSE_OVER, this.glowObject);
			image.addEventListener(MouseEvent.MOUSE_OUT, this.greyObject);
			image.addEventListener(MouseEvent.MOUSE_DOWN, this.imageDown);
			
			this.paths[int(image.name)].push(image.width);
			this.preloadCounter++;
			if(this._data.length == this.preloadCounter)
			{
				this.dispatchEvent(new Event(RESCOURCES_READY));
			}
		}
		
		/**
		 * 	Return the length of the data.
		 */
		public function get dataLength():int
		{
			return this._dataLength;
		}
		
		/**
		 * 	Return the initally created objects.
		 */
		public function get data():Vector.<Asset>
		{
			return this._data;
		}
		
		/**
		 *	Return a specific copy of a initially created object.
		 */
		public function specificCopy(key:int):Asset
		{
			if(this.debugging)
				trace('SpecificCopy Width:', this.paths[key][2]);
			
			var ai:AssetInitializer = new AssetInitializer();
			ai.width = this.paths[key][2];
			
			var copy:Asset = new Asset(ai);
			
			copy.name = String(key);
			copy.addEventListener(AssetEvent.IMAGE_COMPLETE, this.copyComplete);
			copy.setImage(this.paths[key][0], AssetSetting.ASSET_TO_IMAGE);
			
			TweenMax.to(copy, 0, {colorMatrixFilter:{colorize:0xFFFFFF, amount:1}});
			return copy;
		}
		
		private function copyComplete(e:Event):void
		{
			var copy:Asset = Asset(e.currentTarget);
			copy.addEventListener(MouseEvent.MOUSE_OVER, glowObject);
			copy.addEventListener(MouseEvent.MOUSE_OUT, greyObject);
			copy.addEventListener(MouseEvent.MOUSE_DOWN, imageDown);
		}
		
		private function glowObject(e:MouseEvent):void
		{
			var image:Asset = Asset(e.currentTarget);
			
			TweenMax.to(image, 1, {colorMatrixFilter:{amount:1}});
		}
		
		private function greyObject(e:MouseEvent):void
		{
			var image:Asset = Asset(e.currentTarget);
			
			TweenMax.to(image, 1, {colorMatrixFilter:{colorize:0xFFFFFF, amount:1}});
		}
		
		private function imageDown(e:MouseEvent):void
		{
			var image:Asset = Asset(e.currentTarget);
			var link:String = this.paths[int(image.name)][1];
			
			if(link != '')
			{
				navigateToURL(new URLRequest(link), "_blank");	
			}
		}
		
		/**
		 * 	On external data, differences in width may be there.
		 *  Return the widest object to use in the ticker.
		 */
		private var widest:Number = 0;
		public function get widestObject():Number
		{
			if(this.widest == 0)
			{
				var temp:Number = 0;
				for each(var item:Asset in this._data)
				{
					if(item.visibleWidth > this.widest)
					{
						temp = item.visibleWidth;
					}
				}
				this.widest = temp;
			}
			return this.widest;
		}
	}
}