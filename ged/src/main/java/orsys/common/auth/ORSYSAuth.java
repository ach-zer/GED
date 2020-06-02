package orsys.common.auth;

import io.vertx.core.Vertx;
import io.vertx.core.json.JsonObject;
import io.vertx.ext.auth.AuthProvider;
import io.vertx.ext.auth.jdbc.JDBCHashStrategy;

/**
 * project : orsys.JDBCAuth
 * Created by ORSYS on 29/04/2016 12:18.
 */
public interface ORSYSAuth extends AuthProvider {

    static ORSYSAuth create(Vertx vtx, JsonObject dbConfig) {
        return new ORSYSAuthImpl(vtx, dbConfig);
    }

    ORSYSAuth setAuthenticationQuery(String var1);

    ORSYSAuth setRolesQuery(String var1);

    ORSYSAuth setPermissionsQuery(String var1);

    ORSYSAuth setRolePrefix(String var1);

    ORSYSAuth setHashStrategy(JDBCHashStrategy var1);
}
