package com.hand.web;

import com.hand.dto.Msg;
import com.hand.service.AddressService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.validation.Valid;

/**
 * Created by 铭刻 on 2017/8/27.
 */
@Controller
public class AddressController {

    @Autowired
    private AddressService service;

    @RequestMapping(value = "/address",method = RequestMethod.GET)
    @ResponseBody
    public Msg getAddressList(){
        return Msg.success().add("addressList",service.getAddressList());
    }
}
