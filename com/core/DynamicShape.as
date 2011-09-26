package com.core
{
	import flash.display.Sprite;
	
	/**
	 * <p><strong>DynamicShape<strong></p>
	 *
	 * <p>Author: <strong>Dion Snoeijen</strong><br />
	 * Date: <strong>02-04-2010</strong></p>
	 * 
	 * <p>Draw all kinds of shapes for the Assets.</p>
	 *
	 */
	public final class DynamicShape
	{	
		/**
		 * <p><strong>Draw a rectange</strong></p>
		 */
		public static function rectangle(g:Sprite, o:Object):Sprite
		{	
			g.graphics.clear();
			if(o.bt > 0)
			{
				g.graphics.lineStyle(o.bt, o.bc, 1, true);
			}
			g.graphics.beginFill(o.c, o.a);
			g.graphics.drawRect(0, 0, o.w, o.h);
			g.graphics.endFill();
			
			return g;
		}
		
		/**
		 * <p><strong>Draw a circle</strong></p>
		 */
		public static function circle(g:Sprite, o:Object):Sprite
		{
			g.graphics.clear();
			if(o.bt > 0)
			{
				g.graphics.lineStyle(o.bt, o.bc, 1, true);
			}
			g.graphics.beginFill(o.c, o.a);
			g.graphics.drawEllipse(0, 0, o.w, o.h);
			g.graphics.endFill();
			
			return g;
		}
		
		/**
		 * <p><strong>Draw a rndRect</strong></p>
		 */
		public static function rndRect(g:Sprite, o:Object):Sprite
		{
			g.graphics.clear();
			if(o.bt > 0)
			{
				g.graphics.lineStyle(o.bt, o.bc, 1, true);
			}
			g.graphics.beginFill(o.c, o.a);
			g.graphics.drawRoundRect(0, 0, o.w, o.h, 10, 10);
			g.graphics.endFill();
			
			return g;
		}
		
		/**
		 * <p><strong>Draw a triangle</strong></p>
		 */
		public static function triangle(g:Sprite, o:Object):Sprite
		{
			g.graphics.clear();
			if(o.bt > 0)
			{
				g.graphics.lineStyle(o.bt, o.bc, 1, true);
			}
			g.graphics.beginFill(o.c, o.a);
			if(o.custom == null || o.custom == 'v1')
			{
				g.graphics.moveTo(o.w, 0);
				g.graphics.lineTo(o.w, o.h);
				g.graphics.lineTo(0, o.h / 2);
				g.graphics.lineTo(o.w, 0);	
			}
			else if(o.custom == 'v2')
			{
				g.graphics.moveTo(0, 0);
				g.graphics.lineTo(o.w, (o.h / 2));
				g.graphics.lineTo(0, o.h);
				g.graphics.lineTo(0, 0);
			}
			else if(o.custom == 'v3')
			{
				g.graphics.moveTo(0, o.h);
				g.graphics.lineTo((o.w / 2), 0);
				g.graphics.lineTo(o.w, o.h);
				g.graphics.moveTo(0, o.h);
			}
			g.graphics.endFill();
			
			return g;		
		}
		
		/**
		 * <p><strong>Draw a donut</strong></p>
		 */
		public static function donut(g:Sprite, o:Object):Sprite
		{
			g.graphics.clear();
			if(o.bt > 0)
			{
				g.graphics.lineStyle(o.bt, o.bc, 1, true);
			}
			g.graphics.beginFill(o.c, o.a);
			g.graphics.drawCircle(0, 0, (o.w / 2));
			g.graphics.drawCircle(0, 0, ((o.w / 2) - o.custom[0])); 
			g.graphics.endFill();
			
			return g;
		}
		
		public static function arrow(g:Sprite, o:Object):Sprite
		{	
			g.graphics.clear();
			if(o.bt > 0)
			{
				g.graphics.lineStyle(o.bt, o.bc, 1, true);	
			}
			g.graphics.beginFill(o.c, o.a);
			if(o.custom == null)//Draw V1
			{
				g.graphics.moveTo(0, (o.h / 4));
				g.graphics.lineTo(((o.w / 3) * 2), o.h / 4);
				g.graphics.lineTo(((o.w / 3) * 2), 0);
				g.graphics.lineTo(o.w, o.h / 2);
				g.graphics.lineTo(((o.w / 3) * 2), o.h);
				g.graphics.lineTo(((o.w / 3) * 2), ((o.h / 4) * 3));
				g.graphics.lineTo(0, ((o.h / 4) * 3));
				g.graphics.lineTo(0, (o.h / 4));
			}
			else if(o.custom == 'v2') //Draw V2
			{
				g.graphics.moveTo(0, 0);
				g.graphics.lineTo((o.w / 10) * 9, 0);
				g.graphics.lineTo(o.w, (o.h / 2));
				g.graphics.lineTo((o.w / 10) * 9, o.h);
				g.graphics.lineTo(0, o.h);
				g.graphics.lineTo(0, 0);
			}
			else if(o.custom == 'v3') //Draw V3
			{
				g.graphics.moveTo((o.w / 10), 0);
				g.graphics.lineTo(o.w, 0);
				g.graphics.lineTo(o.w, o.h);
				g.graphics.lineTo((o.w / 10), o.h);
				g.graphics.lineTo(0, (o.h / 2));
				g.graphics.lineTo((o.w / 10), 0);
			}

			g.graphics.endFill();
			
			return g;
		}
		
		/**
		 * <p><strong>Draw a segment of a circle<strong></p>
		 * @param target:Sprite The object we want to draw into
		 * @param x:Number The x-coordinate of the origin of the segment
		 * @param y:Number The y-coordinate of the origin of the segment
		 * @param r:Number The radius of the segment
		 * @param start:Number The starting angle (degrees) of the segment (0 = East)
		 * @param end:Number The ending angle (degrees) of the segment (0 = East)
		 * @param step:Number The number of degrees between each point on the segment's circumference
		 */	
		public static function circleSegment(g:Sprite, o:Object):Sprite
		{
			g.graphics.clear();
			if(o.bt > 0)
				g.graphics.lineStyle(o.bt, o.bc, 1, true);
			
			var r:Number = (o.w / 2);
			var start:Number = o.custom[0] == null ? 0 : o.custom[0]; 
			var end:Number = o.custom[1] == null ? 90 : o.custom[1];
			var step:Number = 1;
			
			// -------------------------
			//	More efficient to work in radians
			// -------------------------
			var degreesPerRadian:Number = Math.PI / 180;
			start *= degreesPerRadian;
			end *= degreesPerRadian;
			step *= degreesPerRadian;
			
			// -------------------------
			//	Draw the segment
			// -------------------------
			g.graphics.beginFill(o.c, o.a);
			g.graphics.moveTo(0, 0);
			for (var theta:Number = start; theta < end; theta += Math.min(step, end - theta)) {
				g.graphics.lineTo(0 + r * Math.cos(theta), 0 + r * Math.sin(theta));
			}
			g.graphics.lineTo(0 + r * Math.cos(end), 0 + r * Math.sin(end));
			g.graphics.lineTo(0, 0);
			g.graphics.endFill();
			
			return g;	
		}
		
		/**
		 * <p><strong>Draw a pause icon</strong></p>
		 */
		public static function pause(g:Sprite, o:Object):Sprite
		{
			g.graphics.clear();
			if(o.bt > 0)
			{
				g.graphics.lineStyle(o.bt, o.bc, 1, true);
			}
			g.graphics.beginFill(o.c, o.a);
			g.graphics.drawRect(0, 0, o.w / 3, o.h);
			g.graphics.drawRect((o.w / 3) * 2, 0, (o.w / 3), o.h);
			g.graphics.endFill();
			return g;
		}
		
		/**
		 *	<p><strong>Draw polygon</strong></p>
		 */
		/*
		public static function polygon(g:Sprite, o:Object):Sprite
		{
			var radius:Number = o.w / 2;
			
			var id:int = 0;
			var points:Array = new Array();
			var ratio:Number = 360 / o.custom;
			var top:Number = (o.h / 2) - radius;
			
			for(var i:int = rotating ; i <= 360 + rotating ; i += ratio)
			{
				var radians:Number = Math.PI / 180 * i;
				var xx:Number= centerX + Math.sin(radians) * radius;
				var yy:Number= top + (radius - Math.cos(radians) * radius);
				
				points[id] = new Array(xx, yy);
				
				if(id>=1) 
				{
					g.graphics.lineStyle(line,tint,1);
					g.graphics.moveTo(points[id-1][0],points[id-1][1]);
					g.graphics.lineTo(points[id][0],points[id][1]);
				}
				
				id++;
			}
			id=0;
			
			return g;
		}
		*/
	}
} 