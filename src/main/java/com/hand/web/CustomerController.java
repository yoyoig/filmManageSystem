package com.hand.web;

import com.github.pagehelper.PageInfo;
import com.hand.dto.Msg;
import com.hand.pojo.Customer;
import com.hand.service.CustomerService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.ui.ModelMap;
import org.springframework.validation.BindingResult;
import org.springframework.validation.FieldError;
import org.springframework.web.bind.annotation.*;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;
import javax.validation.Valid;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Objects;

/**
 * Created by 铭刻 on 2017/8/26.
 */
@Controller
@SessionAttributes("customerLogin")
public class CustomerController {

    @Autowired
    private CustomerService service;

    /**
     * 登录映射
     * 传入firstName，通过firstName查找是否有该customer
     * @param firstName
     * @param model  通过model将customerLogin放入到session
     * @return
     */
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
                System.out.println("添加");
                model.addAttribute("customerLogin",customer);
                return Msg.success();

            }
        }

    }


    /**
     * 删除session中customer对象，退出登录
     * 通过@SessionAttributes放对象时，删除时还要删除ModelMap中的对象，不然
     * 该对象会继续放入到session中
     * @param session,model
     * @return
     */
    @RequestMapping(value = "/customerLogout",method = RequestMethod.GET)
    @ResponseBody
    public Msg customerLogout(HttpSession session,ModelMap model){
        session.removeAttribute("customerLogin");
        model.remove("customerLogin");
        return Msg.success();

    }

    /**
     * 判断firstName是否已存在
     * @param firstName
     * @return
     */
    @RequestMapping(value = "/customerExist/{firstName}",method = RequestMethod.GET)
    @ResponseBody
    public Msg customerExist(@PathVariable String firstName){
            Customer customer = service.CustomerLogin(firstName);
            if (customer == null) {
                return Msg.fail();
            } else {
                return Msg.success();
            }


    }

    /**
     * 传入页码，返回当前页面的信息
     * @param pageName
     * @return
     */
//    @RequestMapping(value = "/customer",method = RequestMethod.GET)
//    @ResponseBody
//    public Msg customerByPage(int pageName){
//
//        PageInfo<Customer> pageInfo = service.getCustomerByPage(pageName);
//        return Msg.success().add("pageInfo",pageInfo);
//    }

    /**
     * 传入页码，和查询条件，按条件查询customer
     * @param pageName
     * @return
     */
    @RequestMapping(value = "/customerByExam/{pageName}",method = RequestMethod.GET)
    @ResponseBody
    public Msg customerByPage(@PathVariable int pageName,Customer customer){

        PageInfo<Customer> pageInfo = service.getCustomerByPageWithExample(customer,pageName);

        return Msg.success().add("pageInfo",pageInfo);
    }




    /**
     * 添加customer
     * @param customer
     * @return
     */
    @RequestMapping(value = "/customer",method = RequestMethod.POST)
    @ResponseBody
    public Msg addCustomer(@Valid Customer customer,BindingResult errResult){
//        后端验证
        if(errResult.hasErrors()){
            List<FieldError> list = errResult.getFieldErrors();
            Map map = new HashMap<String,Object>();
            for (FieldError error:list) {

                map.put(error.getField(),error.getDefaultMessage());
            }
            return Msg.fail().add("errors",map);

        }else {

            int result = service.addCustomer(customer);

            if (result != 0) {
                return Msg.success();
            } else {
                return Msg.fail();
            }
        }
    }


    /**
     * 通过id查询customer
     * @param customerId
     * @return
     */
    @RequestMapping(value = "/customer/{customerId}",method = RequestMethod.GET)
    @ResponseBody
    public Msg getCustomerById(@PathVariable short customerId){
        return Msg.success().add("customer",service.getCustomerById(customerId));
    }

    /**
     * 通过Id更新customer
     * @param customerId
     * @param customer
     * @param errResult
     * @return
     */
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


    /**
     * 根据Id进行删除操作，批量删除和单个删除二合一，逻辑写在service中
     * @param customerIds
     * @return
     */
    @RequestMapping("/customer/{customerIds}")
    @ResponseBody
    public Msg deleteCustomerById(@PathVariable String customerIds){
        //多条删除
        if(customerIds==null || customerIds.equals("")){
            return Msg.fail();
        }else {
            return service.deleteCustomerById(customerIds);
        }
    }


}
