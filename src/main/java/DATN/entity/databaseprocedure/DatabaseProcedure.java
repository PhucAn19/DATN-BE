package DATN.entity.databaseprocedure;

import jakarta.persistence.Entity;
import jakarta.persistence.Id;
import jakarta.persistence.NamedStoredProcedureQuery;
import jakarta.persistence.StoredProcedureParameter;
import jakarta.persistence.ParameterMode;

@Entity
@NamedStoredProcedureQuery(
    name = "DATN_CRE_SP_DB00001_0",
    procedureName = "DATN_CRE_SP_DB00001_0",
    parameters = {
        @StoredProcedureParameter(mode = ParameterMode.IN, name = "tensanpham", type = String.class),
        @StoredProcedureParameter(mode = ParameterMode.IN, name = "dongia", type = Long.class),
        @StoredProcedureParameter(mode = ParameterMode.IN, name = "loai", type = Integer.class),
        @StoredProcedureParameter(mode = ParameterMode.IN, name = "thuonghieu", type = Integer.class),
        @StoredProcedureParameter(mode = ParameterMode.IN, name = "anhgoc", type = String.class),
        @StoredProcedureParameter(mode = ParameterMode.IN, name = "thongso", type = String.class),
        @StoredProcedureParameter(mode = ParameterMode.IN, name = "mausac", type = String.class),
        @StoredProcedureParameter(mode = ParameterMode.IN, name = "soluong", type = Integer.class),
        @StoredProcedureParameter(mode = ParameterMode.IN, name = "anhphu", type = String.class)
    }
)
public class DatabaseProcedure {
    @Id
    private Long id;
}
