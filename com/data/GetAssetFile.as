/**
 * 	Fetch .swf containing assets (bitmap files, movieclips... whatever)
 */
package com.data
{
	import com.data.GlobalDataContainer;
	import com.events.DataEvent;
	
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.system.ApplicationDomain;
	import flash.system.LoaderContext;
	import flash.utils.ByteArray;
	
	public final class GetAssetFile extends EventDispatcher
	{
		private var _assetLoader:Loader;
		private var _asset:LoaderInfo;
		
		public function GetAssetFile(embeddedAsset:Class)
		{
			if(!GlobalDataContainer.vars.preloadedAssets)
			{
				this._assetLoader = new Loader();
				this._assetLoader.contentLoaderInfo.addEventListener(Event.COMPLETE, this.assetLoaderComplete);
				this._assetLoader.loadBytes(new embeddedAsset as ByteArray, new LoaderContext(false, ApplicationDomain.currentDomain));
			}
			else
			{
				this.dispatchEvent(new Event(DataEvent.ASSET_FILE_COMPLETE));
			}
		}
		
		private function assetLoaderComplete(e:Event):void
		{
			// -------------------------
			// 	Recieve the embedded swf's LoaderInfo
			// -------------------------
			this._asset = e.currentTarget as LoaderInfo;
			GlobalDataContainer.vars.preloadedAssets = true;
			this.dispatchEvent(new Event(DataEvent.ASSET_FILE_COMPLETE));
		}
		
		public function getClass(className:String):Class 
		{
			try 
			{
				return _asset.applicationDomain.getDefinition(className) as Class;
			}
			catch (e:Error) 
			{
				trace("GetAssetFile::getClass(" + className + ") Failed");
			}
			return null;
		}
	}
}