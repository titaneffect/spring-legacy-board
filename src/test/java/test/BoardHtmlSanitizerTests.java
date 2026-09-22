package test;

import static org.junit.jupiter.api.Assertions.assertFalse;
import static org.junit.jupiter.api.Assertions.assertTrue;

import org.junit.jupiter.api.Test;

import kr.or.oti.util.BoardHtmlSanitizer;

class BoardHtmlSanitizerTests {

    @Test
    void youtubeIframe만허용한다() {
        String youtube = BoardHtmlSanitizer.sanitize(
                "<iframe src=\"https://www.youtube.com/embed/yQZ0BTOAsFE\"></iframe>"
        );
        assertTrue(youtube.contains(
                "https://www.youtube.com/embed/yQZ0BTOAsFE"
        ));

        String otherSite = BoardHtmlSanitizer.sanitize(
                "<iframe src=\"https://evil.example/embed/yQZ0BTOAsFE\"></iframe>"
        );
        assertFalse(otherSite.contains("evil.example"));

        String eventAttribute = BoardHtmlSanitizer.sanitize(
                "<iframe src=\"https://www.youtube.com/embed/yQZ0BTOAsFE\" "
                + "onload=\"alert(1)\"></iframe>"
        );
        assertFalse(eventAttribute.contains("onload"));
    }
}