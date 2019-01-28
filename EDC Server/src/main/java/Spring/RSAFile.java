package Spring;

public class RSAFile {
    private final String id;
    private final String filename;
    private final String filebody;
    private final String owner;
    private final String checkflag;

    public RSAFile(String id, String filename, String filebody, String owner, String checkflag) {
        this.id = id;
        this.filename = filename;
        this.filebody = filebody;
        this.owner = owner;
        this.checkflag = checkflag;
    }

    public String getId() { return id; }
    public String getFilename() { return filename; }
    public String getFilebody() { return filebody; }
    public String getOwner() { return owner; }
    public String getCheckflag() { return checkflag; }
}
