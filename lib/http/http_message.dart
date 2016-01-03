part of dart_force_mvc_lib;
/**
 * Represents the base interface for HTTP request and response messages.
 * Consists of HttpHeaders, retrievable via #getHeaders().
 *
 * @author Joris Hermans
 * @since 0.8.0
 */
abstract class HttpMessage {

	/**
	 * Return the headers of this message.
	 * @return a corresponding HttpHeaders object (never null)
	 */
	HttpHeadersWrapper getHeaders() { return null; }

}
