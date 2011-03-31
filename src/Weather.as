	package{
	
	import com.greensock.*;
	import com.greensock.easing.*;
	import com.mangum.model.WeatherService;
	import com.mangum.view.Output;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	
	[SWF(width='1100', height='200', backgroundColor='#ffffff', frameRate='24')]
	
	public class Weather extends Sprite{
		
		private var ws:WeatherService;	
		private var output:Output
		
		public function Weather(){
			
			//model
			ws = WeatherService.getInstance(); // Singleton
			ws.addEventListener("onWeatherLoaded", onWeatherLoaded, false, 0, true);	
			
			//view
			output = new Output();
			output.scaleX = .65;
			output.scaleY = .65;
			output.x = 5;
			output.y = 15;

		}		
		
		/* EVENT HANDLERS */
		
		private function onWeatherLoaded(e:Event):void{
			output.init(ws);
			addChild(output);

		}
	}
}




