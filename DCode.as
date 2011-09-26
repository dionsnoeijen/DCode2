package
{	
	import com.hd.VideoMax;
	
	import flash.display.Sprite;
	
	[SWF(width="800", height="800", frameRate="30", backgroundColor="#000000")]
	public class DCode extends Sprite
	{
		public function DCode()
		{
			var vm:VideoMax = new VideoMax({playOverlay:true, autoRewind:false, width:480, height:360, source:"http://www.apsbb.com/uploads/general_uploads/2009_apsbb_showreel_1.f4v"});
			this.addChild(vm);
		}
	}
}