
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
    }).appendTo( "#eventlist" );

    $("#eventlist li").on("click", function( click ){
      click.preventDefault();
      toggleSingleEvent($(this));
    });
  });
}

var createNewEvent = function() {
  var title = $("input#title").val();

  $.post( "events", { title: title } )
    .done(function(data){
      updateEventsList();
  });
}

var toggleSingleEvent = function( li ) {
  if ( li.children().length > 0 ) {
    li.children().remove();
  } else {
    id = li.attr("id");

    $.getJSON( "/events/"+li.attr("id"), function( data ){
      event = data.event;

      li.append("<dl>"
        +"<dt>Attendances</dt><dd>"+event.event_attendances.length+"</dd>"
        +"<dt>Invitations</dt><dd>"+event.event_invitations.length+"</dd>"
        +"</dl>"
      );
      console.log( currentUserIsAttending(event.event_attendances) );
    });

  }
}


var currentUserIsAttending = function( attendances ) {
  var currentUserAttendance = false;
  var currentUserId = app.user().id;
  $.each(attendances, function(key,attendance){
    if ( currentUserId == attendance.attendee_id ) {
      currentUserAttendance = true;
      return false; //break
    };
  });
  return currentUserAttendance;
}

$( document ).ready(function() {

  $("a#create").on("click", function( click ){
    click.preventDefault();
    createNewEvent();
  });

  $("a#update").on("click", function( click ){
    click.preventDefault();
    updateEventsList();
  });

  console.log("ready");
  updateEventsList();
  // setInterval(function() { updateEventsList(); }, 3000);

});
