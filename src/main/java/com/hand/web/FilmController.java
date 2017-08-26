package com.hand.web;

import com.hand.service.FilmService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;

/**
 * Created by 铭刻 on 2017/8/26.
 */
@Controller
public class FilmController {

    @Autowired
    private FilmService service;

}
