package orsys.common;

import java.text.ParseException;
import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.util.Calendar;
import java.util.Date;

/**
 *
 * Created by ORSYS on 13/05/2016 15:39.
 */
public class DateTools {

    public static Integer getDay(Date d){
        Calendar cal = Calendar.getInstance();
        cal.setTime((d!=null)?d:new Date());
        return cal.get(Calendar.DAY_OF_MONTH);
    }

    public static Integer getMonth(Date d){
        Calendar cal = Calendar.getInstance();
        cal.setTime((d!=null)?d:new Date());
        return cal.get(Calendar.MONTH)+1;
    }

    public static Integer getYear(Date d){
        Calendar cal = Calendar.getInstance();
        cal.setTime((d!=null)?d:new Date());
        return cal.get(Calendar.YEAR);
    }

    public static Integer getHour(Date d){
        Calendar cal = Calendar.getInstance();
        cal.setTime((d!=null)?d:new Date());
        return cal.get(Calendar.HOUR_OF_DAY);
    }

    public static Integer getMinute(Date d){
        Calendar cal = Calendar.getInstance();
        cal.setTime((d!=null)?d:new Date());
        return cal.get(Calendar.MINUTE);
    }

    public static String formatDate(Date d, String fmt){
        if(fmt == null){
            fmt = "yyyy-MM-dd HH:mm:ss";
        }

        java.text.SimpleDateFormat sdf = new java.text.SimpleDateFormat(fmt);
        return sdf.format(d);
    }

    public static Date addDays(Date date, int days) {
        Calendar cal = Calendar.getInstance();
        cal.setTime(date);
        cal.add(Calendar.DATE, days); //minus number would decrement the days
        return cal.getTime();
    }

    public static String formatDate(String str, String fmt) throws ParseException {
        if(fmt == null){
            fmt = "yyyy-MM-dd HH:mm:ss";
        }
        java.text.SimpleDateFormat sdf = new java.text.SimpleDateFormat(fmt);
        return sdf.format(sdf.parse(str));
    }

    public static Date dateFromStr(String str, String fmt) throws ParseException {
        if(fmt == null){
            fmt = "yyyy-MM-dd HH:mm:ss";
        }
        java.text.SimpleDateFormat sdf = new java.text.SimpleDateFormat(fmt);
        return sdf.parse(str);
    }

    public static String formatDate8(String str, String fmt, String toFrmt) throws Exception {
        return LocalDate.parse(str,  DateTimeFormatter.ofPattern(fmt)).format( DateTimeFormatter.ofPattern(toFrmt));
    }

    public static String formatDate(Date d){
       return formatDate(d, null);
    }
}
