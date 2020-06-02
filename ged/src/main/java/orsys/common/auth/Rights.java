package orsys.common.auth;

import io.vertx.core.json.JsonArray;
import io.vertx.core.json.JsonObject;
import io.vertx.ext.web.RoutingContext;

/**
 * project : GED
 * Created by ORSYS on 09/06/2017 10:02.
 */
public class Rights {

    private final static String _CON_RIGHTS = "CON";
    private final static String _ADD_RIGHTS = "ADD";
    private final static String _EDIT_RIGHTS = "EDI";
    private final static String _DELETE_RIGHTS = "DEL";
    private final static String _AUTHORIZED = "AUTHORIZED";
    private final static String _ABRIOBJE = "ABRIOBJE";
    private final static String _USER_DROIT = "USER_DROIT";
    private final static String _RIGHTS = "USER_DROIT";
    private final static String _DROIT = "DROIT";

    public static JsonObject getObjectRights(RoutingContext routingContext, String ABRIOBJE, String droit){
        if(ABRIOBJE == null){
            return null;
        }

        JsonObject userInfo = routingContext.user().principal();
        JsonArray userRights = userInfo.getJsonArray(_USER_DROIT);
        JsonArray rights = new JsonArray();

        JsonObject objRights = new JsonObject();
        objRights.put(_AUTHORIZED, false);

        userRights.forEach(right->{
            JsonObject r = (JsonObject) right;
            if(ABRIOBJE.equalsIgnoreCase(r.getString(_ABRIOBJE))){
                rights.add(r);
                if(droit != null){
                    if(droit.equalsIgnoreCase(r.getString(_DROIT)) || "ALL".equalsIgnoreCase(r.getString(_DROIT))){
                        objRights.put(_AUTHORIZED, true);
                    }
                }
            }
        });

        objRights.put(_RIGHTS, rights);

        return objRights;
    }

    public static boolean isAuthorized(JsonObject rights){
        return  (rights != null && rights.getBoolean("AUTHORIZED") != null && rights.getBoolean("AUTHORIZED"));
    }

    public static JsonArray getRights(RoutingContext routingContext, String ABRIOBJE){
        JsonObject re = getObjectRights(routingContext, ABRIOBJE, null);
        if(re == null){
            return new JsonArray();
        }

        return re.getJsonArray(_RIGHTS);
    }

    public static boolean isAddAllowed(RoutingContext routingContext, String ABRIOBJE){
        return isAuthorized(getObjectRights(routingContext, ABRIOBJE, _ADD_RIGHTS));
    }

    public static boolean isEditAllowed(RoutingContext routingContext, String ABRIOBJE){
        return isAuthorized(getObjectRights(routingContext, ABRIOBJE, _EDIT_RIGHTS));
    }

    public static boolean isDeleteAllowed(RoutingContext routingContext, String ABRIOBJE){
        return isAuthorized(getObjectRights(routingContext, ABRIOBJE, _DELETE_RIGHTS));
    }

    public static boolean isConsultAllowed(RoutingContext routingContext, String ABRIOBJE){
        return isAuthorized(getObjectRights(routingContext, ABRIOBJE, _CON_RIGHTS));
    }

    public static JsonObject allRights(RoutingContext routingContext, String ABRIOBJE){
        JsonObject ret = new JsonObject();

        ret.put("add", isAddAllowed(routingContext, ABRIOBJE));
        ret.put("edit", isEditAllowed(routingContext, ABRIOBJE));
        ret.put("delete", isDeleteAllowed(routingContext, ABRIOBJE));
        ret.put("consult", isConsultAllowed(routingContext, ABRIOBJE));

        return ret;
    }

}
