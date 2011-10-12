/*
The MIT License

Copyright (c) 2011 Wesley Swanepoel
	
Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:
	
The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.
	
THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.
 */
package com.wezside.component
{
	import com.wezside.data.collection.DictionaryCollection;
	import com.wezside.data.collection.IDictionaryCollection;
	import com.wezside.utilities.observer.IObserverDetail;
	import com.wezside.utilities.observer.ObserverDetail;
	import com.wezside.component.decorator.interactive.IInteractive;
	import com.wezside.component.decorator.interactive.Interactive;
	import com.wezside.component.decorator.layout.ILayout;
	import com.wezside.component.decorator.layout.Layout;
	import com.wezside.component.decorator.scroll.IScroll;
	import com.wezside.component.decorator.scroll.ScrollEvent;
	import com.wezside.component.decorator.scroll.ScrollHorizontal;
	import com.wezside.component.decorator.scroll.ScrollVertical;
	import com.wezside.component.decorator.shape.IShape;
	import com.wezside.data.collection.Collection;
	import com.wezside.data.collection.ICollection;
	import com.wezside.data.iterator.ArrayIterator;
	import com.wezside.data.iterator.ChildIterator;
	import com.wezside.data.iterator.IIterator;
	import com.wezside.data.iterator.NullIterator;
	import com.wezside.utilities.logging.Tracer;
	import com.wezside.utilities.manager.state.StateManager;
	import com.wezside.utilities.manager.style.IStyleManager;
	import com.wezside.utilities.observer.INotifier;
	import com.wezside.utilities.observer.IObserver;
	import com.wezside.utilities.string.StringUtil;

	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.text.StyleSheet;
	import flash.utils.getQualifiedClassName;


	/**
	 * @author Wesley.Swanepoel
	 */
	[Event( name="INIT", type="com.wezside.component.UIElementEvent" )]
	[Event( name="CREATION_COMPLETE", type="com.wezside.component.UIElementEvent" )]
	[Event( name="STYLEMANAGER_READY", type="com.wezside.component.UIElementEvent" )]
	[Event( name="ARRANGE_COMPLETE", type="com.wezside.component.UIElementEvent" )]
	[Event( name="STATE_CHANGE", type="com.wezside.component.UIElementEvent" )]
	public class UIElement extends Sprite implements IUIElement, INotifier, IObserver
	{
		
		public static const ITERATOR_PROPS:String = "ITERATOR_PROPS";
		public static const ITERATOR_CHILDREN:String = "ITERATOR_CHILDREN";
		
		private var _styleName:String;
		private var _skin:IUIElementSkin;
		private var _styleSheet:StyleSheet;
		private var _styleManager:IStyleManager;
		private var _stateManager:StateManager;
		private var _currentStyleName:String;
		private var _childrenContainer:Sprite;		
		private var _layout:ILayout;
		private var _scroll:IScroll;
		private var _background:IShape;
		private var _interactive:IInteractive;
		private var _debug:Boolean;
		private var _observers:ICollection;
		private var _observeStates:IDictionaryCollection;
		private var scrollMask:Sprite;

		public function UIElement()
		{
			construct();
		}

		public function construct():void
		{
			_skin = new UIElementSkin();
			_layout = new Layout( this );
			_interactive = new Interactive( this );
			_childrenContainer = new Sprite();
			_observers = new Collection();
			_observeStates = new DictionaryCollection();
			
			_stateManager = new StateManager();
			_stateManager.addState( UIElementState.STATE_VISUAL_INVALID, true );
			_stateManager.addState( UIElementState.STATE_VISUAL_SELECTED, true );
			_stateManager.addState( UIElementState.STATE_VISUAL_UP );
			_stateManager.addState( UIElementState.STATE_VISUAL_OVER );
			_stateManager.addState( UIElementState.STATE_VISUAL_DOWN );
			_stateManager.addState( UIElementState.STATE_VISUAL_DISABLED );
			_stateManager.addState( UIElementState.STATE_VISUAL_CLICK );
			_stateManager.stateKey = UIElementState.STATE_VISUAL_UP;
			
			registerObserver( this );
		}

		override public function contains( child:DisplayObject ):Boolean
		{
			return _childrenContainer.contains( child );
		}

		override public function addChild( child:DisplayObject ):DisplayObject
		{
			return _childrenContainer.addChild( child );
		}

		override public function addChildAt( child:DisplayObject, index:int ):DisplayObject
		{
			return _childrenContainer.addChildAt( child, index );
		}

		override public function getChildAt( index:int ):DisplayObject
		{
			return _childrenContainer.getChildAt( index );
		}

		override public function getChildByName( name:String ):DisplayObject
		{
			return _childrenContainer.getChildByName( name );
		}
	
		override public function getChildIndex( child:DisplayObject ):int
		{
			return _childrenContainer.getChildIndex( child );
		}
	
		override public function removeChildren( beginIndex:int = 0, endIndex:int = 2147483647 ):void
		{
			_childrenContainer.removeChildren( beginIndex, endIndex );
		}

		override public function removeChild( child:DisplayObject ):DisplayObject
		{
			return _childrenContainer.removeChild( child );
		}

		override public function removeChildAt( index:int ):DisplayObject
		{
			return _childrenContainer.removeChildAt( index );
		}

		override public function get numChildren():int
		{
			return _childrenContainer ? _childrenContainer.numChildren : 0;
		}

		public function containsUI( child:DisplayObject ):Boolean
		{
			return super.contains( child );
		}

		public function addUIChild( child:DisplayObject ):DisplayObject
		{
			return super.addChild( child );
		}

		public function addUIChildAt( child:DisplayObject, index:int ):DisplayObject
		{
			return super.addChildAt( child, index );
		}

		public function getUIChildAt( index:int ):DisplayObject
		{
			return super.getChildAt( index );
		}

		public function getUIChildByName( name:String ):DisplayObject
		{
			return super.getChildByName( name );
		}

		public function removeAllChildren():void
		{
			removeChildren( 0, _childrenContainer.numChildren );
			removeUIChildren( 0, numChildren );
		}

		public function removeUIChildren( beginIndex:int = 0, endIndex:int = 2147483647 ):void
		{
			super.removeChildren( beginIndex, endIndex );
		}

		public function removeUIChild( child:DisplayObject ):DisplayObject
		{
			return super.removeChild( child );
		}

		public function removeUIChildAt( index:int ):DisplayObject
		{
			return super.removeChildAt( index );
		}

		public function get numUIChildren():int
		{
			return super.numChildren;
		}

		public function get bareWidth():Number
		{
			return _childrenContainer.width == 0 ? super.width : _childrenContainer.width;
		}
		
		public function get bareHeight():Number
		{
			return _childrenContainer.height ==0 ? super.height : _childrenContainer.height;
		}

		public function build():void
		{
			if ( _background ) super.addChildAt( _background as DisplayObject, 0 );
			if ( _scroll )
			{
				super.addChild( _scroll as DisplayObject );
			}
			super.addChild( DisplayObject( _skin ) );
			super.addChild( _childrenContainer );
		}

		public function setStyle():void
		{
			// If this has a styleName then apply the styles
			if ( _styleName && styleManager )
				setProperties( this, _styleName );
			else
			{
				// Grab Constructor as styleName
				var qualifiedClass:String = getQualifiedClassName( this );
				_styleName = qualifiedClass.substr( qualifiedClass.lastIndexOf( "::" ) + 2 );

				if ( styleManager )
					setProperties( this, _styleName );
			}
		}

		public function arrange():void
		{
			if ( _layout ) _layout.arrange();
			if ( _scroll )
			{
				_scroll.arrange();
				drawScrollMask();
			}
			if ( _background ) _background.arrange();
		}

		public function activate():void
		{
			_interactive.activate();
		}

		public function deactivate():void
		{
			_interactive.deactivate();
		}

		public function get styleManager():IStyleManager
		{
			return _styleManager;
		}

		public function set styleManager( value:IStyleManager ):void
		{
			_styleManager = value;
			dispatchEvent( new UIElementEvent( UIElementEvent.STYLEMANAGER_READY ) );
		}

		public function get styleName():String
		{
			return _styleName;
		}

		public function set styleName( value:String ):void
		{
			_styleName = value;
		}

		public function get styleSheet():StyleSheet
		{
			return _styleSheet;
		}

		public function set styleSheet( value:StyleSheet ):void
		{
			_styleSheet = value;
		}

		public function get skin():IUIElementSkin
		{
			return _skin;
		}

		public function set skin( value:IUIElementSkin ):void
		{
			_skin = value;
		}

		public function get layout():ILayout
		{
			return _layout;
		}

		public function set layout( value:ILayout ):void
		{
			_layout = value;
			_layout.addEventListener( UIElementEvent.ARRANGE_COMPLETE, arrangeComplete );
		}

		public function get background():IShape
		{
			return _background;
		}

		public function set background( value:IShape ):void
		{
			_background = value;
		}

		public function get scroll():IScroll
		{
			return _scroll;
		}

		public function set scroll( value:IScroll ):void
		{
			_scroll = value;
			_scroll.addEventListener( ScrollEvent.CHANGE, scrollChange );
		}

		public function get interactive():IInteractive
		{
			return _interactive;
		}

		public function set interactive( value:IInteractive ):void
		{
			_interactive = value;
		}

		public function purge():void
		{
			var it:IIterator = iterator( ITERATOR_CHILDREN );
			while ( it.hasNext() )
			{
				var child:* = it.next();
				if ( _childrenContainer )
					_childrenContainer.removeChild( child );
			}
			if ( _childrenContainer && containsUI( _childrenContainer ))
			{
				_childrenContainer.mask = null;
				removeUIChild( _childrenContainer );
			}
			if ( _scroll && containsUI( DisplayObject( _scroll )))
			{
				_childrenContainer.mask = null;
				removeUIChild( scrollMask );
				_scroll.removeEventListener( ScrollEvent.CHANGE, scrollChange );
				_scroll.purge();
				removeUIChild( DisplayObject( _scroll ));
			}
			if ( _layout ) _layout.removeEventListener( UIElementEvent.ARRANGE_COMPLETE, arrangeComplete );
			if ( _stateManager ) _stateManager.purge();
			if ( _skin && containsUI( DisplayObject( _skin ) )) removeUIChild( DisplayObject( _skin ) );
			if ( _background && containsUI( DisplayObject( _background ) )) removeUIChild( DisplayObject( _background ) );

			_observeStates.purge();
			_observeStates = null;

			it.purge();
			it = null;

			_skin = null;
			_styleSheet = null;
			_styleManager = null;
			_stateManager = null;
			_childrenContainer = null;
			_layout = null;
			_scroll = null;
			_background = null;
			_interactive = null;
			scrollMask = null;
		}

		public function get state():String
		{
			return _stateManager.stateKey;
		}

		public function set state( value:String ):void
		{
			_stateManager.stateKey = value;
			_skin.setSkin( _stateManager.stateKeys );
			if ( _observers.length > 0 ) notifyObservers( _stateManager.stateKey );
		}

		public function get stateManager():StateManager
		{
			return _stateManager;
		}

		public function set stateManager( value:StateManager ):void
		{
			_stateManager = value;
		}

		public function iterator( type:String = null ):IIterator
		{
			switch ( type )
			{
				case ITERATOR_PROPS:
					return new ArrayIterator( styleManager.getPropertyStyles( _currentStyleName ) );
				case ITERATOR_CHILDREN:
					return new ChildIterator( _childrenContainer );
			}
			return new NullIterator();
		}

		public function hasOwnProperty( V:* = undefined ):Boolean
		{
			return super.hasOwnProperty( V );
		}

		public function get debug():Boolean
		{
			return _debug;
		}

		public function set debug( value:Boolean ):void
		{
			_debug = value;
		}

		protected function arrangeComplete( event:UIElementEvent ):void
		{
			dispatchEvent( event );
		}

		protected function scrollChange( event:ScrollEvent ):void
		{
			var childContainerProp:String = event.prop == "y" ? "height" : "width";
			_childrenContainer[ event.prop ] = -event.percent * ( _childrenContainer[ childContainerProp ] - event.scrollValue );
		}

		private function drawScrollMask():void
		{
			var w:int = scroll is ScrollHorizontal ? _scroll.scrollWidth : width;
			var h:int = scroll is ScrollVertical ? _scroll.scrollHeight : height;

			if ( !scrollMask ) scrollMask = new Sprite();

			scrollMask.graphics.clear();
			scrollMask.graphics.beginFill( 0xff0000, 0.5 );
			scrollMask.graphics.drawRect( layout.left, layout.top, w, h );
			scrollMask.graphics.endFill();
			addUIChild( scrollMask );
			_childrenContainer.mask = scrollMask;
		}

		private function setProperties( target:IUIElement, currentStyleName:String = "" ):void
		{
			_currentStyleName = currentStyleName;
			var iter:IIterator = iterator( ITERATOR_PROPS );
			var strUtil:StringUtil = new StringUtil();

			while ( iter.hasNext() )
			{
				var property:Object = iter.next();

				// Set all non skin properties
				if ( target.hasOwnProperty( property.prop ))
				{
					var value:* = String( property.value );
					if ( property.value == "false" || property.value == "true" )
						value = strUtil.stringToBoolean( property.value );

					if ( property && String( property.value ).indexOf( "#" ) != -1 )
						value = "0x" + String( property.value ).substring( 1 );

					if ( !isNaN( property.value ))
						value = Number( property.value );

					target[ property.prop ] = value;
					Tracer.output( _debug, " " + property.prop + ": " + value, toString() );
				}

				if ( _skin.hasSkinProperty( property.prop ))
					_skin[ property.prop ] = styleManager.getAssetByName( String( property.value ) );
			}

			if ( _skin.hasSkinProperty( "upSkin" ) && state == "" )
				state = UIElementState.STATE_VISUAL_UP;

			iter = null;
			strUtil = null;
		}

		public function registerObserver( observer:IObserver ):void
		{
			_observers.addElement( observer );
		}
		
		public function unregisterObserver( observer:IObserver ):void
		{
			_observers.removeElement( observer );
		}
		
		public function notifyObservers( data:* = null ):void
		{
			// Notify all observers
			var it:IIterator = _observers.iterator();
			while ( it.hasNext() ) 
			{
				var observer:IObserver = it.next() as IObserver;
				var object:Object = observer.getObserveState( stateManager.state.key );
				// Only notify if the observer registered for this state		
				if ( object && stateManager.compare( object.id ))
				{
					if ( object.callback ) object.callback( new ObserverDetail( this, stateManager.state, data ));
					else observer.notify( new ObserverDetail( this, stateManager.state, data ));
				}
			}
			it.purge();
			it = null;
		}
		
		public function setObserveState( id:String, callback:Function = null ):void
		{
			_observeStates.addElement( id, { id: id, callback: callback });				
		}				
		
		public function getObserveState( id:String ):Object
		{
			return _observeStates.getElement( id );
		}
		
		public function notify( detail:IObserverDetail = null ):void
		{
		}
		
	}
}