/**
 *	Implementation of the Park Miller (1988) "minimal standard" linear
 *	congruential pseudo-random number generator.
 *
 *	The generator uses a modulus constant (m) of 2^31 - 1 which is a
 *	Mersenne Prime number and a full-period-multiplier of 16807.
 *
 *	@author Michael Baczynski, http://www.polygonal.de
 *
 *	Modified version, visit polygonal labs for original source.
 */

/**
 *	Implementation of the Marsaglia polar method for generation of
 *	standard normal pseudo-random numbers.
 *
 *	@author hdachev, http://blog.controul.com
 */

package com.tools
{
	/**
	 *	Park–Miller PRNG.
	 */
	
	public class StandardNormal
	{
		private var s : int;
		private var ready : Boolean;
		private var cache : Number;
		
		public function StandardNormal ( seed : uint = 1 )
		{
			s = seed > 0 ? seed % 2147483647 : 1;
		}
		
		public function get seed () : uint
		{
			//	Clear the cache to make sure that a synched
			//	prng will produce the expected output.
			
			ready = false;
			return s;
		}
		
		public function set seed ( seed : uint ) : void
		{
			//	Clear the cache to make sure that a synched
			//	prng will produce the expected output.
			
			ready = false;
			s = seed > 0 ? seed % 2147483647 : 1;
		}
		
		/*
		*	Returns a Number ~ U(0,1)
		*/
		public function uniform () : Number
		{
			return ( ( s = ( s * 16807 ) % 2147483647 ) / 2147483647 );
		}
		
		/*
		*	Returns a Number ~ N(0,1);
		*/
		public function standardNormal () : Number
		{
			if ( ready )
			{
				ready = false;
				return cache;
			}
			
			var x : Number,
			y : Number,
			w : Number;
			
			do
			{
				x = ( s = ( s * 16807 ) % 2147483647 ) / 1073741823.5 - 1;
				y = ( s = ( s * 16807 ) % 2147483647 ) / 1073741823.5 - 1;
				w = x * x + y * y;
			}
			while ( w >= 1 || !w );
			
			w = Math.sqrt ( -2 * Math.log ( w ) / w );
			
			ready = true;
			cache = x * w;
			
			return y * w;
		}
		
		/*
		*	Returns true with probability p
		*/
		public function bernoulli ( p : Number = 0.5 ) : Boolean
		{
			return ( s = ( s * 16807 ) % 2147483647 ) < p * 2147483647;
		}
	}
}
