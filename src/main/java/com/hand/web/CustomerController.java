package com.hand.web;

import com.github.pagehelper.PageInfo;
import com.hand.dto.Msg;
import com.hand.pojo.Customer;
import com.hand.service.CustomerService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.validation.FieldError;
import org.springframework.web.bind.annotation.*;

import javax.validation.Valid;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

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

    @RequestMapping(value = "/customer",method = RequestMethod.POST)
    @ResponseBody
    public Msg addCustomer(Customer customer){
        int result = service.addCustomer(customer);
        if (result!=0){
            return Msg.success();
        }else {
            return Msg.fail();
        }
    }

    @RequestMapping(value = "/customer/{customerId}",method = RequestMethod.GET)
    @ResponseBody
    public Msg getCustomerById(@PathVariable short customerId){
        return Msg.success().add("customer",service.getCustomerById(customerId));
    }

    @RequestMapping(value = "/customer/{customerId}",method = RequestMethod.PUT)
    @ResponseBody
    public Msg editCustomerById(@PathVariable short customerId, @Valid Customer customer, BindingResult errResult){
        //验证字段是否符合规则
        if(errResult.hasErrors()){
            List<FieldError> list = errResult.getFieldErrors();
            Map map = new HashMap<String,Object>();
            for (FieldError error:list) {
                map.put(error.getField(),error.getDefaultMessage());
            }
            return Msg.fail().add("errors",map);
        }else{
            customer.setCustomerId(customerId);
            int result = service.editCustomerById(customer);
            if (result!=0) {
                return Msg.success();
            }else{
                return Msg.fail().add("error",1);
            }
        }

    }
}
