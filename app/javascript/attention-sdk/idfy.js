class Idfy {
  constructor(val) {
    this.origin = val.toString();
  }

  get keyType() {
    return this.origin.replace('#', '');
  }

  get recordId() {
    return parseInt(this.origin.split('-').pop());
  }
}

export default (id) => new Idfy(id);
