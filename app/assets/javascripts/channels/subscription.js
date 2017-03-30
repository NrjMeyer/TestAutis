App.subscription = App.cable.subscriptions.create("SubscriptionChannel", {
  connected: function() {
    // Called when the subscription is ready for use on the server
  },

  disconnected: function() {
    // Called when the subscription has been terminated by the server
  },

  received: function(data) {
    // Called when there's incoming data on the websocket for this channel
    console.log(getCookie('id'))


    console.log(data);
  },

  test: function(data) {
    return this.perform('test', data)
  }
});

function getCookie(name) {
  var value = "; " + document.cookie;
  var parts = value.split("; " + name + "=");
  if (parts.length == 2) return parts.pop().split(";").shift();
}

function setCookie(cname, cvalue, exdays) {
    var d = new Date();
    d.setTime(d.getTime() + (exdays*24*60*60*1000));
    var expires = "expires="+ d.toUTCString();
    document.cookie = cname + "=" + cvalue + ";" + expires + ";path=/";
}

$(document).click(function() {
  var rand = Math.random();
  var id = Math.random().toString(36).substring(7);
  document.cookie = "id=" + id;

  console.log("sent : " + rand)
  App.subscription.test({nb: rand, id: id});
})
