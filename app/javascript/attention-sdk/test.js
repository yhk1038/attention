class Test {
  constructor(expect) {
    this.expect = expect;
  }

  equal(v) {
    return this.expect === v;
  }
}
export default (v) => new Test(v);
