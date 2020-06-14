require("@rails/ujs").start()
require("turbolinks").start()
require("@rails/activestorage").start()
require("channels")

import $ from 'jquery';
import 'popper.js';
import 'bootstrap';

// require("@rails/ujs").start()
// require("channels")

import '../stylesheets/iframe.scss';



window.$ = $;
window.onReady = function(f) {
  document.addEventListener('turbolinks:load', f);
}

window.didOpen = (notificationId, { width, height }) => {
  parent.postMessage({
    eventName: 'shown',
    iframeWidth: width,
    iframeHeight: height,
    notificationId,
  }, '*');
}

window.didClose = (notificationId) => {
  parent.postMessage({
    eventName: 'hidden',
    notificationId
  }, '*');
}
