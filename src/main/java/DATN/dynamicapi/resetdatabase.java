// package DATN.dynamicapi;

// import java.nio.charset.StandardCharsets;
// import java.nio.file.Files;
// import java.nio.file.Paths;
// import java.sql.Connection;
// import java.sql.Statement;
// import java.util.Map;

// import javax.sql.DataSource;

// import org.springframework.beans.factory.annotation.Autowired;
// import org.springframework.http.ResponseEntity;
// import org.springframework.web.bind.annotation.*;

// @RestController
// @RequestMapping("/api/admin")
// public class resetdatabase {

//     @Autowired
//     private DataSource dataSource;

//     @PostMapping("/reset-db")
//     public ResponseEntity<?> resetDb() {
//         try (Connection conn = dataSource.getConnection();
//              Statement stmt = conn.createStatement()) {

//             // Đọc nội dung file reset-db.sql
//             String sql = Files.readString(Paths.get("src/main/resources/init/reset-db.sql"), StandardCharsets.UTF_8);

//             // Tách theo "GO" dùng biểu thức chính quy (không phân biệt hoa thường, đầu dòng)
//             String[] statements = sql.split("(?im)^[ \t]*GO[ \t]*\r?\n");

//             for (String rawStmt : statements) {
//                 String trimmed = rawStmt.trim();
//                 if (!trimmed.isEmpty()) {
//                     stmt.execute(trimmed);
//                 }
//             }

//             return ResponseEntity.ok(Map.of("message", "Database reset successfully"));
//         } catch (Exception e) {
//             return ResponseEntity.status(500).body(Map.of("error", e.getMessage()));
//         }
//     }
// }
