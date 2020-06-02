package orsys.common.auth.formLogin;

import io.vertx.core.MultiMap;
import io.vertx.core.Vertx;
import io.vertx.core.http.HttpMethod;
import io.vertx.core.http.HttpServerRequest;
import io.vertx.core.http.HttpServerResponse;
import io.vertx.core.json.JsonArray;
import io.vertx.core.json.JsonObject;
import io.vertx.ext.auth.AuthProvider;
import io.vertx.ext.web.RoutingContext;
import io.vertx.ext.web.Session;
import orsys.common.ClientCallBack;
import orsys.common.Logger;
import orsys.common.auth.ORSYSUser;
import orsys.common.database.DB;

/**
 * project : smsAPI
 * Created by ORSYS on 20/05/2016 19:02.
 */
public class FormLoginHandlerImpl implements FormLoginHandler {

//    private Logger logger = LogManager.getLogger(FormLoginHandlerImpl.class);

    private final AuthProvider authProvider;

    private String usernameParam;
    private String passwordParam;
    private String returnURLParam;
    private String directLoggedInOKURL;
    private String directLoggedInKOURL;

    private Vertx vtx;
    private JsonObject dbConfig;
    private String userInfoQuery = "SELECT NOM_UTIL, NOEFPOTR FROM ORASSADM.POSTE_TRAVAIL WHERE NOM_UTIL = upper(?)";
    private String SET_DBMS_APPLICATION_INFO  = "begin DBMS_APPLICATION_INFO.SET_CLIENT_INFO('test'); end;";
    private String rolePrefix = "role:";

    @Override
    public FormLoginHandler setUsernameParam(String usernameParam) {
        this.usernameParam = usernameParam;
        return this;
    }

    @Override
    public FormLoginHandler setPasswordParam(String passwordParam) {
        this.passwordParam = passwordParam;
        return this;
    }

    @Override
    public FormLoginHandler setReturnURLParam(String returnURLParam) {
        this.returnURLParam = returnURLParam;
        return this;
    }

    @Override
    public FormLoginHandler setDirectLoggedInOKURL(String directLoggedInOKURL) {
        this.directLoggedInOKURL = directLoggedInOKURL;
        return this;
    }

    @Override
    public FormLoginHandler setDirectLoggedInKOURL(String directLoggedInKOURL) {
        this.directLoggedInKOURL = directLoggedInKOURL;
        return this;
    }

    public FormLoginHandlerImpl(Vertx vtx, JsonObject dbConfig, AuthProvider authProvider, String usernameParam, String passwordParam,
                                String returnURLParam, String directLoggedInOKURL) {
        this.authProvider = authProvider;
        this.usernameParam = usernameParam;
        this.passwordParam = passwordParam;
        this.returnURLParam = returnURLParam;
        this.directLoggedInOKURL = directLoggedInOKURL;
        this.directLoggedInKOURL = directLoggedInOKURL;

        this.vtx = vtx;
        this.dbConfig = dbConfig;
    }

    @Override
    public void handle(RoutingContext context) {
//        ClientCallBack.RequireLogin(context);
        HttpServerRequest req = context.request();
        if (req.method() != HttpMethod.POST) {
            context.fail(405); // Must be a POST
        } else {
            if (!req.isExpectMultipart()) {
                throw new IllegalStateException("Form body not parsed - do you forget to include a BodyHandler?");
            }
            MultiMap params = req.formAttributes();
            String username = params.get(usernameParam);
            String password = params.get(passwordParam);
            if (username == null || password == null) {
                Logger.debug("No username or password provided in form - did you forget to include a BodyHandler?");
                context.fail(400);
            } else {
                Session session = context.session();
                JsonObject authInfo = new JsonObject().put("username", username).put("password", password);
                DB db = new DB(this.vtx, this.dbConfig.copy());
                db.setUsername(username);
                db.setPassword(password);
                db.connect(resCon-> {
                    if (resCon.succeeded()) {
//                        db.queryWithParams(SET_DBMS_APPLICATION_INFO, new JsonArray(), reee->{});
                        db.queryWithParams(userInfoQuery, new JsonArray().add(username), resInfoUser->{
                            if(resInfoUser.succeeded()){
                                if(resInfoUser.result().getInteger("numRows") == 1){

                                    // init user information
                                    JsonObject user = resInfoUser.result().getJsonArray("rows").getJsonObject(0);
                                    ORSYSUser u = new ORSYSUser(username, user, this.rolePrefix);
                                    context.setUser(u);

                                    if (session != null) {
//                                        session.put("DB", db);

                                        String uuid = orsys.common.Session.createSession(db);

                                        session.put("DB", uuid);

                                        String returnURL = session.remove(returnURLParam);
                                        if (returnURL != null) {
                                            // Now redirect back to the original url
//                                            doRedirect(context, returnURL, db);
                                            ClientCallBack.doRedirect(context, returnURL);
                                            return;
                                        }
                                    }

                                    // Either no session or no return url
                                    if (directLoggedInOKURL != null) {
                                        // Redirect to the default logged in OK page - this would occur
                                        // if the user logged in directly at this URL without being redirected here first from another
                                        // url
//                                        doRedirect(context, directLoggedInOKURL, db);
                                        ClientCallBack.doRedirect(context, directLoggedInOKURL);
                                    } else {
                                        // Just show a basic page
                                        req.response().end(DEFAULT_DIRECT_LOGGED_IN_OK_PAGE);
                                    }

                                }else{
                                    db.closeConnexion(cls->{});
                                    doRedirect(req.response(), this.directLoggedInKOURL, "Invalid username/password");
                                    return;
                                }
                            }else{
                                db.closeConnexion(cls->{});
                                doRedirect(req.response(), this.directLoggedInKOURL, "Invalid username/password");
                                return;
                            }
                        });
                    }else{
                        ClientCallBack.doRedirect(context, this.directLoggedInKOURL);
                        return;
                    }
                });
//                authProvider.authenticate(authInfo, res -> {
//                    if (res.succeeded()) {
//                        User user = res.result();
//                        context.setUser(user);
//                        if (session != null) {
//                            String returnURL = session.remove(returnURLParam);
//                            if (returnURL != null) {
//                                // Now redirect back to the original url
//                                doRedirect(req.response(), returnURL);
//                                return;
//                            }
//                        }
//                        // Either no session or no return url
//                        if (directLoggedInOKURL != null) {
//                            // Redirect to the default logged in OK page - this would occur
//                            // if the user logged in directly at this URL without being redirected here first from another
//                            // url
//                            doRedirect(req.response(), directLoggedInOKURL);
//                        } else {
//                            // Just show a basic page
//                            req.response().end(DEFAULT_DIRECT_LOGGED_IN_OK_PAGE);
//                        }
//                    } else {
//                        doRedirect(req.response(), this.directLoggedInKOURL, res.cause().getMessage());
//                        return;
//                    }
//                });
            }
        }
    }

//    private void doRedirect(RoutingContext context, String url, DB db) {
//        DB dbdd = context.session().get("DB");
//        context.session().remove("DB"); // remove the instance of DB before send response
//        context.response().putHeader("location", url).setStatusCode(302).end();
////        context.session().put("DB", dbdd);
//    }

    private void JsonResponce(HttpServerResponse response, JsonObject data) {
        response.putHeader("content-type", "application/json");
        response.end(data.toString());
    }

    private void doRedirect(HttpServerResponse response, String url, String data) {
        response.putHeader("location", url).setStatusCode(302).end(data);
    }

    private static final String DEFAULT_DIRECT_LOGGED_IN_OK_PAGE = "" +
            "<html><body><h1>Login successful</h1></body></html>";
}
