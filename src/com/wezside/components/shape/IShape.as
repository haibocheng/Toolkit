package com.wezside.components.shape 
{
	import com.wezside.components.IUIDecorator;
	
	/**
	 * @author Wesley.Swanepoel
	 */
	public interface IShape extends IUIDecorator 
	{
		function get backgroundColours():Array
		function set backgroundColours( value:Array ):void
		
		function get backgroundAlphas():Array
		function set backgroundAlphas( value:Array ):void
		
		function get cornerRadius():int
		function set cornerRadius( value:int ):void
		
		function get borderAlpha():int
		function set borderAlpha( value:int ):void
		
		function get borderThickness():int
		function set borderThickness( value:int ):void
		
		function draw():void;
	}
}