package orsys.common.HttpApi;

import io.vertx.core.AsyncResult;
import io.vertx.core.Future;
import io.vertx.core.Handler;
import io.vertx.core.buffer.Buffer;
import io.vertx.core.json.Json;
import io.vertx.core.json.JsonArray;
import io.vertx.core.json.JsonObject;
import io.vertx.ext.web.FileUpload;
import io.vertx.ext.web.RoutingContext;
import oracle.jdbc.OracleTypes;
import org.apache.commons.lang3.StringUtils;
import orsys.common.ClientCallBack;
import orsys.common.Constants;
import orsys.common.Logger;
import orsys.common.Session;
import orsys.common.database.DB;
import orsys.common.msg.Error;

import javax.xml.bind.DatatypeConverter;
import java.io.ByteArrayInputStream;
import java.io.File;
import java.io.InputStream;
import java.sql.*;
import java.util.Set;

public class CommonHttpCall {

    private static final String SOCIETY_INFO = "SELECT RAISSOCI, ABRESOCI, TELESOCI, FAX_SOCI, MONNSOCI, COMMSOCI, COMSOCBA, COMSOCB0, ADRESOCI, LOGOSOCI, ORASVERS FROM SOCIETE";
    private static final String INTER_INFO = "SELECT CODEINTE, RAISOCIN, ABREINTE, COMSOCHP, COMSOCBH, LOGOINTE FROM INTERMEDIAIRE where CODEINTE = :CODEINTE";
    private static final String USER_MENU = "web_pkg_interface.get_user_menu_guard";

    public static void HttpCall(RoutingContext routingContext){
        Session.sessionDB(routingContext, db->{
            if(db.succeeded()){
                dynamicCall(db.result(), routingContext);
            }else{
                ClientCallBack.RequireLogin(routingContext, null);
            }
        });
    }

    public static void getHttpCall(RoutingContext routingContext){
        Session.sessionDB(routingContext, db->{
            if(db.succeeded()){
                dynamicCall(db.result(), new JsonObject(), routingContext);
            }else{
                ClientCallBack.RequireLogin(routingContext, null);
            }
        });
    }

    private static void dynamicCall(DB db, RoutingContext routingContext) {
        try {
            try{
                dynamicCall(db, routingContext.getBodyAsJson(), routingContext);
            }catch (Exception e){
                Logger.warn(e.getMessage(), e);
                ClientCallBack.sendErrorResponce(routingContext, Error.INVALID_DATA.toString());
            }
        }catch (Exception e){
            Logger.error(e.getMessage(), e);
            ClientCallBack.sendErrorResponce(routingContext, e.getMessage());
        }
    }

    private static void dynamicCall(DB db, JsonObject params, RoutingContext routingContext) {
        try {
            String v_package = routingContext.request().getParam("package");
            String func = routingContext.request().getParam("func");
            dynamicCall(db, v_package+"_"+func, params, routingContext, res -> {
                if (res.succeeded()) {
                    ClientCallBack.sendJsonResponce(routingContext, res.result());
                } else {
                    ClientCallBack.sendErrorResponce(routingContext, res.cause().getMessage());
                }
            });
        }catch (Exception e){
            Logger.error(e.getMessage(), e);
            ClientCallBack.sendErrorResponce(routingContext, e.getMessage());
        }
    }


    /**
     * call PL/SQL Function in order BEGIN fct_name(:PARAMS, :MESS_ERR, :RESULTAT) ; END;
     * with:
     * PARAMS: clob,
     * MESS_ERR: varchar2
     * RESULTAT: clob
     *
     * @param fct String: the function name with pkgs name to call
     * @param params JsonObject: params to send to function
     * @param resultHandler  the handler which is called once the operation completes. It will return a {@code JsonObject}.
     */
    private static void dynamicCall(DB db, String fct, JsonObject params, RoutingContext routingContext, Handler<AsyncResult<JsonObject>> resultHandler){

        if(db == null){
            resultHandler.handle(Future.failedFuture(Error.ER_DB_CONX.toString()));
        }else if(fct != null){
            String fcts[] = fct.split(";");
            if(fcts.length > 1){
                params.put("fct_name", fcts[1]);
            }

            for (String param: routingContext.request().params().names()) {
                params.put(StringUtils.lowerCase(param), routingContext.request().getParam(param));
            }

            params.put("route", fcts[0]);

            String sql = "BEGIN web_pkg_router.bootstrap(:req, :res, :error) ; END; ";
            JsonArray paramsIn = new JsonArray().add(params.encode());
            JsonArray paramsOut = new JsonArray().addNull().add(JDBCType.CLOB).add(JDBCType.VARCHAR);

            Logger.info("START CALL TO: ["+fct+"]");
            db.callWithParams(sql, paramsIn, paramsOut, res->{
                if(res.succeeded()){
                    try{
                        JsonArray output = res.result().getJsonArray("output");
                        String error = output.getString(2);
                        if (! "OK".equalsIgnoreCase(error)){
                            resultHandler.handle(Future.failedFuture(error));
                        }else{
                            String r = output.getString(1);
                            if(r == null) r = "{}";
                            resultHandler.handle(Future.succeededFuture(new JsonObject(r)));
                        }
                    }catch (Exception ex){
                        Logger.error(ex, ex);
                        resultHandler.handle(Future.failedFuture(ex.getMessage()));
                    }
                }else {
                    resultHandler.handle(Future.failedFuture(res.cause().getMessage()));
                }
            });
        }else{
            resultHandler.handle(Future.failedFuture(Error.INVALID_PARAMS.toString()));
        }
    }

    public static void getSocietyInfo(RoutingContext routingContext){
        if(! (boolean) routingContext.vertx().sharedData().getLocalMap(Constants.SHARED_DATA).get(Constants.IS_SOCIETY_LOADED)) {
            Session.sessionDB(routingContext, db->{
                if(db.succeeded()){
                    getSocietyInfo(db.result(), soc -> {
                        if (soc.succeeded()) {
                            ClientCallBack.sendJsonResponce(routingContext, soc.result());
                        } else {
                            ClientCallBack.sendErrorResponce(routingContext, soc.cause().getMessage());
                        }
                    });
                }else{
                    ClientCallBack.RequireLogin(routingContext, null);
                }
            });

        }else{
            ClientCallBack.sendJsonResponce(routingContext, (JsonObject) routingContext.vertx().sharedData().getLocalMap(Constants.SHARED_DATA).get(Constants.INFO_SOCIETY));
        }
    }

    private static void getSocietyInfo(DB db, Handler<AsyncResult<JsonObject>> resultHandler){
        getSocietyInfo(db, SOCIETY_INFO, resultHandler);
    }

    private static void getSocietyInfo(DB db, String sql, Handler<AsyncResult<JsonObject>> resultHandler){
        db.queryWithParams(sql, new JsonArray(), res->{
            if(res.succeeded()){
                try{
                    try {
                        JsonObject society = res.result().getJsonArray("rows").getJsonObject(0);
                        society.put("LOGOSOCI", "data:image/png;base64, "+society.getString("LOGOSOCI"));
                        society.put("style", new JsonObject().put("width", "100%"));

                        resultHandler.handle(Future.succeededFuture(society));
                    }catch (Exception e){
                        Logger.debug("ERROR GET INFO SOCIETE => "+e.getMessage());
                        resultHandler.handle(Future.failedFuture(e.getMessage()));
                    }
                }catch (Exception ex){
                    Logger.error(ex);
                    resultHandler.handle(Future.failedFuture(Error.ERROR_OCCURED.toString()));
                }
            }else {
                resultHandler.handle(Future.failedFuture(res.cause().getMessage()));
            }
        });
    }

    // Added by Achraf Zeroual to insert a binary document
    public static void insertDocBin(RoutingContext routingContext){
            Logger.info("Dans insertDocBin...");

            JsonObject jsonResponse = new JsonObject();
            // To receive a file from the input
            Set<FileUpload> uploads = routingContext.fileUploads();
            FileUpload fileUpload = uploads.iterator().next();
            String fileName = fileUpload.uploadedFileName();
            Buffer fileUploaded = routingContext.vertx().fileSystem().readFileBlocking(fileName);
            byte[] bytes = fileUploaded.getBytes();

            //ByteArrayInputStream bis = new ByteArrayInputStream(bytes);

            String sql = "{call dml_ged_doc_bin.ins_ged_doc_bin(?,?)}" ;

            Connection connection = new DB().getConnection();

        int idDocInserted = 0;

        try {

            ByteArrayInputStream bis = new ByteArrayInputStream(bytes);

            CallableStatement cstmt  = connection.prepareCall(sql);
            cstmt.setBinaryStream(1, bis, bytes.length);
            // Id of my DocBin
            cstmt.registerOutParameter(2, OracleTypes.NUMBER);

            int i = cstmt.executeUpdate();

            idDocInserted = cstmt.getInt(2);

            System.out.println(idDocInserted);

            System.out.println("Successful query ");

            connection.close();

        } catch (SQLException e) {
            e.printStackTrace();
        }

        if(idDocInserted != 0)
            jsonResponse.put("idDocInserted",idDocInserted);
            routingContext.response()
                    .setStatusCode(200)
                    .putHeader("content-type", "application/json")
                    .end(Json.encode(jsonResponse));
    }

    public static void getBlobDocById(RoutingContext routingContext){
        Logger.info("Dans getBlobDocById...");

        //final JsonObject body = routingContext.getBodyAsJson();

        final String id = routingContext.request().getParam("idedocbi");

        final int idedocbi = Integer.parseInt(id);

        System.out.println("id reçu est : "+idedocbi);

        JsonObject jsonResponse = new JsonObject();

        String sql = "{call dml_ged_doc_bin.sel_blob_doc_bin_by_id(?,?)}";
        Connection connection = new DB().getConnection();

        Blob blob = null;
        long blobLength = 0 ;

        byte[] bytes = null;
        try {

            CallableStatement cstmt  = connection.prepareCall(sql);
            cstmt.setInt(1, idedocbi);

            cstmt.registerOutParameter(2, OracleTypes.BLOB);

            int i = cstmt.executeUpdate();

            blob = cstmt.getBlob(2);
            blobLength = blob.length();

            bytes = blob.getBytes(1, (int) blobLength);

            System.out.println("Successful query ");

            connection.close();

        } catch (SQLException e) {
            e.printStackTrace();
        }

        if(blobLength != 0){
            Buffer buffer = Buffer.buffer(bytes);
            routingContext.response()
                    .putHeader("Content-Type","application/pdf")
                    .setStatusCode(200)
                    .putHeader("Content-Length", String.valueOf(buffer.length()))
                    .write(buffer)
                    .end();
        }
    }
}
