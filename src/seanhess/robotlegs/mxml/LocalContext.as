/*
* Copyright (c) 2009 the original author or authors
* 
* Permission is hereby granted to use, modify, and distribute this file 
* in accordance with the terms of the license agreement accompanying it.
*/

package seanhess.robotlegs.mxml
{
	import flash.display.DisplayObjectContainer;
	
	import mx.core.IMXMLObject;
	
	import org.robotlegs.base.ContextBase;
	import org.robotlegs.base.ViewMap;
	import org.robotlegs.core.IContext;
	import org.robotlegs.core.IInjector;
	import org.robotlegs.core.IReflector;
	import org.robotlegs.core.IViewMap;
	
	[DefaultProperty("rules")]
	public class LocalContext extends ContextBase implements IContext, IMXMLObject
	{
		/**
		 * @private
		 */
		protected var _contextView:DisplayObjectContainer;
		
		/**
		 * @private
		 */
		protected var _viewMap:IViewMap;
		
		/**
		 * @private
		 */
		protected var _rules:Vector.<Object>;
		
		
		
		/**
		 * The <code>DisplayObjectContainer</code> that scopes this <code>IContext</code>
		 */
		public function get contextView():DisplayObjectContainer
		{
			return _contextView;
		}
		
		/**
		 * @private
		 */
		public function set contextView(value:DisplayObjectContainer):void
		{
			_contextView = value;
		}
		
		/**
		 * The <code>IViewMap</code> for this <code>IContext</code>
		 */
		protected function get viewMap():IViewMap
		{
			return _viewMap || (_viewMap = new ViewMap(contextView, injector));
		}
		
		/**
		 * @private
		 */
		protected function set viewMap(value:IViewMap):void
		{
			_viewMap = value;
		}
		
		protected function mapDefaultInjections():void
		{
			injector.mapValue(IReflector, reflector);
			injector.mapValue(IInjector, injector);
			injector.mapValue(IViewMap, viewMap);
		}
		
		protected function mapCustomInjections():void
		{
			for each (var rule:Object in rules)
			{
				if (rule is Map)
				{
					var map:Map = rule as Map;
					
					if (map.type == null)
						throw new Error("Every Map rule must set type");
					
					if (map.value)
						injector.mapValue(map.type, map.value, map.named);
						
					else if (map.instantiate)
						injector.mapClass(map.type, map.instantiate, map.named);
						
					else if (map.singleton)
						injector.mapSingletonOf(map.type, map.singleton, map.named);
						
					else if (map.rule)
						injector.mapRule(map.type, map.rule, map.named);
						
					else
						injector.mapSingleton(map.type);
				}
				 
				else if (rule is MapView)
				{
					var mapView:MapView = rule as MapView;
					
					if (mapView.packageName)
						viewMap.mapPackage(mapView.packageName);
					
					else if (mapView.type)
						viewMap.mapType(mapView.type);
					
					else
						throw new Error("MapView needs either type or packageName");
				}
			}
		}
	
		
		/**
		 * Called by mxml after setting stuff. Map things now
		 */
		public function initialized(document:Object, id:String):void
		{
			contextView = document as DisplayObjectContainer;
			mapDefaultInjections();
			mapCustomInjections();
		}
	
		[ArrayElementType("Object")]
		public function set rules(value:Vector.<Object>):void
		{
			_rules = value;
		}
		
		public function get rules():Vector.<Object>
		{
			return _rules || (_rules = new Vector.<Object>());
		}
		
	}
}