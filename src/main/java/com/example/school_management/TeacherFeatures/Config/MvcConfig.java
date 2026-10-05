package com.example.school_management.TeacherFeatures.Config; // Change package name according to your project structure

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.web.servlet.ViewResolver;
import org.springframework.web.servlet.view.InternalResourceViewResolver;
import org.springframework.web.servlet.view.JstlView;

@Configuration
public class MvcConfig {

    @Bean
    public ViewResolver jspViewResolver() {
        InternalResourceViewResolver resolver = new InternalResourceViewResolver();
        resolver.setPrefix("/WEB-INF/jsp/"); // Path where JSP files are stored
        resolver.setSuffix(".jsp"); // Suffix for JSP files
        resolver.setViewClass(JstlView.class); // Enables JSTL support
        return resolver;
    }
}