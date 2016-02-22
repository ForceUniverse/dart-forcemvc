### Changelog ###

This file contains highlights of what changes on each version of the forcemvc package.

#### Pub version 0.8.1 ####

- Introducing @RestController

#### Pub version 0.8.0 ####

- Updating dependencies on logging
- Clean up code
- introduce @ResponceBody
- HttpMessageConverters and HttpMessageRegulator are also available in this release with a JsonHttpMessageConverter implementation

#### Pub version 0.7.3 ####

- Introducing a new annotation @ResponseStatus, so we can indicate status code of the response

#### Pub version 0.7.2 ####

- Adopt code to async/await
- Extract locale to an other dependency

#### Pub version 0.7.1+1 ####

- Improve the flow of client serving
- Add more logging

#### Pub version 0.7.1 ####

- Allow completely handling the HttpResponse

#### Pub version 0.7.0 ####

- update forcemvc to wired 4.3
- add web config and an easy change towards core components with di
  * SecurityContextHolder
  * HandlerExceptionResolver
  * LocaleResolver
  * ServingAssistent

#### Pub version 0.6.1+1 ####

- add improvement on static handling internally

#### Pub version 0.6.1 ####

- remove start page and use this instead!

app.static("/", "index.html");

#### Pub Version 0.6.0+1 ####

- Tighter version constraint on exported package

#### Pub Version 0.6.0 ####

- WebServer becomes WebApplication dart class
- The .on method becomes .use method
- app.static will skip the view rendering logic, ideal for angular and polymer applications
- simplify code on some parts

#### Pub Version 0.5.10 ####

- Extending the possibilities of a Rest interface.

#### Pub Version 0.5.9+1 ####

- Fix a bug so that @Authentication works, and takes up BASIC as a role.

#### Pub Version 0.5.9 ####

- Improve the startup functionality, by adding startup fallback mechanism

#### Pub Version 0.5.8 ####

- Make the default value to startpage empty.
  It is better to use:

  app.use('/', (req, model) {
    return "index";
  });

  then startPage: "index.html"

  Be aware that then it becomes a template and that when you use polymer or angular you need to use another delimiter.

#### Pub version 0.5.7+1 ####

- Deprecate the method on, it is too confusing with the on method of dart force, the method 'use' is now the prefered way.
- Fixing a crash when the startPage is not found.

#### Pub version 0.5.7 ####

- Changing the main class of WebServer to WebApplication.
- Making WebServer Deprecated

#### Pub version 0.5.6+1 ####

- Fix issue serving without pub serve
- put more control in accept_header_locale

#### Pub version 0.5.6 ####

- Apply pub serve trick also to view render logic.
- Fallbacks / error handling when a resource is not been found.

#### Pub version 0.5.5 ####

- Add locale resolver mechanics into the framework
- Easy use of the locale in the controller

#### Pub version 0.5.4 ####

- Add required boolean into @RequestParam(required: true)
- Pub serve trick, issue 23 is been solved.

#### Pub version 0.5.3+1 ####

- Small adjustments so dart force can also work on appengine.

#### Pub version 0.5.3 ####

- Add better 404 handling
- Serving the Client files from their URL relative to the script's location
- Make dart-forcemvc WebServer compatible with App Engine Dart

#### Pub version 0.5.2+1 ####

- Fixing 'Replace only the first occurrence of /build'

#### Pub version 0.5.2 ####

- package 'Force IT' is been renamed to 'wired'

#### Pub version 0.5.1 ####

- Add Type checking in @ExceptionHandler

#### Pub version 0.5.0+1 ####

- Add getAuthentication in MVCAnnotationHelper

#### Pub version 0.5.0 ####

- Add PreauthorizeRoles and PreauthorizeFunc Annotations
- Add possibility to define authorization roles
- Define and extend the way security works in forcemvc
- Upgrade to the latest version of 'force it'

#### Pub version 0.4.0+1 & 0.4.0+2 ####

- Adding MVCAnnotationHelper, with the method hasAuthentication(obj) to the package

#### Pub version 0.4.0 ####

- Remove parentheses from annotations.
- Update to the latest version (0.2.0) of force_it
- Add example folder to the git repository

#### Pub version 0.3.8 ####

- Introducing @ControllerAdvice so that you can make methods with @ModelAttribute & @ExceptionHandler that has inpact to all the controller

#### Pub version 0.3.7 ####

- General error handling with a HandlerExceptionResolver
- Introducing the annotation @ExceptionHandler so you can use that in your @Controller classes when an error is happening.

#### Pub version 0.3.6+1 ####

- First steps in error handling

#### Pub version 0.3.6 ####

- Adding startSecure method, so you can start your webserver over SSL.

#### Pub version 0.3.5+1 ####

- Update package configuration

#### Pub version 0.3.5 ####

- Provide a class MockForceRequest to mock more easily ForceRequest in unittests
- Upgrade of the unittest package and introducing of the mock package

#### Pub version 0.3.4+1 & 0.3.4+2 & 0.3.4+3 ####

- update rules for mustache rendering the view

#### Pub version 0.3.4 ####

- Add @RequestMapping on an object level possible

#### Pub version 0.3.3+1 ####

- Make @RequestParam working without a value

#### Pub version 0.3.3 ####

- Error logging when the server don't start
- Add responseHooks into the web_server
- Using variable name of the annotated @RequestParam when value is empty

#### Pub version 0.3.2+1 & 0.3.2+2 ####

- improve serving code of the start page.

#### Pub version 0.3.2 ####

- load values into your webserver from yaml files
- cors
- small improvement on the model object, it allows you to put anything in it

#### Pub version 0.3.1 ####

Fix a problem with serving dart files.

#### Pub version 0.3.0+1 ####

Fix a bug with passing by the startPage.

#### Pub version 0.3.0 ####

Add 'force it' package into this new version of the forcemvc so you can use @Autowired in the @Controller classes.

#### Pub version 0.2.4 ####

Add easier bootstrapping of the logging functionality serverside.

#### Pub version 0.2.3 ####

Implemented changes to the security api. Add an optional parameter {data} in the security strategy checkAuthorization class.

#### Pub version 0.2.2 ####

Refactoring of the use of webSockets, also provide httpRequest in the flow, so you get access to httpsession.

#### Pub version 0.2.1+2 ####

Make the security rules more general.

#### Pub version 0.2.1+1 ####

Make the securityContextHolder object in webserver public accessible.

#### Pub version 0.2.1 ####

New structure!

#### Pub version 0.2.0 ####

Adding security and authentication functionality

#### Pub version 0.1.13+5 ####

Move transformation method to the view renderer!

#### Pub version 0.1.13+4 ####

More logging!

#### Pub version 0.1.13+1 & 0.1.13+2 ####

Adding slashes in src="...", it will become src="/..." when needed of the template rendering is been performed!

#### Pub version 0.1.13 ####

Depend upon mustache4dart and not upon mustache anymore!

#### Pub version 0.1.12+2 ####

Small improvement on the view rendering part!

#### Pub version 0.1.12+1 ####

Changed ../build/ folder to ../build/web/

#### Pub version 0.1.12 ####

Check also view, template files in the build folder, so after pub build in the web folder!

#### Pub version 0.1.11+3 ####

Better logging for view rendering!

#### Pub version 0.1.11+2 ####

Implement getPostRawData, so you can get the raw posted data!

#### Pub version 0.1.11+1 ####

Adapt getPostData to disable jsonifying the data!

#### Pub version 0.1.11 ####

Adding asynchronous requests to the possibilities now!

#### Pub version 0.1.10 ####

Fixing in @RequestMapping, the method part!

#### Pub version 0.1.9+4 ####

Adding redirect functionality.

#### Pub version 0.1.9+3 ####

Removing dependency on Uuid.

#### Pub version 0.1.9+2 ####

Add HttpSession & HttpHeaders in possible arguments in a controller method

#### Pub version 0.1.9+1 ####

Solve an issue with the code, please update!

#### Pub version 0.1.9 ####

Adding @RequestParam, so you can add this annotation to the controller class if you want to have easy access to querystring parameters.

#### Pub version 0.1.8+3 ####

Make static folder configurable and some small improvements on the regex expression.

#### Pub version 0.1.8+2 ####

Static folder for serving static files to the client!

#### Pub version 0.1.8+1 ####

Improved accesability of path variables.

#### Pub version 0.1.8 ####

New ways of view rendering and getting the templates.

#### Pub version 0.1.7+2 & 0.1.7+3 ####

Cleanup code webserver. Solving an issue!

#### Pub version 0.1.7+1 ####

Updated this buildPath: '../build/web' to get it working in Dart 1.2

#### Pub version 0.1.7 ####

Extend ForceRequest with getPostData and getPostParams to support post methods.

#### Pub version 0.1.6 ####

Adding path variables to the mvc part.

#### Pub version 0.1.5 ####

Serving .dart files much easier, putting it in the framework itself.

#### Pub version 0.1.4 ####

Adding interceptors to the game, so you can write interceptor classes to intercept a request.

#### Pub version 0.1.3 ####

Updating dependency on force mirrors, it solves a bug with invocation.
Controller scanning, so you don't need to register a class, just annotate it with @Controller.

#### Pub version 0.1.2+4 & 0.1.2+5 ####

Adding an improvement of force mirrors invoke.

#### Pub version 0.1.2+3 ####

Solving issue with dependency management

#### Pub version 0.1.2+2 ####

Add dependency to forcemirrors.

#### Pub version 0.1.2+1 ####

Adding tests for mirrorhelpers and refactor code to improve annotation handling.

#### Pub version 0.1.2 ####

Adding the ModelAttribute annotation into the mvc framework.

#### Pub version 0.1.0 ####

Adding an abstraction ForceRequest, a wrapper around httprequest.

#### Pub version 0.1.0 ####

Adding renderer and model to the mvc part of it.
Adding mustache as a new dependency for the rendering part.

#### Pub version 0.0.6 & 0.0.7 ####

Fixing issue with annotations of RequestMapping

#### Pub version 0.0.5 ####

Introducing Simple Web Server

#### Pub version 0.0.5 ####

Introduction of the model

#### Pub version 0.0.4 ####

Update version of uuid

#### Pub version 0.0.3 ####

Adding RequestMethod class into the project

#### Pub version 0.0.2 ####

Adding documentation and solving issues.

#### Pub version 0.0.1 ####

Setup of the project, moved basic_server.dart to this package and make it usable in the dart force main package.
