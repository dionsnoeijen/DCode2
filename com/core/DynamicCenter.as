/**
 * DynamicCenter
 *
 * Author: Dion Snoeijen
 * Date 20-02-2010
 * 
 * Rotate, move and scale object around defined point. 
 */
package com.core
{
	import com.graphics.asset.AssetInitializer;
	import com.graphics.asset.AssetText;
	
	import flash.display.Sprite;
	import flash.geom.Point;
	 
	public class DynamicCenter extends Sprite
	{
		public var rp:Point;
		
		public var ai:AssetInitializer;
		public var at:AssetText;
		
		public var debugging			:Boolean = false;
		
		public function DynamicCenter()
		{
			this.ai = new AssetInitializer();
			this.at = new AssetText();
			
			setRegistration();
		}

		public function setRegistration(x:Number=0, y:Number=0):void
		{
			rp = new Point(x, y);
		}

		public function get x2():Number
		{
			var p:Point = this.parent.globalToLocal(this.localToGlobal(rp));
			return p.x;
		}

		public function set x2(value:Number):void
		{
			var p:Point = this.parent.globalToLocal(this.localToGlobal(rp));
			this.x += value - p.x;
		}

		public function get y2():Number
		{
			var p:Point = this.parent.globalToLocal(this.localToGlobal(rp));
			return p.y;
		}

		public function set y2(value:Number):void
		{
			var p:Point = this.parent.globalToLocal(this.localToGlobal(rp));
			this.y += value - p.y;
		}

		public function get scaleX2():Number
		{
			return this.scaleX;
		}

		public function set scaleX2(value:Number):void
		{
			this.setProperty2("scaleX", value);
		}

		public function get scaleY2():Number
		{
			return this.scaleY;
		}

		public function set scaleY2(value:Number):void
		{
			this.setProperty2("scaleY", value);
		}

		public function get rotation2():Number
		{
			return this.rotation;
		}

		public function set rotation2(value:Number):void
		{
			this.setProperty2("rotation", value);
		}

		public function get mouseX2():Number
		{
			return Math.round(this.mouseX - rp.x);
		} 

		public function get mouseY2():Number
		{
			return Math.round(this.mouseY - rp.y);
		}

		public function setProperty2(prop:String, n:Number):void
		{
			if(!this.parent)
			{
				trace('WAAAA. PARENT IS NULL.... HOE KAN DAT?!', this.name);
			}
			try
			{
				var a:Point = this.parent.globalToLocal(this.localToGlobal(rp));
				this[prop] = n;
				var b:Point = this.parent.globalToLocal(this.localToGlobal(rp));

				this.x -= b.x - a.x;
				this.y -= b.y - a.y;
			}
			catch(e:Error)
			{
				// -------------------------
				//	Soms blijft er een object achter, gewoon verder gaan zonder error te genereren.
				// -------------------------
				trace('Parent 0 error, ga maar gewoon verder:', e);
			}
		}
	}
}