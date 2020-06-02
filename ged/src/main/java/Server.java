import io.vertx.core.AbstractVerticle;
import io.vertx.core.Future;
import io.vertx.core.http.HttpMethod;
import io.vertx.core.http.HttpServerOptions;
import io.vertx.core.json.JsonArray;
import io.vertx.core.json.JsonObject;
import io.vertx.core.net.JksOptions;
import io.vertx.core.net.PemKeyCertOptions;
import io.vertx.core.net.PemTrustOptions;
import io.vertx.ext.auth.AuthProvider;
import io.vertx.ext.web.Router;
import io.vertx.ext.web.handler.*;
import io.vertx.ext.web.handler.impl.HttpStatusException;
import io.vertx.ext.web.sstore.LocalSessionStore;

import orsys.common.*;
import orsys.common.HttpApi.CommonHttpCall;
import orsys.common.auth.ORSYSAuth;
import orsys.common.database.DB;

import java.util.regex.Matcher;
import java.util.regex.Pattern;


public class Server extends AbstractVerticle {

    private static final int KB = 1024;
    private static final int MB = 1024 * KB;

    @Override
    public void start(Future<Void> future) throws Exception {
        Router r = Router.router(vertx);

        // We need cookies, sessions and request bodies
        r.route().handler(CookieHandler.create());

        int LIMIT_UPLOADS = config().getInteger("LIMIT_UPLOADS");
        r.route().handler(BodyHandler.create().setBodyLimit(LIMIT_UPLOADS*MB));

        SessionHandler sessionHandler = SessionHandler.create(LocalSessionStore.create(vertx, "orsys.orass.collecte", 1000 * 60 * 60));
        sessionHandler.setSessionCookieName("orsys-orasssuite-collecte.session");
        sessionHandler.setSessionTimeout(1000 * 60 * 60);
        sessionHandler.setCookieHttpOnlyFlag(true);

        JsonObject HTTPS = config().getJsonObject("HTTPS");

        if(HTTPS.getBoolean("STATUS")){
            sessionHandler.setCookieSecureFlag(true);
        }

        r.route().handler(sessionHandler);
        vertx.sharedData().getLocalMap(Constants.SHARED_DATA).put(Constants.IS_SOCIETY_LOADED, false);

        boolean dev_env = config().getBoolean("DEV_ENV");
        boolean CROSS_DOMAIN = config().getBoolean("CROSS_DOMAIN");
        String IP_CROSS_DOMAIN = config().getString("IP_CROSS_DOMAIN");

        if(CROSS_DOMAIN) {
            CorsHandler corsHandler = CorsHandler.create(IP_CROSS_DOMAIN);

            corsHandler.allowedMethod(HttpMethod.OPTIONS);
            corsHandler.allowedMethod(HttpMethod.GET);
            corsHandler.allowedMethod(HttpMethod.PUT);
            corsHandler.allowedMethod(HttpMethod.POST);
            corsHandler.allowedMethod(HttpMethod.DELETE);
            corsHandler.allowedMethod(HttpMethod.OTHER);
            corsHandler.allowedMethod(HttpMethod.CONNECT);
            corsHandler.allowedMethod(HttpMethod.HEAD);
            corsHandler.allowedMethod(HttpMethod.TRACE);

            corsHandler.allowedHeader("Authorization");
            corsHandler.allowedHeader("www-authenticate");
            corsHandler.allowedHeader("Content-Type");
            corsHandler.allowedHeader("Access-Control-Request-Method");
            corsHandler.allowedHeader("Access-Control-Allow-Credentials");
            corsHandler.allowedHeader("Access-Control-Allow-Origin");
            corsHandler.allowedHeader("Access-Control-Allow-Headers");
            corsHandler.allowedHeader("cache-control");
            corsHandler.allowedHeader("x-requested-with");

            r.route().handler(corsHandler);
        }

        if(dev_env){
            /*************** AUTO AUTHENTIFICATION ***************/
            DB db = new DB(vertx, config().getJsonObject("ORACLE"));
            db.connect(resCon-> {
                if(resCon.succeeded()){
                    Logger.info("connected to oracle success!!");
                }else {
                    Logger.info("not connected to oracle!!", resCon.cause());
                }
            });

            String uuid = Session.createSession(db);
            r.route().handler(routingContext->{
                routingContext.session().put("DB", uuid);
                routingContext.next();
            });
        }else{
            /*************** AUTHENTIFICATION ***************/
            r.get("/").handler(routingContext -> {
                routingContext.response().putHeader("location", "/index.html").setStatusCode(302).end();
            });

            r.get("/favicon.ico").handler(routingContext->{
                routingContext.response().putHeader("location", "/img/favicon.ico").setStatusCode(302).end();
            });
            // Simple auth Gateway.vert.service which uses a JDBC data source
            AuthProvider authProvider = ORSYSAuth.create(vertx, config().getJsonObject("ORACLE"));
            // We need a user session handler too to make sure the user is stored in the session between requests
            r.route().handler(UserSessionHandler.create(authProvider));
            // Handles the actual login
            orsys.common.auth.formLogin.FormLoginHandler formHandeler = orsys.common.auth.formLogin.FormLoginHandler.create(vertx, config().getJsonObject("ORACLE"), authProvider);
            formHandeler.setDirectLoggedInOKURL("/index.html");
            formHandeler.setDirectLoggedInKOURL("/assets/login.html#error");
            r.get("/assets/login.html").handler(routingContext -> {
                if(routingContext.user()!=null){
                    routingContext.response().putHeader("location", "/index.html").setStatusCode(302).end();
                }else{
                    routingContext.next();
                }
            });
            r.post("/login").handler(formHandeler);
            r.get("/login").handler(routingContext -> {
                routingContext.response().putHeader("location", Constants.URL_LOGIN).setStatusCode(302).end();
            });
            // Implement logout
            r.get("/logout").handler(routingContext -> {
                Session.destroySession(routingContext);
            });

            // Any requests to URI starting '/api/' require login
            r.route("/api/*").handler(RedirectAuthHandler.create(authProvider, "/assets/login.html"));
            r.route("/index.html").handler(RedirectAuthHandler.create(authProvider, "/assets/login.html"));
            /*************** END AUTHENTIFICATION ***************/
        }

        String initPath = "/api/";

        r.post(initPath+"societe/info").handler(CommonHttpCall::getSocietyInfo);
        r.get(initPath+"societe/info").handler(CommonHttpCall::getSocietyInfo);

        r.get(initPath+"config/info").handler(Config::getConfig);
        r.post(initPath+"config/info").handler(Config::getConfig);

        r.get(initPath+"connected/user").handler(ctx->{
            JsonObject user;

            if(dev_env){
                user = new JsonObject().put("NOM_UTIL", "ORASSADM").put("ORASSADM", "Admin Orass");
            }else{
                user = new JsonObject(ctx.user().principal().encode());
            }
            user.remove("menus");
            user.remove("PASSWORD");
            user.remove("SALTPASS");

            ClientCallBack.sendJsonResponce(ctx, user);
        });




        /* *************************************************************************************** */
        orsys.Server.addRoutes(r);
        /* *************************************************************************************** */

        StaticHandler staticHandler = StaticHandler.create();
        staticHandler.setDefaultContentEncoding("UTF-8");
        staticHandler.setIndexPage("index.html");
        staticHandler.setMaxAgeSeconds(86400); // 86 400 s ==> 24h
        staticHandler.setCachingEnabled(true);

        r.route().handler(staticHandler);

        HttpServerOptions opts = new HttpServerOptions();
        opts.setCompressionSupported(true);
        opts.setCompressionLevel(9);

        if(HTTPS.getBoolean("STATUS") && "PEM".equalsIgnoreCase(HTTPS.getString("TYPE"))){
            opts.setSsl(true)
                    .removeEnabledSecureTransportProtocol("TLSv1")
                    .removeEnabledSecureTransportProtocol("TLSv1.1")
                    .addEnabledSecureTransportProtocol(HTTPS.getString("TLS_VERSION"))
                    .setPemTrustOptions(new PemTrustOptions().addCertPath(HTTPS.getString("CHAIN")))
                    .setPemKeyCertOptions(
                            new PemKeyCertOptions().addKeyPath(HTTPS.getString("KEY"))
                                    .addCertPath(HTTPS.getString("CERT"))
                    )
            ;
        }

        if(HTTPS.getBoolean("STATUS") && "JKS".equalsIgnoreCase(HTTPS.getString("TYPE"))){
            opts.setSsl(true)
                    .removeEnabledSecureTransportProtocol("TLSv1")
                    .removeEnabledSecureTransportProtocol("TLSv1.1")
                    .addEnabledSecureTransportProtocol(HTTPS.getString("TLS_VERSION"))
                    .setKeyStoreOptions(new JksOptions().setPath(HTTPS.getString("FILE_JKS")).setPassword(HTTPS.getString("PWD")))
            ;
        }

/*
        r.route().handler(ctx->{
            ClientCallBack.sendErrorResponce(ctx, "API NOT FOUND !");
        });
*/


        vertx.createHttpServer(opts).requestHandler(r::accept).listen(config().getInteger("SERVER_PORT"));

        Logger.info("Serveur deployed in the port ["+config().getInteger("SERVER_PORT")+"]");

        future.complete();

    }

}

