package orsys.common;

import io.vertx.core.AbstractVerticle;
import io.vertx.core.Future;
import io.vertx.core.Vertx;
import io.vertx.core.json.JsonObject;
import io.vertx.ext.web.RoutingContext;

import java.text.SimpleDateFormat;
import java.util.Date;

public class Config  extends AbstractVerticle {

    private static Vertx vtx;
    private static JsonObject config;

    public void start(Future<Void> future){
        vtx = (Vertx) vertx;
        config = config();

        future.complete();
    }

    public static JsonObject getConfig(){
        return config;
    }

    public static JsonObject mySql(){
        return config.getJsonObject("mysql");
    }

    public static Vertx vertx(){
        return vtx;
    }

    public static void getConfig(RoutingContext routingContext){
        JsonObject jsConfig = new JsonObject();
        JsonObject sysdate = new JsonObject();

        Date aujourdhui = new Date();

        sysdate.put("ddmmyyyy", new SimpleDateFormat("dd/MM/yyy").format(aujourdhui));
        sysdate.put("yyyymmdd", new SimpleDateFormat("yyyy/MM/dd").format(aujourdhui));
        sysdate.put("ddmmyyyy1", new SimpleDateFormat("dd-MM-yyy").format(aujourdhui));
        sysdate.put("yyyymmdd1", new SimpleDateFormat("yyyy-MM-dd").format(aujourdhui));
        sysdate.put("day", new SimpleDateFormat("dd").format(aujourdhui));
        sysdate.put("month", new SimpleDateFormat("MM").format(aujourdhui));
        sysdate.put("year", new SimpleDateFormat("yyyy").format(aujourdhui));
        sysdate.put("hour", new SimpleDateFormat("hh").format(aujourdhui));
        sysdate.put("minute", new SimpleDateFormat("mm").format(aujourdhui));
        jsConfig.put("sysdate", sysdate);

        ClientCallBack.sendJsonResponce(routingContext, jsConfig);
    }
}
