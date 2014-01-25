### Dart Force MVC ###

![LOGO!](https://raw.github.com/jorishermans/dart-force/master/resources/dart_force_logo.jpg)

Part of the Dart Force Framework.

Serverside MVC based implementation for Dart. Easy to setup and part of the dart force framework!

#### Walkthrough ####

Use a server with dart very easily, create controllers with annotations ...

First you will setup a new server.

	WebServer server = new WebServer(wsPath: wsPath, port: port, host: host, buildPath: buildPath);
	
Then you use the on method to handle http requests.

	server.on(url, (req) { /* logic */ }, method: "GET");
	
You can also use the annotation RequestMapping in a dart object

	@RequestMapping(value: "/someurl", method: "GET")
	
Then you register that object on the WebServer object.

	server.register(someObjectWithRequestMappingAnnotations)

More info will follow in the coming days!

#### TODO ####

- get more annotations and options for sending the response back
- writing tests

### Notes to Contributors ###

#### Fork Dart Force MVC ####

If you'd like to contribute back to the core, you can [fork this repository](https://help.github.com/articles/fork-a-repo) and send us a pull request, when it is ready.

If you are new to Git or GitHub, please read [this guide](https://help.github.com/) first.

#### Dart Force ####

Realtime web framework for dart that uses force MVC [source code](https://github.com/jorishermans/dart-force)

#### Twitter ####

Follow us on twitter https://twitter.com/usethedartforce

#### Google+ ####

Follow us on [google+](https://plus.google.com/111406188246677273707)