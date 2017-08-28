package com.hand.web;

import com.hand.dto.Msg;
import com.hand.pojo.Film;
import com.hand.service.FilmService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.validation.BindingResult;
import org.springframework.validation.FieldError;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.validation.Valid;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Objects;

/**
 * Created by 铭刻 on 2017/8/26.
 */
@Controller
public class FilmController {

    @Autowired
    private FilmService service;

    /**
     * 根据分页信息查询film
     * @param pageName
     * @return
     */
    @RequestMapping(value = "/film",method = RequestMethod.GET)
    @ResponseBody
    public Msg getFilmByPage(int pageName){

        return Msg.success().add("pageInfo",service.getFilmByPage(pageName));

    }


    /**
     * 根据title查询film，判断film是否已存在
     * @param title
     * @return
     */
    @RequestMapping(value = "/filmExist/{title}",method = RequestMethod.GET)
    @ResponseBody
    public Msg getFilmByTitle(@PathVariable String title){
        if(service.getFilmBytitle(title)){
            return Msg.success();
        }else{
            return Msg.fail();
        }
    }

    /**
     * 根据id查询Film并返回film
     * @param filmId
     * @return
     */
    @RequestMapping(value = "/film/{filmId}",method = RequestMethod.GET)
    @ResponseBody
    public Msg getFilmById(@PathVariable short filmId){

        return Msg.success().add("film",service.getFilmById(filmId));
    }


    /**
     * 添加film，并对字段进行校验
     * @param film
     * @param result
     * @return
     */
    @RequestMapping(value = "/film",method = RequestMethod.POST)
    @ResponseBody
    public Msg addFilm(@Valid Film film, BindingResult result){

        if(result.hasErrors()){
            List<FieldError> errors = result.getFieldErrors();
            Map map = new HashMap<String, Objects>();
            for (FieldError error:errors) {
                map.put(error.getField(),error.getDefaultMessage());
            }
            return Msg.fail().add("errors",map);

        }else{
            service.addFilm(film);
            return Msg.success();
        }

    }

    /**
     * 根据id修改该film，并验证字段
     * @param filmId
     * @param film
     * @param result
     * @return
     */
    @RequestMapping(value = "/film/{filmId}",method = RequestMethod.PUT)
    @ResponseBody
    public Msg editFilmById(@PathVariable short filmId, @Valid Film film, BindingResult result){

        if(result.hasErrors()){
            List<FieldError> errors = result.getFieldErrors();
            Map map = new HashMap<String, Objects>();
            for (FieldError error:errors) {
                map.put(error.getField(),error.getDefaultMessage());
            }
            return Msg.fail().add("errors",map);

        }else{
            film.setFilmId(filmId);
            service.editFilmById(film);
            return Msg.success();
        }

    }

    /**
     * 根据id删除film，批量删除和单个删除二合一，逻辑在service中
     * @param filmIds
     * @return
     */
    @RequestMapping(value = "/film/{filmIds}",method = RequestMethod.DELETE)
    @ResponseBody
    public Msg deleteFilmById(@PathVariable String filmIds){
        if(filmIds==null || filmIds.equals("")){
            return Msg.fail();
        }else {
            return service.deleteFilmById(filmIds);
        }
    }
}
