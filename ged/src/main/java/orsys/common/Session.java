package orsys.common;

import io.vertx.core.AsyncResult;
import io.vertx.core.Future;
import io.vertx.core.Handler;
import io.vertx.ext.web.RoutingContext;
import orsys.common.database.DB;

import java.util.HashMap;
import java.util.Map;

public class Session {
    private static Map<String, DB> sessions = new HashMap<String, DB>();

    public static String createSession(DB db){
        String uuid = Tools.randomUUID();
        sessions.put(uuid, db);
        return uuid;
    }


    public static DB getSession(String uuid){
        return sessions.get(uuid);
    }

    public static void destroySession(RoutingContext routingContext){
        String uuid = routingContext.session().get("DB");

        if(uuid != null){
            DB db = Session.getSession(uuid);
            if(db != null){
                db.closeConnexion(re->{
                    sessions.remove(uuid);
                    routingContext.session().remove("USER_MENUS");
                    routingContext.clearUser();
                    routingContext.response().putHeader("location", Constants.URL_LOGIN).setStatusCode(302).end();
                });
            }else{
                routingContext.response().putHeader("location", Constants.URL_LOGIN).setStatusCode(302).end();
            }
        }else{
            routingContext.response().putHeader("location", Constants.URL_LOGIN).setStatusCode(302).end();
        }
    }

    public static void sessionDB(RoutingContext routingContext, Handler<AsyncResult<DB>> resultHandler){
        String uuid = routingContext.session().get("DB");

        if(uuid == null){
            resultHandler.handle(Future.failedFuture("You have to Login"));
        }else{
            DB db = Session.getSession(uuid);
            if(db != null){
                resultHandler.handle(Future.succeededFuture(db));
            }else{
                resultHandler.handle(Future.failedFuture("You have to Login"));
            }
        }


    }

}
