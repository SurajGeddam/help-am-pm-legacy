/*
 * Copyright (c) 2023.
 * All right reserved.
 *
 */
package com.helpampm.invoicing.pdfgenerator;

import com.openhtmltopdf.pdfboxout.PdfRendererBuilder;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Component;

import java.io.ByteArrayOutputStream;
import java.util.function.Consumer;

@Component
@Slf4j
/*
  @author kuldeep
 */
public class PdfRenderer {
    @SafeVarargs
    public final ByteArrayOutputStream runRenderer(String resourcePath, String html, Consumer<PdfRendererBuilder>... config) {
        ByteArrayOutputStream actual = new ByteArrayOutputStream();
        PdfRendererBuilder builder = new PdfRendererBuilder();
        builder.withHtmlContent(html, resourcePath);
        builder.toStream(actual);
        builder.useFastMode();

        for (Consumer<PdfRendererBuilder> conf : config) {
            conf.accept(builder);
        }

        try {
            builder.run();
        } catch (Exception e) {
            log.error("Error in converting PDF file");
            e.printStackTrace();
            return null;
        }

        return actual;
    }
}
