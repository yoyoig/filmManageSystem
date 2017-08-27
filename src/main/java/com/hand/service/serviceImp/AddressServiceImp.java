package com.hand.service.serviceImp;

import com.hand.dao.AddressMapper;
import com.hand.pojo.Address;
import com.hand.pojo.AddressExample;
import com.hand.service.AddressService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

/**
 * Created by 铭刻 on 2017/8/27.
 */
@Service
public class AddressServiceImp implements AddressService {

    @Autowired
    private AddressMapper mapper;


    @Override
    public List<Address> getAddressList() {
        return mapper.selectByExample(null);
    }
}
