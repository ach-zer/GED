package orsys.common;

import io.vertx.core.buffer.Buffer;
import io.vertx.core.http.HttpHeaders;
import io.vertx.core.json.JsonArray;
import io.vertx.core.json.JsonObject;
import io.vertx.ext.web.RoutingContext;
import orsys.common.msg.Error;

import java.io.OutputStream;

/**
 *
 * Created by ORSYS on 20/06/2016 15:43.
 */
public class ClientCallBack {

//    private static orsys.common.Logger logger = new orsys.common.Logger(ClientCallBack.class);

    public static void sendErrorResponce(RoutingContext context, String data) {
        JsonObject error = new JsonObject();
        error.put("error", true);
        try{
            error.put("cause",  new JsonObject(data));
        }catch (Exception e){
            error.put("cause",  data);
        }

        JsonResponce(context, error);
    }

    public static void sendPdfFile(RoutingContext context, JsonObject data) {
        context.response().putHeader("content-type", "application/pdf");
        sendFile(context, data);
    }

    public static void sendStream(RoutingContext context, OutputStream outputStream) {
//        context.response().putHeader("content-type", "application/oc");
        context.response().write((Buffer) outputStream);
    }

    public static void sendBaytes(RoutingContext context, byte[] bytes) {
        context.response().putHeader("content-type", "application/pdf");
        Buffer buf = Buffer.buffer(bytes);
        context.response().putHeader("Content-Length", buf.length()+"");
        context.response().write(buf);
        context.response().setStatusCode(200);
        context.response().end();
    }

    public static void sendFile(RoutingContext context, JsonObject data) {
        String file = data.getString("FILE_PATH");
        if(file != null){
            try {
                context.response().sendFile(file).setStatusCode(200).close();
            }catch (Exception e){
                Logger.error(e);
                sendErrorResponce(context, Error.ERROR_OCCURED.toString());
            }
        }else{
            sendErrorResponce(context, Error.INVALID_DATA.toString());
        }
    }

    public static void sendErrorResponce(RoutingContext context, JsonObject data) {
        JsonObject error = new JsonObject();
        error.put("error", true);
        error.put("cause", data);
        JsonResponce(context, error);
    }


    public static void sendErrorResponce(RoutingContext context, JsonArray data) {
        JsonObject error = new JsonObject();
        error.put("error", true);
        error.put("cause", data);
        JsonResponce(context, error);
    }

    public static void sendJsonResponce(RoutingContext context, JsonArray data){
        JsonObject resp = new JsonObject();
        resp.put("data", data);
        JsonResponce(context, resp);
    }

    public static void sendJsonResponce(RoutingContext context, JsonObject data){
        JsonObject resp = new JsonObject();
        resp.put("data", data);
        JsonResponce(context, resp);
    }


    public static void sendJsonResponce(RoutingContext context, String data){
        JsonObject resp = new JsonObject();
        try{
            resp.put("data", new JsonObject(data));
        }catch(Exception e){
            resp.put("data", data);
        }

        JsonResponce(context, resp);
    }

    public static void sendJsonResponce(RoutingContext context, boolean data){
        JsonObject resp = new JsonObject();
        try{
            resp.put("data", data);
        }catch(Exception e){
            resp.put("data", data);
        }

        JsonResponce(context, resp);
    }

    public static void doRedirect(RoutingContext context, String url){
        context.response().putHeader(HttpHeaders.LOCATION, url);
        context.response().setStatusCode(302).end();
    }

    private static void JsonResponce(RoutingContext context, JsonObject data) {
        if(!context.response().closed()){
            context.response().putHeader(HttpHeaders.CONTENT_TYPE, "application/json");

            // do not allow proxies to cache the data
            context.response().putHeader("Cache-Control", "no-store, no-cache")
            // prevents Internet Explorer from MIME - sniffing a
            // response away from the declared content-type
            .putHeader("X-Content-Type-Options", "nosniff")
            // Strict HTTPS (for about ~6Months)
//            .putHeader("Strict-Transport-Security", "max-age=" + 15768000)
            // IE8+ do not allow opening of attachments in the context of this resource
            .putHeader("X-Download-Options", "noopen")
            // enable XSS for IE
            .putHeader("X-XSS-Protection", "1; mode=block")
            // deny frames
            .putHeader("X-FRAME-OPTIONS", "DENY");

            context.response().end(data.toString());

        }else{
            Logger.warn("Response is close!");
        }
    }

    public static void RequireLogin(RoutingContext context, JsonObject data) {
        context.response().putHeader("location", Constants.URL_LOGIN);
    }

    public static void RequireLogin(RoutingContext context) {
        sendErrorResponce(context, "KOLOGIN");
    }

}
