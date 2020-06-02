package orsys.common;

import org.apache.log4j.LogManager;

public class Logger {

    private static org.apache.log4j.Logger logger = LogManager.getLogger(Logger.class);

    public static org.apache.log4j.Logger getLogger(){
        return  logger;
    }

    public static void error(final Object message) {
        logger.error(formatMessage(message, Thread.currentThread().getStackTrace()));
    }

    public static void error(final Object message, final Throwable t) {
        logger.error(formatMessage(message, Thread.currentThread().getStackTrace()), t);
    }

    public static void warn(final Object message) {
        logger.warn(formatMessage(message, Thread.currentThread().getStackTrace()));
    }

    public static void warn(final Object message, final Throwable t) {
        logger.warn(formatMessage(message, Thread.currentThread().getStackTrace()), t);
    }

    public static void fatal(final Object message) {
        logger.fatal(formatMessage(message, Thread.currentThread().getStackTrace()));
    }

    public static void fatal(final Object message, final Throwable t) {
        logger.fatal(formatMessage(message, Thread.currentThread().getStackTrace()), t);
    }

    public static void info(final Object message) {
        logger.info(formatMessage(message, Thread.currentThread().getStackTrace()));
    }

    public static void info(final Object message, final Throwable t) {
        logger.info(formatMessage(message, Thread.currentThread().getStackTrace()), t);
    }

    public static void trace(final Object message) {
        logger.trace(formatMessage(message, Thread.currentThread().getStackTrace()));
    }

    public static void trace(final Object message, final Throwable t) {
        logger.trace(formatMessage(message, Thread.currentThread().getStackTrace()), t);
    }

    public static void debug(final Object message) {
        logger.debug(formatMessage(message, Thread.currentThread().getStackTrace()));
    }

    public static void debug(final Object message, final Throwable t) {
        logger.debug(formatMessage(message, Thread.currentThread().getStackTrace()), t);
    }

    private static String formatMessage(final Object message, StackTraceElement[] trace){
        return "--- "+trace[2].getClassName()+"["+trace[2].getLineNumber()+"] "+message;
    }

}
