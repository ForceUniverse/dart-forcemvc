part of dart_force_mvc_lib;

/**
 * Abstract base class for most HttpMessageConverter implementations.
 */
abstract class AbstractHttpMessageConverter<T> implements HttpMessageConverter<T> {

	List<MediaType> supportedMediaTypes = new List();

	var defaultCharset;

  /**
	 * Set the list of MediaType objects supported by this converter.
	 */
	void setSupportedMediaTypes(List<MediaType> supportedMediaTypes) {
		// Assert.notEmpty(supportedMediaTypes, "'supportedMediaTypes' must not be empty");
		this.supportedMediaTypes = supportedMediaTypes;
	}

	List<MediaType> getSupportedMediaTypes() {
		return new List.unmodifiable(this.supportedMediaTypes);
	}

  /**
	 * Returns true if any of the #setSupportedMediaTypes(List)
	 * supported media types MediaType#includes(MediaType) include the
	 * given media type.
	 * @param mediaType the media type to read, can be null if not specified.
	 * Typically the value of a Content-Type header.
	 * @return true if the supported media types include the media type,
	 * or if the media type is null
	 */
	bool canRead(MediaType mediaType) {
		if (mediaType == null) {
			return true;
		}
		for (MediaType supportedMediaType in getSupportedMediaTypes()) {
			if (supportedMediaType.includes(mediaType)) {
				return true;
			}
		}
		return false;
	}

	/**
	 * Returns true if the given media type includes any of the
	 * #setSupportedMediaTypes(List) supported media types.
	 * @param mediaType the media type to write, can be null if not specified.
	 * Typically the value of an Accept header.
	 * @return true if the supported media types are compatible with the media type,
	 * or if the media type is null
	 */
	bool canWrite(MediaType mediaType) {
		if (mediaType == null || MediaType.ALL == mediaType) {
			return true;
		}
		for (MediaType supportedMediaType in getSupportedMediaTypes()) {
			if (supportedMediaType.isCompatibleWith(mediaType)) {
				return true;
			}
		}
		return false;
	}

  /**
	 * This implementation simple delegates to #readInternal(HttpInputMessage).
	 * Future implementations might add some default behavior, however.
	 */
	T read(HttpInputMessage inputMessage) {
		return readInternal(inputMessage);
	}

	/**
	 * This implementation sets the default headers by calling #addDefaultHeaders,
	 * and then calls #writeInternal.
	 */
	void write(final T t, MediaType contentType, HttpOutputMessage outputMessage) {
		final HttpHeadersWrapper headers = outputMessage.getResponseHeaders();
		addDefaultHeaders(headers, t, contentType);
		writeInternal(t, outputMessage);
	}

	/**
	 * Add default headers to the output message.
	 * This implementation delegates to #getDefaultContentType(Object) if a content
	 * type was not provided, set if necessary the default character set, calls
	 * #getContentLength, and sets the corresponding headers.
	 */
	void addDefaultHeaders(HttpHeadersWrapper headers, T t, MediaType contentType) {
			MediaType contentTypeToUse = contentType;
			if (contentType == null || contentType.isWildcardType() || contentType.isWildcardSubtype()) {
				contentTypeToUse = getDefaultContentType(t);
			}
			else if (MediaType.APPLICATION_OCTET_STREAM == contentType) {
				MediaType mediaType = getDefaultContentType(t);
				contentTypeToUse = (mediaType != null ? mediaType : contentTypeToUse);
			}
			if (contentTypeToUse != null) {
				headers.setContentType(contentTypeToUse);
			}
		 if (headers.getContentLength() == null) {
			var contentLength = getContentLength(t, headers.getContentType());
			if (contentLength != null) {
				headers.setContentLength(contentLength);
			}
		}
	}

	/**
	 * Returns the default content type for the given type. Called when #write
	 * is invoked without a specified content type parameter.
	 * By default, this returns the first element of the
	 * #setSupportedMediaTypes(List) supportedMediaTypes property, if any.
	 * Can be overridden in subclasses.
	 * @param t the type to return the content type for
	 * @return the content type, or null if not known
	 */
	MediaType getDefaultContentType(T t) {
		List<MediaType> mediaTypes = getSupportedMediaTypes();
		return (!mediaTypes.isEmpty ? mediaTypes.first : null);
	}

	/**
	 * Returns the content length for the given type.
	 * By default, this returns null, meaning that the content length is unknown.
	 * Can be overridden in subclasses.
	 * @param t the type to return the content length for
	 * @return the content length, or null if not known
	 */
	num getContentLength(T t, MediaType contentType) {
		return null;
	}

	/**
	 * Abstract template method that reads the actual object. Invoked from {@link #read}.
	 * @param clazz the type of object to return
	 * @param inputMessage the HTTP input message to read from
	 * @return the converted object
	 */
	T readInternal(HttpInputMessage inputMessage);

	/**
	 * Abstract template method that writes the actual body. Invoked from #write.
	 * @param t the object to write to the output message
	 * @param outputMessage the HTTP output message to write to
	 */
	void writeInternal(T t, HttpOutputMessage outputMessage);

}
