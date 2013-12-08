package
{	
	import Box2D.Common.Math.b2Vec2;
	import Box2D.Dynamics.b2Body;
	
	import Creature.AECreature;
	
	import Def.AEHeadDef;
	import Def.AETailDef;
	import Def.AETorsoDef;
	
	import org.flixel.FlxG;
	import org.flixel.FlxGroup;
	import org.flixel.FlxPoint;
	
	public class AEEnemy extends AECreature
	{

		public static var enemies:Array;
		
		/**
		 * The target that the creature is moving towards and therefore also attacking.
		 */
		private var target:FlxPoint = new FlxPoint(AEWorld.player.getX(), AEWorld.player.getY());
        private var counter:Number = 0;
		public var aggroRadius:int = 200;
		private const BOUNDSBUFFER:int = 300;
		private var movementBody:b2Body;
		
		private var attitude:String = "Passive";
		private var original:FlxPoint;
		private var current:FlxPoint;
		private var boxBound:int = Math.random()*300+50;
		
		private static var unusedIDs:Array = new Array(2,3,4,5,6,7,8,9,10,11,12,13,14,15);
		private static var usedIDs:Array = new Array();
		
		private var _id:Number;
		
		public function AEEnemy(id:Number, type:Number, x:Number, y:Number, health:Number, headDef:AEHeadDef, torsoDef:AETorsoDef, tailDef:AETailDef)
		{
			_id = id;
			trace('Enemy created with id:' + _id);
			super(type, x, y, health, headDef, torsoDef, tailDef);
			this.original = new FlxPoint(this.x, this.y);
			this.current  = new FlxPoint(original.x + boxBound, original.y);
		}
		
		public static function generateEnemy(x:Number, y:Number):AEEnemy
		{
			if (unusedIDs.length != 0)
			{
				var id:Number = unusedIDs.pop();
				var newEnemy:AEEnemy = new AEEnemy(id, SpriteType.ENEMY, x, y, 10, AECreature.head1Def(x,y), AECreature.torso1Def(x,y), AECreature.tail1Def(x,y));
				usedIDs.push(id);
				AEEnemy.enemies.push(newEnemy);
				return newEnemy;
			}else {
				for each (var enemy:AEEnemy in enemies)
				{
					if (AEWorld.world.outOfBounds(AEWorld.flxNumFromB2Num(enemy.getX()), AEWorld.flxNumFromB2Num(enemy.getY())))
					{
						enemy.kill();
						// try again
						return generateEnemy(x,y);
					}
				}
				return null;
			}
		}
		
		override public function getID():Number
		{
			return _id;
		}
		
		override public function update():void{		
			this.x = this.getX();
			this.y = this.getY();
			super.update();
			counter += FlxG.elapsed;
			this.movementBody = this._head.headSegment.getBody();
			if (attitude == "Passive") {
				passiveMovement();
			} else {
				aggressiveMovement();
			}
		}
		
		override public function kill():void
		{
			unusedIDs.push(_id);
			enemies.splice(enemies.indexOf(this),1); 
			super.kill();
        }

		public static function updateEnemies():void {
			for each (var enemy:AEEnemy in enemies) {
				enemy.update();
			}
		}

		private function aggressiveMovement():void {
			this.moveCloseToEnemy(AEWorld.player, 240);
			target = new FlxPoint(AEWorld.player.x, AEWorld.player.y);
		}
		
		private function runAwayFromEnemy(enemy:AECreature):void {
			moveRelativeToEnemy(enemy, false);
		}
		
		private function moveTowardsEnemy(enemy:AECreature):void {
			moveRelativeToEnemy(enemy, true);
		}
		
		private function moveRelativeToEnemy(enemy:AECreature, towards:Boolean):void {
			var impulseSize:int = (towards) ? super.speed: -1*super.speed;
			var dirX:int = (enemy.x - this.x);
			var dirY:int = (enemy.y - this.y);
			var forceVec:b2Vec2 = getForceVec(dirX, dirY, impulseSize);
			this.movementBody.ApplyImpulse(forceVec, this.movementBody.GetPosition());
		}
		
		private function moveCloseToEnemy(enemy:AECreature, distance:Number):void {
			var impulseSize:int = super.speed;
			var distanceFromEnemy:int = Math.sqrt(Math.pow(this.x - enemy.x, 2) + Math.pow(this.y - enemy.y, 2));
			if (distanceFromEnemy < distance)
				impulseSize = -1*super.speed;
			// Non-ideal, but OK convergence.
			// I don't know if it's still called convergence though if we just zero out the amplitude at a point.
			if (Math.abs(distanceFromEnemy - distance) < 5) {
				impulseSize = 0;
			} else if (Math.abs(distanceFromEnemy - distance) < 20) {
				impulseSize = (impulseSize / super.speed);
			}
			var dirX:int = (enemy.x - this.x);
			var dirY:int = (enemy.y - this.y);
			var forceVec:b2Vec2 = getForceVec(dirX, dirY, impulseSize*3);
			this.movementBody.ApplyImpulse(forceVec, this.movementBody.GetPosition());
			
		}
		
		// Returns a vector in the (xDir, yDir) direction with a magnitude of impulseSize * 0.001.
		private function getForceVec(xDir:Number, yDir:Number, impulseSize:Number):b2Vec2 {
			var vec:b2Vec2 = new b2Vec2(xDir, yDir);
			vec.Normalize();
			vec.Multiply(impulseSize * 0.01);
			return vec;
		}
		
		private function attack(attackPoint:FlxPoint):void {
			for each (var adapt:Adaptation in _adaptations) {
				adapt.attack(target);
			}
		}
		
		private function aim(attackPoint:FlxPoint):void {
			for each (var adapt:Adaptation in _adaptations) {
				adapt.aim(target);
			}
		}
		
		private function passiveMovement():void{
						
			if(Math.abs(this.x-original.x)<20 && Math.abs(this.y-original.y)<20){
				current = new FlxPoint(original.x + boxBound, original.y);
			}
			else if(Math.abs(this.x-(original.x + boxBound))<20 && Math.abs(this.y-original.y)<20){
				current = new FlxPoint(original.x + boxBound, original.y - boxBound);
			}
			else if(Math.abs(this.x-(original.x + boxBound))<20 && Math.abs(this.y-(original.y - boxBound))<20){
				current = new FlxPoint(original.x, original.y - boxBound);
			}
			else if(Math.abs(this.x-original.x)<20 && Math.abs(this.y-(original.y - boxBound))<20){
				current = new FlxPoint(original.x, original.y);
			}
			
			movetoPoint(current, 10);
		}
			
		private function movetoPoint(target:FlxPoint, distance:Number):void {
			var impulseSize:int = super.speed;
			var distanceFromPoint:int = Math.sqrt(Math.pow(this.x - target.x, 2) + Math.pow(this.y - target.y, 2));
			if (distanceFromPoint < distance)
				impulseSize = -1*super.speed;
			// Non-ideal, but OK convergence.
			// I don't know if it's still called convergence though if we just zero out the amplitude at a point.
			if (Math.abs(distanceFromPoint - distance) < 5) {
				impulseSize = 0;
			} else if (Math.abs(distanceFromPoint - distance) < 20) {
				impulseSize = (impulseSize / super.speed);
			}
			var dirX:int = (target.x - this.x);
			var dirY:int = (target.y - this.y);
			var forceVec:b2Vec2 = getForceVec(dirX, dirY, impulseSize);
			this.movementBody.ApplyImpulse(forceVec, this.movementBody.GetPosition());
		}
	}
}
