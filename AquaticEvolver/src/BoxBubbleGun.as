package
{
	import B2Builder.B2BodyBuilder;
	
	import Box2D.Collision.Shapes.b2PolygonShape;
	import Box2D.Common.Math.b2Vec2;
	
	import Collisions.AECollisionData;
	
	import Creature.AECreature;

	
	public class BoxBubbleGun extends B2FlxSprite
	{
		private var bodyWidth:int = 66/2;
		private var bodyHeight:int = 85/2;
		public var creature:AECreature;
		public var appendage:Appendage;
		
		public function BoxBubbleGun(x:Number, y:Number, creature:AECreature, appendage:Appendage, Graphic:Class=null, width:Number=0, height:Number=0)

		{
			this.creature = creature;
			this.appendage = appendage;
			super(x, y,0, Graphic, width, height, null, -creature.getID());
		}
		
		override protected function bodyBuilder(position:b2Vec2, angle:Number, shape:b2PolygonShape = null):B2BodyBuilder
		{     
			var boxShape:b2PolygonShape = new b2PolygonShape();
			boxShape.SetAsBox(AEWorld.b2NumFromFlxNum(bodyWidth), AEWorld.b2NumFromFlxNum(bodyHeight));
			
			var b2bb:B2BodyBuilder = super.bodyBuilder(position, angle).withShape(boxShape)
				.withLinearDamping(2)
				.withData(new AECollisionData(SpriteType.BUBBLEGUN, this, this.appendage, this.creature));
			return b2bb;
		}
		
		public function getOwner():AECreature
		{
			return creature;
		}
	}
}