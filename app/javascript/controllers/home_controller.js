import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="home"
export default class extends Controller {
  connect() {
    console.log("home controller has been connected 55"); 

       $( "#datepicker" ).datepicker();


    var initial_val = 0;
    $("#btn-click").click(function (e) { 
      e.preventDefault();
      var date_value = $("#datepicker").val();
      alert(`button has been clicked ${initial_val} and date ${date_value} `);
      initial_val+= 1;
    });


      $( function() {
        $( "#draggable" ).draggable();
      } );

       // $( function() {
       //   $( "#sortable" ).sortable();
       // } );

       $( function() {
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
       } );
  }
}