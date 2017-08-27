package com.hand.service;

import com.github.pagehelper.PageInfo;
import com.hand.pojo.Customer;

/**
 * Created by 铭刻 on 2017/8/26.
 */
public interface CustomerService {

    Customer CustomerLogin(String firstName);

    PageInfo<Customer> getCustomerByPage(int pageName);

    int addCustomer(Customer customer);

    Customer getCustomerById(short id);

    int editCustomerById(Customer customer);
}
