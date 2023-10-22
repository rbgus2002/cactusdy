package ssu.groupstudy.global.config;

import com.google.gson.Gson;
import lombok.extern.slf4j.Slf4j;
import org.apache.commons.lang3.StringUtils;
import org.aspectj.lang.ProceedingJoinPoint;
import org.aspectj.lang.annotation.Around;
import org.aspectj.lang.annotation.Aspect;
import org.aspectj.lang.reflect.MethodSignature;
import org.springframework.stereotype.Component;
import org.springframework.util.StopWatch;

import java.text.MessageFormat;
import java.util.ArrayList;
import java.util.List;

@Aspect
@Component
@Slf4j
public class LoggingConfig {
    private static final Gson GSON = new Gson();
    private static final String STR_CLASS_METHOD = "{0}.{1}({2})";
    private static final String STR_END_EXECUTE_TIME = "[{}] [{}] // Return({}) : {} // FINISH : {} ms";
    private static final String STR_END = "[{}] [{}] // Return({}) : {}";

    @Around("execution(* ssu.groupstudy..*Service.*(..)) && !execution(* ssu.groupstudy..CustomUserDetailService.*(..))")
    public Object loggingInService(final ProceedingJoinPoint pjp) throws Throwable {
        Object retVal = null;
        final String formatClassMethod = MessageFormat.format(STR_CLASS_METHOD, pjp.getTarget().getClass().getSimpleName(), pjp.getSignature().getName(), this.getArgumentNames(pjp.getArgs()));
        String methodArgs = getMethodArgs(pjp);

        try{
            StopWatch stopWatch = new StopWatch();
            stopWatch.start();
            retVal = pjp.proceed();
            stopWatch.stop();

            log.info(STR_END_EXECUTE_TIME, formatClassMethod, methodArgs, ((MethodSignature)pjp.getSignature()).getReturnType().getSimpleName(), StringUtils.defaultString(GSON.toJson(retVal), "null"), stopWatch.getTotalTimeMillis());
        }catch (Throwable e){
            log.warn(STR_END, formatClassMethod, methodArgs, ((MethodSignature)pjp.getSignature()).getReturnType().getSimpleName(), StringUtils.defaultString(GSON.toJson(retVal), "null"));
            throw e;
        }

        return retVal;
    }

    private String getArgumentNames(final Object[] obj) {
        final List<String> list = new ArrayList<>();
        for (Object o : obj) {
            if (o != null) {
                list.add(o.getClass().getSimpleName());
            }
        }
        return StringUtils.join(list, ",");
    }

    private String getMethodArgs(ProceedingJoinPoint pjp) {
        StringBuilder argsStringBuilder = new StringBuilder();

        for (Object arg : pjp.getArgs()) {
            argsStringBuilder.append(arg).append(", ");
        }
        return argsStringBuilder.length() > 0 ? argsStringBuilder.substring(0, argsStringBuilder.length() - 2) : "";
    }
}
