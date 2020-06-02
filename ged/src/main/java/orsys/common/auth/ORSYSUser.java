package orsys.common.auth;

import io.vertx.core.AsyncResult;
import io.vertx.core.Handler;
import io.vertx.core.buffer.Buffer;
import io.vertx.core.json.JsonObject;
import io.vertx.ext.auth.AbstractUser;
import io.vertx.ext.auth.AuthProvider;
import orsys.common.database.DB;

import java.nio.charset.StandardCharsets;

/**
 * project : orsys.ORSYSAuth
 * Created by ORSYS on 29/04/2016 12:20.
 */
public class ORSYSUser extends AbstractUser {
//    private ORSYSAuthImpl authProvider;
    private String username;
    private JsonObject principal;
    private String rolePrefix;
    private JsonObject user;
    private DB DBClient;

    public ORSYSUser() {
    }

    public ORSYSUser(String username, JsonObject user, String rolePrefix) {
        this.username = username;
        this.user = user;
        this.rolePrefix = rolePrefix;
    }

    public void doIsPermitted(String permissionOrRole, Handler<AsyncResult<Boolean>> resultHandler) {
//        this.authProvider.hasPermission(permissionOrRole, this.principal.getInteger("USER_ID"), resultHandler);
    }

    public void setDataBaseClient(DB client){
        this.DBClient = client;
    }

    public JsonObject principal() {
        if(this.principal == null) {
            JsonObject userPrincipal = this.user;
            userPrincipal.remove("USER_PASSWORD");
            userPrincipal.remove("SALT");
            this.principal = userPrincipal;
        }

        return this.principal;
    }

    public void setAuthProvider(AuthProvider authProvider) {
        if(authProvider instanceof ORSYSAuthImpl) {
//            this.authProvider = (ORSYSAuthImpl)authProvider;
        } else {
            throw new IllegalArgumentException("Not a ORSYSAuthImpl");
        }
    }

    public void writeToBuffer(Buffer buff) {
        super.writeToBuffer(buff);
        byte[] bytes = this.username.getBytes(StandardCharsets.UTF_8);
        buff.appendInt(bytes.length);
        buff.appendBytes(bytes);
        bytes = this.rolePrefix.getBytes(StandardCharsets.UTF_8);
        buff.appendInt(bytes.length);
        buff.appendBytes(bytes);
    }

    public int readFromBuffer(int pos, Buffer buffer) {
        pos = super.readFromBuffer(pos, buffer);
        int len = buffer.getInt(pos);
        pos += 4;
        byte[] bytes = buffer.getBytes(pos, pos + len);
        this.username = new String(bytes, StandardCharsets.UTF_8);
        pos += len;
        len = buffer.getInt(pos);
        pos += 4;
        bytes = buffer.getBytes(pos, pos + len);
        this.rolePrefix = new String(bytes, StandardCharsets.UTF_8);
        pos += len;
        return pos;
    }

}
