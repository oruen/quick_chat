(function() {

  window.App = Ember.Application.create({
    socketUrl: "ws://0.0.0.0:8765",
    ready: function() {
      return console.log("Ember namespace is ok");
    },
    ApplicationController: Ember.Controller.extend({
      socket: null
    }),
    ChatController: Ember.ArrayController.extend({
      content: [],
      handleMessage: function(m) {
        var obj;
        obj = Ember.Object.create({
          text: m.data
        });
        return this.pushObject(obj);
      }
    }),
    ApplicationView: Ember.View.extend({
      templateName: "application"
    }),
    LoginView: Ember.View.extend({
      templateName: "login"
    }),
    ChatView: Ember.View.extend({
      templateName: "chat"
    }),
    Router: Ember.Router.extend({
      enableLogging: true,
      root: Ember.Route.extend({
        index: Ember.Route.extend({
          route: "/",
          connectOutlets: function(router, context) {
            return router.get("applicationController").connectOutlet("login");
          },
          doLogin: function(router, context) {
            var login, socket;
            login = router.get("applicationController.login");
            socket = new WebSocket(App.get("socketUrl"));
            return socket.onopen = function() {
              socket.send("Hi! I am " + login);
              router.set("applicationController.socket", socket);
              return router.transitionTo("chat", context);
            };
          }
        }),
        chat: Ember.Route.extend({
          route: "/chat",
          connectOutlets: function(router, context) {
            var socket;
            socket = router.get("applicationController.socket");
            if (socket) {
              router.get("applicationController").connectOutlet("chat");
              return socket.onmessage = function(message) {
                return router.get("chatController").handleMessage(message);
              };
            } else {
              return router.transitionTo("index", context);
            }
          },
          doSend: function(router, context) {
            var socket;
            socket = router.get("applicationController.socket");
            socket.send(router.get("chatController.newMessage"));
            return router.set("chatController.newMessage", "");
          }
        })
      })
    })
  });

  $(function() {
    console.log("Init app");
    return App.initialize();
  });

}).call(this);

