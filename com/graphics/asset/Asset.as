package com.graphics.asset
{
	import com.core.DynamicCenter;
	import com.core.DynamicFilter;
	import com.core.DynamicShape;
	import com.data.GetBitmap;
	import com.data.GetCSS;
	import com.data.GetSwf;
	import com.events.AssetEvent;
	import com.graphics.asset.AssetInitializer;
	import com.graphics.asset.AssetSetting;
	import com.graphics.asset.AssetText;
	import com.graphics.fills.Fill;
	import com.graphics.patterns.Pattern;
	import com.graphics.preloaders.AppleStyle;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.BlendMode;
	import flash.display.DisplayObject;
	import flash.display.Loader;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.MouseEvent;
	import flash.events.NetStatusEvent;
	import flash.events.ProgressEvent;
	import flash.events.TimerEvent;
	import flash.media.Sound;
	import flash.media.Video;
	import flash.net.NetConnection;
	import flash.net.NetStream;
	import flash.net.URLRequest;
	import flash.system.ApplicationDomain;
	import flash.system.LoaderContext;
	import flash.system.Security;
	import flash.system.SecurityDomain;
	import flash.text.AntiAliasType;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFieldType;
	import flash.text.TextFormat;
	import flash.utils.Timer;
	import flash.utils.clearInterval;
	import flash.utils.setInterval;
	
	/**
	 * Asset class
	 * 
	 * @author					Dion Snoeijen
	 * @version					2.0
	 * @playerversion			10
	 */
	public class Asset extends DynamicCenter
	{	
		// ------------------------------
		// Store data within instance.
		// ------------------------------
		public var vars:Object = {};
		
		private var shape						  :String;
		private var o							  :Object;
		private var assetMask					  :Sprite;
		
		private var initialColor				  :uint;
		private var hoverColor					  :uint;
		
		// ------------------------------
		//	Create easy ref for TF
		// ------------------------------
		public var tf							  :TextField;
		private var _textFormat					  :TextFormat;
		
		// ------------------------------
		//	Create easy ref for MC
		// ------------------------------
		private var refMc						  :MovieClip;
		private var mcLoader					  :Loader;
		
		// ------------------------------
		//	Create easy ref for IMG
		// ------------------------------
		public var img							  :Sprite;
		
		// ------------------------------
		//	Create easy ref for CONTENT
		// ------------------------------
		private var _content					  :MovieClip;
		
		// ------------------------------
		//	Movie
		// ------------------------------
		private var nc							  :NetConnection;
		private var ns							  :NetStream;
		private var vid							  :Video;
		private var client						  :Object;
		private var mov							  :Boolean;
		private var movContainer				  :DynamicCenter;
		private var movLeading					  :String;
		private var movPlaying					  :Boolean;
		private var movTimer					  :Timer;
		public var movTotalTime				  	  :Number;
		public var movSendTimePercentage		  :Number;
		
		private var autoHeight					  :Boolean;
		
		private var preloaderGraphic			  :AppleStyle;
		
		/**
		 * <p><strong>Constructor</strong></p>
		 * 
		 * @param ai:AssetInitializer Initialier Object
		 */
		public function Asset(ai:AssetInitializer = null)
		{	
			if(this.debugging)
				trace('Asset.constructor()');
			
			if(ai == null)
			{
				ai = new AssetInitializer();
			}
			
			this.o = new Object();
			this.o = {w:ai.width, 
					  h:ai.height, 
					  c:ai.color, 
					  a:ai.alpha, 
					  bt:ai.borderThickness, 
					  bc:ai.borderColor, 
					  custom:ai.customShapeSettings};
			this.initialColor = ai.color;
			
			this.shape = ai.shape;			
			this.drawShape(this);
			
			this.cacheAsBitmap = true;
			
			if(ai.mask)
				this.setMask();
			
			if(ai.image != '')
				this.setImage(ai.image, AssetSetting.AUTO_LEADING);
			
			this.autoHeight = ai.autoHeight;
		}
		
		private function createPreloaderGraphic():void
		{
			this.preloaderGraphic = new AppleStyle();
			this.preloaderGraphic.x = (this.width / 2);
			this.preloaderGraphic.y = (this.height / 2);
			this.addChild(preloaderGraphic);
		}
		
		private function removePreloaderGraphic():void
		{
			this.removeChild(this.preloaderGraphic);
			this.preloaderGraphic = null;
		}
		
		public function setMask():void
		{
			this.assetMask = new Sprite();
			this.drawShape(this.assetMask);			
			this.addChild(this.assetMask);
		}
		
		private var resize:String;
		private var align:String;
		/**
		 * <strong>setImage()</strong><br />
		 * <p>Load an external image into the asset</p>
		 * 
		 * @param path:String The image path.
		 * @param leading:String default value: NO_LEADING use ASSET_TO_IMAGE to automagically resize the asset to the image size
		 * @param align:String default value: ALIGN_LEFT
		 */
		public function setImage(path:String, leading:String = AssetSetting.NO_LEADING, align:String = AssetSetting.ALIGN_LEFT):void
		{
			this.createPreloaderGraphic();
			
			this.resize = leading;
			this.align = align;
			this.img = new Sprite();
			var getBM:GetBitmap = new GetBitmap(path);
			getBM.addEventListener(Event.COMPLETE, this.assetImageLoaded);
			getBM.name = path;
			this.img.addChild(getBM);
			this.addChild(this.img);
			
			if(this.assetMask)
			{
				this.img.mask = this.assetMask;
			}
			
			if(debugging)
				trace('Asset.setImage();');
		}
		
		private var bg:Boolean = false;
		private var backGroundSprite:Sprite;
		private var pattern:Pattern;
		private var bData:BitmapData;
		/**
		 * <strong>setBackground</strong>
		 * <p>Choose from a variety of background patterns generated in the Pattern class</p>
		 * 
		 * @see com.graphics.patterns.Pattern
		 */
		public function setBackground():void
		{
			if(!this.bg)
			{
				backGroundSprite = new  Sprite();
				pattern = new Pattern(Pattern.RECT_BLUR);
				bData = new BitmapData(pattern.width, pattern.height, true);
				bData.draw(pattern);
			}
			
			backGroundSprite.graphics.clear();
			backGroundSprite.graphics.beginBitmapFill(bData);
			backGroundSprite.graphics.drawRect(0, 0, o.w, o.h);
			backGroundSprite.graphics.endFill();
			this.addChild(backGroundSprite);
			
			this.bg = true;
		}
		
		private var fill:Fill;
		private var fillType:String;
		private var fillSettings:Array;
		public function setFill(type:String, settings:Array):void
		{
			this.fillType = type;
			this.fillSettings = new Array();
			this.fillSettings = settings;
			
			this.fill = new Fill();
			
			this.drawFill(this.fillSettings);
			
			this.addChild(fill);
		}
		
		public function setBitmap(b:Bitmap):void
		{
			this.addChild(b);
			this.resizeAsset(b.width, b.height);
		}
		
		private function drawFill(s:Array):void
		{
			switch(this.fillType)
			{
				case AssetSetting.FILL_LIN_GRAD: this.fill.linearGradient(this.o.w, this.o.h, s); break;
				case AssetSetting.FILL_RAD_GRAD: this.fill.radialGradient(this.o.w, this.o.h, s); break;
				default: throw new Error('Class: Asset  |  Method: setFill  |  ERROR: No fill');
			}	
		}
		
		private function assetImageLoaded(e:Event):void
		{	
			if(this.preloaderGraphic)
			{
				this.removePreloaderGraphic();
			}
			if(this.resize == AssetSetting.AUTO_LEADING)
			{	
				this.resizeAsset(this.width, this.height);
			}
			else if(this.resize == AssetSetting.WIDTH_LEADING)
			{
				//trace(WIDTH_LEADING);
			}
			else if(this.resize == AssetSetting.HEIGHT_LEADING)
			{
				//trace(HEIGHT_LEADING);
			}
			else if(this.resize == AssetSetting.ASSET_TO_IMAGE)
			{
				this.updateShapeSize(e.currentTarget.width, e.currentTarget.height);
			}
			
			var dif:Number;
			var hdif:Number;
			switch(this.align)
			{
				case AssetSetting.ALIGN_RIGHT:
					dif = this.img.width - this.o.w;
					this.img.x = -dif;
					this.img.y = 0;
					break;
				case AssetSetting.ALIGN_LEFT:
					this.img.x = 0;
					this.img.y = 0;
					break;
				case AssetSetting.ALIGN_CENTER:
					dif = this.img.width - this.o.w;
					hdif = this.img.height - this.o.h;
					this.img.x = -(dif / 2);
					this.img.y = -(hdif / 2);
					break;
				default:
					throw new Error('Class: Asset  |  Method: assetImageLoaded  |  ERROR: No alginment');
			}
			
			this.dispatchEvent(new Event(AssetEvent.IMAGE_COMPLETE));
			
			if(debugging)
				trace('Asset.assetImageLoaded();');
		}
		
		private var youTubeLoader:Loader;
		public var youTubePlayer:Object;
		public function setYouTube(id:String, chromeless:Boolean = false):void
		{
			Security.allowDomain('www.youtube.com');
			//Security.allowInsecureDomain('*');
			Security.loadPolicyFile('http://www.youtube.com/crossdomain.xml');

			this.youTubeLoader = new Loader();
			this.youTubeLoader.contentLoaderInfo.addEventListener(Event.INIT, onLoaderInit);
			this.youTubeLoader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, youTubeIOError);
			
			if(!chromeless)
			{
 				this.youTubeLoader.load(new URLRequest("http://www.youtube.com/v/" + id + "?version=3"));
			}
			else
			{
				this.youTubeLoader.load(new URLRequest("http://www.youtube.com/apiplayer?video_id=" + id + "&version=3"));
			}
		}
		
		private function onLoaderInit(e:Event):void
		{
			this.addChild(this.youTubeLoader);
			this.youTubeLoader.content.addEventListener("onReady", onPlayerReady);
			this.youTubeLoader.content.addEventListener("onError", onPlayerError);
		 	this.youTubeLoader.content.addEventListener("onStateChange", onPlayerStateChange);
			this.youTubeLoader.content.addEventListener("onPlaybackQualityChange", onVideoPlaybackQualityChange);
		}
		
		private function onPlayerReady(e:Event):void
		{	
			// -------------------------
			//	Once this event has been dispatched by the player, we can use
			//	cueVideoById, loadVideoById, cueVideoByUrl and loadVideoByUrl
			//	to load a particular YouTube video.
			// -------------------------
			this.youTubePlayer = youTubeLoader.content;
			this.youTubePlayer.setPlaybackQuality('hd720');
			
			// -------------------------
			//	Set appropriate player dimensions for your application
			// -------------------------
			this.youTubePlayer.setSize(480, 360);
			
			if(this.debugging)
				trace('THE YOUTUBE PLAYER IS READY');
			
			// -------------------------
			//	Event.data contains the event parameter, which is the Player API ID
			// -------------------------
			dispatchEvent(new Event(AssetEvent.YOUTUBE_READY));
		}
		
		private function youTubeIOError(e:IOErrorEvent):void
		{
			//trace('YOUTUBE IO ERROR:', e);
		}
		
		private function onPlayerError(e:Event):void
		{
			//trace("player error:", Object(e).data);
		}
		
		private function onPlayerStateChange(e:Event):void
		{
			trace("player state:", Object(e).data);
			if(Object(e).data == 0)
			{
				this.dispatchEvent(new Event(AssetEvent.YOUTUBE_END));
			}
		}
		
		private function onVideoPlaybackQualityChange(e:Event):void
		{
			//trace("video quality:", Object(e).data);
		}

		public function setSwf(path:String, leading:String = AssetSetting.NO_LEADING, sepDef:Boolean = false):void
		{	
			if(path != "")
			{
				this.resize = leading;
				this.refMc = new MovieClip();
				
				// ------------------------------
				//	Dit laat de swf die wordt geladen
				//	in zijn eigen omgeving draaien.
				// ------------------------------
				if(sepDef)
				{
					var appDomain:ApplicationDomain = new ApplicationDomain();
					var seperateDefinitions:LoaderContext = new LoaderContext(false, appDomain);
					try
					{
						this.mcLoader = new GetSwf(path, seperateDefinitions);
					}
					catch(e:Error)
					{
						trace('SWF NIET GELADEN:', e);
					}
				}
				else
				{
					try
					{
						this.mcLoader = new GetSwf(path);
					}
					catch(e:Error)
					{
						trace('SWF NIET GELADEN:', e);
					}
				}
				this.mcLoader.addEventListener(Event.COMPLETE, this.placeSwf);
				this.refMc.addChild(this.mcLoader);
			}
			else
			{
				throw new Error('NO SWF PATH SET IN Asset::setSwf();');		
			}
		}
		
		private function getAbsoluteUrl(urlInput:String):String {
			var strResult:String = "";
			if(urlInput.indexOf("http://") > -1) //only convert when online
			{
				if(urlInput.indexOf(".swf") > -1) // only convert when an actual .swf file is used
				{
					strResult = urlInput.substring(0, urlInput.lastIndexOf("/")+1); // find absolut path minus filename of .swf
				}
			}
			//throw new Error(strResult);
			return strResult;
		}
		
		private function placeSwf(e:Event):void
		{
			if(this.preloaderGraphic)
			{
				this.removePreloaderGraphic();
				
			}
			
			this.addChild(this.refMc);
			this.dispatchEvent(new Event(AssetEvent.SWF_COMPLETE));
		}
		
		private var contentMargin:Number;
		public function setContent(c:MovieClip, margin:Number = 5):void
		{
			this.contentMargin = margin;
			
			if(!this._content)
			{
				this._content = new MovieClip();
			}
			this._content = MovieClip(c);
			this._content.addEventListener(Event.COMPLETE, resizeAfterContent);
			
			this.addChild(_content);
		}
		
		private function resizeAfterContent(e:Event):void
		{
			this.content.x = this.contentMargin;
			this.content.y = this.contentMargin;
			this.updateShapeSize(this.content.width + (this.contentMargin * 2), this.content.height + (this.contentMargin * 2));
		}
		
		private var movComplete:Boolean;
		private var nsInterval:Number;
		/**
		 * <p><strong>setVideo()</strong></p>
		 * <p>Play streaming video straight from the asset :)</p>
		 * 
		 * @param path:String Path where the video is to be found. flv or f4v supported
		 * @param leading:String
		 */
		public function setVideo(path:String, leading:String = AssetSetting.AUTO_LEADING):void
		{
			// -------------------------
			//	Make sure event get's dispatched when movie is ready for use.
			// -------------------------
			this.movComplete = false;
			
			if(this.movContainer)
			{
				this.movContainer.removeChild(this.vid);
			}
			
			this.movContainer = new DynamicCenter();
			this.nc = new NetConnection();
			this.vid = new Video();
			this.client = new Object();
			this.movContainer.addChild(vid);
			this.addChild(movContainer);
			
			this.mov = true;
			this.movLeading = leading;
			
			this.movTimer = new Timer(50);
			this.movTimer.addEventListener(TimerEvent.TIMER, videoSendPos);
			
			// -------------------------
			//	Initialize net stream
			// 	Not using a media server
			// -------------------------
			this.nc.connect(null);
			this.ns = new NetStream(nc);
			
			this.ns.addEventListener(NetStatusEvent.NET_STATUS, onNetStatus);
			this.ns.bufferTime = 3;
			
			this.vid.smoothing = true;
			
			this.client.onMetaData = nsMetaDataCallback;
			this.client.onPlayStatus = playStatus;
			this.client.onCuePoint = onCuePointHandler;
			this.ns.client = this.client;
			
			this.vid.attachNetStream(ns);
			this.ns.play(path);
			
			if(leading == AssetSetting.AUTO_LEADING)
			{
				if(this.debugging)
					trace('setVideo AUTO_LEADING', this.vid.width, this.vid.x, this.vid.scaleX);
				
				if(this.debugging)
					trace('setVideo AUTO_LEADING', this.vid.height, this.vid.y, this.vid.scaleY);
			}
			else if(leading == AssetSetting.WIDTH_LEADING)
			{
				trace(AssetSetting.WIDTH_LEADING);
			}
			else
			{
				trace(AssetSetting.HEIGHT_LEADING);
			}
			
			this.nsInterval = setInterval(nsProgress, 500);
			
			this.ns.pause();
			
			if(this.debugging)
				trace('setVideo.bufferLength:', this.ns.bufferLength, 'setVideo.bufferTime:', this.ns.bufferTime, 'setVideo.bytesTotal:', this.ns.bytesTotal, 'setVideo.bytesLoaded:', this.ns.bytesLoaded);
		}
		
		private function onCuePointHandler(cueInfoObj:Object):void 
		{
			trace("cuepoint: time=" + cueInfoObj.time + " name=" + cueInfoObj.name + " type=" + cueInfoObj.type);
		}
		
		private function onNetStatus(event:Object):void {
			// -------------------------
			//	handles NetConnection and NetStream status events
			// -------------------------
			if(this.debugging)
				trace(event.info.code);
			switch (event.info.code) {
				case "NetConnection.Connect.Success":
					// -------------------------
					//	play stream if connection successful
					//	connectStream();
					// -------------------------
					break;
				case "NetStream.Play.StreamNotFound":
					// -------------------------
					//	error if stream file not found in
					//	location specified
					//	trace("Stream not found: " + _videoURL);
					// -------------------------
					break;
				case "NetStream.Play.Start":
					// -------------------------
					//	preloading done
					// -------------------------
					//this.dispatchEvent(new Event(AssetEvent.MOV_PRELOADED));
					break;
				case "NetStream.Seek.Notify":
					// -------------------------
					//	 preloading and positioning done
					// -------------------------
					this.dispatchEvent(new Event(AssetEvent.MOV_SIZED_AND_PRELOADED));
					break;
				case "NetStream.Play.Stop":
					// -------------------------
					//	do if video is stopped
					//	videoPlayComplete();
					// -------------------------
					this.dispatchEvent(new Event(AssetEvent.MOV_END));
					break;
			}
		}
		
		private function playStatus(event:Object):void 
		{
			//handles onPlayStatus complete event if available
			trace('PLAY STATUS EVENT', event.info.code);
			
			switch (event.code) {
				case "NetStream.Play.Complete":
					//do if video play completes
					this.dispatchEvent(new Event(AssetEvent.MOV_END));
					break;
			}
			//trace(event.info.code);
		}
		
		private function nsMetaDataCallback(mdata:Object):void 
		{
			//MetaData
			this.movTotalTime = mdata.duration;
			this.updateShapeSize(mdata.width, mdata.height);
			this.vid.width = mdata.width;
			this.vid.height = mdata.height;
			
			if(!movComplete)
			{
				//this.videoPlay();
				//this.videoSearch(1);
				//this.videoPause();
				dispatchEvent(new Event(AssetEvent.MOV_COMPLETE));
			}
			
			this.movComplete = true;
		}
		
		private var _totalLoadedPercentage:Number;
		private var _bufferLoadedPercentage:Number;
		private function nsProgress():void
		{
			this._totalLoadedPercentage = Math.round((this.ns.bytesLoaded / this.ns.bytesTotal) * 100);
			
			var bufferBytesTotal:Number = (this.ns.bytesTotal / this.movTotalTime) * this.ns.bufferLength;
			
			//trace('BUFFER BYTES TOTAL:', bufferBytesTotal, 'MOVIE TOTAL BYTES:', this.ns.bytesTotal, 'MOVIE TOTAL TIME:', this.movTotalTime);
			this._bufferLoadedPercentage = (this.ns.bytesLoaded / bufferBytesTotal) / 100;
			
			if(_totalLoadedPercentage >= 100)
			{
				clearInterval(this.nsInterval);
			}
			
			this.dispatchEvent(new Event(AssetEvent.MOV_PROGRESS));
		}
		
		public function get totalLoadedPercentage():Number
		{
			return this._totalLoadedPercentage;
		}
		
		public function get bufferLoadedPercentage():Number
		{
			return this._bufferLoadedPercentage;
		}
		
		public function videoSearch(pos:Number):void
		{	
			var totalTimePercentage:Number = movTotalTime / 100;
			var seekPos:Number = pos * totalTimePercentage;
			
			this.ns.seek(seekPos);
		}
		
		public function videoPausePlay():void
		{
			if(!movPlaying)
			{
				this.videoPlay();
			}
			else
			{
				this.videoPause();
			}
		}
		
		public function videoPause():void
		{
			this.ns.pause();
			this.movTimer.stop();
			this.movPlaying = false;	
		}
		
		public function videoPlay():void
		{
			if(this.debugging)
				trace('videoPlay');
			this.ns.resume();
			this.movTimer.start();
			this.movPlaying = true;
		}
		
		public function get playing():Boolean
		{
			return this.movPlaying;
		}
		
		private function videoSendPos(e:TimerEvent):void
		{
			this.movSendTimePercentage = this.ns.time / (this.movTotalTime / 100);
			
			dispatchEvent(new ProgressEvent(ProgressEvent.PROGRESS));
		}
		
		public function get content():MovieClip
		{
			return this._content;
		}
		
		private var css:GetCSS;
		private var xHtml:String;
		private var embedFonts:Boolean;
		/**
		 * <strong>setText()</strong><br />
		 * <br />
		 * <p>This function processes text diaplayed in the Asset</p>
		 * 
		 * @param textProps:Object Accepting a couple of custom properties when not using a external cssPath.
		 * @param CSSPath:String Or use a path to a css file.
		 * @param html:String And the string of course, I recommend always using html strings.
		 * @param embedFont:Boolean Do you want to embed fonts?
		 * @param padding:Number Distance between the edge of the asset, and the textfield.
		 * @param autoSize:String TextField AutoSize mode.
		 * @param font:String What font would you like to use?
		 * @param type:String This is the TextFieldType.
		 */
		public function setText(at:AssetText = null):void
		{	
			if(this.debugging)
				trace('Asset.setText()');
			
			if(at == null)
				at = new AssetText();
			
			// -------------------------
			//	Prevent creation of multiple tf.
			// -------------------------
			if(!this.tf)
			{
				if(this.debugging)
					trace('Asset create new TextField (once per instance)', at.html);
				
				this.tf = new TextField();
				this.tf.type = at.type;
			}
			// -------------------------
			//	Make info for cssLoaded ready.
			// -------------------------
			this.xHtml = at.html;

			if(this.debugging)
				trace('Asset::setText() html:', at.html);
			
			if(at.CSSPath)
			{
				this.embedFonts = at.embedFont;
				css = new GetCSS();
				css.addEventListener(Event.COMPLETE, this.cssLoaded);
				css.getCSS(at.CSSPath);
			}
			else if(at.textProps.styleSheet)
			{
				tf.styleSheet = at.textProps.styleSheet;
				tf.embedFonts = at.embedFont;
				// -------------------------
				//	Wordwrap set to false again, this.. .in some occasions is not desirable, check when and how.
				// -------------------------
				tf.wordWrap = false;
				tf.multiline = true;
				tf.htmlText = this.xHtml;
				if(this.debugging)
					trace('Asset.setText() object passed a stylesheet:', tf.width, tf.height, at.html);

				this.fixLineHeight();
			}
			else
			{
				if(this.debugging)
					trace('Asset.setText() setting text with textProps');
				
				tf.embedFonts = at.embedFont;
				_textFormat = new TextFormat();
				_textFormat.size = at.textProps.size == undefined ? 10 : at.textProps.size;
				_textFormat.color = at.textProps.color == undefined ? 0x000000 : at.textProps.color;
				_textFormat.font = at.font;
				tf.wordWrap = at.textProps.wordWrap == undefined ? false : at.textProps.wordWrap;
				tf.multiline = at.textProps.multiline == undefined ? false : at.textProps.multiline;
				tf.htmlText = at.html;
				tf.setTextFormat(_textFormat);
				
				this.fixLineHeight();
			}
			
			if(at.autoSize == TextFieldAutoSize.NONE)
			{
				tf.width = o.w - (at.padding * 2);
				if(autoHeight)
				{
					at.autoSize = TextFieldAutoSize.LEFT;
				}
				else
				{
					tf.height = o.h - (at.padding * 2);
				}
			}
			
			this.tf.x = tf.y = at.padding;
			this.tf.antiAliasType = AntiAliasType.ADVANCED;
			
			if(!at.CSSPath)
			{
				if(this.debugging)
					trace('Asset::setText() setting autosize');
				this.tf.autoSize = at.autoSize;
			}
			
			if(at.autoSize != TextFieldAutoSize.NONE && !at.CSSPath)
			{
				if(this.debugging)
					trace('Asset autosize required, call updateShapeSize');
				this.updateShapeSize(o.w, tf.height + (at.padding * 2));
			}
			if(tf.getImageReference('body') != null)
			{
				//this.createPreloaderGraphic();
				//tf.getImageReference('body').addEventListener(Event.COMPLETE, this.bodyIdLoaded);
				tf.getImageReference('body').x = tf.getImageReference('body').x - 6;
				tf.getImageReference('body').y = tf.getImageReference('body').y - 3;
			}
			
			// -------------------------
			//	See if there is a way to find all active loaders in a text field?!
			// -------------------------
			if(tf.getImageReference('left') != null)
			{
				tf.getImageReference('left').x = tf.getImageReference('left').x - 6;
				tf.getImageReference('left').y = tf.getImageReference('left').y - 3;
			}
			
			if(tf.getImageReference('right') != null)
			{
				tf.getImageReference('right').x = tf.getImageReference('right').x + 6;
				tf.getImageReference('right').y = tf.getImageReference('right').y - 3;
			}
				
			tf.blendMode = BlendMode.LAYER;
			tf.cacheAsBitmap = true;
			
			this.addChild(tf);
		}
				
		private function bodyIdLoaded(e:Event):void
		{
			this.dispatchEvent(new Event(AssetEvent.BODY_ID_IMAGE_COMPLETE));
		}
		
		public function get tfLines():int
		{
			var numLines:int;
			return numLines = (this.tf.bottomScrollV - this.tf.scrollV);
		}
		
		/**
		 * <strong>fixLineHeight()</strong><br />
		 * <br />
		 * <p>Try to fix the lineheight problem when TextField only holds one line of text.<br />
		 * Add following line to css: .fix_line_height {font-family:Arial; font-size:1px; color:#000;}</p>
		 * 
		 * <strong>Notes:</strong>
		 * <p>Obviously this solutions sucks bigtime, try to find a better solution.</p>
		 */
		private function fixLineHeight():void
		{
			if(this.tfLines < 2)
			{
				this.tf.htmlText += '<p class="fix_line_height"></p>';
			}
		}
		
		public function cssLoaded(e:Event):void
		{
			this.tf.styleSheet = css;
			this.tf.embedFonts = this.embedFonts;
			this.tf.wordWrap = true;
			this.tf.multiline = true;
			this.tf.htmlText = this.xHtml;
			this.tf.autoSize = TextFieldAutoSize.LEFT;

			this.updateShapeSize(o.w, tf.height + (at.padding * 2));
			
			this.fixLineHeight();
		}
		
		/**
		 * 	Return the mc loader, so we can reference the content loader info.
		 */
		public function get mcl():Loader
		{
			return this.mcLoader;	
		}
		
		/**
		 * 	Provide easy reference to loaded .swf MC
		 */
		public function get mc():MovieClip
		{
			var _mc:MovieClip;
			if(GetSwf(refMc.getChildAt(0)).mc)
			{
				_mc = GetSwf(refMc.getChildAt(0)).mc;
			}
			else
			{
				_mc = refMc;
			}
			return _mc; 
		}
		
		private var hoverImageLoader:Loader;
		private var textHoverColor:uint;
		public function makeButton(hc:uint = 0xFFFFFF, hoverImage:String = '', textHoverColor:uint = 0):void
		{
			this.hoverColor = hc;
			this.textHoverColor = textHoverColor;
			this.buttonMode = true;
			this.addEventListener(MouseEvent.MOUSE_OVER, buttonMouseOver);
			
			if(this.assetMask)
			{
				this.hitArea = this.assetMask;
				this.assetMask.buttonMode = true;
			}
			this.mouseChildren = false;
			if(tf)
			{	
				this.tf.selectable = false;
				this.tf.mouseEnabled = false;	
			}
			if(img)
			{
				this.img.mouseEnabled = false;
				this.img.mouseChildren = false;
			}
			
			if(hoverImage)
			{
				this.hoverImageLoader = new Loader();
				this.hoverImageLoader.load(new URLRequest(hoverImage));
				this.hoverImageLoader.contentLoaderInfo.addEventListener(Event.COMPLETE, hoverImageLoaderComplete);
			}
		}
		
		private function hoverImageLoaderComplete(e:Event):void
		{
			this.hoverImageLoader.visible = false;
			this.addChild(this.hoverImageLoader);
		}
		
		public function setFilter(type:String, strength:Number):void
		{
			switch(type)
			{
				case AssetSetting.FILTER_SHADOW: DynamicFilter.shadow(this, strength); break;
				case AssetSetting.FILTER_GLOW: DynamicFilter.glow(this, strength); break;
				default: throw new Error('Class: Asset  |  Method: setFilter  | ERROR: No shape'); 
			}
		}
		
		private var storeColor:Object;
		private function buttonMouseOver(e:MouseEvent):void
		{
			this.removeEventListener(MouseEvent.MOUSE_OVER, buttonMouseOver);
			this.addEventListener(MouseEvent.MOUSE_OUT, buttonMouseOut);
			this.o.c = this.hoverColor;
			this.drawShape(this);
			
			if(this.hoverImageLoader)
			{
				this.hoverImageLoader.visible = true;
				this.img.visible = false;
			}
			
			if(this.tf && this.textHoverColor > 0)
			{
				this.storeColor = this._textFormat.color;
				this._textFormat.color = this.textHoverColor;
				this.tf.setTextFormat(this._textFormat);
				this.tf.mouseEnabled = false;
				this.tf.selectable = false;
			}
		}
		
		private function buttonMouseOut(e:MouseEvent):void
		{
			this.removeEventListener(MouseEvent.MOUSE_OUT, buttonMouseOut);
			this.addEventListener(MouseEvent.MOUSE_OVER, buttonMouseOver);
			this.o.c = initialColor;
			this.drawShape(this);
			
			if(this.hoverImageLoader)
			{
				this.hoverImageLoader.visible = false;
				this.img.visible = true;
			}
			
			if(this.tf && this.textHoverColor > 0)
			{
				this._textFormat.color = this.storeColor;
				this.tf.setTextFormat(this._textFormat);
				this.tf.mouseEnabled = false;
				this.tf.selectable = false;
			}
		}
		
		public function updateBorder(borderThickness:Number = 1, borderColor:uint = 0xFF0000):void
		{
			this.o.bt = borderThickness;
			this.o.bc = borderColor;
			
			this.drawShape(this);
		}
		
		private function drawShape(sprite:Sprite):void
		{
			// ------------------------------
			//	Always build asset and mask according to
			//	constructor settings.
			// ------------------------------
			switch(this.shape)
			{
				case AssetSetting.RECT: DynamicShape.rectangle(sprite, this.o); break;
				case AssetSetting.CIRC: DynamicShape.circle(sprite, this.o); break;
				case AssetSetting.TRI: DynamicShape.triangle(sprite, this.o); break;
				case AssetSetting.ARROW: DynamicShape.arrow(sprite, this.o); break;
				case AssetSetting.PAUSE: DynamicShape.pause(sprite, this.o); break;
				case AssetSetting.RNDRECT: DynamicShape.rndRect(sprite, this.o); break;
				case AssetSetting.CIRCLE_SEGMENT: DynamicShape.circleSegment(sprite, this.o); break;
				case AssetSetting.DONUT: DynamicShape.donut(sprite, this.o); break;
				default: throw new Error('Class: Asset  |  Method: createShape  |  ERROR: No shape');
			}	
		}
		
		public function textFormat(change:Object):void
		{
			_textFormat.underline = change.underline == undefined ? false : change.underline;
			tf.setTextFormat(_textFormat);
		}
		
		public function get visibleHeight():Number
		{
			return this.assetMask ? this.assetMask.height : this.height;
		}
		
		public function get visibleWidth():Number
		{
			return this.assetMask ? this.assetMask.width : this.width;
		}
		
		public function updateShapeColor(newColor:uint, newAlpha:Number = 1):void
		{
			this.o.c = newColor;
			this.o.a = newAlpha;
			this.drawShape(this);
		}
		
		public function updateShape(newShape:String):void
		{
			this.shape = newShape;
			this.updateShapeSize(this.width, this.height);
		}
		
		public function updateShapeSize(width:Number = NaN, height:Number = NaN, custom:Array = null):void
		{
			if(width)
				this.o.w = width;
			
			if(height)
				this.o.h = height;
			
			if(custom)
				this.o.custom = custom;
			
			if(this.assetMask)
				this.drawShape(this.assetMask);
			
			if(this.bg)
				this.setBackground();
			
			if(this.fill)
				this.drawFill(this.fillSettings);
			
			if(this.debugging)
				trace('Asset.updateShapeSize(), width and height', this.o.w, this.o.h);
			
			this.drawShape(this);	
		}
		
		/**
		 * Make available some getters and setters so the shape updates can be animated == cool!.
		 */
		public function set newWidth(nw:Number):void
		{
			this.updateShapeSize(nw);
		}
		
		public function get newWidth():Number
		{
			return this.o.w;
		}
		
		public function set newHeight(nh:Number):void
		{
			this.updateShapeSize(NaN, nh);
		}
		
		public function get newHeight():Number
		{
			return this.o.h;
		}
		
		/**
		 * The custom params are the custom array items. newCustom0 is in fact custom[0];
		 */
		public function set newCustom0(newC0:Number):void
		{
			this.o.custom[0] = newC0;
			this.updateShapeSize(NaN, NaN, this.o.custom);
		}
		
		public function get newCustom0():Number
		{
			return Number(this.o.custom[0]);
		}
		
		public function set newCustom1(newC1:Number):void
		{
			this.o.custom[1] = newC1;
			this.updateShapeSize(NaN, NaN, this.o.custom);
		}
		
		public function get newCustom1():Number
		{
			return Number(this.o.custom[1]);
		}
		
		/**
		 * Custom array cannot be animated by tween max, because an array can't be converted to a Number...
		 */
		public function set newCustom(custom:Array):void
		{
			this.updateShapeSize(this.visibleWidth, this.visibleHeight, custom);
		}
		
		public function get newCustom():Array
		{
			return this.o.custom;
		}
		
		public function resizeAsset(newWidth:Number, newHeight:Number, center:String = AssetSetting.CENTER_X_Y):void
		{
			if(this.img)
			{
				this.updateShapeSize(newWidth, newHeight);
				this.img.width = newWidth;
				this.img.height = newHeight;
				this.img.scaleX <= this.img.scaleY ? (this.img.scaleX = this.img.scaleY) : (this.img.scaleY = this.img.scaleX);
				
				if(this.img.height > newHeight)
					this.img.y = -(this.img.height - newHeight) / 2;
				
				if(this.img.width > newWidth)
					this.img.x = -(this.img.width - newWidth) / 2;
			}
			
			if(this.vid)
			{
				this.movContainer.width = newWidth;
				this.movContainer.height = newHeight;
				this.movContainer.scaleX <= this.movContainer.scaleY ? (this.movContainer.scaleX = this.movContainer.scaleY) : (this.movContainer.scaleY = this.movContainer.scaleX);
				
				if(this.debugging)
					trace('vid.scaleX', this.movContainer.scaleX, 'vid.scaleY', this.movContainer.scaleY, 'vid.width', this.movContainer.width, 'vid.height', this.movContainer.height);

				if(center == AssetSetting.CENTER_X_Y || center == AssetSetting.CENTER_Y)
				{
					if(this.movContainer.height > newHeight)
						this.movContainer.y = -(this.movContainer.height - newHeight) / 2;
				}
				if(center == AssetSetting.CENTER_X_Y || center == AssetSetting.CENTER_X)
				{
					if(this.movContainer.width > newWidth)
						this.movContainer.x = -(this.movContainer.width - newWidth) / 2;
				}
			}
			
			if(this.youTubeLoader)
			{
				if(this.youTubePlayer)
					this.youTubePlayer.setSize(newWidth, newHeight);
			}
		}
	}
}