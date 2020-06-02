package orsys.common.HttpApi;

import io.vertx.core.json.JsonObject;

public class MapQuery {
    private static final JsonObject req = new JsonObject()
            // GETS
            .put("G.CMN.013", "web_pkg_admin.get_users_pwd_expert")
            .put("G.CMN.012", "web_pkg_admin.get_poste_travail")
            .put("G.CMN.011", "web_pkg_admin.get_reports")
            .put("G.CMN.010", "web_pkg_admin.get_user_reports")
            .put("G.CMN.009", "web_pkg_interface.list_user_report")
            .put("G.CMN.008", "web_pkg_admin.get_list_domain")
            .put("G.CMN.007", "web_pkg_admin.get_user_archive_structure")
            .put("G.CMN.006", "web_pkg_admin.get_archive_structure")
            .put("G.CMN.005", "web_pkg_admin.get_user_process")
            .put("G.CMN.004", "web_pkg_admin.get_list_process")
            .put("G.CMN.003", "web_pkg_admin.get_user_menus")
            .put("G.CMN.002", "web_pkg_admin.get_users")
            .put("G.CMN.001", "web_pkg_admin.get_menus")

            // posts
            .put("P.CMN.008", "web_pkg_admin.lock_unlock_user")
            .put("P.CMN.007", "web_pkg_admin.change_password")
            .put("P.CMN.006", "web_pkg_admin.save_user_reports")
            .put("P.CMN.005", "web_pkg_report.exec_plsql_fun")
            .put("P.CMN.004", "web_pkg_admin.merge_poste_travail")
            .put("P.CMN.003", "web_pkg_admin.save_user_class_archive")
            .put("P.CMN.002", "web_pkg_admin.save_user_process")
            .put("P.CMN.001", "web_pkg_admin.save_user_menus")
            ;

    public static String getReqOf(String name){
        if(name != null) return req.getString(name);
        return null;
    }

    public static JsonObject getList(){
        return req;
    }
}
