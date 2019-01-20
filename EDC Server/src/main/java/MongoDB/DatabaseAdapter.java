package MongoDB;

import Spring.User;
import com.mongodb.*;

import java.util.Map;
import java.util.UUID;

public class DatabaseAdapter {
    private static DB database;
    private static boolean dbConnectionIsOpen = false;

    public static boolean initializeDbConnection() {
        if (dbConnectionIsOpen)
            System.out.println("DB connection is already open");
        else
            try {
                MongoClient mongoClient = new MongoClient(new MongoClientURI("mongodb://localhost:27017"));
                database = mongoClient.getDB("rsadb");
                dbConnectionIsOpen = true;
            } catch (Exception e) {
                System.out.println(e.getMessage());
            }
        return dbConnectionIsOpen;
    }

    public static User signIn(String username) {
        if (dbConnectionIsOpen) {
            DBCollection collection = database.getCollection("rsausers");
            DBCursor rsaUsers = collection.find(new BasicDBObject().append("username", username));
            if (!rsaUsers.hasNext()) {
                System.out.println("User with name " + username + " doesn't exist exists.");
                return null;
            }
            Map<String, String> userArray = rsaUsers.next().toMap();
            return new User(userArray.get("_id"), userArray.get("username"));
        }
        return null;
    }

    public static User addUser(String username) {
        if (dbConnectionIsOpen) {
            DBCollection collection = database.getCollection("rsausers");
            DBCursor rsaUsers = collection.find(new BasicDBObject().append("username", username));
            if (rsaUsers.hasNext()) {
                System.out.println("User with name " + username + " already exists.");
                Map<String, String> userArray = rsaUsers.next().toMap();
                return new User(userArray.get("_id"), userArray.get("username"));
            }
            DBObject rsaUser = new BasicDBObject("_id", UUID.randomUUID().toString())
                    .append("username", username);
            collection.insert(rsaUser);
            Map<String, String> userArray = rsaUser.toMap();
            return new User(userArray.get("_id"), userArray.get("username"));
        }
        return null;
    }
}
