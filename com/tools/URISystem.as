/**
 * URISystem (singleton)
 *
 * Author: Dion Snoeijen
 * Date: 30-06-2010
 *
 * Functionality:
 *	- Update URI with hash and location data.
 * 	- Return URI data before hash.
 * 	- Return URI data after hash.
 * 	- Detect browser prev or next down.
 */
package com.tools
{
	import com.events.URIEvent;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.external.ExternalInterface;
	import flash.net.URLRequest;
	import flash.net.navigateToURL;
	import flash.utils.setInterval;
	
	public class URISystem extends EventDispatcher
	{	
		private static var instance				:URISystem;
		private static var allowInstantiation	:Boolean;
		
		private var currentHash					:String;
		private var allowDispatch				:Boolean;
		
		public var debugging					:Boolean = false;
		
		/**
		 * <p><strong>getInstance()</strong><br />
		 * This is a Singleton class so it can be used through the entire project.</p>
		 * 
		 * @return the URISystem class
		 */
		public static function getInstance():URISystem 
		{
			if (instance == null)
			{
				allowInstantiation = true;
				instance = new URISystem();
				allowInstantiation = false;
			}
			return instance;
		}
		
		public function URISystem():void
		{
			if (!allowInstantiation) 
			{
				throw new Error("Error: Instantiation failed: Use URISystem.getInstance() instead of new.");
			}
			else
			{
				this.allowDispatch = false;
				this.currentHash = this.getURIAfterHash();
				var interval:Number = setInterval(this.checkHash, 100);
			}
		}
		
		/**
		 * <p><strong>getURIBeforeHash()</strong></p>
		 * 
		 * @return everything before the hash tag
		 */
		public function getURIBeforeHash():String
		{
			var segment:Array;
			var returnVal:String;
			
			try
			{
				var curUrl:String = String(ExternalInterface.call("function(){return document.location.href.toString();}"));
				segment = curUrl.split("#");
				returnVal = segment[0];
			}
			catch(error:Error)
			{
				dispatchEvent(new Event(URIEvent.URI_BEFORE_HASH_ERROR));
				returnVal = '';
			}
			
			return returnVal;
		}
		
		/**
		 * <p><strong>isLastSlash();</strong></p>
		 * 
		 * @return true if the last component in the path is a /
		 */
		public function isLastSlash():Boolean
		{
			var lastHash:Boolean = false;
			var curUrl:String = String(ExternalInterface.call("function(){return document.location.href.toString();}"));
			
			if(curUrl.substr(-1, 1) == '/')
			{
				lastHash = true;
			}
			
			return lastHash;
		}
		
		/**
		 * <p<strong>getURIAfterHash();</strong>
		 * Return the value after the hash in the URL.</p>
		 * 
		 * @return everything after the hash tag.
		 */
		public function getURIAfterHash():String
		{	
			var segment:Array;
			var returnVal:String = '';
			
			try
			{													
				var curUrl:String = String(ExternalInterface.call("function(){return document.location.href.toString();}"));
				segment = curUrl.split("#");
				if(segment[1])
				{
					var retV:Array = String(segment[1].slice(1)).split("?");
					returnVal = String(retV[0]);
					
					if(this.debugging)
						trace('URISystem.getURIAfterHash()', returnVal);
				}
				else
				{
					returnVal = '';
				}
			}
			catch(error:Error)
			{
				dispatchEvent(new Event(URIEvent.URI_AFTER_HASH_ERROR));
				returnVal = '';
			}

			return returnVal;
		}
		
		/**
		 * <p><strong>checkHash();</strong><br />
		 * Interval function to check if the URI has changed.<br />
		 * If the uri changed check if it came from a internal uri change or from the browser back button.</p> 
		 */
		public function checkHash():void
		{
			if(this.currentHash != this.getURIAfterHash())
			{
				this.currentHash = this.getURIAfterHash();
				
				if(this.allowDispatch)
				{
					this.dispatchEvent(new Event(URIEvent.URI_BROWSER_BACK_DOWN, true));
				}
				else
				{
					this.allowDispatch = true;
				}
			}
		}
		
		/**
		 * <p><strong>setLocation();</strong><br />
		 * Update the URI</p>
		 */
		public function setLocation(loc:String):void
		{
			if(this.debugging)
				trace('URISysten.setLocation(loc:String): getURIAfterHash:', this.getURIAfterHash(), 'LOC:', loc);
			
			if(this.getURIAfterHash() != loc)
			{
				// ------------------------
				//	The URI is updated from the swf, meaning it's certainly not the browser back button.
				// ------------------------
				if(this.getURIAfterHash() != '')
				{
					this.allowDispatch = false;
				}
				
				var hash:String = "#/";				
				var url:String = this.getURIBeforeHash() + hash + loc;
				var request:URLRequest = new URLRequest(url);
				
				try 
				{
					navigateToURL(request, "_self");
				} 
				catch (error:Error)
				{
					dispatchEvent(new Event(URIEvent.URI_SET_ERROR));
				}
			}
		}
	}
}