part of dart_force_mvc_lib;

class ServingAssistent {
  final Uri pubServeUrl; // They read that from the Environment variable
  final client = new HttpClient();
  final http_server.VirtualDirectory vd;

  ServingAssistent(this.pubServeUrl, this.vd);

  Future proxyToPub(HttpRequest request, String path) {
    const RESPONSE_HEADERS = const [
        HttpHeaders.CONTENT_LENGTH,
        HttpHeaders.CONTENT_TYPE ];

    var uri = pubServeUrl.resolve(path);
    return client.openUrl(request.method, uri)
        .then((proxyRequest) {
          proxyRequest.headers.removeAll(HttpHeaders.ACCEPT_ENCODING);
          return proxyRequest.close();
        })
        .then((proxyResponse) {
          proxyResponse.headers.forEach((name, values) {
            if (RESPONSE_HEADERS.contains(name)) {
              request.response.headers.set(name, values);
            }
          });
          request.response.statusCode = proxyResponse.statusCode;
          request.response.reasonPhrase = proxyResponse.reasonPhrase;
          return proxyResponse.pipe(request.response);
        })
        .catchError((e) {
          print("Unable to connect to 'pub serve' for '${request.uri}': $e");
          var error = new AssistentError(
              "Unable to connect to 'pub serve' for '${request.uri}': $e");
          return new Future.error(error);
        });
  }

  Future serveFromFile(HttpRequest request, String path) {
    // Check if the request path is pointing to a static resource.
    Uri fileUri = Platform.script.resolve(path);
    File file = new File(fileUri.toFilePath());
    return file.exists().then((exists) { 
        if (exists) {
          return vd.serveFile(file, request);
        } else {
          // look outside the build folder!
          path = path.replaceFirst("/build", "");
          fileUri = Platform.script.resolve(path);
          file = new File(fileUri.toFilePath());
          if (file.existsSync()) {
            return vd.serveFile(file, request);
          } else {
            print("Unable to connect to 'pub serve' for '${request.uri}'");
            var error = new AssistentError("Unable to connect to 'pub serve' for '${request.uri}'");
            return new Future.error(error);
          }
        }
    });
  }

  Future<Stream<List<int>>> readFromPub(String path) {
    var uri = pubServeUrl.resolve(path);
    return client.openUrl('GET', uri)
        .then((request) => request.close())
        .then((response) {
          if (response.statusCode == HttpStatus.OK) {
            return response;
          } else {
            var error = new AssistentError(
                "Failed to fetch asset '$path' from pub: "
                "${response.statusCode}.");
            return new Future.error(error);
          }
        })
        .catchError((error) {
          if (error is! AssistentError) {
            error = new AssistentError(
                "Failed to fetch asset '$path' from pub: '${path}': $error");
          }
          return new Future.error(error);
        });
  }

  Future serve(HttpRequest request, String root, String path) {
    if (pubServeUrl != null) {
      // path = normalize(path);
      
      return proxyToPub(request, path);
    } else {
      return serveFromFile(request, "${root}${path}");
    }
  }
  
  Future<Stream<List<int>>> readFromFile(String root, String path) {
      path = normalize(path);
      return FileSystemEntity.isFile(root + path).then((exists) {
        if (exists) {
          return new File(root + path).openRead();
        } else {
          var error = new AssistentError("Asset '$path' not found");
          return new Future.error(error);
        }
      });
    }

    Future<Stream<List<int>>> read(String root, String path) {
      if (pubServeUrl != null) {
        return readFromPub(path);
      } else {
        return readFromFile(root, path);
      }
    }
  
}

class AssistentError extends Error {
    final message;

    /** The [message] describes the erroneous argument. */
    AssistentError([this.message]);

    String toString() {
      if (message != null) {
        return "Illegal argument(s): $message";
      }
      return "Illegal argument(s)";
    }
}