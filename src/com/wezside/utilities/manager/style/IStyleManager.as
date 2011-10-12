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
package com.wezside.utilities.manager.style
{
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.text.StyleSheet;
	import flash.text.engine.ElementFormat;

	/**
	 * @author Wesley.Swanepoel
	 */
	public interface IStyleManager
	{
		function parseCSSByteArray( clazz:Class ):void;

		function hasAssetByName( linkageClassName:String ):Boolean;

		function getAssetByName( linkageClassName:String ):DisplayObject;
		
		function getClassByName( linkageClassName:String ):Class;

		function getStyleSheet( styleName:String ):StyleSheet;

		function getLibraryItems( styleName:String ):Object;

		function getPropertyStyles( styleName:String ):Array;
		
		function getElementFormat( styleName:String ):ElementFormat;

		function get css():String;

		function dispatchEvent( event:Event ):Boolean;

		function hasEventListener( type:String) :Boolean;

		function removeEventListener( type:String, listener:Function, useCapture:Boolean = false ):void;

		function addEventListener( type:String, listener:Function, useCapture:Boolean = false, priority:int = 0, useWeakReference:Boolean = false ):void;
		
		function purge():void;
	}
}
