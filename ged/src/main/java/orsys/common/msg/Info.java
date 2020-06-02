package orsys.common.msg;

/**
 *
 * Created by ORSYS on 05/02/2017 08:03
 */
public enum Info {

    MSG_SUCCESS("ORASS", "Operation successfully completed"),
    MSG_OK("ORASS:1", "OK")
    ;
    private final String code;
    private final String description;

    private Info(String code, String description) {
        this.code = code;
        this.description = description;
    }

    private Info(int code, String description) {
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
