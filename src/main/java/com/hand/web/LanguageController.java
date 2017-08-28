package com.hand.web;

import com.hand.dto.Msg;
import com.hand.service.LanguageService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

/**
 * Created by 铭刻 on 2017/8/28.
 */
@Controller
public class LanguageController {

    @Autowired
    private LanguageService service;

    @RequestMapping(value = "/language",method = RequestMethod.GET)
    @ResponseBody
    public Msg getAllLanguage(){

        return Msg.success().add("languageList",service.getAllLanguage());
    }

}
