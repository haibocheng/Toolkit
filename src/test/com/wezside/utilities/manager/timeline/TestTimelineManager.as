package test.com.wezside.utilities.manager.timeline 
{
	import flexunit.framework.Assert;

	import com.wezside.utilities.manager.timeline.TimelineEvent;
	import com.wezside.utilities.manager.timeline.TimelineManager;

	import org.flexunit.asserts.assertEquals;
	import org.flexunit.async.Async;

	import flash.display.MovieClip;

	/**
	 * @author Wesley.Swanepoel
	 */
	public class TestTimelineManager 
	{
		
		[Embed(source="/../assets-embed/swf/timelineManager/Animation01.swf")]
		private var Animation01:Class;
		
		[Embed(source="/../assets-embed/swf/timelineManager/Animation03.swf")]
		private var Animation02:Class;
		
		[Embed(source="/../assets-embed/swf/timelineManager/Animation03.swf")]
		private var Animation03:Class;
		
		private var tm:TimelineManager;
		private var mc1:MovieClip;
		private var mc2:MovieClip;
		private var mc3:MovieClip;

		[Before]
		public function setUp():void
		{
			tm = new TimelineManager();			
			mc1 = new Animation01() as MovieClip;		
			mc2 = new Animation02() as MovieClip;		
			mc3 = new Animation03() as MovieClip;		
		}
				
		[After]
		public function tearDown():void
		{
			tm.purgeAll();
			tm = null;
			mc1 = null;
			mc2 = null;
			mc3 = null;
		}		
				
		[Test(async)]
		public function testSimpleStruct():void
		{
			tm.push( "1", mc1 );
			tm.push( "two", mc2 );
			tm.push( "3", mc3 );
			tm.playAuto();
			tm.addEventListener( TimelineEvent.SEQUENTIAL_COMPLETE, Async.asyncHandler( this, complete, 13000, null, timeout ), false, 0, true );
		}
		
		protected function complete( event:TimelineEvent, object:Object ):void
		{
			assertEquals( 1, tm.total );
			assertEquals( 1, tm.playIndex );
			assertEquals( "1", tm.playID );
		}		
		
		protected function timeout( object:Object ):void
		{
		   	Assert.fail( "Pending Event Never Occurred" );
		}			
	}
}
