package DATN.config;

import java.io.BufferedReader;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.sql.*;

public class CustomDatabaseCreator {

    public static void createDatabaseIfNotExists() {
        String masterUrl = "jdbc:sqlserver://localhost:1433;databaseName=master;encrypt=false;";
        String username = "DEV_BACKEND";
        String password = "DEV";

        // Kết nối tới master để thực thi toàn bộ SQL (cả tạo DB, user, bảng...)
        try (Connection conn = DriverManager.getConnection(masterUrl, username, password);
             Statement stmt = conn.createStatement()) {

            String sqlScript = readSqlFile("/database/DATN_WebBHDT.sql");

            // Chia các câu lệnh bằng GO (thay vì ; nếu bạn dùng GO trong file SQL)
            for (String sql : sqlScript.split("(?i)\\bGO\\b")) {
                if (!sql.trim().isEmpty()) {
                    stmt.execute(sql);
                }
            }

            System.out.println("✅ Executed full SQL script in master context.");

        } catch (Exception e) {
            System.err.println("❌ Error executing SQL script: " + e.getMessage());
        }
    }

    private static String readSqlFile(String path) throws Exception {
        InputStream inputStream = CustomDatabaseCreator.class.getResourceAsStream(path);
        if (inputStream == null) {
            throw new RuntimeException("File not found: " + path);
        }

        BufferedReader reader = new BufferedReader(new InputStreamReader(inputStream));
        StringBuilder sqlBuilder = new StringBuilder();
        String line;

        while ((line = reader.readLine()) != null) {
            sqlBuilder.append(line).append("\n");
        }

        return sqlBuilder.toString();
    }
}
