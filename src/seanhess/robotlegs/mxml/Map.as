package seanhess.robotlegs.mxml
{
	/**
	 * Who has priority?
	 */
	public class Map
	{
		/**
		 * Always required. The definition they are requesting
		 */
		public var type:Class;
		
		// value has first priority
		public var value:Object;
		
		// if not value then try to instantiate it. 
		public var instantiate:Class;
		public var singleton:Class;
		public var rule:*;
		public var named:String = "";
	}
}