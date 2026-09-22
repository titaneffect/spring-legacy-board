package kr.or.oti.util;

import java.net.URI;
import java.util.regex.Pattern;

import org.owasp.html.HtmlPolicyBuilder;
import org.owasp.html.PolicyFactory;
import org.owasp.html.Sanitizers;

public class BoardHtmlSanitizer {
	
	private static final Pattern VIDEO_ID =
            Pattern.compile("[A-Za-z0-9_-]{11}");
	
	private static final PolicyFactory YOUTUBE =
            new HtmlPolicyBuilder()
                    .allowElements("iframe")
                    .allowUrlProtocols("https")
                    .allowAttributes("src")
                    .matching((element, attribute, value) -> {
                        try {
                            URI uri = URI.create(value);

                            if (!"https".equalsIgnoreCase(uri.getScheme())
                                    || !"www.youtube.com".equalsIgnoreCase(uri.getHost())
                                    || uri.getPort() != -1
                                    || uri.getUserInfo() != null) {
                                return null;
                            }

                            String path = uri.getPath();
                            String prefix = "/embed/";

                            if (path == null || !path.startsWith(prefix)) {
                                return null;
                            }

                            String id = path.substring(prefix.length());

                            if (!VIDEO_ID.matcher(id).matches()) {
                                return null;
                            }

                            return "https://www.youtube.com/embed/" + id;

                        } catch (IllegalArgumentException e) {
                            return null;
                        }
                    })
                    .onElements("iframe")
                    .allowAttributes("width", "height")
                    .matching(Pattern.compile("[0-9]{1,4}"))
                    .onElements("iframe")
                    .toFactory();
	
	private static final PolicyFactory LOCAL_IMAGE =
	        new HtmlPolicyBuilder()
	                .allowElements("img")
	                .allowAttributes("src")
	                .matching(Pattern.compile(
	                        "/attachments/[1-9][0-9]*/view"
	                ))
	                .onElements("img")
	                .allowAttributes("alt")
	                .onElements("img")
	                .allowAttributes("width", "height")
	                .matching(Pattern.compile("[1-9][0-9]{0,3}"))
	                .onElements("img")
	                .toFactory();

	private static final PolicyFactory POLICY =
			Sanitizers.FORMATTING
					.and(Sanitizers.BLOCKS)
					.and(Sanitizers.TABLES)
					.and(Sanitizers.STYLES)
					.and(Sanitizers.LINKS)
					.and(YOUTUBE)
					.and(LOCAL_IMAGE);
					
	public static String sanitize(String html) {
		return html == null ? "" : POLICY.sanitize(html);
	}
}
