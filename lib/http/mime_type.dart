part of dart_force_mvc_lib;

/**
 * Represents a MIME Type, as originally defined in RFC 2046 and subsequently used in
 * other Internet protocols including HTTP.
 *
 * This class, however, does not contain support for the q-parameters used
 * in HTTP content negotiation. Those can be found in the sub-class
 * MediaType in the http folder.
 */
class MimeType {

	static final String WILDCARD_TYPE = "*";

	// static final BitSet TOKEN;

	static final String PARAM_CHARSET = "charset";

  String type;

	String subtype;

	Map<String, String> parameters;

  String charset;

  MimeType._();

	/**
	 * Create a new Mimetype for the given primary type and subtype and charset and parameters.
	 */
	MimeType(String type, {String subtype, String charset, Map<String, String> parameters}) {
    // Assert.hasLength(type, "type must not be empty");
		// Assert.hasLength(subtype, "subtype must not be empty");
		// checkToken(type);
		// checkToken(subtype);
		this.type = type.toLowerCase();
		this.subtype = subtype.toLowerCase();
    this.charset = charset;

		if (parameters != null && parameters.length > 0) {
			Map<String, String> map = new LinkedHashMap<String, String>();
			for (var attribute in parameters.keys) {
				String value = parameters[attribute];
				checkParameters(attribute, value);
				map[attribute] = value;
			}
			this.parameters = map;
		}
		else {
			this.parameters = new LinkedHashMap();
		}
  }

	void checkParameters(String attribute, String value) {
		// Assert.hasLength(attribute, "parameter attribute must not be empty");
		// Assert.hasLength(value, "parameter value must not be empty");
		// checkToken(attribute);
		if (PARAM_CHARSET == attribute) {
			value = unquote(value);
		}
	}

	bool isQuotedString(String s) {
		if (s.length < 2) {
			return false;
		}
		else {
			return ((s.startsWith("\"") && s.endsWith("\"")) || (s.startsWith("'") && s.endsWith("'")));
		}
	}

	String unquote(String s) {
		if (s == null) {
			return null;
		}
		return isQuotedString(s) ? s.substring(1, s.length - 1) : s;
	}

	/**
	 * Indicates whether the getType is the wildcard character
	 * or not.
	 */
	bool isWildcardType() {
		return WILDCARD_TYPE == getType();
	}

	/**
	 * Indicates whether the subtype is the wildcard
	 * character or the wildcard character followed by a suffix.
	 * @return whether the subtype is a wildcard
	 */
	bool isWildcardSubtype() {
		return WILDCARD_TYPE == (getSubtype()) || getSubtype().startsWith("*+");
	}

	/**
	 * Indicates whether this media type is concrete, i.e. whether neither the type
	 * nor the subtype is a wildcard character.
	 * @return whether this media type is concrete
	 */
	bool isConcrete() {
		return !isWildcardType() && !isWildcardSubtype();
	}

	/**
	 * Return the primary type.
	 */
	String getType() {
		return this.type;
	}

	/**
	 * Return the subtype.
	 */
	String getSubtype() {
		return this.subtype;
	}

	/**
	 * Return the character set, as indicated by a charset parameter, if any.
	 * @return the character set, or null if not available
	 */
	String getCharSet() {
		String charSet = getParameter(PARAM_CHARSET);
		return (charSet != null ? unquote(charSet) : null);
	}

	/**
	 * Return a generic parameter value, given a parameter name.
	 * @param name the parameter name
	 * @return the parameter value, or null if not present
	 */
	String getParameter(String name) {
		return this.parameters[name];
	}

	/*
	 * Return all generic parameter values.
	 * @return a read-only map (possibly empty, never null)
	 */
	Map getParameters() {
		return this.parameters;
	}

	/**
	 * Indicate whether this MediaType includes the given media type.
   * For instance, text includes text/plain and text/html,
	 * and application+xml includes application/soap+xml, etc. This
	 * method is <b>not</b> symmetric.
	 * @param other the reference media type with which to compare
	 * @return true if this media type includes the given media type;
	 * false otherwise
	 */
	bool includes(MimeType other) {
		if (other == null) {
			return false;
		}
		if (this.isWildcardType()) {
			// includes anything
			return true;
		}
		else if (getType() == other.getType()) {
			if (getSubtype() == other.getSubtype()) {
				return true;
			}
			if (this.isWildcardSubtype()) {
				// wildcard with suffix, e.g. application/*+xml
				int thisPlusIdx = getSubtype().indexOf('+');
				if (thisPlusIdx == -1) {
					return true;
				}
				else {
					// application/*+xml includes application/soap+xml
					int otherPlusIdx = other.getSubtype().indexOf('+');
					if (otherPlusIdx != -1) {
						String thisSubtypeNoSuffix = getSubtype().substring(0, thisPlusIdx);
						String thisSubtypeSuffix = getSubtype().substring(thisPlusIdx + 1);
						String otherSubtypeSuffix = other.getSubtype().substring(otherPlusIdx + 1);
						if (thisSubtypeSuffix == otherSubtypeSuffix && WILDCARD_TYPE == thisSubtypeNoSuffix) {
							return true;
						}
					}
				}
			}
		}
		return false;
	}

	bool isCompatibleWith(MimeType other) {
		if (other == null) {
			return false;
		}
		if (isWildcardType() || other.isWildcardType()) {
			return true;
		}
		else if (getType() == other.getType()) {
			if (getSubtype() == other.getSubtype()) {
				return true;
			}
			// wildcard with suffix? e.g. application/*+xml
			if (this.isWildcardSubtype() || other.isWildcardSubtype()) {

				int thisPlusIdx = getSubtype().indexOf('+');
				int otherPlusIdx = other.getSubtype().indexOf('+');

				if (thisPlusIdx == -1 && otherPlusIdx == -1) {
					return true;
				}
				else if (thisPlusIdx != -1 && otherPlusIdx != -1) {
					String thisSubtypeNoSuffix = getSubtype().substring(0, thisPlusIdx);
					String otherSubtypeNoSuffix = other.getSubtype().substring(0, otherPlusIdx);

					String thisSubtypeSuffix = getSubtype().substring(thisPlusIdx + 1);
					String otherSubtypeSuffix = other.getSubtype().substring(otherPlusIdx + 1);

					if (thisSubtypeSuffix == otherSubtypeSuffix &&
							(WILDCARD_TYPE == thisSubtypeNoSuffix || WILDCARD_TYPE == otherSubtypeNoSuffix)) {
						return true;
					}
				}
			}
		}
		return false;
	}

	String toString() {
		// return "${type}/${subtype} -> ${parameters}";
		return "${type}/${subtype}";
	}

	/**
	 * Parse the given String value into a MimeType object,
	 * with this method name following the 'valueOf' naming convention
	 * @see MimeTypeUtils#parseMimeType(String)
	 */
	static MimeType valueOf(String value) {
		return MimeTypeUtils.parseMimeType(value);
	}

}
