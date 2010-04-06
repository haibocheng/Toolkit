/*	The MIT License	Copyright (c) 2010 Wesley Swanepoel		Permission is hereby granted, free of charge, to any person obtaining a copy	of this software and associated documentation files (the "Software"), to deal	in the Software without restriction, including without limitation the rights	to use, copy, modify, merge, publish, distribute, sublicense, and/or sell	copies of the Software, and to permit persons to whom the Software is	furnished to do so, subject to the following conditions:		The above copyright notice and this permission notice shall be included in	all copies or substantial portions of the Software.		THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR	IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,	FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE	AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER	LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,	OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN	THE SOFTWARE. */package com.wezside.utilities.switchutil{
	import flash.utils.Dictionary;	import flash.utils.getQualifiedClassName;		
	/**
	 * @author Wesley.Swanepoel	 * 	 * A simple class to return switches based on xml.  
	 */
	public class SwitchUtil 	{				private static var switches:Dictionary;		private static var instance:SwitchUtil;		public function SwitchUtil() 		{			if ( instance )				throw new Error( "An instance already exists. Please use getInstance()" );							switches = new Dictionary();		}				public static function getInstance():SwitchUtil  		{			if ( instance )				instance = new SwitchUtil( );			return instance;		}				public function addSwitch( id:String, _property:String, _value:String ):void		{			switches[id] = { property: _property, value: _value };		}				public function getSwitch( id:String ):Object		{			return switches[id];		}		public function getValue( id:String ):String		{			return switches[id].value || "";		}		public function getPropertyByID( id:String ):String		{			return String( switches[id].property ) || ""; 		}		public function stringToBoolean( string:String ):Boolean		{			if ( string ) return ( string.toLowerCase() == "true" || string.toLowerCase() == "1");			return false;;		}				public function toString():String 		{			return getQualifiedClassName( this );		}
	}
}
