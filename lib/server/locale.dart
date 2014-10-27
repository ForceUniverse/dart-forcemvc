part of dart_force_mvc_lib;

/**
 *
 * A [Locale] object represents a specific geographical, political,
 * or cultural region. An operation that requires a [Locale] to perform
 * its task is called <em>locale-sensitive</em> and uses the [Locale]
 * to tailor information for the user. For example, displaying a number
 * is a locale-sensitive operation--the number should be formatted
 * according to the customs/conventions of the user's native country,
 * region, or culture.
 *
**/

class Locale {

    // cache to store singleton Locales
    static Map<String, Locale> cache =
        new Map<String, Locale>();
    
    static Locale defaultLocale = Locale.ENGLISH;

    /** Useful constant for language.
     */
    static Locale ENGLISH = createSingleton("en__", "en", "");

    /** Useful constant for language.
     */
    static Locale FRENCH = createSingleton("fr__", "fr", "");

    /** Useful constant for language.
     */
    static Locale GERMAN = createSingleton("de__", "de", "");

    /** Useful constant for language.
     */
    static Locale ITALIAN = createSingleton("it__", "it", "");

    /** Useful constant for language.
     */
    static Locale JAPANESE = createSingleton("ja__", "ja", "");

    /** Useful constant for language.
     */
    static Locale KOREAN = createSingleton("ko__", "ko", "");

    /** Useful constant for language.
     */
    static Locale CHINESE = createSingleton("zh__", "zh", "");

    /** Useful constant for language.
     */
    static Locale SIMPLIFIED_CHINESE = createSingleton("zh_CN_", "zh", "CN");

    /** Useful constant for language.
     */
    static Locale TRADITIONAL_CHINESE = createSingleton("zh_TW_", "zh", "TW");

    /** Useful constant for country.
     */
    static Locale FRANCE = createSingleton("fr_FR_", "fr", "FR");

    /** Useful constant for country.
     */
    static Locale GERMANY = createSingleton("de_DE_", "de", "DE");

    /** Useful constant for country.
     */
    static Locale ITALY = createSingleton("it_IT_", "it", "IT");

    /** Useful constant for country.
     */
    static Locale JAPAN = createSingleton("ja_JP_", "ja", "JP");

    /** Useful constant for country.
     */
    static Locale KOREA = createSingleton("ko_KR_", "ko", "KR");

    /** Useful constant for country.
     */
    static Locale CHINA = SIMPLIFIED_CHINESE;

    /** Useful constant for country.
     */
    static Locale PRC = SIMPLIFIED_CHINESE;

    /** Useful constant for country.
     */
    static Locale TAIWAN = TRADITIONAL_CHINESE;

    /** Useful constant for country.
     */
    static Locale UK = createSingleton("en_GB_", "en", "GB");

    /** Useful constant for country.
     */
    static Locale US = createSingleton("en_US_", "en", "US");

    /** Useful constant for country.
     */
    static Locale CANADA = createSingleton("en_CA_", "en", "CA");

    /** Useful constant for country.
     */
    static Locale CANADA_FRENCH = createSingleton("fr_CA_", "fr", "CA");

    /**
     * Useful constant for the root locale.  The root locale is the locale whose
     * language, country, and variant are empty ("") strings.  This is regarded
     * as the base locale of all locales, and is used as the language/country
     * neutral locale for the locale sensitive operations.
     */
    static Locale ROOT = createSingleton("__", "", "");

    /**
     * Display types for retrieving localized names from the name providers.
     */
    static final int DISPLAY_LANGUAGE = 0;
    static final int DISPLAY_COUNTRY  = 1;
    static final int DISPLAY_VARIANT  = 2;

    /**
     * Construct a locale from language, country, variant.
     * NOTE:  ISO 639 is not a stable standard; some of the language codes it defines
     * (specifically iw, ji, and in) have changed.  This constructor accepts both the
     * old codes (iw, ji, and in) and the new codes (he, yi, and id), but all other
     * API on Locale will return only the OLD codes.
     * @param language lowercase two-letter ISO-639 code.
     * @param country uppercase two-letter ISO-3166 code.
     * @param variant vendor and browser specific code. See class description.
     * @exception NullPointerException thrown if any argument is null.
     **/
   Locale(String language, String country, {String variant}) {
        this._language = language;
        this._country = country.toUpperCase();
        this._variant = variant;
    }


    /**
     * Creates a <code>Locale</code> instance with the given
     * <code>language</code> and <code>counry</code> and puts the
     * instance under the given <code>key</code> in the cache. This
     * method must be called only when initializing the Locale
     * constants.
     */
    static Locale createSingleton(String key, String language, String country) {
        Locale locale = new Locale(language, country);
        cache[key] = locale;
        return locale;
    }

    /**
     * Returns a <code>Locale</code> constructed from the given
     * <code>language</code>, <code>country</code> and
     * <code>variant</code>. If the same <code>Locale</code> instance
     * is available in the cache, then that instance is
     * returned. Otherwise, a new <code>Locale</code> instance is
     * created and cached.
     *
     * @param language lowercase two-letter ISO-639 code.
     * @param country uppercase two-letter ISO-3166 code.
     * @param variant vendor and browser specific code. See class description.
     * @return the <code>Locale</code> instance requested
     * @exception NullPointerException if any argument is null.
     */
    static Locale getInstance(String language, String country, String variant) {
        if (language== null || country == null || variant == null) {
            // throw new NullPointerException();
        }

        String key = "${language}_{$country}_${variant}";
        Locale locale = cache[key];
        if (locale == null) {
            locale = new Locale(language, country, variant: variant);
            Locale l = cache.putIfAbsent(key, () => locale);
            if (l != null) {
                locale = l;
            }
        }
        return locale;
    }
    
    /**
     * Sets the default locale for this instance of the Java Virtual Machine.
     * This does not affect the host locale.
     * <p>
     * If there is a security manager, its <code>checkPermission</code>
     * method is called with a <code>PropertyPermission("user.language", "write")</code>
     * permission before the default locale is changed.
     * <p>
     * The Java Virtual Machine sets the default locale during startup
     * based on the host environment. It is used by many locale-sensitive
     * methods if no locale is explicitly specified.
     * <p>
     * Since changing the default locale may affect many different areas
     * of functionality, this method should only be used if the caller
     * is prepared to reinitialize locale-sensitive code running
     * within the same Java Virtual Machine.
     *
     * @throws SecurityException
     *        if a security manager exists and its
     *        <code>checkPermission</code> method doesn't allow the operation.
     * @throws NullPointerException if <code>newLocale</code> is null
     * @param newLocale the new default locale
     * @see SecurityManager#checkPermission
     * @see java.util.PropertyPermission
     */
    static void setDefault(Locale newLocale) {
        if (newLocale == null)
            // throw new NullPointerException("Can't set default locale to NULL");

            defaultLocale = newLocale;
    }

    /**
     * Returns the language code for this locale, which will either be the empty string
     * or a lowercase ISO 639 code.
     * <p>NOTE:  ISO 639 is not a stable standard-- some languages' codes have changed.
     * Locale's constructor recognizes both the new and the old codes for the languages
     * whose codes have changed, but this function always returns the old code.  If you
     * want to check for a specific language whose code has changed, don't do <pre>
     * if (locale.getLanguage().equals("he"))
     *    ...
     * </pre>Instead, do<pre>
     * if (locale.getLanguage().equals(new Locale("he", "", "").getLanguage()))
     *    ...</pre>
     * @see #getDisplayLanguage
     */
    String getLanguage() {
        return _language;
    }

    /**
     * Returns the country/region code for this locale, which will
     * either be the empty string or an uppercase ISO 3166 2-letter code.
     * @see #getDisplayCountry
     */
    String getCountry() {
        return _country;
    }

    /**
     * Returns the variant code for this locale.
     * @see #getDisplayVariant
     */
    String getVariant() {
        return _variant;
    }

    /**
     * Getter for the programmatic name of the entire locale,
     * with the language, country and variant separated by underbars.
     * Language is always lower case, and country is always upper case.
     * If the language is missing, the string will begin with an underbar.
     * If both the language and country fields are missing, this function
     * will return the empty string, even if the variant field is filled in
     * (you can't have a locale with just a variant-- the variant must accompany
     * a valid language or country code).
     * Examples: "en", "de_DE", "_GB", "en_US_WIN", "de__POSIX", "fr__MAC"
     * @see #getDisplayName
     */
    String toString() {
        bool l = _language!=null && _language.length != 0;
        bool c = _country!= null && _country.length != 0;
        bool v = _variant!= null && _variant.length != 0;
        StringBuffer result = new StringBuffer(_language);
        if (c||(l&&v)) {
            result..write('_')
                  ..write(_country); // This may just append '_'
        }
        if (v&&(l||c)) {
            result..write('_')
                  ..write(_variant);
        }
        return result.toString();
    }

    // Overrides

    /**
     * Returns true if this Locale is equal to another object.  A Locale is
     * deemed equal to another Locale with identical language, country,
     * and variant, and unequal to all other objects.
     *
     * @return true if this Locale is equal to the specified object.
     */

    bool equals(Object obj) {
        if (this == obj)                      // quick check
            return true;
        if (!(obj is Locale))
            return false;
        Locale other = obj;
        return _language == other._language && _country == other._country && _variant == other._variant;
    }

    
    /**
     * @serial
     * @see #getLanguage
     */
    String _language;

    /**
     * @serial
     * @see #getCountry
     */
    String _country;

    /**
     * @serial
     * @see #getVariant
     */
    String _variant;

} 