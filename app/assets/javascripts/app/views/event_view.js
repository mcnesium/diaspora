
var updateEventsList = function() {

  $.getJSON( "/events", function( data ) {

    var items = [];
    $.each( data, function( key, val ) {
      var title = val.event.title;
      var id = val.event.id;
      items.push( "<li id='" + id + "'>" + title + "</li>" );
    });

    $( "#known-events").remove();
    $( "<ul/>", {
      "id": "known-events",
      html: items.join( "" )
    }).appendTo( "#list" );
  });

}

$( document ).ready(function() {

  $('a#create').on("click",function( event ){
    event.preventDefault;

    var title = $("input#title").val();

    $.post( "events", { title: title } )
      .done(function(data){
        console.log(data);
        updateEventsList();
      })
  });


  console.log('ready');
  updateEventsList();

});
