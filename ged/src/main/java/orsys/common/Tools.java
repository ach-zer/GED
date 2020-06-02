package orsys.common;

import io.vertx.core.AbstractVerticle;
import io.vertx.core.Future;
import io.vertx.core.Vertx;
import io.vertx.core.json.JsonArray;
import io.vertx.core.json.JsonObject;
import org.apache.commons.lang3.StringUtils;
import orsys.common.database.DBConst;

import java.util.Map;
import java.util.UUID;

//import org.apache.commons.lang.StringUtils;


public class Tools extends AbstractVerticle {

//    private static Logger logger = new Logger(Tools.class);
    private static Vertx vtx;

    @Override
    public void start(Future<Void> future) {
        vtx = vertx;

        future.complete();
    }

    public static Vertx getVertxInstance(){
        return vtx;
    }

    public static JsonObject formatOracleConfig(JsonObject config){
        String URL = DBConst.DB_ORACLE_URL;
        String DRIVER = DBConst.DB_ORACLE_DRIVER;
        return new JsonObject()
                .put("url", URL.replace("#DB_HOST#", config.getString(DBConst.DB_HOST_CONFIG))
                        .replace("#DB_PORT#", config.getInteger(DBConst.DB_PORT_CONFIG)+"")
                        .replace("#DB_NAME#",config.getString(DBConst.DB_NAME_CONFIG)))
                .put("driver_class", DRIVER)
                .put("user", config.getString(DBConst.DB_LOGIN_CONFIG))
                .put("password", config.getString(DBConst.DB_PASS_CONFIG));
    }

    public static String randomUUID(){
        return UUID.randomUUID().toString();
    }

    public static Boolean isJsonArrayContain(JsonArray arr, String key, String str){
        Boolean isCOnt = false;
        for (int i = 0; i < arr.size(); i++) {
            if(str != null && StringUtils.equalsIgnoreCase(str, arr.getJsonObject(i).getString(key) )){
                isCOnt = true;
                break;
            }
        }
        return  isCOnt;
    }

    public static Boolean isRouteAllowed(JsonArray arr, String key, String str){
//        System.out.println("----> "+str);
        Boolean isCOnt = false;
        for (int i = 0; i < arr.size(); i++) {
            str = StringUtils.lowerCase(str);
//            Logger.info("--- ===> "+str+" ===> "+arr.getJsonObject(i).getString(key)+" ==> "+StringUtils.startsWith(str, StringUtils.lowerCase(arr.getJsonObject(i).getString(key))));
            if(str != null && StringUtils.startsWith(str, StringUtils.lowerCase(arr.getJsonObject(i).getString(key)))){
                isCOnt = true;
                break;
            }
        }

        return  isCOnt;
    }

    public static JsonObject decodeStr(String str, JsonObject map){

        JsonObject rets = new JsonObject();

        String strCloned = str;

        for (Map.Entry<String, Object> pair : map) {
            try{
                String splite = strCloned.substring(0, (int)pair.getValue());
                strCloned = strCloned.substring((int)pair.getValue());
                rets.put(pair.getKey(), StringUtils.trimToEmpty(splite));
            }catch (Exception e){
                rets.put(pair.getKey(), "");
            }
        }

//        Logger.error(rets.encodePrettily());
        return  rets;

    }



}
