package Creature
{
	import Box2D.Common.Math.b2Vec2;

	public class AESlot
	{
		public var segment:AESegment;
		public var slotLocation:b2Vec2;
		
		public function AESlot(segment:AESegment, slotLocation:b2Vec2)
		{
			this.segment = segment;
			this.slotLocation = slotLocation;
		}
	}
}