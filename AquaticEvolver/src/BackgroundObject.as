// ActionScript file
package{

	import org.flixel.FlxCamera;
	import org.flixel.FlxSprite;
	
	/**
	 * Class representing the background elements of the game world.
	 */
	public class BackgroundObject extends FlxSprite{
		
		[Embed(source='res/BackgroundBubble.png')]
		public static var BubbleImg:Class;
		
		private var camera:FlxCamera;
		
		private var viewDistance:int;
		
		private var MAXSCROLLSPEED:int = 500;

		
		public function BackgroundObject(x:int , y:int, viewDistance:int, camera:FlxCamera){
			
			this.loadGraphic(BubbleImg, false, false);
			
			this.viewDistance = viewDistance;
			
			this.x = x;
			this.y = y;
			//Setting background object's scroll factor for parallax scrolling
			this.scrollFactor.x = 10*(1.0/viewDistance);
			this.scrollFactor.y = 10*(1.0/viewDistance);
			//Adjusting the sprite's scale to appear smaller when further
			this.scale.x = this.scale.y = (Math.random()*5+1)*(1.0/viewDistance);
			
			this.alpha = 1.0/viewDistance;
			
			this.camera = camera;
						
			
		}
		
		override public function update():void{
			super.update();

			//Make sure that the object is still on the screen
			if(!this.onScreen(camera)){
				trace('Destroying background object');
				//CURRENTLY CRASHES GAME WHEN CALLED DON'T KNOW HOW TO CLEAN UP MEMORY
//				this.destroy();
				this.kill(); 
				
			}
		}
		
		
		public function moveAround():void{
			//Randomly move around
			this.acceleration.x = Math.random() * 100 - 50;
			this.acceleration.y = Math.random() * 100 - 50;
		}
		
		public function floatUpward():void{
			this.velocity.x = 0;
			this.velocity.y = -Math.round(MAXSCROLLSPEED/this.viewDistance);
		}
	}
}