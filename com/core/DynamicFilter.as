/**
 * DynamicFilter
 *
 * Author: Dion Snoeijen
 * Date 02-04-2010
 * 
 * Add filter to object Dynamically
 */
package com.core
{
	import flash.filters.BitmapFilter;
	import flash.filters.BitmapFilterQuality;
	import flash.filters.DropShadowFilter;
	import flash.filters.GlowFilter;
	
	public final class DynamicFilter
	{
		public static function glow(g:DynamicCenter, strength:Number = 1,
													 color:Number = 0x000000,
													 alpha:Number = .3,
													 blurX:Number = 25,
													 blurY:Number = 25,
													 inner:Boolean = false,
													 knockout:Boolean = false
													 ):void
		{
			var filterArray:Array = new Array();
            var quality:Number = BitmapFilterQuality.HIGH;

            var glowFilter:BitmapFilter = new GlowFilter(color,
                                  						 alpha,
                                  						 blurX,
                                  						 blurY,
                                  						 strength,
                                  						 quality,
                                  						 inner,
                                  						 knockout);
                                  						 
            filterArray.push(glowFilter);
           	g.filters = filterArray;                  
		}
		
		public static function shadow(g:DynamicCenter, strength:Number = 1, 
									  				   distance:Number = 4, 
													   angle:Number = 45, 
													   color:uint = 0x000000, 
													   alpha:Number = 1, 
													   blurX:Number = 4, 
													   blurY:Number = 1, 
													   inner:Boolean = false, 
													   knockout:Boolean = false,
													   hideObject:Boolean = false
													   ):void
		{
			var filterArray:Array = new Array();
			var quality:Number = BitmapFilterQuality.HIGH;
			
			var shadowFilter:BitmapFilter = new DropShadowFilter(distance, 
																 angle, 
																 color, 
																 alpha, 
																 blurX, 
																 blurY, 
																 strength, 
																 quality, 
																 inner, 
																 knockout, 
																 hideObject);
																 
			filterArray.push(shadowFilter);
			g.filters = filterArray;
		}
	}
}