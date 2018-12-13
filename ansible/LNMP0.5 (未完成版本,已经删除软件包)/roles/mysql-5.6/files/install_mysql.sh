#!/bin/bash
#Description:install mysql；
#Usage：.a；
#Date：2018-09-10；
#Author：chenxiaomin；
#Version: 0.1；

## defined variables

### software package
mysql_ver=mysql-5.6.41
ncurses_ver=ncurses-4.2
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

    if [ -f "${mysql_ver}.tar.gz" ]
    then
        tar xf ${mysql_ver}.tar.gz 
    else
        echo "${mysql_ver}.tar.gz : No such file or directory"
        return 1 
    fi

    if [ -f "${ncurses_ver}.tar.gz" ]
    then
        tar xf ${ncurses_ver}.tar.gz 
    else
        echo "${ncurses_ver}.tar.gz : No such file or directory"
        return 1 
    fi
}

### install ncurses
function install_ncures()
{
    cd ${path}
    [  -d  "${lib_path}/${ncurses_ver}" ] && echo "${lib_path}/${ncurses_ver} is exist " && return 1 
    
    cd ${ncurses_ver}
    make clean 

    ./configure                              \
    --prefix=${lib_path}/${ncurses_ver}  \
    --enable-shared                      \
    --enable-static         

    if [ $? -eq 0 ] 
    then
    make -j ${make_proccess}  && make install && echo "${ncurses_ver} install successfully" || echo "${ncurses_ver} install failed"  
    else
    echo "${ncurses_ver} install failed" 
    return 1 
    fi

    if [ $? -eq 0 ]
    then
        cd  ${lib_path}
        ln -s ${ncurses_ver} ncurses
    fi

}

### check lib
function check_lib() {
    cd ${lib_path}
    if [ ! -d "ncurses" ] 
    then
        echo "${lib_path}/ncures:No such file or directory"
        return 1
    fi

    if [ ! -d "zlib" ] 
    then
        echo "${lib_path}/zlib:No such file or directory"
        return 1
    fi
}

### install mysql
function install_mysql()
{
    cd ${path}
    [  -d  "${install_dir}/${mysql_ver}" ] &&  echo "${install_dir}/${mysql_ver} is exist "  && return 1 
    
    cd ${mysql_ver}
    make clean
    
    L_CFLAGS="-I${lib_path}/ncurses/include -I${lib_path}/readline/include"
    L_LDFLAGS="-L${lib_path}/ncurses/lib -L${lib_path}/readline/lib"
    L_CPPFLAGS="-I${lib_path}/ncurses/include -I${lib_path}/readline/include"


    CFLAGS=" $G_CFLAGS $L_CFLAGS";export CFLAGS;
    LDFLAGS=" $G_LDFLAGS $L_LDFLAGS";export LDFLAGS;
    CPPFLAGS=" $G_CPPFLAGS $L_CPPFLAGS";export CPPFLAGS;





    cmake . -DCMAKE_INSTALL_PREFIX=${install_dir}/${mysql_ver}         \
        -DDEFAULT_CHARSET=utf8                                         \
        -DWITH_ZLIB=${lib_path}/zlib                                   \
        -DCURSES_INCLUDE_PATH=${lib_path}/ncurses/include              \
        -DCURSES_NCURSES_INCLUDE_PATH=${lib_path}/ncurses/include      \
        -DCURSES_LIBRARY=${lib_path}/ncurses/lib/libncurses.a          \
        -DCURSES_NCURSES_LIBRARY=${lib_path}/ncurses/lib/libncurses.a  \
        -DDEFAULT_COLLATION=utf8_general_ci                            \
        -DWITH_EXTRA_CHARSETS:STRING=utf8,gbk            \
        -DENABLED_LOCAL_INFILE=ON                        \
        -DWITH_INNOBASE_STORAGE_ENGINE=1                 \
        -DWITH_FEDERATED_STORAGE_ENGINE=1                \
        -DWITH_BLACKHOLE_STORAGE_ENGINE=1                \
        -DWITHOUT_EXAMPLE_STORAGE_ENGINE=1               \
        -DWITHOUT_PARTITION_STORAGE_ENGINE=0             \
        -DWITH_COMMENT="yh mysql"                        \
        -DMYSQL_UNIX_ADDR=${install_dir}/${mysql_ver}/mysql.sock       \
        -DSYSCONFDIR=${install_dir}/${mysql_ver}/etc   \
        -DWITH_DEBUG=0                                   \
        -DDWITH_EDITLINE=0                               \
        -DWITH_READLINE=0

    if [ $? -eq 0 ] 
    then
        make -j ${make_proccess}  && make install && echo "${mysql_ver} install successfully"  
    else
        echo "${mysql_ver} install failed" 
        return 1 
    fi  
}

### create soft link 
function create_link() 
{
    ln -sv ${install_dir}/${mysql_ver}  ${install_dir}/mysql
}

## function End

## main 

unpack

[ $? -eq 0 ] &&  install_ncures || exit 11

[ $? -eq 0 ] &&  check_lib      || exit 12

[ $? -eq 0 ] &&  install_mysql  || exit 13

[ $? -eq 0 ] &&  create_link
