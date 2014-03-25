### Changelog ###

This file contains highlights of what changes on each version of the forcemvc package. 

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
