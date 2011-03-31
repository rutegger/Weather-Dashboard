
package com.mangum.view{
	
	import com.greensock.*;
	import com.greensock.easing.*;
	
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	import com.mangum.view.text.Messenger;

	public class Output extends Sprite{
		
		private var msg:Messenger;
		private var dashboard:Dashboard;
		private var timeMsg:Messenger;
		private var tempMsg:Messenger;
		private var humidityMsg:Messenger;
		private var timer:Timer = new Timer(30000); // tick every 30sec
		private var glare:Sprite = new Glare();

		public function Output():void {			
			dashboard = new Dashboard();
			addChild(dashboard);
			setTextfields();
			timer.addEventListener(TimerEvent.TIMER, onTimer);
			timer.start();
			addChild(glare);
		}
		
		public function init(obj:Object):void{
			setValues(dashboard,obj);	
		}
		
		private function onTimer(e:TimerEvent):void {
			setTime();
		}
		
		private function setTime():void{
			var time:Object = getTime();
			timeMsg.setLabel(time.hours + ":" + time.minutes + " " + time.ampm);
			trace(time.hours + ":" + time.minutes + " " + time.ampm);
		}
		
		private function setTextfields():void{
			timeMsg = new Messenger("--:--:--", 300, 0xffffff, 80, -1);
			addChild(timeMsg);
			timeMsg.x = 35;
			timeMsg.y = 50;
			timeMsg.setAttribute("align","right");
			setTime();
			
			tempMsg = new Messenger("-- °F", 300, 0xffffff, 100, -1);
			addChild(tempMsg);
			tempMsg.x = 750;
			tempMsg.y = 30;
			
			
		}
		
		private function setValues(dashboard:Dashboard,obj:Object):void{
			
			// Todaycast
			var year:String = new Date().getFullYear().toString();
			dashboard.today.todayTxt.text = obj.weatherArr[0].day + ", " + obj.weatherArr[0].date  + ", " + year; 
			dashboard.sunrise.sunriseTxt.text = "sunrise: " + obj.sunrise;
			dashboard.sunset.sunsetTxt.text = "sunset: " + obj.sunset;
			
			setIcon(obj.icon);
			dashboard.conditions.conditionsTxt.text = obj.currently;
			
			setDirection(obj.windDirection);
			dashboard.windSpeed.windSpeedTxt.text = (obj.windSpeed == "calm") ? obj.windSpeed: obj.windSpeed  + " mph" ;
			
			tempMsg.setLabel(obj.temp + "°F");
			
			dashboard.high.highTxt.text = obj.high + " °F";
			dashboard.low.lowTxt.text = obj.low  + " °F";
			dashboard.humidity.humidityTxt.text = "humidity: "+ obj.humidity + "%";	
			
			// 4 Day Forcast
			for(var i:int = 1; i <= 4; i++){
				dashboard["day"+i].icon.gotoAndStop(obj.weatherArr[i].icon)
				dashboard["day"+i].date.text = obj.weatherArr[i].day.substr(0,3) + ", " + obj.weatherArr[i].date;
				dashboard["day"+i].high.text = obj.weatherArr[i].high + " °F";
				dashboard["day"+i].low.text = obj.weatherArr[i].low + " °F";
			}		
		}
		
		private function setIcon(val:uint):void{
			dashboard.icons.gotoAndStop(val);
		}
			
		private function setDirection(str:String):void{
			var dir:Number;
			
			switch(str){ // degress 22.5 deg appt
				case "N"  : dir = 0; break;
				case "NNE": dir = 22.5; break;
				case "NE" : dir = 45; break;
				case "ENE": dir = 67.5; break;
				case "E"  : dir = 90; break;	
				case "ESE": dir = 112.5; break;
				case "SE" : dir = 135; break;
				case "SSE": dir = 157.5; break;
				case "S"  : dir = 180; break;
				case "SSW": dir = 202.5; break;
				case "SW" : dir = 225; break;
				case "WSW": dir = 247.5; break;
				case "W"  : dir = 270; break;
				case "WNW": dir = 292.5; break;
				case "NW" : dir = 315; break;
				case "NNW": dir = 337.5; break;
				case "VAR": dir = 500; break;
				default   : dir = 360; break;
			}

			if(dir == 500){ // if direction is variable, fake randomness
				TweenMax.to(dashboard.windDirection, 30, {shortRotation:{rotation:randRange(0,360)}, ease:Quad.easeOut,onComplete:onTwComplete});
			} else {
				TweenMax.to(dashboard.windDirection, 1.25, {shortRotation:{rotation:dir}, ease:Quad.easeOut});
			}
			
		}
		
		private function onTwComplete():void{
			TweenMax.to(dashboard.windDirection, 30, {shortRotation:{rotation:randRange(0,360)}, ease:Quad.easeOut,onComplete:onTwComplete});
		}
		
		private function randRange(min:Number, max:Number):Number{
			var randomNum:Number = Math.round((Math.random() * (max - min )) + min);					
			return randomNum;
		}	
		
		private function getTime():Object {
			var time:Date = new Date();
			var minutes:String = (String(time.getMinutes()).length < 2) ? "0" + String(time.getMinutes()) : String(time.getMinutes());
			var hours:uint = time.getHours() % 12;
			if(hours == 0)hours = 12;
			var ampm:String = (time.getHours() >= 12) ? "PM" : "AM";
			var currentTime:Object = {minutes:minutes ,hours: hours, ampm:ampm};
			return currentTime;
		}
				
	}
}