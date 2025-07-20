package ssu.groupstudy.global.config;

import io.swagger.v3.oas.models.Components;
import io.swagger.v3.oas.models.OpenAPI;
import io.swagger.v3.oas.models.info.Info;
import io.swagger.v3.oas.models.security.SecurityRequirement;
import io.swagger.v3.oas.models.security.SecurityScheme;
import io.swagger.v3.oas.models.servers.Server;
import org.springdoc.core.SpringDocUtils;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.security.core.annotation.AuthenticationPrincipal;

import java.util.List;

@Configuration
public class SwaggerConfig {
    static {
        SpringDocUtils.getConfig().addAnnotationsToIgnore(AuthenticationPrincipal.class);
    }

    @Bean
    public OpenAPI openAPI() {
        Info info = new Info()
                .title("Group StudyEntity API Document")
                .version("v0.0.1")
                .description("API documentation");

        SecurityScheme securityScheme = configureSecurityScheme();

        // HTTPS 서버 설정 추가
        Server httpsServer = new Server()
                .url("https://cactusdy.guegue.dev")
                .description("Production HTTPS Server");
                
        // Local 서버 설정 추가
        Server localServer1 = new Server()
                .url("http://localhost:8080")
                .description("Local Development Server");

        Server localServer2 = new Server()
                .url("http://localhost:8081")
                .description("Local Development Server");

        return new OpenAPI()
                .servers(List.of(httpsServer, localServer1, localServer2))
                .components(new Components().addSecuritySchemes("bearerAuth", securityScheme))
                .info(info)
                .addSecurityItem(new SecurityRequirement().addList("bearerAuth"));
    }

    private SecurityScheme configureSecurityScheme() {
        return new SecurityScheme()
                .type(SecurityScheme.Type.HTTP)
                .scheme("bearer")
                .bearerFormat("JWT")
                .in(SecurityScheme.In.HEADER)
                .name("Authorization")
                .description("JWT Bearer token authentication");
    }
}