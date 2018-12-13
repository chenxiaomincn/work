#!/bin/bash
#Description:install redis；
#Usage：./install_redis；
#Date：2018-09-13；
#Author：chenxiaomin；
#Version: 0.1；

## defined variables

### software package
redis_ver=redis-4.0.11

path=$( pwd )

### config variable

dir=/apps/svr
install_dir=${dir}

make_proccess=4

## definde variables End

## function

### tar software package
function unpack() 
{

    if [ -f "${redis_ver}.tar.gz" ]
    then
        tar xf ${redis_ver}.tar.gz 
    else
        echo "${redis_ver}.tar.gz : No such file or directory"
        return 1 
    fi
}

### install redis
function install_redis()
{
    cd ${path}
    [  -d  "${install_dir}/${redis_ver}" ] &&  echo "${install_dir}/${redis_ver} is exist "  && return 1 
    
    cd ${redis_ver}
    make clean

    make PREFIX=${install_dir}/${redis_ver} install

}

### create soft link 
function create_link() 
{
    ln -sv ${install_dir}/${redis_ver}  ${install_dir}/redis
}
### cp redis_config
function cp_config() 
{
    mkdir ${install_dir}/redis/etc
    cp -v ${path}/${redis_ver}/redis.conf  ${install_dir}/redis/etc/
}


## function End

## main 

unpack

[ $? -eq 0 ] &&  install_redis || exit 11

[ $? -eq 0 ] &&  create_link  || exit 12 

sleep 3

[ $? -eq 0 ] &&  cp_config  || exit 13