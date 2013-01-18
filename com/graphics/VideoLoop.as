/** 
 * Creates an automatically looping video. 
 * @author Devon O. 
 * @version 0.1 
 */  
package com.graphics 
{  
	import flash.events.AsyncErrorEvent;
	import flash.events.NetStatusEvent;
	import flash.media.Video;
	import flash.net.NetConnection;
	import flash.net.NetStream;  
	
	public class VideoLoop extends Video 
	{  
		
		private var URL:String;  
		
		private var connection:NetConnection 
		private var stream:NetStream; 
		private var playedOnce:Boolean = false;  
		
		/** 
		 * 
		 * @param	relative or absolute path to .flv file 
		 */ 
		private var client:Object;
		public function VideoLoop(videoPath:String):void 
		{ 
			URL = videoPath;  
			
			connection = new NetConnection(); 
			connection.addEventListener(NetStatusEvent.NET_STATUS, onStatus); 
			connection.connect(null);
		}  
		
		public function play():void 
		{ 
			stream.resume(); 
		}  
		
		public function pause():void 
		{ 
			stream.pause(); 
		}  
		
		private function onStatus(nse:NetStatusEvent):void 
		{
			if (nse.info.code == "NetConnection.Connect.Success" && !playedOnce)
			{ 
				playedOnce = true; 
				initVideo(); 
			} 
			if (nse.info.code == "NetStream.Play.Stop" && playedOnce) 
			{ 
				stream.seek(0); 
			} 
		}  
		
		private function asyncErrorHandler(event:AsyncErrorEvent):void 
		{ 
			dispatchEvent(event); 
		}  
		
		private function initVideo():void 
		{ 
			stream = new NetStream(connection);
			
			// -------------------------
			//	Avoid the NetStream onMetaData error
			// -------------------------
			stream.client = new Object();
			
			stream.addEventListener(NetStatusEvent.NET_STATUS, onStatus); 
			stream.addEventListener(AsyncErrorEvent.ASYNC_ERROR, asyncErrorHandler); 
			attachNetStream(stream); 
			stream.play(URL); 
		} 
	} 
}