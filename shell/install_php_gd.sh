#!/bin/bash
#Description:install php_gd；
#Usage：./install_php_gd；
#Date：2018-09-26；
#Author：chenxiaomin；
#Version: 0.1；

## defined variables

### software package
php_ver=php-5.6.30


### config variable

path=$( pwd )
make_proccess=4
php_path="/apps/lib/php5"
phpize_path="${php_path}/bin/phpize"
php_config="${php_path}/bin/php-config"

### lib path
lib_path=/apps/lib
openssl_dir="/apps/lib/openssl"
jpeg_dir="/apps/lib/jpeg"
freetype_dir="/apps/lib/freetype"
png_dir="/apps/lib/libpng"
zlib_dir="/apps/lib/zlib"

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
lib_file=" ${openssl_dir} ${jpeg_dir} ${freetype_dir} ${png_dir} ${zlib_dir}"

for file_name in  ${lib_file}
do
    if [ ! -d "${file_name}" ]
    then
        echo "${file_name} : No such file or directory"
        return 1 
    fi
done

}


### install php gd
function install_php_gd()
{
    
    cd ${path}/${php_ver}
    make clean 
    cd ext/gd
    ${phpize_path}

    sleep 1 
    export LDFLAGS="-L${lib_path}/zlib/lib"
    export CPPFLAGS="-I${lib_path}/zlib/include"

    ./configure  \
    --with-php-config=${php_config}      \
    --with-jpeg-dir=${jpeg_dir}          \
    --with-freetype-dir=${freetype_dir}  \
    --with-png-dir=${png_dir}            \
    --with-zlib-dir=${zlib_dir}          \
    --with-gd

    if [ $? -eq 0 ] 
    then
        make -j ${make_proccess}  && make install && echo "php gd install successfully"  
    else
        echo "${php_ver} gd install failed" 
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
        sed -i '/^;extension=php_xsl.dll/a\extension=gd.so' php.ini
    else
        echo "php.ini : No such file or directory"  
        return 1
    fi
}

## function End

## mai

unpack

[ $? -eq 0 ] && check_lib || exit 11
sleep 3
[ $? -eq 0 ] && install_php_gd || exit 12
sleep 3
[ $? -eq 0 ] && change_php_config || exit 13