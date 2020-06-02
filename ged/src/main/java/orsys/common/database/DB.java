package orsys.common.database;

import io.vertx.core.AsyncResult;
import io.vertx.core.Future;
import io.vertx.core.Handler;
import io.vertx.core.Vertx;
import io.vertx.core.json.JsonArray;
import io.vertx.core.json.JsonObject;
import io.vertx.ext.jdbc.JDBCClient;
import io.vertx.ext.sql.SQLConnection;
import orsys.common.Logger;
import orsys.common.Tools;
import orsys.common.msg.Error;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.util.Locale;

public class DB {
    private JsonObject config;
    private Vertx vtx;
    private Boolean sharedClient = false;
    private JDBCClient client;

    public DB(){

    }

    public DB(Vertx vtx, JsonObject config){
        this.config = config;
        this.vtx = vtx;

        if("EN".equalsIgnoreCase(config.getString("LOCALE"))){
            Locale.setDefault(Locale.ENGLISH);
        }

        if("FR".equalsIgnoreCase(config.getString("LOCALE"))){
            Locale.setDefault(Locale.FRENCH);
        }

    }

    public DB(Vertx vtx, JsonObject config, Boolean sharedClient){
        this.config = config;
        this.vtx = vtx;
        this.sharedClient = sharedClient;

        if("EN".equalsIgnoreCase(config.getString("LOCALE"))){
            Locale.setDefault(Locale.ENGLISH);
        }

        if("FR".equalsIgnoreCase(config.getString("LOCALE"))){
            Locale.setDefault(Locale.FRENCH);
        }
    }

    public void closeConnexion(Handler<AsyncResult<Boolean>> resultHandler){
        this.closeConnexion();
        resultHandler.handle(Future.succeededFuture(true));
    }

    public void init_client(Handler<AsyncResult<JDBCClient>> resultHandler){
        try {
            //System.out.println(Tools.formatOracleConfig(this.config).encodePrettily());
            if(this.sharedClient){
                this.client = JDBCClient.createShared(vtx, Tools.formatOracleConfig(this.config));
            }else{
                this.client = JDBCClient.createShared(vtx, Tools.formatOracleConfig(this.config));
            }
            resultHandler.handle(Future.succeededFuture(this.client));
        }catch (Exception e){
            Logger.error(e.getMessage(), e);
            resultHandler.handle(Future.failedFuture(e.getMessage()));
        }
    }

    public void connect(Handler<AsyncResult<SQLConnection>> resultHandler){
        try {
            if(this.client != null){
                this.client.getConnection(resultHandler);
            }else{
                this.init_client(co->{
                    if(co.succeeded()){
                        this.client.getConnection(resultHandler);
                    }else{
                        resultHandler.handle(Future.failedFuture(co.cause().getMessage()));
                    }
                });
            }
        }catch (Exception e){
            Logger.error(e.getMessage(), e);
            resultHandler.handle(Future.failedFuture(e.getMessage()));
        }
    }

    private void closeConnexion(){
        if(this.client != null){
           this.client.close();
        }
    }

    public void queryWithParams(String sql, JsonArray params, Handler<AsyncResult<JsonObject>> resultHandler){
        Logger.info("START QUERY WITH PARAMS: ["+sql+"]");
        if(sql == null){
            resultHandler.handle(Future.failedFuture(Error.NULL_OR_EMPTY_SQL.toString()));
        }else{
            getConnection(connection->{
                if (connection.succeeded()) {
                    connection.result().queryWithParams(sql, params, query -> {
                        if (query.succeeded()) {
                            resultHandler.handle(Future.succeededFuture(query.result().toJson()));
                        } else {
                            Logger.error(query.cause().getMessage(), query.cause());
                            resultHandler.handle(Future.failedFuture(query.cause().getMessage()));
                        }

                        connection.result().close();
                    });
                }else{
                    Logger.error(connection.cause().getMessage());
                    resultHandler.handle(Future.failedFuture(Error.ER_DB_CONX.toString()));
                }
            });
        }
    }

    public void callWithParams(String sql, JsonArray paramsIn, JsonArray paramsOut, Handler<AsyncResult<JsonObject>> resultHandler){
        Logger.info("START CALL TO PROCEDURE OR FUNCTION: ["+sql+"]");
        if(sql == null){
            resultHandler.handle(Future.failedFuture(Error.NULL_OR_EMPTY_SQL.toString()));
        }else{
            getConnection(connection->{
                if (connection.succeeded()) {
                    connection.result().callWithParams(sql, paramsIn, paramsOut, query -> {
                        if (query.succeeded()) {
                            resultHandler.handle(Future.succeededFuture(query.result().toJson()));
                        } else {
                            Logger.error(query.cause().getMessage(), query.cause());
                            resultHandler.handle(Future.failedFuture(query.cause().getMessage()));
                        }

                        connection.result().close();
                    });
                }else{
                    Logger.error(connection.cause().getMessage());
                    resultHandler.handle(Future.failedFuture(Error.ER_DB_CONX.toString()));
                }
            });
        }
    }

    public void setUsername(String username){
        config.put(DBConst.DB_LOGIN_CONFIG, username);
    }

    public void setPassword(String password){
        config.put(DBConst.DB_PASS_CONFIG, password);
    }

    public void getConnection(Handler<AsyncResult<SQLConnection>> resultHandler){
        if(this.client == null){
            Logger.error(Error.BD_CLIENT_NOT_FOUND);
            resultHandler.handle(Future.failedFuture(Error.BD_CLIENT_NOT_FOUND.toString()));
        }else {
            this.client.getConnection(connection -> {
                if (connection.succeeded()) {
                    if(connection.result() != null){
                        resultHandler.handle(Future.succeededFuture((SQLConnection)connection.result()));
                    }else {
                        resultHandler.handle(Future.failedFuture(Error.CONNECT_TO_DATA_BASE_FAIL.toString()));
                    }
                } else {
                    Logger.error(connection.cause().getMessage(), connection.cause());
                    resultHandler.handle(Future.failedFuture(connection.cause().getMessage()));
                }
            });
        }
    }
    public Connection getConnection() {
         Connection connection = null;
        try {

            Class.forName("oracle.jdbc.driver.OracleDriver");
            connection = DriverManager.getConnection("jdbc:oracle:thin:@localhost:1521:firstdataba", "hr", "hr");

        } catch (ClassNotFoundException e) {
            e.printStackTrace();
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return connection;
    }


}
