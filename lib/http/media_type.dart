part of dart_force_mvc_lib;

/**
 * A sub-class of MimeType that adds support for quality parameters as defined
 * in the HTTP specification.
 *
 * @author Joris Hermans
 *
 */
class MediaType extends MimeType {

	/**
	 *  constant media type that includes all media ranges (i.e. "&#42;/&#42;").
	 */
	static final MediaType ALL = new MediaType.parseMediaType(ALL_VALUE);

	/**
	 * A String equivalent of {@link MediaType#ALL}.
	 */
	static final String ALL_VALUE = "*/*";

	/**
	 *   constant media type for {@code application/atom+xml}.
	 */
	static final MediaType APPLICATION_ATOM_XML = new MediaType.parseMediaType(APPLICATION_ATOM_XML_VALUE);

	/**
	 * A String equivalent of {@link MediaType#APPLICATION_ATOM_XML}.
	 */
  static final String APPLICATION_ATOM_XML_VALUE = "application/atom+xml";

	/**
	 *  constant media type for {@code application/x-www-form-urlencoded}.
	 *  */
	static final MediaType APPLICATION_FORM_URLENCODED = new MediaType.parseMediaType(APPLICATION_FORM_URLENCODED_VALUE);

	/**
	 * A String equivalent of {@link MediaType#APPLICATION_FORM_URLENCODED}.
	 */
	static final String APPLICATION_FORM_URLENCODED_VALUE = "application/x-www-form-urlencoded";

	/**
	 *  constant media type for {@code application/json}.
	 * @see #APPLICATION_JSON_UTF8
	 */
	static final MediaType APPLICATION_JSON = new MediaType.parseMediaType(APPLICATION_JSON_VALUE);

	/**
	 * A String equivalent of {@link MediaType#APPLICATION_JSON}.
	 * @see #APPLICATION_JSON_UTF8_VALUE
	 */
	static final String APPLICATION_JSON_VALUE = "application/json";

	/**
	 *  constant media type for {@code application/json;charset=UTF-8}.
	 */
	static final MediaType APPLICATION_JSON_UTF8 = new MediaType.parseMediaType(APPLICATION_JSON_UTF8_VALUE);

	/**
	 * A String equivalent of {@link MediaType#APPLICATION_JSON_UTF8}.
	 */
	static final String APPLICATION_JSON_UTF8_VALUE = APPLICATION_JSON_VALUE + ";charset=UTF-8";

	/**
	 *  constant media type for {@code application/octet-stream}.
	 *  */
	static final MediaType APPLICATION_OCTET_STREAM = new MediaType.parseMediaType(APPLICATION_OCTET_STREAM_VALUE);

	/**
	 * A String equivalent of {@link MediaType#APPLICATION_OCTET_STREAM}.
	 */
	static final String APPLICATION_OCTET_STREAM_VALUE = "application/octet-stream";

	/**
	 *  constant media type for {@code application/xhtml+xml}.
	 *  */
	static final MediaType APPLICATION_XHTML_XML = new MediaType.parseMediaType(APPLICATION_XHTML_XML_VALUE);

	/**
	 * A String equivalent of {@link MediaType#APPLICATION_XHTML_XML}.
	 */
	static final String APPLICATION_XHTML_XML_VALUE = "application/xhtml+xml";

	/**
	 *  constant media type for {@code application/xml}.
	 */
	static final MediaType APPLICATION_XML = new MediaType.parseMediaType(APPLICATION_XML_VALUE);

	/**
	 * A String equivalent of {@link MediaType#APPLICATION_XML}.
	 */
	static final String APPLICATION_XML_VALUE = "application/xml";

	/**
	 *  constant media type for {@code image/gif}.
	 */
	static final MediaType IMAGE_GIF = new MediaType.parseMediaType(IMAGE_GIF_VALUE);

	/**
	 * A String equivalent of {@link MediaType#IMAGE_GIF}.
	 */
	static final String IMAGE_GIF_VALUE = "image/gif";

	/**
	 *  constant media type for {@code image/jpeg}.
	 */
	static final MediaType IMAGE_JPEG = new MediaType.parseMediaType(IMAGE_JPEG_VALUE);

	/**
	 * A String equivalent of {@link MediaType#IMAGE_JPEG}.
	 */
	static final String IMAGE_JPEG_VALUE = "image/jpeg";

	/**
	 * Public constant media type for {@code image/png}.
	 */
	static final MediaType IMAGE_PNG = new MediaType.parseMediaType(IMAGE_PNG_VALUE);

	/**
	 * A String equivalent of {@link MediaType#IMAGE_PNG}.
	 */
	static final String IMAGE_PNG_VALUE = "image/png";

	/**
	 * Public constant media type for {@code image/webp}.
	 */
	static final MediaType IMAGE_WEBP = new MediaType.parseMediaType(IMAGE_WEBP_VALUE);

	/**
	 * A String equivalent of {@link MediaType#IMAGE_WEBP}.
	 */
	static final String IMAGE_WEBP_VALUE = "image/webp";

	/**
	 * Public constant media type for {@code multipart/form-data}.
	 *  */
	static final MediaType MULTIPART_FORM_DATA = new MediaType.parseMediaType(MULTIPART_FORM_DATA_VALUE);

	/**
	 * A String equivalent of {@link MediaType#MULTIPART_FORM_DATA}.
	 */
	static final String MULTIPART_FORM_DATA_VALUE = "multipart/form-data";

	/**
	 * Public constant media type for {@code text/html}.
	 *  */
	static final MediaType TEXT_HTML = new MediaType.parseMediaType(TEXT_HTML_VALUE);

	/**
	 * A String equivalent of {@link MediaType#TEXT_HTML}.
	 */
	static final String TEXT_HTML_VALUE = "text/html";

	/**
	 * Public constant media type for {@code text/plain}.
	 *  */
	static final MediaType TEXT_PLAIN = new MediaType.parseMediaType(TEXT_PLAIN_VALUE);

	/**
	 * A String equivalent of {@link MediaType#TEXT_PLAIN}.
	 */
	static final String TEXT_PLAIN_VALUE = "text/plain";

	/**
	 * Public constant media type for {@code text/xml}.
	 *  */
	static final MediaType TEXT_XML = new MediaType.parseMediaType(TEXT_XML_VALUE);

	/**
	 * A String equivalent of {@link MediaType#TEXT_XML}.
	 */
	static final String TEXT_XML_VALUE = "text/xml";


	static final String PARAM_QUALITY_FACTOR = "q";

	MediaType(String type, {String subtype, String charset, Map<String, String> parameters}) : super(type, subtype: subtype, charset: charset, parameters: parameters);

  factory MediaType.parseMediaType(String mediaType) {
    MimeType type;
		type = MimeTypeUtils.parseMimeType(mediaType);
		return new MediaType(type.getType(), subtype: type.getSubtype(), parameters: type.getParameters());
  }

	bool includes(MediaType other) {
		return super.includes(other);
	}

	bool isCompatibleWith(MediaType other) {
		return super.isCompatibleWith(other);
	}

	bool hasSame(MediaType other) {
		return this.getType() == other.getType()
				&& this.getSubtype() == other.getSubtype();
	}

	/*
	 * Return a replica of this instance with the quality value of the given MediaType.
	 * @return the same instance if the given MediaType doesn't have a quality value, or a new one otherwise
	 */
	MediaType copyQualityValue(MediaType mediaType) {
		if (!mediaType.getParameters().containsKey(PARAM_QUALITY_FACTOR)) {
			return this;
		}
		Map<String, String> params = new LinkedHashMap<String, String>();
    params.addAll(getParameters());
    params[PARAM_QUALITY_FACTOR] = mediaType.getParameters()[PARAM_QUALITY_FACTOR];
		return new MediaType(this.getType(), parameters: params);
	}

	/*
	 * Return a replica of this instance with its quality value removed.
	 * @return the same instance if the media type doesn't contain a quality value, or a new one otherwise
	 */
	MediaType removeQualityValue() {
		if (!getParameters().containsKey(PARAM_QUALITY_FACTOR)) {
			return this;
		}
		Map<String, String> params = new LinkedHashMap<String, String>();
    params.addAll(getParameters());
		params.remove(PARAM_QUALITY_FACTOR);
		return new MediaType(this.getType(), parameters: params);
	}

	/*
	 * Parse the given, comma-separated string into a list of MediaType objects.
	 * This method can be used to parse an Accept or Content-Type header.
	 * @param mediaTypes the string to parse
	 * @return the list of media types
	 * @throws IllegalArgumentException if the string cannot be parsed
	 */
	static List<MediaType> parseMediaTypes(String mediaTypes) {
		var tokens = mediaTypes.split(",\\s*");
		print('tokens ... ${tokens.length}');
		List<MediaType> result = new List<MediaType>();
		for (String token in tokens) {
			result.add(new MediaType.parseMediaType(token));
		}
		return result;
	}

	/**
	 * Return a string representation of the given list of MediaType objects.
	 * This method can be used to for an Accept or Content-Type header.
	 * @param mediaTypes the media types to create a string representation for
	 * @return the string representation
	 */
	static String toStringify(Iterable<MediaType> mediaTypes) {
		return MimeTypeUtils.toStringify(mediaTypes);
	}
}
