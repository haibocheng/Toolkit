/**
 * Copyright (c) 2011 Wesley Swanepoel
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 */
package com.wezside.data.collection 
{
	import com.wezside.data.iterator.ArrayIterator;
	import com.wezside.data.iterator.IIterator;

	/**
	 * @author Wesley.Swanepoel
	 */
	public class XMLDataCollection implements ICollection
	{
		
		private var _collection:Array;

		public function XMLDataCollection() 
		{
			_collection = [];	
		}
		
		public function iterator():IIterator
		{
			return new ArrayIterator( _collection );
		}

		public function addElement( value:* ):void 
		{
			_collection.push( value );	
		}		

		public function addElementAt( value:*, index:int ):void
		{
		}		
		
		public function getElementAt( index:int ):*
		{
			return _collection[ index ];
		}			

		public function find( prop:* = "", value:* = null ):*
		{			
			var it:IIterator = iterator();
			var item:*;
						
			// Returns the first item
			if ( prop == "" && !value && it.hasNext() ) 
			{
				item = it.next();
			}
			if ( item )
			{
				it.purge();
				it = null;
				return item;
			}				
			
			while ( it.hasNext() )	
			{
				item = it.next();
				if ( item[ prop ] == value )
				{
					it.purge();
					it = null;
					return item;
				}
			}
			it.purge();
			it = null;
			return null;
		}
				
		public function removeElement( prop:* = "", value:* = null ):*
		{
			var removeIndex:int = -1;
			var it:IIterator = iterator();
			while ( it.hasNext())
			{
				var item:* = it.next();
				if ( item.hasOwnProperty( prop ) && item[ prop ] == value )
				{
					removeIndex = it.index() - 1;
					break;
				}
			}			
			it.purge();
			it = null;
			return _collection.splice( removeIndex, 1 );			
		}		
		
		public function removeElementAt( index:int ):void
		{
			_collection.splice( index, 1 );
		}				
		
		public function get length():int
		{
			return _collection.length;			
		}
		
		public function clone():ICollection
		{
			var copy:ICollection = new Collection();
			var it:IIterator = iterator();
			var object:*;
			while ( it.hasNext() )
				copy.addElement( it.next() );

			it.purge();
			it = null;
			object = null;
			return copy;
		}		
		
		public function cloneFromIndex( index:int, end:int = -1 ):ICollection
		{
			var copy:ICollection = new Collection();
			var it:IIterator = iterator();
			var object:*;
			while ( it.hasNext() && ( end == -1 || it.index() - 1 < end - 1 ))
			{
				object = it.next();
				if ( it.index() - 1 >= index )
					copy.addElement( object );
			}
			it.purge();
			it = null;
			object = null;
			return copy;			
		}
		
		public function purge():void
		{
			_collection = null;
		}
		
		public function toString():String
		{
			var str:String = "";
			var it:IIterator = iterator();
			while ( it.hasNext())
			{
				var item:* = it.next();	
				str += item.toString();
			}
			it.purge();
			it = null;			
			return str;
		}

		public function ascending():ICollection
		{
			return null;
		}

		public function descending():ICollection
		{
			return null;
		}

		public function sortOn( property:String ):ICollection
		{
			return null;
		}

		public function elapsedSortTime():Number
		{
			return 0;
		}

		public function sortMethod( type:int = 0 ):ICollection
		{
			return null;
		}

		public function sort():ICollection
		{
			return null;
		}
	}
}
