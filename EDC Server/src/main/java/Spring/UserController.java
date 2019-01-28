package Spring;

import MongoDB.DatabaseAdapter;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RestController;

import java.util.ArrayList;
import java.util.Map;

@RestController
public class UserController {

    @RequestMapping(value = "/login", method = RequestMethod.POST)
    public User loginUser(@RequestBody Map<String, String> body){
        String username = body.get("username");

        User dbUser = DatabaseAdapter.signIn(username);
        if (dbUser != null) {
            System.out.println("user exists.");
            return dbUser;
        }
        return DatabaseAdapter.addUser(username);
    }

    @RequestMapping("/getfiles")
    public ArrayList<RSAFile> getFiles() {
        return DatabaseAdapter.getFiles();
    }

}
