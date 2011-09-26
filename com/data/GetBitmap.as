/**
 * GetBitmap
 *
 * Author: Dion Snoeijen
 * Date 02-04-2010
 * 
 * Smooth image by url
 * 
 * Update:
 * 09-11-2010: Added the loader context.
 */
package com.data
{
	import flash.display.Bitmap;
	import flash.display.Loader;
	import flash.errors.IOError;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.net.URLRequest;
	import flash.system.LoaderContext;
		
	public final class GetBitmap extends Bitmap
	{
		public function GetBitmap(path:String):void
		{
			var loaderContext:LoaderContext = new LoaderContext();
			loaderContext.checkPolicyFile = true;
			
			var l:Loader = new Loader();
			l.contentLoaderInfo.addEventListener(Event.COMPLETE, returnBitmap);		
			l.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, ioError);
			l.load(new URLRequest(path), loaderContext);
		}
		
		private function ioError(e:IOErrorEvent):void
		{
			trace('Image loading ERROR:', e);
		}
		
		private function returnBitmap(e:Event):void
		{
			this.bitmapData = e.target.content.bitmapData;
			this.smoothing = true;
			this.dispatchEvent(new Event(Event.COMPLETE));
		}
	}
}