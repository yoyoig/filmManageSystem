package com.hand.service.serviceImp;

import com.github.pagehelper.PageInfo;
import com.hand.pojo.Customer;
import com.hand.service.AddressService;
import com.hand.service.CustomerService;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;

import static org.junit.Assert.*;

/**
 * Created by 铭刻 on 2017/8/26.
 */
@RunWith(SpringJUnit4ClassRunner.class)
@ContextConfiguration(locations = "classpath:spring/applicationContext.xml")
public class CustomerServiceImpTest {
    @Autowired
    private CustomerService service;

    @Autowired
    private AddressService addressService;
    @Test
    public void getCustomerByPage() throws Exception {
//        PageInfo<Customer> pageInfo = service.getCustomerByPage(1);
//        System.out.println(pageInfo.getList().get(0));

//        Customer customer = service.CustomerLogin("MARY");
//        System.out.println(customer==null);

        System.out.println(addressService.getAddressList());
    }

}