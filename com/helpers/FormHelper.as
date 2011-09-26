/**
 * FormHelper
 *
 * Author: Dion Snoeijen
 * Project: DCode
 *
 * Handle APSBB Forms
 */
package com.helpers
{
	import com.controls.CheckBox;
	import com.controls.RadioButton;
	import com.graphics.asset.*;
	import com.greensock.TweenMax;
	import com.helpers.FormValidation;
	import com.tools.ClassCheck;
	import com.debug.Print;
	import com.core.DynamicCenter;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	import flash.net.URLRequestMethod;
	import flash.net.URLVariables;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFieldType;
	import flash.text.TextFormat;
	
	import spark.components.TextArea;
	
	/**
	 *  {apsbb:form action="http://www.apsbb.com/index.php/site/contact_form/"}
	 *	{inputfield name="Bedrijfsnaam" width="385" height="20" x="0" y="0"} 
 	 *	{radiobutton name="Aanhef" width="385" height="20" x="0" y="25" options="mr-mrs"} 
	 *	{inputfield name="Voornaam" width="385" height="20" x="0" y="50"}
	 *	{inputfield name="Achternaam" width="385" height="20" x="0" y="75"}
	 *	{inputfield name="Straat" width="385" height="20" x="0" y="100"}
	 *	{inputfield name="Nr" width="385" height="20" x="0" y="125"}
	 *	{inputfield name="Postcode" width="385" height="20" x="400" y="0"}
	 *	{inputfield name="Woonplaats" width="385" height="20" x="400" y="25"}
	 *	{inputfield name="Telefoonnummer" width="385" height="20" x="400" y="50"}
	 *	{inputfield name="Email" width="385" height="20" x="400" y="75"}
	 *	{inputfield name="Vraag" width="385" height="20" x="400" y="100"}
	 *	{checkbox name="Mailing" width="385" height="20" x="400" y="125"}
	 *	{/apsbb:form}
	 */
	public class FormHelper extends DynamicCenter
	{	
		private var formContainer	:Sprite;
		private var fields			:Array;
		private var submit			:Asset;
		private var checkBox		:CheckBox;
		private var action			:String;
		
		public function FormHelper(f:Array):void
		{
			this.debugging = false;
			
			this.fields = new Array();
			this.fields = f;
			
			if(this.fields.length > 0)
			{
				this.action = fields.shift();
	
				this.formContainer = new Sprite();
				this.addChild(this.formContainer);
				
				var textFormat:TextFormat = new TextFormat();
				textFormat.font = 'Arial';
				textFormat.color = 0x666666;
				
				if(this.debugging)
					Print.r(this.fields);
				
				for each(var field:Array in fields)
				{
					if(field[0] == 'inputfield')
					{
						var inputField:TextField = new TextField();
						
						with(inputField)
						{
							type = TextFieldType.INPUT;
							background = true;
							width = field[2];
							height = field[3];
							border = true;
							borderColor = 0xCCCCCC;
							text = field[1];
							wordWrap = true;
							multiline = true;
							name = field[1];
							maxChars = 100;
							//restrict = 'A-Z a-z 1-0 , . @';
							setTextFormat(textFormat);
							addEventListener(MouseEvent.MOUSE_DOWN, inputFieldDown);
							x = field[4]
							y = field[5];
						}
						
						if(this.debugging)
							trace(inputField.name);
						
						this.formContainer.addChild(inputField);
					}
					else if(field[0] == 'checkbox')
					{
						this.ai.width = 100;
						this.ai.height = 20;
						
						this.at.textProps = {color:0x666666, size:13};
						this.at.html = '<p>' + field[1] + '</p>';
						this.at.autoSize = TextFieldAutoSize.LEFT;
						var checkBoxCaption:Asset = new Asset(this.ai);
						checkBoxCaption.setText(this.at);
						checkBoxCaption.x = Number(field[4]);
						checkBoxCaption.y = Number(field[5]);
						
						var checkBox:CheckBox = new CheckBox();
						checkBox.x = Number(field[4]) + checkBoxCaption.visibleWidth + 20;
						checkBox.y = Number(field[5]) + 4;
						
						checkBox.name = field[1];
						
						this.formContainer.addChild(checkBoxCaption);
						this.formContainer.addChild(checkBox);
					}
					else if(field[0] == 'radiobutton')
					{
						var rButtons:Array = new Array();
						rButtons = field[6].split('-');
						
						var i:int = 0;
						var store:Number = 0;
						for each(var rButton:String in rButtons)
						{	
							var radioButtonCaption:Asset = new Asset(this.ai);
							radioButtonCaption.setText(this.at);
							if(!radioButton)
							{
								radioButtonCaption.x = Number(field[4]);
							}
							else
							{
								store = radioButton.x + 10;
								radioButtonCaption.x = radioButton.x + 10;
							}
							radioButtonCaption.y = Number(field[5]);
							
							var radioButton:RadioButton = new RadioButton();
							radioButton.x = Number(field[4]) + radioButtonCaption.visibleWidth + store + 10;
							radioButton.y = Number(field[5]) + 8;
							radioButton.name = field[1];
							radioButton.vars.value = rButton;
							//radioButton.name = 'radiobutton';
							radioButton.addEventListener(MouseEvent.MOUSE_DOWN, radioButtonDown);
							
							this.formContainer.addChild(radioButtonCaption);
							this.formContainer.addChild(radioButton);
							
							i++;
						}
					}
					else
					{
						trace('Input type not found.');		
					}
				}
				
				this.ai.reset();
				this.ai.shape = AssetSetting.ARROW;
				this.ai.width = 100;
				this.ai.height = 20;
				this.ai.color = 0xCCCCCC;
				this.ai.alpha = 1;
				this.ai.customShapeSettings = [AssetSetting.V2];
				this.submit = new Asset(this.ai);
				
				this.at.reset();
				this.at.textProps = {color:0xFFFFFF};
				this.at.html = '<p>     Submit</p>';
				this.at.font = 'RockW';
				this.at.padding = 0;
				this.at.embedFont = true;
				this.submit.setText(this.at);
				this.submit.y = this.formContainer.height + 20;
				this.submit.makeButton(0x666666);
				this.submit.addEventListener(MouseEvent.MOUSE_DOWN, submitDown);
				
				this.addChild(submit);
			}
			else
			{
				if(this.debugging)
					trace('FormHelper::constructor no field data');
			}
		}
		
		private function radioButtonDown(e:MouseEvent):void
		{
			trace(e.currentTarget.name);
			trace(e.currentTarget.vars.value);
			
			for (var i:int = 0 ; i < this.formContainer.numChildren ; i++)
			{
				if(RadioButton == ClassCheck.getClass(this.formContainer.getChildAt(i)))
				{
					RadioButton(this.formContainer.getChildAt(i)).turnOff();
				}
			}
			
			e.currentTarget.turnOn();
		}
		
		private function inputFieldDown(e:MouseEvent):void
		{	
			if(e.currentTarget.name == e.currentTarget.text)
			{
				e.currentTarget.text = '';
			}
		}
		
		private function submitDown(e:MouseEvent):void
		{	
			if(this.validateForm())
			{
				this.allFineConstructUrlAndSend();
			}
		}
		
		/**
		 *	Todo: The radiobuttons can be in multiple groups, make it possible!!
		 */
		private function validateForm():Boolean
		{
			var allFine:Boolean = true;
			var rbAvailable:Boolean = false;
			var rbFine:Boolean = false;
			
			for each(var field:Array in fields)
			{
				var fieldName:String = field[1];
				
				switch(field[0])
				{
					case 'inputfield':
						
						var selector:TextField = TextField(this.formContainer.getChildByName(fieldName));
						
						if(FormValidation.hasValue(selector.text))
						{
							this.greenBorder(selector);
							
							// ------------------------
							//	If input field content is the same as the name....
							// ------------------------
							if(selector.text != 'Vraag')
							{
								if(selector.text == field[1])
								{
									this.redBorder(selector);
									allFine = false;
								}
							}
							
							// ------------------------
							//	If the field is the email field, check if it's a correct email format...
							// ------------------------
							if(field[1] == 'Email')
							{
								if(!FormValidation.isEmail(selector.text))
								{
									this.redBorder(selector);
									allFine = false;
								}
							}
						}
						else
						{
							this.redBorder(selector);
							allFine = false;
						}
						break;
					case 'checkbox':
						// Hmmm, don't do anyting... yet
						break;
					case 'radiobutton':
						allFine  = false;
						rbAvailable = true;
						
						for (var i:int = 0 ; i < this.formContainer.numChildren ; i++)
						{	
							if(RadioButton == ClassCheck.getClass(this.formContainer.getChildAt(i)))
							{
								var rb:RadioButton = RadioButton(this.formContainer.getChildAt(i));
								
								if(rb.status)
								{
									allFine = true;
									rbFine = true;
								}
							}
						}
						
						break;
					default:
						throw new Error('No valid validation key');
				}
			}
			
			if(rbAvailable)
			{
				for (var j:int = 0 ; j < this.formContainer.numChildren ; j++)
				{	
					if(RadioButton == ClassCheck.getClass(this.formContainer.getChildAt(j)))
					{
						var radiob:RadioButton = RadioButton(this.formContainer.getChildAt(j));
								
						if(rbFine)
						{
							this.greenBorderRadio(radiob);
						}
						else
						{
							this.redBorderRadio(radiob);
						}
					}
				}
			}
			
			return allFine;
		}
		
		private function redBorderRadio(selector:RadioButton):void
		{
			selector.drawBackground(0xe17e7e);
		}
		
		private function greenBorderRadio(selector:RadioButton):void
		{
			selector.drawBackground(0xd3f2d3);
		}
		
		private function redBorder(selector:TextField):void
		{
			selector.borderColor = 0xe17e7e;
		}
		
		private function greenBorder(selector:TextField):void
		{
			selector.borderColor = 0xd3f2d3;
		}
		
		private function allFineConstructUrlAndSend():void
		{
			var urlSegment:String = '';
			
			for each(var field:Array in fields)
			{
				if(this.debugging)
					trace(field);
				
				if(field[0] == 'inputfield')
				{
					urlSegment += field[1] + '|' + TextField(this.formContainer.getChildByName(field[1])).text + '_';
				}
				else if(field[0] == 'checkbox')
				{
					urlSegment += field[1] + '|' + CheckBox(this.formContainer.getChildByName(field[1])).text + '_';
				}
				else if(field[0] == 'radiobutton')
				{
					if(this.debugging)
						trace('RADIOBUTTON:', RadioButton(this.formContainer.getChildByName(field[1])).vars.value);
					
					var radioSegment:String = 'No Value';
					
					//radioSegment = RadioButton(this.formContainer.getChildByName(field[1])).vars.value;
					
					for (var i:int = 0 ; i < this.formContainer.numChildren ; i++)
					{
						if(RadioButton == ClassCheck.getClass(this.formContainer.getChildAt(i)))
						{
							if(RadioButton(this.formContainer.getChildAt(i)).status)
							{
								radioSegment = 	RadioButton(this.formContainer.getChildAt(i)).vars.value;
							}
						}
					}
					
					urlSegment += field[1] + '|' + radioSegment + '_';
				}
			}
			
			var url:String = this.action + escape(urlSegment.substr(0, -1)) + '/';
			
			if(this.debugging)
				trace(url);
			
			var req:URLRequest = new URLRequest(url);
			
			var l:URLLoader = new URLLoader();
			l.addEventListener(Event.COMPLETE, lComplete);
			l.load(req);
		}
		
		private function lComplete(e:Event):void
		{	
			for each(var field:Array in fields)
			{
				if(field[0] == 'inputfield')
				{
					TextField(this.formContainer.getChildByName(field[1])).text = '';
					TweenMax.to(TextField(this.formContainer.getChildByName(field[1])), 1, {alpha:.4});
				}
				else if(field[0] == 'checkbox')
				{
					TweenMax.to(CheckBox(this.formContainer.getChildByName(field[1])), 1, {alpha:.4});
				}
				else if(field[0] == 'radiobutton')
				{
					for (var i:int = 0 ; i < this.formContainer.numChildren ; i++)
					{
						if(RadioButton == ClassCheck.getClass(this.formContainer.getChildAt(i)))
						{
							TweenMax.to(RadioButton(this.formContainer.getChildAt(i)), 1, {alpha:.4});
						}
					}	
				}
				
				TweenMax.to(this.submit, 1, {alpha:.4});
				this.submit.removeEventListener(MouseEvent.MOUSE_DOWN, submitDown);
			}
		}
	}
}