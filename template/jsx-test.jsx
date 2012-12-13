import "test-case.jsx";

class _Test extends TestCase {
  function testHello() : void {
    var got = "foo bar";
    this.expect(got).toBe("Hello, world!");
  }
}

// vim: set tabstop=2 shiftwidth=2 expandtab:

