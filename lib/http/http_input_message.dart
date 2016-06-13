part of dart_force_mvc_lib;
/**
 * Represents an HTTP input message, consisting of headers
 * and a readable body.
 *
 * Typically implemented by an HTTP request handle on the server side,
 * or an HTTP response handle on the client side.
 *
 */
abstract class HttpInputMessage extends HttpMessage {

	/**
	 * Return the headers of this message.
	 * @return a corresponding HttpHeaders object (never null)
	 */
	HttpHeadersWrapper getRequestHeaders() { return null; }

	/**
	 * Return the body of the message as an stream.
	 */
	Stream getBody() { return null; }

}
