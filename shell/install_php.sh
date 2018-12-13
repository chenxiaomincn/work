#!/bin/bash
#Description:install php；
#Usage：./install_php；
#Date：2018-09-10；
#Author：chenxiaomin；
#Version: 0.1；

## defined variables

### software package
php_ver=php-5.6.30
lib_path=/apps/lib

### config variable
php_user=apps
php_group=apps
path=$( pwd )
dir=/apps/lib

install_dir=${dir}
make_proccess=4

## definde variables End

## function

### tar software package
function  unpack() {

    if [ -f "${php_ver}.tar.gz" ]
    then
        tar xf ${php_ver}.tar.gz 
    else
        echo "${php_ver}.tar.gz : No such file or directory"
        return 1 
    fi
}

### check lib
function check_lib() {
    cd ${lib_path}
    if [ ! -d "curl" ] 
    then
        echo "${lib_path}/curl:No such file or directory"
        return 1
    fi
    
    if [ ! -d "freetype" ] 
    then
        echo "${lib_path}/freetype:No such file or directory"
        return 1
    fi

    if [ ! -d "jpeg" ] 
    then
        echo "${lib_path}/jpeg:No such file or directory"
        return 1
    fi

    if [ ! -d "libmcrypt" ] 
    then
        echo "${lib_path}/libmcrypt:No such file or directory"
        return 1
    fi

    if [ ! -d "zlib" ] 
    then
        echo "${lib_path}/zlib:No such file or directory"
        return 1
    fi

    if [ ! -d "libpng" ] 
    then
        echo "${lib_path}/libpng:No such file or directory"
        return 1
    fi

    if [ ! -d "openssl" ] 
    then
        echo "${lib_path}/openssl:No such file or directory"
        return 1
    fi

    if [ ! -d "libxml2" ] 
    then
        echo "${lib_path}/libxml2:No such file or directory"
        return 1
    fi
}

### install php
function install_php()
{
    cd ${path}
    [  -d  "${install_dir}/${php_ver}" ] &&  echo "${install_dir}/${php_ver} is exist "  && return 1 

    export LDFLAGS="-L${lib_path}/zlib/lib"
    export CPPFLAGS="-I${lib_path}/zlib/include"

    LD_LIBRARY_PATH="${lib_path}/openssl/lib"
    L_CFLAGS=""
    L_LDFLAGS=""
    L_CPPFLAGS=""
    CFLAGS=" $G_CFLAGS $L_CFLAGS";export CFLAGS;
    LDFLAGS=" $G_LDFLAGS $L_LDFLAGS";export LDFLAGS;
    CPPFLAGS=" $G_CPPFLAGS $L_CPPFLAGS";export CPPFLAGS;

    cd ${php_ver}
    make clean 

    ./configure   --prefix=${install_dir}/${php_ver}  \
        --with-fpm-user=$php_user           \
        --with-fpm-group=$php_group         \
        --with-openssl=${lib_path}/openssl  \
        --with-zlib-dir=${lib_path}/zlib    \
        --with-jpeg-dir=${lib_path}/jpeg    \
        --with-mcrypt=${lib_path}/libmcrypt \
        --with-freetype-dir=${lib_path}/freetype \
        --with-curl=${lib_path}/curl        \
        --with-png-dir=${lib_path}/libpng   \
        --with-xpm-dir=/usr/lib64           \
        --with-iconv-dir=${lib_path}/libiconv \
        --with-gd                           \
        --enable-fpm                        \
        --enable-mbstring                   \
        --with-libxml-dir=${lib_path}/libxml2 

    if [ $? -eq 0 ] 
    then
        make -j ${make_proccess}  && make install && echo "${php_ver} install successfully"  
    else
        echo "${php_ver} install failed" 
        return 1 
    fi  
}

### create soft link 
function create_link() 
{
    ln -sv ${install_dir}/${php_ver}  ${install_dir}/php5 
}

### cp php_config
function cp_config() 
{
    cd ${path}/${php_ver}
    cp -v php.ini-development  ${install_dir}/php5/lib/php.ini
    cd ${install_dir}/${php_ver}/etc
    cp -v php-fpm.conf.default php-fpm.conf
}



## function End

## main 

unpack

[ $? -eq 0 ] && check_lib || exit 11

[ $? -eq 0 ] && install_php || exit 12

[ $? -eq 0 ] && create_link || exit 13

[ $? -eq 0 ] && cp_config