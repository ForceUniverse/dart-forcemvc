part of dart_force_mvc_lib;
/**
 * Represents an HTTP output message, consisting of headers
 * and a writable body.
 *
 * Typically implemented by an HTTP request handle on the client side,
 * or an HTTP response handle on the server side.
 *
 * @author Joris Hermans
 * @since 0.8.0
 */
abstract class HttpOutputMessage extends HttpMessage {

	/**
	 * Return the headers of this message.
	 * @return a corresponding HttpHeaders object (never null)
	 */
	HttpHeadersWrapper getResponseHeaders() { return null; }

	/**
	 * Return the body of the message as an output stream.
	 */
	IOSink getOutputBody();

}
