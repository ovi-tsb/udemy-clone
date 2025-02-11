

// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
import "@hotwired/turbo-rails"
import "./controllers"
import * as bootstrap from "bootstrap"
// import Rails from "@rails/ujs"
Rails.start()
import "@fortawesome/fontawesome-free/js/all";
library.add(far, fas, fab)

import "trix"
import "@rails/actiontext"
////////////////
// import "popper"
import "bootstrap"
import "@popperjs/core"
import "jquery"
// import "jquery_ujs"
import "./jquery_ui"
import "../stylesheets/application";




$(document).on('turbolinks:load', function(){
  console.log("test JS connection ");
  $('.lesson-sortable').sortable({
    cursor: "grabbing",
    cursorAt: { left: 10 },
    placeholder: "ui-state-highlight",
    update: function(e, ui){
      let item = ui.item;
      let item_data = item.data();
      let params = {_method: 'put'};
      params[item_data.modelName] = { row_order_position: item.index() }
      $.ajax({
        type: 'POST',
        url: item_data.updateUrl,
        dataType: 'json',
        data: params
      });
    },
    stop: function(e, ui){
      console.log("stop called when finishing sort of cards");
    }
  });
});

