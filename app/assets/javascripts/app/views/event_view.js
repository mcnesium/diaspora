
var updateEventsList = function() {

  $.getJSON( "/events", function( data ) {

    var items = [];
    $.each( data, function( key, val ) {
      var title = val.event.title;
      var id = val.event.id;
      items.push( "<li id='" + id + "'><b>" + title + "</b></li>" );
    });

    $( "#eventlist").remove();
    $( "<ul/>", {
      "id": "eventlist",
      html: items.join( "" )
    }).appendTo( "#eventportal" );

    $("#eventlist li b").on("click", function( click ){
      click.preventDefault();
      toggleSingleEvent($(this).parent());
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
  if ( li.children().length > 1 ) {
    li.children("dl").remove();
  } else {
    id = li.attr("id");

    $.getJSON( "/events/"+li.attr("id"), function( data ){
      event = data.event;

      li.append("<dl>"
        +"<dt>Attendances</dt><dd class=\"a\">"+event.event_attendances.length+"</dd>"
        +"<i data-id=\""+event.id+"\" class=\"entypo entypo-check\"></i>"
        +"<dt>Invitations</dt><dd class=\"i\">"+event.event_invitations.length+"</dd>"
        +"<i data-id=\""+event.id+"\" class=\"entypo entypo-user\"></i>"
        +"<input class=\"form-control invitee\" type=\"text\"/><i  data-id=\""+event.id+"\" class=\"entypo entypo-right-bold\"></i>"
        +"</dl>"
      );

      if( currentUserIsAttending(event.event_attendances) ){
        $("#"+event.id+" i.entypo-check").addClass('attending');
      }
      $("#"+event.id+" i.entypo-check").on("click",function(click){
        toggleAttendance(click.currentTarget);
      });

      if( currentUserIsInvited(event.event_invitations) ){
        $("#"+event.id+" i.entypo-user").addClass('invited');
      }
      $("#"+event.id+" i.entypo-right-bold").on("click",function(click){
        inviteSomeone(click.currentTarget);
      });
    });
  }
}

var inviteSomeone = function(i){

  var invitee = $("li#"+i.dataset.id+" input.invitee").val();
  if ( parseInt(invitee) > 0 ){

    $.post( "/event_invitations", {
        event: i.dataset.id,
        invitee: invitee
      })
      .fail(function(data) {
        console.error( data );
      })
      .done(function(data){
        var counter = $("li#"+i.dataset.id+" dd.i");
        counter.text( parseInt(counter.html()) + 1 );
    });
  } else {
    console.error("enter a number, stupid!");
  }

}

var toggleAttendance = function(i){
  if ($(i).hasClass("attending")){

    $.getJSON("/events/"+i.dataset.id, function(data){
      $.each(data.event.event_attendances,function(key, attendance){

        var currentUserId = app.user().id;
        if ( currentUserId == attendance.attendee_id ) {
          $.ajax({
              url: "/event_attendances/"+attendance.id,
              method: 'DELETE',
              contentType: "application/json",
              success: function(suc) {
                $(i).removeClass("attending")
                  var counter = $("li#"+i.dataset.id+" dd.a");
                  counter.text( parseInt(counter.html()) - 1 );
              },
              error: function(err) {
                console.error(err);
              }
          });
          return false; //break
        };

      });
    });

  } else {

    $.post( "/event_attendances", { event: i.dataset.id } )
      .done(function(data){
        $(i).addClass("attending");
        var counter = $("li#"+i.dataset.id+" dd.a");
        counter.text( parseInt(counter.html()) + 1 );
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

var currentUserIsInvited = function( invitations ) {
  var currentUserInvited = false;
  var currentUserId = app.user().id;
  $.each(invitations, function(key,invitation){
    if ( currentUserId == invitation.invitee_id ) {
      currentUserInvited = true;
      return false; //break
    };
  });
  return currentUserInvited;
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