part of dart_force_mvc_lib;

enum HttpMethod {

	GET, HEAD, POST, PUT, PATCH, DELETE, OPTIONS, TRACE

}

class HttpMethodUtils {
  final Map<String, HttpMethod> mappings = new HashMap<String, HttpMethod>();

	HttpMethodUtils() {
		mappings["GET"] = HttpMethod.GET;
    mappings["HEAD"] = HttpMethod.HEAD;
    mappings["POST"] = HttpMethod.POST;
    mappings["PUT"] = HttpMethod.PUT;
    mappings["PATCH"] = HttpMethod.PATCH;
    mappings["DELETE"] = HttpMethod.DELETE;
    mappings["OPTIONS"] = HttpMethod.OPTIONS;
    mappings["TRACE"] = HttpMethod.TRACE;
	}


	/**
	 * Resolve the given method value to an [HttpMethod].
	 * @param method the method value as a String
	 * @return the corresponding [HttpMethod], or [null] if not found
	 */
	HttpMethod resolve(String method) {
		return (method != null ? mappings[method] : null);
	}


	/**
	 * Determine whether this [HttpMethod] matches the given
	 * method value.
	 * @param method the method value as a String
	 * @return true if it matches, false otherwise
	 */
	bool matches(HttpMethod http_method, String method) {
		return (http_method == resolve(method));
	}
}
