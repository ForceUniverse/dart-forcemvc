part of dart_force_mvc_lib;

class MimeTypeUtils {

  /**
	 * Parse the given String into a single [MimeType].
	 * @param mimeType the string to parse
	 * @return the mime type
	 */
	static MimeType parseMimeType(String mimeType) {
		if (mimeType.length == 0) {
			throw new InvalidMimeTypeError(mimeType, "'mimeType' must not be empty");
		}
		List parts = mimeType.split(";");
		String fullType = parts[0].trim();

		if (MimeType.WILDCARD_TYPE == fullType) {
			fullType = "*/*";
		}
		int subIndex = fullType.indexOf('/');
		if (subIndex == -1) {
			throw new InvalidMimeTypeError(mimeType, "does not contain '/'");
		}
		if (subIndex == fullType.length - 1) {
			throw new InvalidMimeTypeError(mimeType, "does not contain subtype after '/'");
		}
		String type = fullType.substring(0, subIndex);
		String subtype = fullType.substring(subIndex + 1, fullType.length);
		if (MimeType.WILDCARD_TYPE == type && !(MimeType.WILDCARD_TYPE == subtype)) {
			throw new InvalidMimeTypeError(mimeType, "wildcard type is legal only in '*/*' (all mime types)");
		}

		Map<String, String> parameters = null;
		if (parts.length > 1) {
			parameters = new LinkedHashMap<String, String>();
			for (int i = 1; i < parts.length; i++) {
				String parameter = parts[i];
				int eqIndex = parameter.indexOf('=');
				if (eqIndex != -1) {
					String attribute = parameter.substring(0, eqIndex);
					String value = parameter.substring(eqIndex + 1, parameter.length);
					parameters[attribute] = value;
				}
			}
		}
		return new MimeType(type, subtype: subtype, parameters: parameters);
	}

	/**
	 * Return a string representation of the given list of MimeType objects.
	 * @param mimeTypes the string to parse
	 * @return the list of mime types
	 * @throws IllegalArgumentException if the String cannot be parsed
	 */
	static String toStringify(Iterable<MimeType> mimeTypes) {
		String builder = "";
		bool hasNext = true;
		for (Iterator<MimeType> iterator = mimeTypes.iterator; hasNext;) {
			MimeType mimeType = iterator.current;
			builder = "$builder${mimeType.toString()}";
			hasNext = iterator.moveNext();
			if (hasNext) {
				builder = "$builder, ";
			}
		}
		return builder;
	}

}
