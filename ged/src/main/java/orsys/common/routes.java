package orsys.common;

import io.vertx.ext.web.Router;
import orsys.common.HttpApi.CommonHttpCall;


public class routes {

    public static Router addRoutes(Router r){
        String initPath = "/api/";
        r.get(initPath+"cdc/of/:name").handler(CommonHttpCall::getHttpCall);
        r.post(initPath+"cdc/of/:name").handler(CommonHttpCall::HttpCall);
        r.put(initPath+"cdc/of/:name").handler(CommonHttpCall::HttpCall);
        r.delete(initPath+"cdc/of/:name").handler(CommonHttpCall::HttpCall);
        return r;
    }
}
