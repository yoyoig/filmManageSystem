package com.hand.web;

import com.github.pagehelper.PageInfo;
import com.hand.dto.Msg;
import com.hand.pojo.Customer;
import com.hand.service.CustomerService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.annotation.SessionAttributes;

/**
 * Created by 铭刻 on 2017/8/26.
 */
@Controller
@SessionAttributes("customerLogin")
public class CustomerController {

    @Autowired
    private CustomerService service;

    @RequestMapping(value = "/customerLogin",method = RequestMethod.POST)
    @ResponseBody
    public Msg customerLogin(String firstName,Model model){
        //后端空值验证
        if (firstName==null || firstName.equals("")){

            return Msg.fail().add("errorMsg","用户名不能为空");


        }else {

            Customer customer = service.CustomerLogin(firstName);
            if (customer == null) {

                return Msg.fail().add("errorMsg", "用户名有误");

            } else {
                model.addAttribute("customerLogin",customer);
                return Msg.success();

            }
        }

    }

    //分页查询，并返回给前端页面
    @RequestMapping(value = "/customer",method = RequestMethod.GET)
    @ResponseBody
    public Msg customerByPage(int pageName){

        PageInfo<Customer> pageInfo = service.getCustomerByPage(pageName);
        return Msg.success().add("pageInfo",pageInfo);
    }

}
