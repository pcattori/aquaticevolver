package
{
	import Box2D.Common.Math.b2Vec2;
	import Box2D.Dynamics.b2World;
	
	import org.flixel.FlxG;
	import org.flixel.FlxGroup;

	public class BoxEnemy extends Creature
	{
		public var aggroRadius:int = 200;
		
		public function BoxEnemy(x:int, y:int, speed:Number, health:int, maxHealth:int, adaptations:Array) {
			super(x, y, speed, health, maxHealth);
			this.attackingWith = null;
			
			this.maxVelocity.x = 80;
			this.maxVelocity.y = 80;
			this.drag.x = this.maxVelocity.x * 2;
			this.drag.y = this.maxVelocity.y * 2;
		}
		
		/**
		 * The list of creatures, this is passed to an NPC creature's updateMovement function.
		 * -- Carlo Biedenharn - 11/12/2013
		 */
		static public var enemies:FlxGroup = new FlxGroup();
		
		static public function generateBoxEnemy(newX, newY, defaultSpeed, curHealth, maxHealth):BoxEnemy {
			var newEnemy:BoxEnemy = new BoxEnemy(newX, newY, defaultSpeed, curHealth, maxHealth, new Array());
			enemies.add(newEnemy);
			return newEnemy;
		}
		
		static public function getEnemiesLength():Number {
			return enemies.length;
		}
		
		private function getRandomAdaptations(adaptations:Array, maxPower:int):Array{
			
			var remainingValue:int = maxPower;
			var adaptArray:Array = new Array();
			
			//Selecting random adaptations while we still have power points remaining
			while(remainingValue > 0){
				var randomAdaptation:Adaptation = adaptations[Math.floor(Math.random() * adaptations.length)]; 
				adaptArray.push(randomAdaptation);
				//Subtracting the selected adaptation's "power" from the remaining value
				remainingValue -= (randomAdaptation.attackDamage + randomAdaptation.attackPower);
			}
			
			return adaptArray;
		}
		
		override public function update():void {
			var weakestIndex:int   = 0;
			var strongestIndex:int = 0;
			var weakestStrength:int   = 0;
			var strongestStrength:int = 0;
			var score:int;
			var seeSomething:Boolean = false;
			
			if (!this.onScreen(null))
			{
				enemies.remove(this, true);
				this.kill();
				this.destroy();
			}
			
			updateMove();
			
			super.update();
		}
		
		private function updateMove():void {
			var weakestIndex:int   = 0;
			var strongestIndex:int = 0;
			var weakestStrength:int   = 0;
			var strongestStrength:int = 0;
			var score:int;
			var seeSomething:Boolean = false;
			for (var i:int = 0; i < enemies.length; i++) {
				if (Math.sqrt(Math.pow(this.x - enemies.members[i].x, 2) +
					Math.pow(this.y - enemies.members[i].y, 2)) < aggroRadius) {
					seeSomething = true;
					score = enemies.members[i].getHealth() - this.getHealth();
					if (score < weakestStrength) {
						weakestIndex = i;
						weakestStrength = score;
					}
					if (score > strongestStrength) {
						strongestIndex = i;
						strongestStrength = score;
					}
				}
			}
			if (seeSomething) {
				this.moveTowardsEnemy(AEWorld.player);
				if (weakestStrength == 0) {
					trace("RUN AWAY");
					//this.runAwayFromEnemy(enemies.members[strongestIndex]);
				} else {
					trace("MOVE TOWARDS");
					//this.moveTowardsEnemy(enemies.members[weakestIndex]);
				}
			} else {
				//this.moveAround();
			}
		}
		
		private function runAwayFromEnemy(enemy:Creature):void {
          moveRelativeToEnemy(enemy, false);
		}

		private function moveTowardsEnemy(enemy:Creature):void {
          moveRelativeToEnemy(enemy, true);
		}

        private function moveRelativeToEnemy(enemy:Creature, towards:Boolean):void {
            var impulseSize:int = (towards) ? super.speed: -1*super.speed;
			var dirX:int = (enemy.x - this.x)
			var dirY:int = (enemy.y - this.y)
            var impulseX:int = 0;
            var impulseY:int = 0;
			if (dirX < 0) {
				impulseX = -1*impulseSize;
			} else if (dirX > 0) {
				impulseX = impulseSize;
			}
			if (dirY < 0) {
				impulseY = -1*impulseSize;
			} else if (dirY > 0) {
				impulseY = impulseSize;
			}
		    _obj.ApplyImpulse(getForceVec(impulseX, impulseY), _obj.GetPosition());
        }

		private function getForceVec(xDir:Number, yDir:Number):b2Vec2 {
			var vec:b2Vec2;
			if ( xDir != 0 && yDir != 0)
			{
				vec = new b2Vec2(xDir * 1/Math.sqrt(2), yDir * 1/Math.sqrt(2));
			}
			else
			{
				vec = new b2Vec2(xDir, yDir);
			}
			vec.Multiply(0.001);
			return vec;
		}

		public function moveAround():void{
			//TODO Make the enemy randomly move around if it's not chasing/attacking/running away from another enemy
			this.acceleration.x = Math.random() * 600 - 300;
			this.acceleration.y = Math.random() * 600 - 300;
		}
	}
}
