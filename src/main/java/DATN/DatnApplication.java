package DATN;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;

import DATN.config.CustomDatabaseCreator;

@SpringBootApplication
public class DatnApplication {

	public static void main(String[] args) {
		CustomDatabaseCreator.createDatabaseIfNotExists();
		SpringApplication.run(DatnApplication.class, args);
	}

}
