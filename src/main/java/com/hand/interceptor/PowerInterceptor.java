package com.hand.interceptor;

import com.hand.pojo.Customer;
import org.springframework.web.servlet.HandlerInterceptor;
import org.springframework.web.servlet.ModelAndView;

import javax.servlet.ServletOutputStream;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

/**
 * Created by 铭刻 on 2017/8/28.
 */
class PowerInterceptor implements HandlerInterceptor {
    @Override
    public boolean preHandle(HttpServletRequest httpServletRequest, HttpServletResponse httpServletResponse, Object o) throws Exception {
        Customer customer = (Customer) httpServletRequest.getSession().getAttribute("customerLogin");
        if (customer==null){

            if (httpServletRequest.getHeader("x-requested-with") != null && httpServletRequest.getHeader("x-requested-with").equalsIgnoreCase("XMLHttpRequest")){

                System.out.print("发生ajax请求...");
                ServletOutputStream out = httpServletResponse.getOutputStream();
                out.print("unlogin");//返回给前端页面的未登陆标识
                out.flush();
                out.close();
                return false;
            }else{
                String url = httpServletRequest.getRequestURI();
                System.out.println("***********************"+url);
                System.out.println("————————————————————用户为空");
                httpServletRequest.setAttribute("msg","请登录！");
                httpServletResponse.sendRedirect("/index.jsp");
                httpServletRequest.getRequestDispatcher("/index.jsp").forward(httpServletRequest,httpServletResponse);
                return false;
            }




        }else {
            System.out.println("————————————————————用户存在");
            return true;
        }
    }

    @Override
    public void postHandle(HttpServletRequest httpServletRequest, HttpServletResponse httpServletResponse, Object o, ModelAndView modelAndView) throws Exception {

    }

    @Override
    public void afterCompletion(HttpServletRequest httpServletRequest, HttpServletResponse httpServletResponse, Object o, Exception e) throws Exception {

    }
}