package com.graphics.fills
{  
	import flash.display.GradientType;
	import flash.display.SpreadMethod;
	import flash.display.Sprite;
	import flash.filters.GradientBevelFilter;
	import flash.geom.Matrix;
	   
	public class Fill extends Sprite  
	{  
		private var matrix:Matrix;
		
		private var gType:String;
		private var gColors:Array;
		private var gAlphas:Array;
		private var gRatio:Array;
		
		private var grad:Sprite;
		
		public function Fill():void
		{
			this.grad = new Sprite();
		}
		
		public function radialGradient(w:Number, h:Number, s:Array):void
		{
			this.gType = GradientType.RADIAL;  
			
			this.matrix = new Matrix();  
			this.matrix.createGradientBox(w, h, 0, 0, 0);  
			
			this.gColors = s[0];  
			this.gAlphas = s[1];  
			this.gRatio = s[2];  

			this.grad.graphics.clear();
			this.grad.graphics.beginGradientFill(gType, gColors, gAlphas, gRatio, matrix);  
			this.grad.graphics.drawRect(0, 0, w, h);  
			this.grad.x = this.grad.y = 0;  
			
			this.addChild(this.grad);  
		}
		
		public function linearGradient(w:Number, h:Number, s:Array):void
		{
			this.gType = GradientType.LINEAR;
			
			this.matrix = new Matrix();
			this.matrix.createGradientBox(h, w, 0, 0, 0);
			
			if(s[3])
			{
				this.matrix.rotate(Number(s[3]) / 180 * Math.PI);
			}
			
			this.gColors = s[0];
			this.gAlphas = s[1];
			this.gRatio = s[2];

			this.grad.graphics.clear();
			this.grad.graphics.beginGradientFill(gType, gColors, gAlphas, gRatio, matrix);
			this.grad.graphics.drawRect(0, 0, w, h);
			this.grad.x = this.grad.y = 0;
			
			this.addChild(this.grad);
		}
	} 
}  