package com.hand.service.serviceImp;

import com.github.pagehelper.PageHelper;
import com.github.pagehelper.PageInfo;
import com.hand.dao.CustomerMapper;
import com.hand.pojo.Customer;
import com.hand.pojo.CustomerExample;
import com.hand.service.CustomerService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

/**
 * Created by 铭刻 on 2017/8/26.
 */
@Service
public class CustomerServiceImp implements CustomerService {

    @Autowired
    private CustomerMapper mapper;

    @Override
    public Customer CustomerLogin(String firstName) {
        //通过first name查询Customer
        CustomerExample example = new CustomerExample();
        example.createCriteria().andFirstNameEqualTo(firstName);
        List<Customer> list =  mapper.selectByExample(example);
//        当list长度为0时返回null，否者返回该customer
        if (list.size()!=0){

            return list.get(0);
        }else {
            return null;
        }
    }

    @Override
    public PageInfo<Customer> getCustomerByPage(int pageName) {
//        分页查询customer
        PageHelper.startPage(pageName,10);
        List<Customer> list = mapper.selectByExampleWithAddress(null);
        PageInfo<Customer> pageInfo = new PageInfo<Customer>(list,5);
        //当pageName大于总页数时，默认到最后一页
        if(pageName>pageInfo.getPages()){
            pageName=pageInfo.getPages();
            PageHelper.startPage(pageName,10);
            List<Customer> list2 = mapper.selectByExampleWithAddress(null);
            PageInfo<Customer> pageInfo2 = new PageInfo<Customer>(list2,5);
            return pageInfo2;
        }else {
            return pageInfo;
        }
    }

    @Override
    public int addCustomer(Customer customer) {
        return mapper.insertSelective(customer);
    }

    @Override
    public Customer getCustomerById(short id) {
        return mapper.selectByPrimaryKey(id);
    }

    @Override
    public int editCustomerById(Customer customer) {
        return mapper.updateByPrimaryKeySelective(customer);
    }


}
