package
{
	import B2Builder.B2BodyBuilder;
	
	import Box2D.Collision.Shapes.b2PolygonShape;
	import Box2D.Common.Math.b2Vec2;
	import Box2D.Dynamics.b2Body;
	
	import Collisions.AECollisionData;
	
	import Creature.AECreature;
	
	import org.flixel.FlxG;
	import org.flixel.FlxPoint;
	import org.flixel.FlxSprite;
	
	public class SpikeBullet extends B2FlxSprite
	{
		
		[Embed(source='res/Spike1.png')]
		public static var SpikeBulletImg:Class;
		
		private var bodyWidth:int = 32;
		private var bodyHeight:int = 128;
		
		private var creature:AECreature;
		private var appendage:Appendage;

		public var pos:b2Vec2;
		public var attackDamage:Number;
		private var SpikeBulletShape:b2PolygonShape;
		private var polygonVerticies:Array = new Array(
			new b2Vec2(AEWorld.b2NumFromFlxNum(-3.0/2),AEWorld.b2NumFromFlxNum(51.0/2)),
			new b2Vec2(AEWorld.b2NumFromFlxNum(2.0/2),AEWorld.b2NumFromFlxNum(45.0/2)),
			new b2Vec2(AEWorld.b2NumFromFlxNum(1.0/2),AEWorld.b2NumFromFlxNum(35.0/2)),
			new b2Vec2(AEWorld.b2NumFromFlxNum(10.5/2),AEWorld.b2NumFromFlxNum(-31.0/2)),
			new b2Vec2(AEWorld.b2NumFromFlxNum(21/2),AEWorld.b2NumFromFlxNum(35.0/2)),
			new b2Vec2(AEWorld.b2NumFromFlxNum(19.0/2),AEWorld.b2NumFromFlxNum(45.0/2)),
			new b2Vec2(AEWorld.b2NumFromFlxNum(15.0/2),AEWorld.b2NumFromFlxNum(51.0/2)));
		
		public function SpikeBullet(pos:b2Vec2, width:Number, height:Number, attackDamage:Number, creature:AECreature, appendage:Appendage, orientation:Number, speed:Number, targetPoint:FlxPoint)
			
		{
			//this.loadGraphic(ImgAttackBubble, false, false);
			this.attackDamage = attackDamage;
			this.pos = pos;
			this.SpikeBulletShape = new b2PolygonShape();
			this.SpikeBulletShape.SetAsArray(polygonVerticies);
			this.creature = creature;
			this.appendage = appendage;
			super(AEWorld.flxNumFromB2Num(pos.x), AEWorld.flxNumFromB2Num(pos.y),orientation, SpikeBulletImg, width, height, this.SpikeBulletShape, -creature.getID());
		}
		override public function update():void{
			if (!this.onScreen(null))
			{
				trace("Offscreen spike bullet killed!");
				this.kill();
				return;
			}
			super.update();
		}
		
		override protected function bodyBuilder(position:b2Vec2, angle:Number, shape:b2PolygonShape = null):B2BodyBuilder
		{
			var b2bb:B2BodyBuilder = super.bodyBuilder(position, angle)
				.withShape(shape)
				.withType(b2Body.b2_kinematicBody)
				.withData(new AECollisionData(SpriteType.SPIKEBULLET, this, this.appendage, this.creature));
			return b2bb;
		}
	}
}