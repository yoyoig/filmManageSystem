package com.hand.filter;

import com.hand.pojo.Customer;

import javax.servlet.*;
import javax.servlet.annotation.WebFilter;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

/**
 * Created by 铭刻 on 2017/8/29.
 */
@WebFilter(filterName = "PowerFilter")
public class PowerFilter implements Filter {
    public void destroy() {
    }

    public void doFilter(ServletRequest req, ServletResponse resp, FilterChain chain) throws ServletException, IOException {
        HttpServletRequest request = (HttpServletRequest)req;
        HttpServletResponse response = (HttpServletResponse)resp;
        System.out.println(request==null);
        String url = request.getRequestURI();

        //对静态资源进行放行
        Customer customer = (Customer) request.getSession().getAttribute("customerLogin");
        if(     url.contains("/index.jsp") || url.contains("/customerLogin") ||
                url.contains("/js/") ||url.contains("/css/") ||
                url.contains("/fonts/") || url.contains("/img/")){

                chain.doFilter(req, resp);
                return;

        }

        if(customer==null){
            System.out.println(url+"-----------");
            request.setAttribute("msg","请登录！");
            request.getRequestDispatcher("/index.jsp").forward(request,response);
        }else{
            chain.doFilter(req, resp);
        }



    }

    public void init(FilterConfig config) throws ServletException {

    }

}
