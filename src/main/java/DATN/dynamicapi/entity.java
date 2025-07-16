package DATN.dynamicapi;
import java.util.HashMap;
import java.util.Map;

import com.fasterxml.jackson.annotation.JsonInclude;
import com.fasterxml.jackson.databind.annotation.JsonSerialize;

import lombok.Data;
@Data
@JsonInclude(JsonInclude.Include.NON_NULL)
public class entity {
    @JsonSerialize(using = nulldata.class)
    private Map<String, Object> fields = new HashMap<>();

    public Object get(String key) {
        return fields.get(key);
    }

    public void set(String key, Object value) {
        fields.put(key, value);
    }

    public Map<String, Object> getFields() {
        return fields;
    }

    public void setFields(Map<String, Object> fields) {
        this.fields = fields;
    }
}
