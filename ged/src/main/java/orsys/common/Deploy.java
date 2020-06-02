package orsys.common;

import io.vertx.core.DeploymentOptions;
import io.vertx.core.Future;
import io.vertx.core.Vertx;
import io.vertx.core.json.JsonArray;
import io.vertx.core.json.JsonObject;
import io.vertx.rx.java.ObservableFuture;
import io.vertx.rx.java.RxHelper;

/**
 * project : ORASS
 * Created by ORSYS on 18/10/2016 15:05.
 */
public class Deploy {
//    private static orsys.common.Logger logger = new orsys.common.Logger(Deploy.class);

    private static void deployAsynchronousVerticalByIndex(Vertx vertx, int indexCurrentDeploye, JsonArray verticalArray, Future<Void> startFuture, JsonObject jsonObjectconfig) {
        JsonObject currentVertical = verticalArray.getJsonObject(indexCurrentDeploye);
        currentVertical.forEach(entry -> {
            Logger.debug("STARTING DEPLOYE OF VERTICLE: " + entry.getKey() + ", CONFIG: " + entry.getValue()+".");

            DeploymentOptions optionsDeploye = new DeploymentOptions().setConfig(jsonObjectconfig);
            ObservableFuture<String> observable = RxHelper.observableFuture();
            vertx.deployVerticle(entry.getKey(), optionsDeploye, observable.toHandler());

            observable.subscribe(id -> {
                Logger.info("VERTICLE "+entry.getKey() + " DEPLOYED.");
                if (indexCurrentDeploye + 1 < verticalArray.size()) {
                    deployAsynchronousVerticalByIndex(vertx, indexCurrentDeploye + 1, verticalArray, startFuture, jsonObjectconfig);
                } else {
                    Logger.info("ALL VERTICLES ARE DEPLOYED :).");
                    startFuture.complete();
                }
            }, err -> {
                Logger.error(err, err);
                startFuture.fail(err.getMessage());

            });
        });
    }

    public static void deployAsynchronousVertical(Vertx vertx, JsonArray verticalArray, Future<Void> startFuture, JsonObject jsonObjectconfig) {
        deployAsynchronousVerticalByIndex(vertx, 0, verticalArray, startFuture, jsonObjectconfig);
    }
}
