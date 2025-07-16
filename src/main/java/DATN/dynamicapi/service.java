package DATN.dynamicapi;

import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Service;

import java.util.*;
import java.util.regex.Matcher;
import java.util.regex.Pattern;
import java.util.stream.Collectors;

@Service
public class service {
    private final JdbcTemplate jdbcTemplate;

    // Regex cho phép tên procedure và tách loại hành động (SEL|CRT|UPD|DEL)
    private static final Pattern PROCEDURE_NAME_PATTERN =
            Pattern.compile("^WBH_(US|AD)_(SEL|CRT|UPD|DEL)_([A-Za-z0-9_]+)$");

    public service(JdbcTemplate jdbcTemplate) {
        this.jdbcTemplate = jdbcTemplate;
    }

    public List<Map<String, Object>> callProcedure(String procedureName, Map<String, Object> params) {
        // Validate + extract action type
        Matcher matcher = PROCEDURE_NAME_PATTERN.matcher(procedureName);
        if (!matcher.matches()) {
            throw new IllegalArgumentException("Invalid or unsafe procedure name: " + procedureName);
        }

        String actionType = matcher.group(2); // SEL, CRT, UPD, DEL

        // Build SQL string
        StringBuilder sql = new StringBuilder("EXEC ").append(procedureName);
        Object[] paramValues = new Object[0];

        if (params != null && !params.isEmpty()) {
            String paramPlaceholders = params.keySet().stream()
                    .map(key -> "@" + key + "=?")
                    .collect(Collectors.joining(", "));
            sql.append(" ").append(paramPlaceholders);
            paramValues = params.values().toArray();
        }

        logProcedureCall(procedureName, params);

        // Gọi đúng JDBC method theo loại procedure
        switch (actionType) {
            case "SEL":
                return jdbcTemplate.queryForList(sql.toString(), paramValues);
            case "CRT":
            case "UPD":
            case "DEL":
                jdbcTemplate.update(sql.toString(), paramValues);
                return Collections.singletonList(Map.of("message", "Procedure executed successfully"));
            default:
                throw new UnsupportedOperationException("Unsupported action: " + actionType);
        }
    }

    private void logProcedureCall(String procedure, Map<String, Object> params) {
        System.out.println("[PROC CALL] " + procedure + " with params: " + params);
    }
}
