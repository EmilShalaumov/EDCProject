package MongoDB;

import Spring.RSAFile;
import Spring.User;
import com.mongodb.*;

import java.lang.reflect.Array;
import java.util.ArrayList;
import java.util.List;
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

    public static ArrayList<RSAFile> getFiles() {
        if (dbConnectionIsOpen) {
            DBCollection collection = database.getCollection("rsafiles");
            DBCursor rsaFiles = collection.find();
            ArrayList<RSAFile> files = new ArrayList<RSAFile>();
            while(rsaFiles.hasNext()) {
                Map<String, Object> filesArray = rsaFiles.next().toMap();
                files.add(new RSAFile(filesArray.get("_id").toString(),
                        filesArray.get("filename").toString(),
                        filesArray.get("filebody").toString(),
                        getUsername(filesArray.get("owner").toString()),
                        filesArray.get("checkflag").toString()));
            }
            return files;
        }
        return null;
    }

    static String getUsername(String userId) {
        DBCollection collection = database.getCollection("rsausers");
        DBCursor userCursor = collection.find(new BasicDBObject().append("_id", userId));
        return userCursor.next().get("username").toString();
    }
}
