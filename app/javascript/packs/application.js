// This file is automatically compiled by Webpack, along with any other files
// present in this directory. You're encouraged to place your actual application logic in
// a relevant structure within app/javascript and only use these pack files to reference
// that code so it'll be compiled.

require("@rails/ujs").start()
require("turbolinks").start()
require("@rails/activestorage").start()
require("channels")

import 'jquery'
import 'popper.js'
import 'bootstrap'
import 'summernote'
import 'summernote/lang/summernote-ko-KR'
import 'summernote/lang/summernote-th-TH'
import 'summernote/lang/summernote-vi-VN'
import 'jquery-datetimepicker'
import chart from 'tui-chart'

// Uncomment to copy all static images under ../images to the output folder and reference
// them with the image_pack_tag helper in views (e.g <%= image_pack_tag 'rails.png' %>)
// or the `imagePath` JavaScript helper below.
//
// const images = require.context('../images', true)
// const imagePath = (name) => images(name, true)

window.globalOnReadyHandler = function () {
  $(".sidebar-toggle").click(function(e) {
    e.preventDefault();
    $("#wrapper").toggleClass("toggled");
  });


  /**
   * Tooltip
   */
  $(function () {
    $('[data-toggle="tooltip"]').tooltip();
  });


  /**
   * SummerNote
   */
  var text_areas = $('[data-provider="summernote"]');
  if (text_areas[0]) {
    var HelloButton = function (context) {
      var ui = $.summernote.ui;

      // create button
      var button = ui.button({
        contents: '<i class="fa fa-child"/> Hello',
        tooltip: 'hello',
        click: function () {
          // invoke insertText method with 'hello' on editor module.
          context.invoke('editor.insertText', 'hello');
        }
      });

      return button.render();   // return button as jquery object
    };

    text_areas.each(function () {
      $(this).summernote({
        lang: this.dataset.lang,
        height: 300,
        codemirror: 'monokai',
        disableDragAndDrop: true,
        toolbar: [
          // [groupName, [list of button]]
          // ['hi', ['hello']],
          ['style', ['bold', 'italic', 'underline']],
          ['font', ['strikethrough']],
          ['fontsize', ['fontsize']],
          ['color', ['color']],
          ['para', ['ul', 'ol', 'paragraph']],
          ['table', ['table']],
          ['insert', ['link']],
          ['view', ['codeview', 'help']],
        ],
        buttons: {
          hello: HelloButton
        }
      })
    });
  }


  /**
   * DateTimePicker
   */
  var datetime_fields = $('[data-provider="datetimepicker"]');
  if (datetime_fields[0]) {
    datetime_fields.each(function() {
      var self = this;
      $(this).datetimepicker({
        format:'Y-m-d H:i',
        mask: true,
        startDate: this.dataset.min,
        onShow: function(ct){
          this.setOptions({
            minDate: $(self).val() ? $(self).val() : false,
            minTime: $(self).val() ? $(self).val() : false
          })
        },
      });
    })
  }


  /**
   * Toast UI Chart
   */
  document.querySelectorAll('.hits-chart').forEach(function (container) {
    container.innerHTML = '';
    chart.columnChart(container, JSON.parse(container.dataset.data), {
      chart: {
        width: container.clientWidth,
        height: container.dataset.height || 100,
      },
      legend: {
        visible: false
      },
      chartExportMenu: {
        visible: false
      }
    });
  });

  document.querySelectorAll('[data-toggle=dropdown]').forEach(function (toggleBtn) {
    // console.log($(toggleBtn.closest('.dropdown')).dropdown());
    // $(toggleBtn.closest('.dropdown')).dropdown();
    // console.log();
    // toggleBtn.addEventListener('click', function() {
    //   toggleBtn.closest('.dropdown')
    // });
  })
}
document.addEventListener('turbolinks:load', globalOnReadyHandler);
