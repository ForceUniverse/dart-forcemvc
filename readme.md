### Dart Force MVC ###

![LOGO!](https://raw.github.com/jorishermans/dart-force/master/resources/dart_force_logo.jpg)

Part of the Dart Force Framework.

Serverside MVC based implementation for Dart. Easy to setup and part of the dart force framework!

#### Walkthrough ####

Use a server with dart very easily, create controllers with annotations ... similar to spring mvc.

First you will setup a new server.

	WebServer server = new WebServer(wsPath: wsPath, port: port, host: host, buildPath: buildPath);
	
Then you use the on method to handle http requests.

	server.on(url, (ForceRequest req, Model model) { /* logic */ }, method: "GET");
	
You can also use the annotation RequestMapping in a dart object

	@RequestMapping(value: "/someurl", method: "GET")
	void index(ForceRequest req, Model model)
	
You can also use the annotation @ModelAttribute to add an object to all the scopes in the methods.
An @ModelAttribute on a method argument indicates the argument should be retrieved from the model. If not present in the model, the argument should be instantiated first and then added to the model. Once present in the model, the argument's fields should be populated from all request parameters that have matching names.

	@ModelAttribute("someValue")
	String someName() {
		return mv.getValue();
	}
	
Then you register that object on the WebServer object.

	server.register(someObjectWithRequestMappingAnnotations)
	
Or you can annotate a class with @Controller and then it will be registered automatically in the force server.

	@Controller
	class SomeObject {
	
	}

#### Starting your web server ####

You can do this as follow!

	server.start();
	
It is also possible to start a server with SSL possibilities.

	server.startSecure();

#### ForceRequest ####

ForceRequest is an extension for HttpRequest

	forceRequest.postData().then((data) => print(data));
	
#### Interceptors ####

You can define inteceptors as follow, the framework will pick up all the HandlerInterceptor classes or implementations.

	class RandomInterceptor implements HandlerInterceptor {
  
	  bool preHandle(ForceRequest req, Model model, Object handler) { return true; }
	  void postHandle(ForceRequest req, Model model, Object handler) {}
	  void afterCompletion(ForceRequest req, Model model, Object handler) {}
	  
	}

#### Path variables ####

You can now use path variables in force mvc.

	@RequestMapping(value: "/var/{var1}/other/{var2}/", method: "GET")
	void pathvariable(ForceRequest req, Model model, String var1, String var2)

This is an alternative way how you can access path variables.

	req.path_variables['var1']

You can also use the annotation @PathVariable("name") to match the pathvariable, like below:

	  @RequestMapping(value: "/var/{var1}/", method: "GET")
	  String multivariable(req, Model model, @PathVariable("var1") variable) {}

#### Redirect ####

You can instead of returning a view name, performing a redirect as follow:

	@RequestMapping(value: "/redirect/")
  	String redirect(req, Model model) {
    	redirect++;
    	return "redirect:/viewable/";
  	}
  	
#### Asynchronous Controller ####

In the controller you can have asynchronous methods to handle for example POST methods much easier.

On the ForceRequest object you have a method .async and his value is the return value that matters for the req.

When a method is asynchrounous you must return req.asyncFuture.

This is an example how you can use it.

	@RequestMapping(value: "/post/", method: "POST")
	Future countMethod(req, Model model) {
	     req.getPostParams().then((map) {
	       model.addAttribute("email", map["email"]);
	       
	       req.async(null);
	     });
	     model.addAttribute("status", "ok");
	     
	     return req.asyncFuture;
	}

#### Authentication ####

You can now add the annotation @Authentication to a controller class. 
This will make it necessary to for a user to authenticate before accessing these resources.

An authentication in force is following a strategy.
You can set a strategy by extending the class SecurityStrategy.

	class SessionStrategy extends SecurityStrategy {
	  
	  bool checkAuthorization(HttpRequest req, {data: null}) {
	    HttpSession session = req.session;
	    return (session["user"]!=null);
	  }   
	  
	  Uri getRedirectUri(HttpRequest req) {
	    var referer = req.uri.toString();
	    return Uri.parse("/login/?referer=$referer");
	  }
	} 
	
And then add this strategy to the webserver.

	server.strategy = new SessionStrategy();
	
#### Logging ####

You can easily boostrap logging.

	server.setupConsoleLog();

#### Force it ####

Force it is a dependency injection package.
You can use @Autowired and @bean and more in forcemvc find info [here](https://github.com/jorishermans/dart-force_it)


#### Example ####

You can find a simple example with a page counter implementation [here](https://github.com/jorishermans/dart-forcemvc-example) - [live demo](http://forcemvc.herokuapp.com/)

#### TODO ####

- get more annotations and options for sending the response back
- writing tests

### Api documents ###

You can find them [here](https://jorishermans.github.io/dart-forcemvc/api/index.html) 

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

#### Join our discussion group ####

[Google group](https://groups.google.com/forum/#!forum/dart-force)