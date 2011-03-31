package com.mangum.view.text {
	
	import com.greensock.*;
	import com.greensock.easing.*;
	import com.greensock.plugins.*;
	
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.filters.DropShadowFilter;
	import flash.text.AntiAliasType;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	
	public class Messenger extends Sprite {
				
		[Embed(source="/../assets/fonts/HelveticaNeueLTCom-BdCn.ttf", fontFamily="HelveticaNeueBold", embedAsCFF="false")] 		
		
		public var bar:String;
		
		private var _label:TextField;
		private var _labelText:String; 
		private var _color:Number; 
		private var _size:Number; 
		private var format:TextFormat;
		private var container:MovieClip =  new MovieClip();
		
		public function Messenger(msg:String,width:Number,color:Number=0x000000,size:Number=20,letterSpacing:Number=0) {
			addChild(container);
			_labelText = msg;
			_color = color;
			_size = size;
			configureLabel(width,color,size,letterSpacing);
			setLabel(_labelText);
			setShadow();			
		}
		
		/* PUBLIC METHODS */
		
		public function setLabel(str:String):void {
			_label.text = str;
		}	
		
		public function setAttribute(attribute:String, value:String):void {
			format[attribute] = value;
			_label.defaultTextFormat = format;
		}

		
		/* PRIVATE METHODS */
		private function configureLabel(width:Number,color:Number,size:Number,letterSpacing:Number):void {
			_label = new TextField();
			_label.embedFonts = true;
			_label.antiAliasType = AntiAliasType.ADVANCED;
			_label.autoSize = TextFieldAutoSize.LEFT;
			_label.background = false;
			_label.border = false;
			_label.selectable = false;
	
			format = new TextFormat();
			format.font = "HelveticaNeueBold";
			format.color = color;
			format.size = size;
			format.bold = true;
			format.underline = false;
			format.kerning = true;
			format.letterSpacing = letterSpacing;	
			format.align = "center";

			_label.defaultTextFormat = format;
			_label.wordWrap = true;
			_label.width = width;
			container.addChild(_label);
			container.cacheAsBitmap = true;
		}	
		
		private function setShadow():void{
			var shadow:DropShadowFilter = new DropShadowFilter(); 
			shadow.distance = .5; 
			shadow.angle = 30;
			shadow.alpha = 1;		
			this.filters = [shadow];		
		}
		
		/* GETTER SETTERS */
		
	
	}
}