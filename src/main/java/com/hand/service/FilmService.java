package com.hand.service;

import com.github.pagehelper.PageInfo;
import com.hand.dto.Msg;
import com.hand.pojo.Customer;
import com.hand.pojo.Film;

/**
 * Created by 铭刻 on 2017/8/26.
 */
public interface FilmService {


    PageInfo<Film> getFilmByPage(int pageName);

    int addFilm(Film film);

    Film getFilmById(short id);

    int editFilmById(Film film);

    Msg deleteFilmById(String filmIds);

    Boolean getFilmBytitle(String title);

    PageInfo<Film> getFilmByPageWithExample(Film film,int pageName);
}
