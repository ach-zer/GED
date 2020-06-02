package orsys.common;

import io.vertx.core.*;
import io.vertx.core.buffer.Buffer;
import io.vertx.core.json.JsonObject;

/**
 * project : OrassSMS
 * Created by ORSYS on 11/07/2017 17:09.
 */
public class Files extends AbstractVerticle {
//    private static Logger logger = new Logger(Files.class);
    private static Vertx vtx;

    public void start(Future<Void> future){
        vtx = vertx;

        future.complete();
    }

    /**
     * Write a String data to File
     *
     * @param path String path to save the file include the file name
     * @param str String body of the file
     * @param resultHandler  the handler which is called once the operation completes. It will return a {@code String}.
     */

    public static void writeToFile(String path, String str, Handler<AsyncResult<JsonObject>> resultHandler){
        vtx.fileSystem().writeFile(path, Buffer.buffer(str), result -> {
            if (result.succeeded()) {
                JsonObject ret = new JsonObject();
                ret.put("path", path);
                ret.put("text", str);
                resultHandler.handle(Future.succeededFuture(ret));
            } else {
                Logger.debug(result.cause());
                resultHandler.handle(Future.failedFuture(result.cause()));
            }
        });
    }

}
