part of dart_force_mvc_lib;

class HttpHeadersWrapper {

  HttpHeaders httpHeaders;

  HttpHeadersWrapper(this.httpHeaders);

  /**
	 * Set the list of acceptable MediaType,
	 * as specified by the Accept Header.
	 */
	void setAccept(List<MediaType> acceptableMediaTypes) {
    this.httpHeaders.set(HttpHeaders.ACCEPT, MediaType.toStringify(acceptableMediaTypes));
	}

	/**
	 * Return the list of acceptable MediaType media types,
	 * as specified by the Accept header.
	 * Returns an empty list when the acceptable media types are unspecified.
	 */
	List<MediaType> getAccept() {
		String value = getFirst(HttpHeaders.ACCEPT);
		List<MediaType> result = (value != null ? MediaType.parseMediaTypes(value) : new List());

		return result;
	}

  /**
	 * Set the MediaType media type of the body,
	 * as specified by the Content-Type header.
	 */
	void setContentType(MediaType mediaType) {
		// Assert.isTrue(!mediaType.isWildcardType(), "'Content-Type' cannot contain wildcard type '*'");
		// Assert.isTrue(!mediaType.isWildcardSubtype(), "'Content-Type' cannot contain wildcard subtype '*'");
		this.httpHeaders.set(HttpHeaders.CONTENT_TYPE, mediaType.toString());
	}

	/**
	 * Return the MediaType media type of the body, as specified
	 * by the Content-Type header.
	 * Returns null when the content-type is unknown.
	 */
	MediaType getContentType() {
		String value = getFirst(HttpHeaders.CONTENT_TYPE);
		return (hasLength(value) ? new MediaType.parseMediaType(value) : null);
	}

  /**
	 * Set the (new) value of the Content-Disposition header
	 * for form-data.
	 */
	void setContentDispositionFormData(String name, String filename) {
		// Assert.notNull(name, "'name' must not be null");
		String builder = "form-data; name=\"";
		builder = "$builder$name\"";
		if (filename != null) {
			builder = "$builder; filename=\"";
			builder = "$builder$filename\"";
		}
		set(CONTENT_DISPOSITION, builder);
	}

  bool hasLength(String value) {
    return value != null && value.length > 0;
  }

  String getFirst(name) {
    return this.httpHeaders.value(name);
  }
}
