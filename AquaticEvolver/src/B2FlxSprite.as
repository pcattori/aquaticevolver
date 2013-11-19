package
{
	
	import Box2D.Collision.Shapes.b2PolygonShape;
	import Box2D.Dynamics.b2Body;
	
	import org.flixel.FlxSprite;
	import B2Builder.B2BodyBuilder;
	
	public class B2FlxSprite extends FlxSprite
	{
		protected var body:b2Body;
		
		public function B2FlxSprite(x:int, y:int, Graphic:Class=null, width:Number=0, height:Number=0):void
		{
			super(x,y);
			if (Graphic) {
				this.loadGraphic(Graphic,true,true,width,height);
			}
			body = bodyBuilder().build();
		}
		
		/*
		public override function loadGraphic(Graphic:Class, Animated:Boolean=false, Reverse:Boolean=false, Width:uint=0, Height:uint=0, Unique:Boolean=false):FlxSprite
		{
			var flxSprite:FlxSprite = super.loadGraphic(Class, Animated, Reverse, Width, Height, Unique);
			
			return flxSprite;
		}
		*/
		
		override public function update():void
		{
			x = AEWorld.flxXFromB2X(body.GetPosition().x, width);
			y = AEWorld.flxYFromB2Y(body.GetPosition().y, height);
			angle = AEWorld.flxAngleFromB2Angle(body.GetAngle());
			super.update();
		}
		
		protected function bodyBuilder():B2BodyBuilder
		{     
			var boxShape:b2PolygonShape = new b2PolygonShape();
			boxShape.SetAsBox(AEWorld.b2NumFromFlxNum(width)/2.0, AEWorld.b2NumFromFlxNum(height)/2.0);
			var b2bb:B2BodyBuilder = new B2BodyBuilder().withShape(boxShape).withType(b2Body.b2_dynamicBody)
				.withDensity(0.1);
			return b2bb;
		}
		
		override public function kill():void
		{
			AEWorld.AEB2World.DestroyBody(this.body);
			trace("kill body");
			super.kill();
		}
		
		public function getBody():b2Body
		{
			return body;
		}
	}
}