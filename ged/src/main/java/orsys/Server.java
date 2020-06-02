package orsys;

import io.vertx.ext.web.Router;
import orsys.common.HttpApi.CommonHttpCall;

public class Server {

    public static void addRoutes(Router r){
        String initPath = "/api/";
        r.get(initPath+"dc/of/:package/:func").handler(CommonHttpCall::getHttpCall);
        r.post(initPath+"dc/of/:package/:func").handler(CommonHttpCall::HttpCall);
        r.put(initPath+"dc/of/:package/:func").handler(CommonHttpCall::HttpCall);
        r.delete(initPath+"dc/of/:package/:func").handler(CommonHttpCall::HttpCall);
        r.post(initPath+"doc/insert").handler(CommonHttpCall::insertDocBin);// Added by Achraf Zeroual
        r.get(initPath+"doc/select").handler(CommonHttpCall::getBlobDocById);// Added by Achraf Zeroual
    }
}
