class Draggable {
  constructor(container, boxes) {
    this.container = container;
    this.boxes = boxes;

    this._addEventListener();
  }

  _addEventListener() {
    console.log(this.boxes);
    console.log(this.container);
    this.boxes.forEach(element => {
      element.draggable = true;
      element.addEventListener('dragenter', this.dragenter)
      element.addEventListener('dragleave', this.dragleave)
      element.addEventListener('dragover', this.dragover)
      element.addEventListener('drop', this.drop)
    });

    this.container.addEventListener('dragstart', this.dragstart);
    this.container.addEventListener('dragend', this.dragend);
  }

  dragstart(e) {
    console.log(this);
    this.classList.add('drag_start');
    setTimeout(() => {
      this.classList.add('invisible');
    }, 0);
  }

  dragend(e) {
    console.log('dragend')
    this.classList.remove('invisible');
    this.classList.remove('drag_start');
  }

  dragenter(e) {
    e.preventDefault();

    console.log('dragenter')
    this.classList.add('drag_enter');
  }

  dragleave(e) {
    console.log('dragleave')
    this.classList.remove('drag_enter');
  }

  dragover(e) {
    e.preventDefault();
    console.log('dragover')
  }

  drop() {
    let container = document.querySelector('.box__dragabble');
    this.classList.remove('drag_enter')
    this.append(container)
  }

  static init(container, ...boxes) {
    return new this(container, boxes);
  }
}

export default Draggable
