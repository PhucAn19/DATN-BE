package DATN.config;

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.jdbc.datasource.DriverManagerDataSource;

import javax.sql.DataSource;
import java.net.InetAddress;
import java.net.URI;
import java.sql.DriverManager;

@Configuration
public class DataSourceConfig {

    @Bean
    public DataSource dataSource() {
        String[] urls = {
            "jdbc:sqlserver://26.12.21.105:1433;databaseName=DATN_WebBHDT;encrypt=false",
            "jdbc:sqlserver://localhost:1433;databaseName=DATN_WebBHDT;encrypt=false"
        };

        String username = "DEV_BACKEND";
        String password = "DEV";

        for (String url : urls) {
            try {
                // 👇 Trích xuất host từ JDBC URL
                URI uri = new URI(url.replace("jdbc:sqlserver://", "http://")); // tạm dùng http để URI parse được
                String host = uri.getHost();

                // 👇 Kiểm tra IP hoặc hostname có sống không
                InetAddress inet = InetAddress.getByName(host);
                if (!inet.isReachable(1000)) { // timeout 1 giây
                    System.out.println("⚠️ IP không khả dụng: " + host);
                    continue;
                }

                // 👇 Thử kết nối DB
                DriverManager.getConnection(url, username, password).close();
                System.out.println("✅ Kết nối thành công với: " + url);

                DriverManagerDataSource dataSource = new DriverManagerDataSource();
                dataSource.setUrl(url);
                dataSource.setUsername(username);
                dataSource.setPassword(password);
                dataSource.setDriverClassName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
                return dataSource;

            } catch (Exception e) {
                System.out.println("❌ Không kết nối được với: " + url + " - " + e.getMessage());
            }
        }

        throw new RuntimeException("❗Không thể kết nối SQL Server bằng bất kỳ URL nào.");
    }
}
