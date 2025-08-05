/*
 * Copyright (c) 2023.
 * All right reserved.
 *
 */
package com.helpampm.invoicing.pdfgenerator;

import org.springframework.stereotype.Component;
import org.thymeleaf.TemplateEngine;
import org.thymeleaf.context.Context;
import org.thymeleaf.extras.java8time.dialect.Java8TimeDialect;
import org.thymeleaf.templateresolver.ClassLoaderTemplateResolver;

import java.util.Locale;
import java.util.Map;

@Component
/*
  @author kuldeep
 */
public class ThymeleafProcessor {
    private final TemplateEngine templateEngine = createTemplateEngine();

    private TemplateEngine createTemplateEngine() {
        TemplateEngine te = new TemplateEngine();

        ClassLoaderTemplateResolver tr = new ClassLoaderTemplateResolver();
        tr.setPrefix("/templates/");
        tr.setSuffix(".ftl");

        te.setTemplateResolver(tr);
        te.addDialect(new Java8TimeDialect());

        return te;
    }

    public String process(String template, Map<String, Object> args) {
        Context ctx = new Context(Locale.US, args);
        return templateEngine.process(template, ctx);
    }
}
