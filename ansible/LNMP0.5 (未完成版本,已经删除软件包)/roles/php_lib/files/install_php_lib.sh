#!/bin/bash
#Description:install php_lib；
#Usage：./install_php_lib.sh；
#Date：2018-09-08；
#Author：chenxiaomin；
#Version: 0.2；

## defined variables

### software package
curl_ver=curl-7.36.0
freetype_ver=freetype-2.4.6
jpeg_ver=jpeg-9a
libmcrypt_ver=libmcrypt-2.5.8
zlib_ver=zlib-1.2.8
openssl_ver=openssl-1.0.2p
libpng_ver=libpng-1.6.10
libxml2_ver=libxml2-2.7.8
libiconv_ver=libiconv-1.14

### config variable
path=$( pwd )
dir=/apps/lib
install_dir=${dir}
make_proccess=4

## definde variables End

## function

### tar software package
function  unpack() {
    if [ -f "${curl_ver}.tar.gz" ]
    then
        tar xf ${curl_ver}.tar.gz
    else
        echo "${curl_ver}.tar.gz : No such file or directory"
        return 1
    fi

    if [ -f "${freetype_ver}.tar.gz" ]
    then
        tar xf ${freetype_ver}.tar.gz
    else
        echo "${freetype_ver}.tar.gz : No such file or directory"
        return 1
    fi

    if [ -f "${jpeg_ver}.tar.gz" ]
    then
        tar xf ${jpeg_ver}.tar.gz
    else
        echo "${jpeg_ver}.tar.gz : No such file or directory"
        return 1
    fi

    if [ -f "${libmcrypt_ver}.tar.gz" ]
    then
        tar xf ${libmcrypt_ver}.tar.gz
    else
        echo "${libmcrypt_ver}.tar.gz : No such file or directory"
        return 1
    fi

    if [ -f "${zlib_ver}.tar.gz" ]
    then
        tar xf ${zlib_ver}.tar.gz
    else
        echo "${zlib_ver}.tar.gz : No such file or directory"
        return 1
    fi

    if [ -f "${openssl_ver}.tar.gz" ]
    then
        tar xf ${openssl_ver}.tar.gz
    else
        echo "${openssl_ver}.tar.gz : No such file or directory"
        return 1
    fi

    if [ -f "${libpng_ver}.tar.gz" ]
    then
        tar xf ${libpng_ver}.tar.gz
    else
        echo "${libpng_ver}.tar.gz : No such file or directory"
        return 1
    fi

    if [ -f "${libxml2_ver}.tar.gz" ]
    then
        tar xf ${libxml2_ver}.tar.gz
    else
        echo "${libxml2_ver}.tar.gz : No such file or directory"
        return 1
    fi

    if [ -f "${libiconv_ver}.tar.gz" ]
    then
        tar xf ${libiconv_ver}.tar.gz
    else
        echo "${libiconv_ver}.tar.gz : No such file or directory"
        return 1
    fi

}

### check lib
function check_lib() {
    [ ! -d "${curl_ver}" ]      &&  echo "${curl_ver} :  No such file or directory"     && return 1 
    [ ! -d "${freetype_ver}" ]  &&  echo "${freetype_ver} : No such file or directory"  && return 1 
    [ ! -d "${jpeg_ver}" ]      &&  echo "${jpeg_ver} : No such file or directory"      && return 1 
    [ ! -d "${libmcrypt_ver}" ] &&  echo "${libmcrypt_ver} : No such file or directory" && return 1
    [ ! -d "${zlib_ver}" ]      &&  echo "${zlib_ver} :  No such file or directory"     && return 1 
    [ ! -d "${openssl_ver}" ]   &&  echo "${openssl_ver} : No such file or directory"   && return 1 
    [ ! -d "${libpng_ver}" ]    &&  echo "${libpng_ver} : No such file or directory"    && return 1 
    [ ! -d "${libxml2_ver}" ]   &&  echo "${libxml2_ver} : No such file or directory"   && return 1
    [ ! -d "${libiconv_ver}" ]  &&  echo "${libiconv_ver} : No such file or directory"  && return 1
    echo "check_lib succeed  "
}

### install libXpm-devel
function install_libXpm-deve() {
    rpm -q libXpm-devel &>/dev/null || yum -y install libXpm-devel &>/dev/null
    if [ ! $? -eq 0  ] 
    then
        echo "yum install libXpm-devel  failure,You have to be an administrator"
        return 1 
    fi
}

###  install jpeg
function install_jpeg() {
    cd ${path}
    [  -d  "${install_dir}/${jpeg_ver}" ] && echo "${install_dir}/${jpeg_ver} is exist " && return 1 
    
    cd ${jpeg_ver}
    make clean 

    ./configure                              \
    --prefix=${install_dir}/${jpeg_ver}  \
    --enable-shared                      \
    --enable-static         

    if [ $? -eq 0 ] 
    then
    make -j ${make_proccess}  && make install && echo "${jpeg_ver} install successfully" || echo "${jpeg_ver} install failed"  
    else
    echo "${jpeg_ver} install failed" 
    return 1 
    fi

}

###  install zlib 
function install_zlib () {
    cd ${path}
    [  -d  "${install_dir}/${zlib_ver}" ] &&  echo "${install_dir}/${zlib_ver} is exist "  && return 1 

    cd ${zlib_ver}
    make clean 

    ./configure                                    \
    --prefix=${install_dir}/${zlib_ver}  

    if [ $? -eq 0 ] 
    then
    make -j ${make_proccess}  && make install && echo "${zlib_ver} install successfully" || echo "${zlib_ver} install failed"  
    else
    echo "${zlib_ver} install failed" 
    return 1 
    fi

}

###  install libmcrypt 
function install_libmcrypt () {
    cd ${path}
    [  -d  "${install_dir}/${libmcrypt_ver}" ] &&  echo "${install_dir}/${libmcrypt_ver} is exist " && return 1 

    cd ${libmcrypt_ver}
    make clean 

    ./configure                                    \
    --prefix=${install_dir}/${libmcrypt_ver}  

    if [ $? -eq 0 ] 
    then
        make -j ${make_proccess}  && make install && echo "${libmcrypt_ver} install successfully" || echo "${libmcrypt_ver} install failed"  
    else
        echo "${libmcrypt_ver} install failed" 
    return 1 
    fi

}

###  install libiconv 
function install_libiconv () {
    cd ${path}
    [  -d  "${install_dir}/${libiconv_ver}  " ] &&  echo "${install_dir}/${libiconv_ver}   is exist " && return 1 
    
    cd ${libiconv_ver}
    make clean 

    ./configure                                    \
    --prefix=${install_dir}/${libiconv_ver}  

    if [ $? -eq 0 ] 
    then
        make -j ${make_proccess}  && make install && echo "${libiconv_ver} install successfully" || echo "${libiconv_ver} install failed"  
    else
        echo "${libiconv_ver} install failed" 
        return 1 
    fi

}

###  install freetype 
function install_freetype () {
    cd ${path}
    [  -d  "${install_dir}/${freetype_ver}" ] &&  echo "${install_dir}/${freetype_ver} is exist " && return 1 
    
    cd ${freetype_ver}
    make clean 

    ./configure                                    \
        --prefix=${install_dir}/${freetype_ver}  

    if [ $? -eq 0 ] 
    then
        make -j ${make_proccess}  && make install && echo "${freetype_ver} install successfully" || echo "${freetype_ver} install failed"  
    else
        echo "${freetype_ver} install failed" 
        return 1 
    fi

}

###  install openssl 
function install_openssl () {
    cd ${path}
    [  -d  "${install_dir}/${openssl_ver}" ] &&  echo "${install_dir}/${openssl_ver} is exist "  && return 1 
    
    cd ${openssl_ver}
    make clean 

    ./config                                   \
        --prefix=${install_dir}/${openssl_ver}  -shared

    if [ $? -eq 0 ] 
    then
        make -j ${make_proccess}  && make install && echo "${openssl_ver} install successfully"  
    else
        echo "${openssl_ver} install failed" 
        return 1 
    fi

}

###  install libxml2 
function install_libxml2 () {
    cd ${path}
    [  -d  "${install_dir}/${libxml2_ver}" ] &&  echo "${install_dir}/${libxml2_ver} is exist "  && return 1 
    
    cd ${libxml2_ver}
    make clean 

    ./configure                                    \
        --prefix=${install_dir}/${libxml2_ver} 

    if [ $? -eq 0 ] 
    then
        make -j ${make_proccess}  && make install && echo "${libxml2_ver} install successfully" || echo "${libxml2_ver} install failed"  
    else
        echo "${libxml2_ver} install failed" 
        return 1 
    fi

}


###  install curl 
function install_curl () {
    cd ${path}
    [  -d  "${install_dir}/${curl_ver}" ] &&  echo "${install_dir}/${curl_ver} is exist " && return 1 

    LD_LIBRARY_PATH="${install_dir}/${openssl_ver}/lib"
    export LD_LIBRARY_PATH
    L_CFLAGS=""
    L_LDFLAGS=""
    L_CPPFLAGS=""
    CFLAGS=" $G_CFLAGS $L_CFLAGS";export CFLAGS;
    LDFLAGS=" $G_LDFLAGS $L_LDFLAGS";export LDFLAGS;
    CPPFLAGS=" $G_CPPFLAGS $L_CPPFLAGS";export CPPFLAGS;

    export LDFLAGS="-L${install_dir}/${zlib_ver}/lib"
    export CPPFLAGS="-I${install_dir}/${zlib_ver}/include"


    cd ${curl_ver}
    make clean 

    ./configure                           \
        --prefix=${install_dir}/${curl_ver}   \
        --with-ssl=${install_dir}/${openssl_ver} \
	    --with-zlib==${install_dir}/${zlib_ver}

    if [ $? -eq 0 ] 
    then
        make -j ${make_proccess}  && make install && echo "${curl_ver} install successfully" || echo "${curl_ver} install failed"  
    else
        echo "${curl_ver} install failed" 
        return 1 
    fi

}

###  install libpng 
function install_libpng () {
    cd ${path}
    [  -d  "${install_dir}/${libpng_ver} " ] && echo "${install_dir}/${libpng_ver}  is exist "  && return 1 
    
    cd ${libpng_ver}
    make clean 

    export LDFLAGS="-L${install_dir}/${zlib_ver}/lib"
    export CPPFLAGS="-I${install_dir}/${zlib_ver}/include"
    ./configure                           \
        --prefix=${install_dir}/${libpng_ver}   

    if [ $? -eq 0 ] 
    then
        make -j ${make_proccess}  && make install && echo "${libpng_ver} install successfully" || echo "${libpng_ver} install failed"  
    else
        echo "${libpng_ver} install failed" 
        return 1 
    fi

}


### create soft link 
function create_link() {
    cd ${install_dir}
    ln -s ${curl_ver}        curl
    ln -s ${freetype_ver}    freetype
    ln -s ${jpeg_ver}         jpeg
    ln -s ${libmcrypt_ver}   libmcrypt
    ln -s ${zlib_ver}        zlib
    ln -s ${openssl_ver}     openssl
    ln -s ${libpng_ver}      libpng
    ln -s ${libxml2_ver}         libxml2
}

## function End

## main 

unpack 

[ $? -eq 0 ] && check_lib && sleep 3  || exit 12

[ $? -eq 0 ] && install_jpeg &&  sleep 3 || exit 13

[ $? -eq 0 ] && install_zlib && sleep 3 || exit 14

[ $? -eq 0 ] && install_libmcrypt && sleep 3 || exit 15

[ $? -eq 0 ] && install_libiconv && sleep 3 || exit 16

[ $? -eq 0 ] && install_freetype && sleep 3 || exit 17

[ $? -eq 0 ] && install_openssl && sleep 3 || exit 18

[ $? -eq 0 ] && install_libxml2 && sleep 3 || exit 19

[ $? -eq 0 ] && install_curl && sleep 3 || exit 20

[ $? -eq 0 ] && install_libpng && sleep 3 || exit 21

[ $? -eq 0 ] && create_link  && sleep 3 || exit 23

#install_libXpm-deve
