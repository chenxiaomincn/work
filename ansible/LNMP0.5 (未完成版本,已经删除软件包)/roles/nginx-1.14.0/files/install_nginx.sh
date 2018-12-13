#!/bin/bash
#Description:Install nginx；
#Usage：./Install_nginx.sh；
#Date：2018-09-07；
#Author：chenxiaomin；
#Version: 0.2；

## defined variables

### software package
nginx_ver=nginx-1.14.0
openssl_ver=openssl-1.0.2j
pcre_ver=pcre-8.35
zlib_ver=zlib-1.2.8

### config variable
dir=/apps/svr
install_dir=${dir}/${nginx_ver}
config_file=${install_dir}/nginx.conf
log_dir=/apps/log/nginx
nginx_user=apps
nginx_group=apps
make_proccess=4

## definde variables End

## function

### tar software package
function  unpack() {
    if  [ -f "${nginx_ver}.tar.gz" ]
    then
        tar xf ${nginx_ver}.tar.gz
    else
        echo "${nginx_ver}.tar.gz : No such file or directory"
        return 1
    fi

    if [  -f "${openssl_ver}.tar.gz" ]  
    then
        tar xf ${openssl_ver}.tar.gz
    else
        echo "${openssl_ver}.tar.gz : No such file or directory"
        return 1
    fi

    if [  -f "${pcre_ver}.tar.gz" ]
    then
        tar xf ${pcre_ver}.tar.gz
    else
        echo "${pcre_ver}.tar.gz : No such file or directory"
        return 1
    fi

    if [  -f "${zlib_ver}.tar.gz" ] 
    then
        tar xf ${zlib_ver}.tar.gz
    else
        echo "${zlib_ver}.tar.gz : No such file or directory"
        return 1
    fi
}

### check lib
function check_lib() {
    [ ! -d "${nginx_ver}" ]    &&   echo "${nginx_ver} :  No such file or directory"  && return 1 
    [ ! -d "${openssl_ver}" ]  &&   echo "${openssl_ver} : No such file or directory" && return 1 
    [ ! -d "${pcre_ver}" ]     &&   echo "${pcre_ver} : No such file or directory"    && return 1 
    [ ! -d "${zlib_ver}" ]     &&   echo "${zlib_ver} : No such file or directory"    && return 1
    echo "check_lib"
}

###  install nginx
function install_nginx() {
    [  -d  "${install_dir}" ] && echo "${install_dir} is exist " && return 1
    

cd ${nginx_ver}
make clean 

./configure  --prefix=${install_dir}              \
    --sbin-path=${install_dir}/sbin/nginx         \
    --conf-path=${config_file}                  \
    --error-log-path=${log_dir}/error.log       \
    --http-log-path=${log_dir}/access.log       \
    --pid-path=${install_dir}/nginx.pid         \
    --lock-path=${install_dir}/nginx.lock       \
    --user=${nginx_user}                        \
    --group=${nginx_group}                      \
    --with-http_ssl_module                      \
    --without-http_charset_module               \
    --without-http_userid_module                \
    --without-http_auth_basic_module            \
    --without-http_referer_module               \
    --without-http_geo_module                   \
    --without-http_memcached_module             \
    --without-http_limit_conn_module            \
    --without-http_empty_gif_module             \
    --without-http_browser_module               \
    --with-http_stub_status_module              \
    --with-zlib=../${zlib_ver}                  \
    --with-pcre=../${pcre_ver}                  \
    --with-openssl=../${openssl_ver}              

if [ $? -eq 0 ] 
then
    make -j ${make_proccess}  && make install && echo "nginx install successfully" || echo "nginx install failed"  
else
    echo "nginx install failed"  
fi

}

### create soft link 
function create_link() 
{
    cd ${dir}
    ln -sv ${nginx_ver}  nginx
}

## function End

## main 

unpack 

[ $? -eq 0 ] && check_lib || exit 2

[ $? -eq 0 ] && install_nginx || exit 3 

[ $? -eq 0 ] && create_link 


