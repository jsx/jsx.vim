interface I {
	abstract function foo(a : int) : void;
}
mixin M implements I {
	override function foo(a : int) : void {
		log a;
	}
}

class _Main {
	static function main(args : string[]) : void {
		var i0 = 0xabcdef;
		var i0 = 0XABCDEF;

		var n0 = 3.14;
		var n1 = 1e100;
		var n2 = 1e+10;
		var n3 = 1e-10;

		var r0 = /foo/;
		var r1 = /foo/m;
		var r2 = /foo/i;
		var r3 = /foo/g;
		var r4 = /foo/gim;
		var r5 = /\bfoo\b/;

		var a0xff = -0;
		var a1e10 = +0;

		var s0 = "\x0a\x0d";
		var s0 = "\u000d";

		log true;
		log false;
		log null;
		log Infinity;
		log NaN;
	}
}
