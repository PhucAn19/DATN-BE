package DATN.config;

import java.io.*;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.Statement;
import java.util.Scanner;

public class CustomDatabaseCreator {

    private static final String FLAG_FILE = "dev.flag";

    public static void createDatabaseIfNotExists() {
        String username;
        String password;

        // Nếu đã tạo user rồi, dùng tài khoản DEV_BACKEND
        if (new File(FLAG_FILE).exists()) {
            username = "DEV_BACKEND";
            password = "DEV";
            System.out.println("🔁 Sử dụng tài khoản DEV_BACKEND để kết nối.");
        } else {
            // Nếu chưa, hỏi tài khoản ban đầu (ví dụ: sa/123)
            Scanner scanner = new Scanner(System.in);
            System.out.print("Nhập tài khoản SQL Server (ví dụ: sa): ");
            username = scanner.nextLine();
            System.out.print("Nhập mật khẩu: ");
            password = scanner.nextLine();
        }

        String masterUrl = "jdbc:sqlserver://localhost:1433;databaseName=master;encrypt=false;";

        try (Connection conn = DriverManager.getConnection(masterUrl, username, password);
                Statement stmt = conn.createStatement()) {

            String sqlScript = readSqlFile("/database/DATN_WebBHDT.sql");

            for (String sql : sqlScript.split("(?i)\\bGO\\b")) {
                if (!sql.trim().isEmpty()) {
                    stmt.execute(sql);
                }
            }

            System.out.println("✅ Đã thực thi file SQL thành công.");

            // Ghi flag nếu là lần đầu
            if (!new File(FLAG_FILE).exists()) {
                try (FileWriter writer = new FileWriter(FLAG_FILE)) {
                    writer.write("USER_CREATED=true");
                    System.out.println("📌 Đã lưu trạng thái: DEV_BACKEND đã được tạo.");
                }
            }

        } catch (Exception e) {
            System.err.println("❌ Lỗi khi thực thi SQL: " + e.getMessage());
        }
    }

    private static String readSqlFile(String path) throws Exception {
        InputStream inputStream = CustomDatabaseCreator.class.getResourceAsStream(path);
        if (inputStream == null) {
            throw new RuntimeException("Không tìm thấy file: " + path);
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
