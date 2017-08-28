package com.hand.service.serviceImp;

import com.hand.dao.LanguageMapper;
import com.hand.pojo.Language;
import com.hand.service.LanguageService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

/**
 * Created by 铭刻 on 2017/8/28.
 */
@Service
public class LanguageServiceImp implements LanguageService {

    @Autowired
    private LanguageMapper mapper;


    @Override
    public List<Language> getAllLanguage() {
        return mapper.selectByExample(null);
    }
}
