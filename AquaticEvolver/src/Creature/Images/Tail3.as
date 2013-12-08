package Creature.Images
{
	import Box2D.Common.Math.b2Vec2;
	
	import Creature.Schematics.AESchematic;
	
	public class Tail3
	{
		
		private static const WIDTH:Number = 128;
		private static const HEIGHT:Number = 128;
		
		/**
		 * Vertices defining the verteces for the shape, have to offset them by half the width
		 * to assure that they are centered on the sprite
		 */
		public static var polygonVerteces:Array = new Array(
			//TODO: update these numbers with Nick's locations
			new b2Vec2(AEWorld.b2NumFromFlxNum(-27),AEWorld.b2NumFromFlxNum(4)),
			new b2Vec2(AEWorld.b2NumFromFlxNum(-27),AEWorld.b2NumFromFlxNum(-1)),
			new b2Vec2(AEWorld.b2NumFromFlxNum(-13),AEWorld.b2NumFromFlxNum(-11)),
			new b2Vec2(AEWorld.b2NumFromFlxNum(2),AEWorld.b2NumFromFlxNum(-17)),
			new b2Vec2(AEWorld.b2NumFromFlxNum(12),AEWorld.b2NumFromFlxNum(-17)),
			new b2Vec2(AEWorld.b2NumFromFlxNum(20),AEWorld.b2NumFromFlxNum(-11)),
			new b2Vec2(AEWorld.b2NumFromFlxNum(25),AEWorld.b2NumFromFlxNum(-3)),
			new b2Vec2(AEWorld.b2NumFromFlxNum(25),AEWorld.b2NumFromFlxNum(4)),
			new b2Vec2(AEWorld.b2NumFromFlxNum(19),AEWorld.b2NumFromFlxNum(12)),
			new b2Vec2(AEWorld.b2NumFromFlxNum(11),AEWorld.b2NumFromFlxNum(16)),
			new b2Vec2(AEWorld.b2NumFromFlxNum(0),AEWorld.b2NumFromFlxNum(16)),
			new b2Vec2(AEWorld.b2NumFromFlxNum(-12),AEWorld.b2NumFromFlxNum(12)));
		
		[Embed(source='../../res/Tail3.png')]
		private static const IMG:Class;
		
		//TODO: update these numbers with Nick's locations
		public static const suggestedTailAnchor:b2Vec2 = AESchematic.b2Vec2FromFlxCoords(50,32,WIDTH,HEIGHT);
		
		//TODO: update these numbers with Nick's locations
		public static const suggestedAppendageSlot1:b2Vec2 = AESchematic.b2Vec2FromFlxCoords(11,32, WIDTH, HEIGHT);
		public static const suggestedAppendageSlots:Array = new Array(suggestedAppendageSlot1);
		
		public static function image():AEImage
		{
			return new AEImage(IMG,WIDTH,HEIGHT);
		}
	}
}
