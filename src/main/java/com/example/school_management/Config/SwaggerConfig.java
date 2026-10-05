package com.example.school_management.Config;
import io.swagger.v3.oas.models.OpenAPI;
import io.swagger.v3.oas.models.info.Info;
import io.swagger.v3.oas.models.servers.Server;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

@Configuration
public class SwaggerConfig {

    @Bean
    public OpenAPI customOpenAPI() {
        return new OpenAPI()
                .info(new Info()
                        .title("School Management API")
                        .version("1.0")
                        .description("API documentation for the School Management project"))
                .addServersItem(new Server().url("https://school-management-production-2040.up.railway.app").description("Production Server"));
    }
}