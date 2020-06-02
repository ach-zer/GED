package orsys.common.msg;

/**
 *
 * Created by ORSYS on 21/06/2016 15:03.
 */

public enum Error {

    ERROR_OCCURED("ORASS-ERR", " An error occurred please try again later"),
    INVALID_PARAMS("ORASS-ERR:1", "Paramètres invalides"),
    NULL_OR_EMPTY("ORASS-ERR:2", " %s is null/empty"),
    DOESNT_EXIST("ORASS-ERR:3" ,"[ %s ] does not exist"),
    ALREADY_EXISTS("ORASS-ERR:4" ,"[ %s ] already exists"),
    DUPLICATE_USER("ORASS-ERR:5", "This user already exists."),
    MUST_SPECIFY("ORASS-ERR:6", "Please specify %s "),
    NULL_OR_EMPTY_DATA("ORASS-ERR:7", "Data is null/empty"),
    INVALID_DATA("ORASS-ERR:8", "Data is not valid"),
    REPORTING_FAIL("ORASS-ERR:9", "Fail to generate a pdf file, show logs for more info."),

    ER_DB_CONX("ORASS-ERR:1000","Erreur d'E/S: The Network Adapter could not establish the connection"),
    UPDATE_WITH_PARAMS_FAIL("ORASS-ERR:1001","UPDATE_WITH_PARAMS_FAIL"),
    QUERY_WITH_PARAMS_FAIL("ORASS-ERR:1002" ,"QUERY_WITH_PARAMS_FAIL"),
    BD_CLIENT_NOT_FOUND("ORASS-ERR:1003" ,"You have to connect to database before doing a query !"),
    CURSOR_FAIL("ORASS-ERR:1004" ,"CURSOR_FAIL"),
    CALL_WITH_PARAMS_FAIL("ORASS-ERR:1005" ,"CALL_WITH_PARAMS_FAIL"),
    CONNECT_TO_DATA_BASE_FAIL("ORASS-ERR:1006" ,"CONNECT_TO_DATA_BASE_FAIL"),
    SQLException("ORASS-ERR:1007" ,"SQL Exception occurred"),
    NULL_OR_EMPTY_SQL("ORASS-ERR:1008" ,"SQL is null/empty"),

    VALIDATION_POLICE_FAIL("ORASS-ERR:2001", "VALIDATION_POLICE_FAIL"),
    DUPLICATE_POLICE_FAIL("ORASS-ERR:1002", "DUPLICATE_POLICE_FAIL"),
    ;

    private final String code;
    private final String description;

    private Error(String code, String description) {
        this.code = code;
        this.description = description;
    }

    private Error(int code, String description) {
        this.code = code+"";
        this.description = description;
    }

    public String getDescription() {
        return description;
    }

    public String getCode() {
        return code;
    }

    public String with(String... args){
        return String.format(this.toString(), args);
    }

    @Override
    public String toString() {
        return code + ": " + description;
    }
}
