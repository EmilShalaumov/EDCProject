package Spring;

import MongoDB.DatabaseAdapter;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;

@SpringBootApplication
public class Application {
    public static void main(String[] args) {
        if (DatabaseAdapter.initializeDbConnection())
            SpringApplication.run(Application.class, args);
        else
            System.out.println("Unable to connect to database.");
    }
}
