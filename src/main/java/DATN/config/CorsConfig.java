package DATN.config;

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.web.servlet.config.annotation.*;

@Configuration
public class CorsConfig {
    
    @Bean
    public WebMvcConfigurer corsConfigurer() {
        return new WebMvcConfigurer() {

            @Override
            public void addCorsMappings(CorsRegistry registry) {
                registry.addMapping("/**") // Cho phép tất cả endpoint
                        .allowedOrigins("http://26.142.28.217:5173") // Thay đúng URL của frontend 
                        .allowedMethods("GET", "POST", "PUT", "DELETE", "OPTIONS") // Các method được phép
                        .allowedHeaders("*") // Cho phép tất cả header
                        .allowCredentials(true); // Cho phép gửi cookie/token
            }
        };
    }
}
