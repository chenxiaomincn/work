#!/bin/bash
#Description:install php_ext；
#Usage：./install_php_ext；
#Date：2018-09-13；
#Author：chenxiaomin；
#Version: 0.1；

## defined variables

### software package
php_ver=php-5.6.30
memcache_ver=memcache-2.2.4
redis_ver=redis-4.1.0
swoole_ver=swoole-1.10.5

### config variable

path=$( pwd )
make_proccess=4
php_path="/apps/lib/php5"
phpize_path="${php_path}/bin/phpize"
php_config="${php_path}/bin/php-config"

mysql_path="/apps/svr/mysql"

zlib_dir="/apps/lib/zlib"

openssl_dir="/apps/lib/openssl"
## definde variables End

## function

### tar software package
function  unpack() {
unpack_file=" ${memcache_ver} ${redis_ver} ${swoole_ver}"
for file_name in  $unpack_file
do
    if [ -f "${file_name}.tgz" ]
    then
        tar xf ${file_name}.tgz 
    else
        echo "${file_name}.tgz : No such file or directory"
        return 1 
    fi
done

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

}

### install pdo_mysql
function install_pdo_mysql()
{
    [ ! -d  "${mysql_path}" ] &&  echo "${mysql_path} is  no exist "  && return 1     
    
    cd ${path}/${php_ver}
    make clean 
    cd ext/pdo_mysql
    ${phpize_path}

    sleep 1 

    ./configure                 \
        --with-php-config=${php_config}  \
        --with-pdo-mysql=${mysql_path}


    if [ $? -eq 0 ] 
    then
        make -j ${make_proccess}  && make install && echo "pdo_mysql install successfully"  
    else
        echo "${php_ver} install failed" 
        return 1 
    fi  
}

### install php_memcache
function install_php_memcache()
{
    cd ${path}/${memcache_ver}
    make clean 
    ${phpize_path}

    sleep 1 
    export LDFLAGS="-L${zlib_dir}/lib"
    export CPPFLAGS="-I${zlib_dir}/include"
    ./configure                 \
        --with-php-config=${php_config} \
        --with-zlib-dir=${zlib_dir}   \
        --enable-memcache \
        --with-memcached 

    if [ $? -eq 0 ] 
    then
        make -j ${make_proccess}  && make install && echo "php ${memcache_ver} install successfully"  
    else
        echo "${php_ver} install failed" 
        return 1 
    fi  
}

### install php_redis
function install_php_redis()
{
    cd ${path}/${redis_ver}
    make clean 
    ${phpize_path}

    sleep 1 

    ./configure                 \
        --with-php-config=${php_config}  

    if [ $? -eq 0 ] 
    then
        make -j ${make_proccess}  && make install && echo "php ${redis_ver} install successfully"  
    else
        echo "${redis_ver} install failed" 
        return 1 
    fi  
}


### install php ftp
function install_php_ftp()
{
    
    cd ${path}/${php_ver}
    make clean 
    cd ext/ftp
    ${phpize_path}

    sleep 1 

    ./configure                 \
        --with-php-config=${php_config}  \
        --with-openssl-dir=${openssl_dir}


    if [ $? -eq 0 ] 
    then
        make -j ${make_proccess}  && make install && echo "ftp install successfully"  
    else
        echo "${php_ver} ftp install failed" 
        return 1 
    fi  
}

### install php bcmath
function install_php_bcmath()
{
    
    cd ${path}/${php_ver}
    make clean 
    cd ext/bcmath
    ${phpize_path}

    sleep 1 

    ./configure                 \
        --with-php-config=${php_config}  
 

    if [ $? -eq 0 ] 
    then
        make -j ${make_proccess}  && make install && echo "bcmath install successfully"  
    else
        echo "${php_ver} bcmath install failed" 
        return 1 
    fi  
}

### install swoole
function install_php_swoole()
{
    cd ${path}/${swoole_ver}
    make clean 
    ${phpize_path}

    sleep 1 

    ./configure                 \
        --with-php-config=${php_config}  

    if [ $? -eq 0 ] 
    then
        make -j ${make_proccess}  && make install && echo "php ${swoole_ver} install successfully"  
    else
        echo "${swoole_ver} install failed" 
        return 1 
    fi  
}

### echo add  php.in
function change_php_config()
{
    cd ${php_path}/lib/
    if [ -f "php.ini" ]  
    then
        cp -a  php.ini  php.ini_bak_$(date +%F_%T)
        sed -i '/^;extension=php_xsl.dll/a\extension=redis.so' php.ini
        sed -i '/^;extension=php_xsl.dll/a\extension=memcache.so' php.ini
        sed -i '/^;extension=php_xsl.dll/a\extension=pdo_mysql.so' php.ini
        sed -i '/^;extension=php_xsl.dll/a\extension=ftp.so' php.ini
        sed -i '/^;extension=php_xsl.dll/a\extension=bcmath.so' php.ini
    else
        echo "php.ini : No such file or directory"  
        return 1
    fi
}

## function End

## main 

unpack

[ $? -eq 0 ] && install_pdo_mysql || exit 11
[ $? -eq 0 ] && install_php_memcache || exit 12
[ $? -eq 0 ] && install_php_redis || exit 13
[ $? -eq 0 ] && install_php_ftp || exit 14
[ $? -eq 0 ] && install_php_bcmath || exit 15
[ $? -eq 0 ] && install_php_swoole || exit 16
[ $? -eq 0 ] && change_php_config || exit 17