package
{
	import Box2D.Common.Math.b2Vec2;
	import Box2D.Dynamics.b2Body;
	import Box2D.Dynamics.b2World;
	import Box2D.Dynamics.Joints.b2RevoluteJointDef;
	
	import Creature.AECreature;
	
	import org.flixel.FlxG;
	import org.flixel.FlxPoint;
	import org.flixel.FlxU;
	
	public class BubbleGun extends Appendage
	{
		[Embed(source='res/sfx/BubbleCannonShoot1.mp3')]
		public var BubbleGunSFX1:Class;
		[Embed(source='res/sfx/BubbleCannonShoot2.mp3')]
		public var BubbleGunSFX2:Class;
		[Embed(source='res/sfx/BubbleCannonShoot3.mp3')]
		public var BubbleGunSFX3:Class;
		public var bubbleGunNoises:Array = new Array();
		// bubble gun joint locations
		private var bubbleGunJoint:b2Vec2 = new b2Vec2(0,32);
		
		private var bubbleGun:BoxBubbleGun;
		
		private var jointAngleCorrection:Number = 0;
		
		private var lastAttackTime:Number = 0;
		
		private var ATTACKDELAY:Number = .5;
		
		// images
		
		[Embed(source='res/BubbleCannon1.png')]
		public static var bubbleGunImg:Class;
		
		public function BubbleGun(jointPos:b2Vec2, jointAngle:Number, creature:AECreature, segment:B2FlxSprite)
		{
			bubbleGunNoises[0] = BubbleGunSFX1;
			bubbleGunNoises[1] = BubbleGunSFX2;
			bubbleGunNoises[2] = BubbleGunSFX3;
			jointAngle = jointAngle + jointAngleCorrection;
			super(AdaptationType.BUBBLEGUN, 30, true, 1, jointPos, jointAngle, creature, segment);
			
			var world:b2World = AEWorld.AEB2World;
			
			var revoluteJointDef:b2RevoluteJointDef;
			
			
			// create the sprites
			bubbleGun = new BoxBubbleGun(0, 0, creature, this, bubbleGunImg, 128, 128);
			this.add(bubbleGun);
			
			// create the joint from base to creature
			revoluteJointDef = new b2RevoluteJointDef();
			revoluteJointDef.bodyA = segment.getBody();
			revoluteJointDef.bodyB = bubbleGun.getBody();
			revoluteJointDef.localAnchorA = jointPos;
			//			FlxG.log("AanchorCoords = " + revoluteJointDef.localAnchorA.x + ", " + revoluteJointDef.localAnchorA.y);
			revoluteJointDef.localAnchorB = convertToBox2D(bubbleGunJoint);
			//			FlxG.log("BanchorCoords = " + revoluteJointDef.localAnchorB.x + ", " + revoluteJointDef.localAnchorB.y);
			revoluteJointDef.referenceAngle = jointAngle;
			revoluteJointDef.enableLimit = true;
			revoluteJointDef.lowerAngle = -Math.PI/4;
			revoluteJointDef.upperAngle = Math.PI/4;
			revoluteJointDef.collideConnected = false;
			world.CreateJoint(revoluteJointDef);			
		}
		
		override public function attack(point:FlxPoint):void
		{
			if(lastAttackTime <= 0) {
				var randomSong = FlxU.getRandom(bubbleGunNoises,0, 3);
				FlxG.play(randomSong);				
				super.attack(point);
				//trace("bubble gun attacking");
				// insert code to shoot a bubble here
				
				var headPoint:b2Vec2 = bubbleGun.getBody().GetPosition();
				var spawnPoint :b2Vec2 = calcBulletSpawnPoint(point, bubbleGun.getScreenXY(), headPoint);
				var bubble:AttackBubble = new AttackBubble(spawnPoint, 64, 64, this.attackDamage, this.creature, this, 5, point);
				AEWorld.world.add(bubble);
				var bubbleBody:b2Body = bubble.getBody();
				bubbleBody.SetLinearVelocity(calcBulletVelocity(point, bubbleGun.getScreenXY()));
				//Set the delay for attacking
				lastAttackTime = ATTACKDELAY;
			}
		}
		
		protected function calcBulletVelocity(mousePoint:FlxPoint, bodyPoint:FlxPoint):b2Vec2 {
			var angle:Number = Math.atan2(mousePoint.y - bodyPoint.y,mousePoint.x - bodyPoint.x);
			var magnitude:Number = 3;
			return new b2Vec2(magnitude * Math.cos(angle), magnitude * Math.sin(angle));
		}
		
		protected function calcBulletSpawnPoint(mousePoint:FlxPoint, bodyPoint:FlxPoint, gunPoint:b2Vec2):b2Vec2 {
			var angle:Number = Math.atan2(mousePoint.y - bodyPoint.y,mousePoint.x - bodyPoint.x);
			var magnitude:Number = .7;
			var xSpawn:Number = magnitude * Math.cos(angle) + gunPoint.x;
			var ySpawn:Number = magnitude * Math.sin(angle) + gunPoint.y;
			return new b2Vec2(xSpawn,ySpawn);
		}
		
		override public function update():void
		{
			if(lastAttackTime > 0){
				lastAttackTime -= FlxG.elapsed;
			}else if (lastAttackTime < 0){
				lastAttackTime = 0;
			}
			super.update();
		}
		
		override public function color(color:Number):void {
			super.color(color);
			this.bubbleGun.color = color;
		}
	}
}