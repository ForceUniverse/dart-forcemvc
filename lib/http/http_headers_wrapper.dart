part of dart_force_mvc_lib;

class HttpHeadersWrapper {

  static final String CONTENT_DISPOSITION = "Content-Disposition";

  HttpHeaders httpHeaders;

  HttpHeadersWrapper(this.httpHeaders);

  /**
	 * Set the list of acceptable MediaType,
	 * as specified by the Accept Header.
	 */
	void setAccept(List<MediaType> acceptableMediaTypes) {
    this.set(HttpHeaders.ACCEPT, MediaType.toStringify(acceptableMediaTypes));
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
		// assert(!mediaType.isWildcardType());
		// assert(!mediaType.isWildcardSubtype());

		this.set(HttpHeaders.CONTENT_TYPE, mediaType.toString());
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
	 * Set the MediaType media type of the body,
	 * as specified by the Content-Type header.
	 */
	void setContentLength(length) {
		this.set(HttpHeaders.CONTENT_LENGTH, length);
	}

	/**
	 * Return the MediaType media type of the body, as specified
	 * by the Content-Type header.
	 * Returns null when the content-type is unknown.
	 */
	dynamic getContentLength() {
		return getFirst(HttpHeaders.CONTENT_LENGTH);
	}


  /**
	 * Set the (new) value of the Content-Disposition header
	 * for form-data.
	 */
	void setContentDispositionFormData(String name, String filename) {
		assert(name != null);

		String builder = "form-data; name=\"";
		builder = "$builder$name\"";
		if (filename != null) {
			builder = "$builder; filename=\"";
			builder = "$builder$filename\"";
		}
		this.set(CONTENT_DISPOSITION, builder);
	}

  bool hasLength(String value) {
    return value != null && value.length > 0;
  }

  String getFirst(name) {
    return this.httpHeaders.value(name);
  }

  void set(name, value) {
    this.httpHeaders.set(name, value);
  }

  void add(name, value) {
    this.httpHeaders.add(name, value);
  }
}
