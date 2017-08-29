package com.hand.service.serviceImp;

import com.github.pagehelper.PageHelper;
import com.github.pagehelper.PageInfo;
import com.hand.dao.FilmMapper;
import com.hand.dto.Msg;
import com.hand.pojo.Customer;
import com.hand.pojo.Film;
import com.hand.pojo.FilmExample;
import com.hand.service.FilmService;
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
public class FilmServiceImp implements FilmService {

    @Autowired
    private FilmMapper mapper;

    @Override
    public PageInfo<Film> getFilmByPage(int pageName) {

        PageHelper.startPage(pageName,10);
        List<Film> list = mapper.selectByExampleWithLanguage(null);
        PageInfo<Film> pageInfo = new PageInfo<Film>(list,5);

        //当pageName大于总页数时，默认到最后一页
        if(pageName>pageInfo.getPages()){
            pageName=pageInfo.getPages();
            PageHelper.startPage(pageName,10);
            List<Film> list2 = mapper.selectByExampleWithLanguage(null);
            PageInfo<Film> pageInfo2 = new PageInfo<Film>(list2,5);
            return pageInfo2;
        }else {
            return pageInfo;
        }
    }

    @Override
    public int addFilm(Film film) {
        return mapper.insertSelective(film);
    }

    @Override
    public Film getFilmById(short id) {
        return mapper.selectByPrimaryKey(id);
    }

    @Override
    public int editFilmById(Film film) {
        return mapper.updateByPrimaryKeySelective(film);
    }

    @Override
    @Transactional(propagation = Propagation.SUPPORTS,isolation = Isolation.DEFAULT)
    public Msg deleteFilmById(String filmIds){

        if(filmIds.contains("-")){
            //将ids字符串转化为id，进行删除
            List<Short> num = new ArrayList<Short>();
            List<Short> numFail = new ArrayList<Short>();
            String [] ids = filmIds.split("-");
            for (String strId:ids) {


                short id = Short.parseShort(strId);


//                进行删除
                int result = 0;
                try {
                    mapper.deleteFilmPreOne(id);
                    mapper.deleteFilmPreTwo(id);
                    mapper.deleteFilmPreThree(id);
                    mapper.deleteFilmPreFour(id);
                    mapper.deleteFilmPreFive(id);
                    result = mapper.deleteByPrimaryKey(id);
                } catch (Exception e) {
                    numFail.add(id);
                }

                if (result!=0){
                    num.add(id);
                }
            }
            //当size大于0,有customer删除成功
            if(num.size()>0){
                return Msg.success().add("ids",num).add("errs",numFail);
            }else{
                //result中没有id时，全部删除失败
                return Msg.fail();
            }

        }else {

            short filmId = Short.parseShort(filmIds);
            int result = 0;
            try {
                mapper.deleteFilmPreOne(filmId);
                mapper.deleteFilmPreTwo(filmId);
                mapper.deleteFilmPreThree(filmId);
                mapper.deleteFilmPreFour(filmId);
                mapper.deleteFilmPreFive(filmId);
                result = mapper.deleteByPrimaryKey(filmId);
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

    @Override
    public Boolean getFilmBytitle(String title) {
        FilmExample example = new FilmExample();
        example.createCriteria().andTitleEqualTo(title);
        List<Film> films = mapper.selectByExample(example);
        if (films.size()!=0){
            return false;
        }else{
            return true;
        }
    }

    @Override
    public PageInfo<Film> getFilmByPageWithExample(Film film, int pageName) {
        return null;
    }
}
