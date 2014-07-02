part of dart_force_mvc_lib;

typedef WebSocketHandler(WebSocket ws, HttpRequest req);
typedef dynamic ControllerHandler(ForceRequest req, Model model);
typedef ResponseHook(HttpResponse res);