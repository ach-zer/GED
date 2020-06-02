package orsys.common.auth;

import io.vertx.core.AsyncResult;
import io.vertx.core.Future;
import io.vertx.core.Handler;
import io.vertx.core.Vertx;
import io.vertx.core.json.JsonArray;
import io.vertx.core.json.JsonObject;
import io.vertx.core.logging.Logger;
import io.vertx.core.logging.LoggerFactory;
import io.vertx.ext.auth.AuthProvider;
import io.vertx.ext.auth.User;
import io.vertx.ext.auth.jdbc.JDBCHashStrategy;
import io.vertx.ext.sql.ResultSet;
import orsys.common.database.DB;

import java.util.function.Consumer;

/**
 * project : orsys.ORSYSAuth
 * Created by ORSYS on 29/04/2016 12:19.
 */
public class ORSYSAuthImpl implements AuthProvider, ORSYSAuth {
    private static final Logger log = LoggerFactory.getLogger(ORSYSAuthImpl.class);
//    private String authenticateQuery = "SELECT PASSWORD, PASSWORD_SALT FROM USER WHERE USERNAME = ?";
    private String authenticateQuery = "SELECT NOM_UTIL, NOEFPOTR FROM ORASSADM.POSTE_TRAVAIL WHERE NOM_UTIL = upper(?)";
    private String userInfoQuery = "SELECT NOM_UTIL, NOEFPOTR FROM ORASSADM.POSTE_TRAVAIL WHERE NOM_UTIL = upper(?)";
    private String rolesQuery = "SELECT ROLE FROM USER_ROLES WHERE USERNAME = ?";

    private String permissionsQuery = "";
    private String rolePrefix = "role:";
    private Vertx vtx;
    private JsonObject dbConfig;
    private JDBCHashStrategy strategy = new DefaultHashStrategy();
    public ORSYSAuthImpl(Vertx vtx, JsonObject dbConfig) {
        this.vtx = vtx;
        this.dbConfig = dbConfig;
    }

    public void authenticate(JsonObject authInfo, Handler<AsyncResult<User>> resultHandler) {
        String username = authInfo.getString("username");
        if(username == null) {
            resultHandler.handle(Future.failedFuture("authInfo must contain username in \'username\' field"));
        } else {
            String password = authInfo.getString("password");
            if(password == null) {
                resultHandler.handle(Future.failedFuture("authInfo must contain password in \'password\' field"));
            } else {
                DB db = new DB(this.vtx, this.dbConfig.copy());
                db.setUsername(username);
                db.setPassword(password);
                db.connect(resCon->{
                    if(resCon.succeeded()){
                        db.queryWithParams(userInfoQuery, new JsonArray().add(username), resInfoUser->{
                            if(resInfoUser.succeeded()){
                                if(resInfoUser.result().getInteger("numRows") == 1){
                                    JsonObject user = resInfoUser.result().getJsonArray("rows").getJsonObject(0);
                                    ORSYSUser u = new ORSYSUser(username, user, this.rolePrefix);
                                    db.closeConnexion(cls->{});
                                    resultHandler.handle(Future.succeededFuture(u));
                                }else{
                                    db.closeConnexion(cls->{});
                                    resultHandler.handle(Future.failedFuture("Invalid username/password"));
                                }
                            }else{
                                db.closeConnexion(cls->{});
                                resultHandler.handle(Future.failedFuture("Invalid username/password"));
                            }
                        });
                    }else{
                        resultHandler.handle(Future.failedFuture("Invalid username/password"));
                    }
                });
           }
        }
    }

    public void hasPermission(String page, int id, Handler<AsyncResult<Boolean>> resultHandler){
        if(page == null || "".equalsIgnoreCase(page) || "".equalsIgnoreCase(id+"")){
            resultHandler.handle(Future.succeededFuture(false));
        }else{
            this.executeQuery(this.permissionsQuery, (new JsonArray()).add(page).add(id), resultHandler, (rs) -> {
                if(rs.getNumRows() == 1){
                    JsonArray ps = (JsonArray)rs.getResults().get(0);
                    if(page.equalsIgnoreCase((String)ps.getValue(0))){
                        resultHandler.handle(Future.succeededFuture(true));
                    }else{
                        resultHandler.handle(Future.succeededFuture(false));
                    }
                }else{
                    resultHandler.handle(Future.succeededFuture(false));
                }


            });
        }
    }

    protected <T> void executeQuery(String query, JsonArray params, Handler<AsyncResult<T>> resultHandler, Consumer<ResultSet> resultSetConsumer) {
//        DB.queryWithParams(query, params, (res) -> {
//            if(res.succeeded()) {
//                SQLConnection conn = (SQLConnection)res.result();
//                conn.queryWithParams(query, params, (queryRes) -> {
//                    if(queryRes.succeeded()) {
//                        ResultSet rs = (ResultSet)queryRes.result();
//                        resultSetConsumer.accept(rs);
//                    } else {
//                        resultHandler.handle(Future.failedFuture(queryRes.cause()));
//                    }
//
//                    conn.close((closeRes) -> {
//                    });
//                });
//            } else {
//                resultHandler.handle(Future.failedFuture(res.cause()));
//            }
//        });
    }

    public ORSYSAuth setAuthenticationQuery(String authenticationQuery) {
        this.authenticateQuery = authenticationQuery;
        return this;
    }

    public ORSYSAuth setRolesQuery(String rolesQuery) {
        this.rolesQuery = rolesQuery;
        return this;
    }

    public ORSYSAuth setPermissionsQuery(String permissionsQuery) {
        this.permissionsQuery = permissionsQuery;
        return this;
    }

    public ORSYSAuth setRolePrefix(String rolePrefix) {
        this.rolePrefix = rolePrefix;
        return this;
    }

    public ORSYSAuth setHashStrategy(JDBCHashStrategy strategy) {
        this.strategy = strategy;
        return this;
    }

    String getRolesQuery() {
        return this.rolesQuery;
    }

    String getPermissionsQuery() {
        return this.permissionsQuery;
    }

    private class DefaultHashStrategy implements JDBCHashStrategy {
        private DefaultHashStrategy() {
        }

        @Override
        public String generateSalt() {
            return null;
        }

        @Override
        public String computeHash(String password, String salt, int version) {
            return null;
        }

        public String getHashedStoredPwd(JsonArray row) {
            return row.getString(0);
        }

        public String getSalt(JsonArray row) {
            return row.getString(1);
        }

        @Override
        public void setNonces(JsonArray nonces) {

        }
    }
}
