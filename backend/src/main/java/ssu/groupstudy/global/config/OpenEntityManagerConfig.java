package ssu.groupstudy.global.config;

import org.springframework.boot.web.servlet.FilterRegistrationBean;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.orm.jpa.support.OpenEntityManagerInViewFilter;

@Configuration
public class OpenEntityManagerConfig { // [2024-06-13:최규현] TODO: param 변경 후 삭제 고려
    @Bean
    public FilterRegistrationBean<OpenEntityManagerInViewFilter> openEntityManagerInViewFilter() {
        FilterRegistrationBean<OpenEntityManagerInViewFilter> bean = new FilterRegistrationBean<>();
        bean.setFilter(new OpenEntityManagerInViewFilter());
        bean.setOrder(Integer.MIN_VALUE);
        return bean;
    }
}
