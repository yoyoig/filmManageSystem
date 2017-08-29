package com.hand.service.serviceImp;

import com.github.pagehelper.Page;
import com.github.pagehelper.PageHelper;
import com.github.pagehelper.PageInfo;
import com.hand.dao.CustomerMapper;
import com.hand.dto.Msg;
import com.hand.pojo.Customer;
import com.hand.pojo.CustomerExample;
import com.hand.service.CustomerService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Isolation;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

import java.util.ArrayList;
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

    @Override
    @Transactional(propagation = Propagation.SUPPORTS,isolation = Isolation.DEFAULT)
    public Msg deleteCustomerById(String customerIds) {
        if(customerIds.contains("-")){
            //将ids字符串转化为id，进行删除
            List<Short> num = new ArrayList<Short>();
            List<Short> numFail = new ArrayList<Short>();
            String [] ids = customerIds.split("-");
            for (String strId:ids) {


                short id = Short.parseShort(strId);
//                进行删除
                int result = 0;
                try {
                    mapper.deleteCustomerByPreOne(id);
                    mapper.deleteCustomerByPreTwo(id);
                    result = mapper.deleteByPrimaryKey(id);
                } catch (Exception e) {
                    numFail.add(id);
                }

                if (result!=0){
                    num.add(id);
                }
            }

            if(num.size()>0){
                return Msg.success().add("ids",num).add("errs",numFail);
            }else{
                //result中没有id时，全部删除失败
                return Msg.fail();
            }

        }else {
            short customerId = Short.parseShort(customerIds);
            int result = 0;
            try {
                mapper.deleteCustomerByPreOne(customerId);
                mapper.deleteCustomerByPreTwo(customerId);
                result = mapper.deleteByPrimaryKey(customerId);
            } catch (Exception e) {

                return Msg.fail();
            }

            if (result != 0) {
                return Msg.success();
            } else {
                return Msg.fail();
            }
        }
    }

    //多条件分页查询
    @Override
    public PageInfo<Customer> getCustomerByPageWithExample(Customer customer,int pageName){
        CustomerExample example = new CustomerExample();

        String firstName = customer.getFirstName()==null?"":customer.getFirstName();
        String lastName = customer.getLastName()==null?"":customer.getLastName();
        Short addressId =customer.getAddressId();
        String email = customer.getEmail()==null?"":customer.getEmail();

        if(addressId==null || addressId==0){
            example.createCriteria().andFirstNameLike("%"+firstName+"%").andLastNameLike("%"+lastName+"%").andEmailLike("%"+email+"%");
        }else{
            example.createCriteria().andAddressIdEqualTo(addressId).andFirstNameLike("%"+firstName+"%").andLastNameLike("%"+lastName+"%").andEmailLike("%"+email+"%");
        }




        PageHelper.startPage(pageName,10);
        List<Customer> list = mapper.selectByExampleWithAddress(example);
        PageInfo<Customer> pageInfo = new PageInfo<Customer>(list,5);
        //当pageName大于总页数时，默认到最后一页
        if(pageName>pageInfo.getPages()){
            pageName=pageInfo.getPages();
            PageHelper.startPage(pageName,10);
            List<Customer> list2 = mapper.selectByExampleWithAddress(example);
            PageInfo<Customer> pageInfo2 = new PageInfo<Customer>(list2,5);
            return pageInfo2;
        }else {
            return pageInfo;
        }
    }

}
