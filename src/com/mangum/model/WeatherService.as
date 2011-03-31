package com.mangum.model{
	
	import flash.display.Sprite;
	import flash.errors.IOError;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.TimerEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.sampler.StackFrame;
	import flash.system.Security;
	import flash.utils.Timer;
	
	
	public class WeatherService extends Sprite{
		
		private static var RELOAD_TIME:Number = 900000; //15 min
		private static var instance:WeatherService;
		private static var allowInstantiation:Boolean;
		
		public static function getInstance():WeatherService {
			if (instance == null) {
				allowInstantiation = true;
				instance = new WeatherService();
				allowInstantiation = false;
			}
			return instance;
		}
		
		public function WeatherService():void {		
			if (!allowInstantiation) {
				throw new Error("Error: Instantiation failed: Use WeatherService.getInstance() instead of new.");
			} else {
				init();
			}
		}
		
		private var city:String;
		private var par_id:String;
		private var key:String;
		private var units:String;
			
		private var data_xml_url:String = "http://utwired.engr.utexas.edu/ecjKiosk/weather/data.xml";
		private var user_data:XML = new XML();
		private var data_url:URLRequest;
		private var dataLoader:URLLoader;	
		private var weather_xml_url:String;		
		private var weather:XML;
		private var weather_url:URLRequest;
		private var weatherLoader:URLLoader;
		
		private var _city:String;
		private var _time:String;
		private var _currently:String;
		private var _icon:String;
		private var _temp:String;
		private var _high:String;
		private var _low:String;
		private var _flike:String;
		private var _windSpeed:String;
		private var _windDir:String;
		private var _humidity:String;
		private var _visibility:String;
		private var _sunrise:String;
		private var _sunset:String;
		private var timer:Timer = new Timer(RELOAD_TIME); 
		
		private var _weatherArr:Array = new Array();
		
		private function init():void {
			data_url = new URLRequest(data_xml_url);
			dataLoader = new URLLoader();
			
			dataLoader.load(data_url);
			dataLoader.addEventListener(Event.COMPLETE, dataLoaded, false, 0, true);
			Security.allowDomain("*", "xoap.weather.com");
			
			// Reload the x a day		
			timer.start();
			timer.addEventListener(TimerEvent.TIMER, onTimer, false, 0, true);
		}
		
		private function onTimer(e:TimerEvent):void{
			dataLoader.load(data_url);
		}
		
		private function dataLoaded(e:Event):void{
			user_data = XML(dataLoader.data);
			city = user_data.city.toString();
			par_id  = user_data.parid.toString();
			key  = user_data.key.toString();
			units  = user_data.units.toString();
			
			weather_xml_url = "http://xoap.weather.com/weather/local/"+city+"?cc=*&link=xoap&dayf=5&par="+par_id+"&key="+key+"&unit="+units;

			weather = new XML();
			weatherLoader = new URLLoader();
			weather_url= new URLRequest(weather_xml_url);
			weatherLoader.load(weather_url);
			weatherLoader.addEventListener(IOErrorEvent.IO_ERROR, onIOError);
				
			weatherLoader.addEventListener(Event.COMPLETE, weatherLoaded, false, 0, true);
		}
		
		private function onIOError(e:IOErrorEvent):void{
			trace("An IO Error has occured.\n\n", e);
		}
		
		private function weatherLoaded(e:Event):void{
			weatherLoader.removeEventListener(Event.COMPLETE, weatherLoaded);
			weather = XML(weatherLoader.data);
		    		   
			trace("weather: "+weather); //XML
			
			_city      = weather.loc.dnam;
			_time      = weather.loc.tm;
			_temp      = weather.cc.tmp;
			_currently = weather.cc.t;
			_icon	   = weather.cc.icon;
			_flike     = weather.cc.flik;  
			_sunrise   = weather.loc.sunr;
			_sunset    = weather.loc.suns;
			_windSpeed = weather.cc.wind.s;
			_windDir   = weather.cc.wind.t;
			_humidity  = weather.cc.hmid;
			_visibility= weather.cc.vis;
			
			for(var i:int = 0; i < 5; i++){
				var d_day:String  = weather.dayf.day[i].attribute("t");
				var d_date:String = weather.dayf.day[i].attribute("dt");
				var d_high:String = weather.dayf.day[i].hi;
				var d_low:String  = weather.dayf.day[i].low;
				var d_icon:String = weather.dayf.day[i].part[0].icon;
				var d_t:String    = weather.dayf.day[i].part[0].t;
				
				_weatherArr[i] = {day:d_day, date:d_date, high:d_high, 
								  low:d_low, icon:d_icon, t:d_t};
			}
			
			_high  = _weatherArr[0].high;
			_low   = _weatherArr[0].low;

			dispatchEvent(new Event("onWeatherLoaded"));
		}
		
		/* GETTER SETTERS */
		
		public function get myCity():String {
			return _city;
		}
		
		public function get myTime():String {
			return _time;
		}
		
		public function get cityTime():String {
			return _city + " | " + _time;
		}
		
		public function get temp():String {
			return _temp;
		}
		
		public function get high():String {
			return _high;
		}
		
		public function get low():String {
			return _low;
		}
		
		public function get currently():String {
			return _currently;
		}
		
		public function get icon():String {
			return _icon;
		}
		
		public function get feelslike():String {
			return _flike;
		}
		
		public function get windSpeed():String {
			return _windSpeed;
		}
		
		public function get windDirection():String {
			return _windDir;
		}
		
		public function get humidity():String {
			return _humidity;
		}
		
		public function get visibility():String {
			return _visibility;
		}
		
		public function get sunrise():String {
			return _sunrise;
		}
		
		public function get sunset():String {
			return _sunset;
		}
		
		public function get weatherArr():Object {
			return _weatherArr;
		}

	}
}