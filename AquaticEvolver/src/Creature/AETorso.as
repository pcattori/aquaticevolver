package Creature
{	
	import Box2D.Common.Math.b2Vec2;

	public class AETorso
	{
		public var headSegment:AESegment;
		public var torsoSegments:Array;
		public var tailSegment:AESegment;
		
		public var headAnchor:b2Vec2;
		public var tailAnchor:b2Vec2;
				
		private var _appendageSlots:Array;
		
		/**
		 * IMPORTANT: An AETorso object requires that the headSegment, torsoSegments, and tailSegment be connected by joints BEFORE this constructor is called!
		 */
		public function AETorso(headSegment, headAnchor, torsoSegments, tailSegment, tailAnchor)
		{
			this.headSegment = headSegment;
			this.headAnchor = headAnchor;
			this.torsoSegments = torsoSegments;
			this.tailSegment = tailSegment;
			this.tailAnchor = tailAnchor;
			
			initializeAppendageSlots();
		}
		
		private function initializeAppendageSlots():void
		{
			_appendageSlots = new Array();
			for (var segment:AESegment in torsoSegments)
			{
				_appendageSlots = _appendageSlots.concat(segment.appendageSlots);
			}
		}
		
		public function getAppendageSlots():Array
		{
			return _appendageSlots;
		}
	}
}