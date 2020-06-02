
import io.vertx.core.AbstractVerticle;
import io.vertx.core.Future;
import io.vertx.core.json.JsonArray;
import io.vertx.core.json.JsonObject;
import orsys.common.Deploy;

public class MainVertical extends AbstractVerticle {
    @Override
    public void start(Future<Void> startFuture) throws Exception {
        JsonObject jsonObjectconfig = config();

        JsonArray deployVerticals = new JsonArray();
        deployVerticals.add(new JsonObject().put("orsys.common.Tools", "{}"));
        deployVerticals.add(new JsonObject().put("orsys.common.Files", "{}"));
        deployVerticals.add(new JsonObject().put("orsys.common.Config", "{}"));

        deployVerticals.add(new JsonObject().put("Server", "{}"));
        Deploy.deployAsynchronousVertical(vertx, deployVerticals, startFuture, jsonObjectconfig);
    }
}
