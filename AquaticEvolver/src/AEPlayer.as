package
{
	import Box2D.Collision.Shapes.b2PolygonShape;
	import Box2D.Common.Math.b2Vec2;
	import Box2D.Dynamics.b2Body;
	
	import Creature.AECreature;
	import Creature.AEHead;
	import Creature.AESegment;
	import Creature.AETail;
	import Creature.AETorso;
	import Creature.Images.Head1;
	import Creature.Images.Tail1;
	import Creature.Images.Torso1;
	import Creature.Schematics.AESchematic;
	
	import org.flixel.FlxG;
	import org.flixel.FlxPoint;
	
	public class AEPlayer extends AECreature
	{
		private var defaultMovementScheme:Boolean = true; 
		
		public function AEPlayer(x:Number, y:Number)
		{	
			var head:AEHead = playerHead(x,y);
			var torso:AETorso = playerTorso(x,y);
			var tail:AETail = playerTail(x,y);
			super(SpriteType.PLAYER, x, y, head, torso, tail);
		}
		
		public function getFollowObject():B2FlxSprite
		{
			return _head.headSegment;
		}
		
		//Should probably be moved up to the AECreature class
		private function playerHead(x:Number, y:Number):AEHead
		{
			var headSchematic:AESchematic = new AESchematic(Head1.image(), Head1.suggestedAppendageSlots);
			//Setting up the segment's shape
			var playerHeadShape:b2PolygonShape = new b2PolygonShape();
			playerHeadShape.SetAsArray(Head1.polygonVerteces);
			var playerHeadSegment:AESegment = new AESegment(x,y, headSchematic, playerHeadShape); //TODO: HeadSegment should have modified height/width... current dimensions make head and tail touch and prevent swiveling
			var playerHead:AEHead = new AEHead(playerHeadSegment, Head1.suggestedHeadAnchor);
			return playerHead;
		}
		//Should probably be moved up to the AECreature class
		private function playerTorso(x:Number, y:Number):AETorso
		{
			var torsoSchematic:AESchematic = new AESchematic(Torso1.image(), Torso1.suggestedAppendageSlots);
			//Setting up segment's shape
			var playerTorsoShape:b2PolygonShape = new b2PolygonShape();
			playerTorsoShape.SetAsArray(Torso1.polygonVerteces);
			var playerTorsoSegment:AESegment = new AESegment(x,y, torsoSchematic, playerTorsoShape);
			var playerTorsoSegments:Array = new Array(playerTorsoSegment);
			var playerTorso:AETorso = new AETorso(playerTorsoSegment, Torso1.suggestedHeadAnchor, playerTorsoSegments, playerTorsoSegment, Torso1.suggestedTailAnchor);
			return playerTorso;
		}
		//Should probably be moved up to the AECreature class
		private function playerTail(x:Number, y:Number):AETail
		{
			var tailSchematic:AESchematic = new AESchematic(Tail1.image(), Tail1.suggestedAppendageSlots);
			var playerTailShape:b2PolygonShape = new b2PolygonShape();
			//Setting the segment's shape
			playerTailShape.SetAsArray(Tail1.polygonVerteces);
			var playerTailSegment:AESegment = new AESegment(x, y, tailSchematic, playerTailShape);
			var playerTail:AETail = new AETail(playerTailSegment, Tail1.suggestedTailAnchor);
			return playerTail;
		}	
		
		public function update():void
		{		
			var movementBody:b2Body = _head.headSegment.getBody();
			if (!FlxG.paused) {
				var xDir:Number = 0;
				var yDir:Number = 0;
				
				if(FlxG.mouse.justPressed())
				{
					
					var mousePoint:FlxPoint = new FlxPoint(FlxG.mouse.screenX, FlxG.mouse.screenY);
					var playerPoint:FlxPoint = new FlxPoint(AEWorld.flxNumFromB2Num(movementBody.GetPosition().x), AEWorld.flxNumFromB2Num(movementBody.GetPosition().y));
					movementBody.ApplyImpulse(calcB2Impulse(mousePoint, playerPoint), movementBody.GetPosition());					
				}
					
					// moving the player based on the arrow keys inputs
				else if (FlxG.keys.LEFT && FlxG.keys.RIGHT) {
				} 
				else if (FlxG.keys.LEFT) {
					//					trace("BoxPlayer: left");
					xDir = -1*this.speed;
				} else if (FlxG.keys.RIGHT) {
					//					trace("BoxPlayer: right");
					xDir = 1*this.speed;
				}
					
				else if (FlxG.keys.UP && FlxG.keys.DOWN)	{
				} 
				else if (FlxG.keys.UP) {
					//					trace("BoxPlayer: up");
					yDir = -1*this.speed;
				} else if (FlxG.keys.DOWN) {
					//					trace("BoxPlayer: down");
					yDir = 1*this.speed;
				}
				
				if(defaultMovementScheme) {
					movementBody.ApplyImpulse(getForceVec(xDir, yDir), movementBody.GetPosition());					
				} else {
					var angle:Number = movementBody.GetAngle() + Math.PI/2;
					var force:b2Vec2 = new b2Vec2(0.05 * Math.sin(angle) * yDir * -1, 0.05 * Math.cos(angle) * yDir);
					movementBody.ApplyImpulse(force, movementBody.GetPosition());
					var torque:Number = 0.5;
					movementBody.SetAngularVelocity(torque * xDir);
				}
			}
		}
		
		private function getForceVec(xDir:Number, yDir:Number):b2Vec2 {
			var vec:b2Vec2;
			if ( xDir != 0 && yDir != 0) {
				vec = new b2Vec2(xDir * 1/Math.sqrt(2), yDir * 1/Math.sqrt(2));
			} else {
				vec = new b2Vec2(xDir, yDir);
			}
			vec.Multiply(0.05);
			return vec;
		}
		
		private function calcB2Impulse(mousePoint:FlxPoint, bodyPoint:FlxPoint):b2Vec2
		{
			var angle:Number = Math.atan2(mousePoint.y - bodyPoint.y,mousePoint.x - bodyPoint.x);
			var magnitude:Number = 0.002;
			return new b2Vec2(magnitude * Math.cos(angle), magnitude * Math.sin(angle));
		}
	}
}