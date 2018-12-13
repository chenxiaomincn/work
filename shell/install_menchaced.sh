#!/bin/bash
#Description:install memchaced；
#Usage：./install_memchaced；
#Date：2018-09-13；
#Author：chenxiaomin；
#Version: 0.1；

# --------版本变化描述------- #
# 版本      时间        更新描述
# 0.2      2018-10-10  修改memcached的编译选项以及编译后把scripts复制到编译目录下
#
#--------- END ------------#

## defined variables

### software package
memcached_ver=memcached-1.5.10
libevent_ver=libevent-2.1.8
path=$( pwd )

### config variable
lib_path=/apps/lib

dir=/apps/svr
install_dir=${dir}

make_proccess=4

## definde variables End

## function

### tar software package
function unpack() 
{

    if [ -f "${memcached_ver}.tar.gz" ]
    then
        tar xf ${memcached_ver}.tar.gz 
    else
        echo "${memcached_ver}.tar.gz : No such file or directory"
        return 1 
    fi

    if [ -f "${libevent_ver}.tar.gz" ]
    then
        tar xf ${libevent_ver}.tar.gz 
    else
        echo "${libevent_ver}.tar.gz : No such file or directory"
        return 1 
    fi
}

### install libevent
function install_libevent()
{
    cd ${path}
    [  -d  "${lib_path}/${libevent_ver}" ] && echo "${lib_path}/${libevent_ver} is exist " && return 1 
    
    cd ${libevent_ver}-stable
    make clean

    ./configure                              \
    --prefix=${lib_path}/${libevent_ver}  


    if [ $? -eq 0 ] 
    then
    make -j ${make_proccess}  && make install && echo "${libevent_ver} install successfully" || echo "${libevent_ver} install failed"  
    else
    echo "${ncurses_ver} install failed" 
    return 1 
    fi

    [ $? -eq 0 ] && cd  ${lib_path} && ln -s ${lib_path}/${libevent_ver}   libevent
}

### check lib
function check_lib() {
    cd ${lib_path}
    if [ ! -d "libevent" ] 
    then
        echo "${lib_path}/ncures:No such file or directory"
        return 1
    fi
}

### install memcached
function install_memcached()
{
    cd ${path}
    [  -d  "${install_dir}/${memcached_ver}" ] &&  echo "${install_dir}/${memcached_ver} is exist "  && return 1 
    
    cd ${memcached_ver}
    make clean

    ./configure --prefix=${install_dir}/${memcached_ver}                    \
            --with-libevent=${lib_path}/libevent                            \
            --sysconfdir=${install_dir}/${memcached_ver}/etc

    if [ $? -eq 0 ] 
    then
        make -j ${make_proccess}  && make install && echo "${memcached_ver} install successfully"  
    else
        echo "${memcached_ver} install failed" 
        return 1 
    fi 
    cp -r scripts ${install_dir}/${memcached_ver}/
}

### create soft link 
function create_link() 
{
    ln -sv ${install_dir}/${memcached_ver}  ${install_dir}/memcached
}

## function End

## main 

unpack

[ $? -eq 0 ] &&  install_libevent || exit 11

[ $? -eq 0 ] &&  check_lib      || exit 12

[ $? -eq 0 ] &&  install_memcached  || exit 13

[ $? -eq 0 ] &&  create_link
