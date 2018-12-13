#!/bin/bash
#Description:Install python3；
#Author：chenxiaomin；

# --------版本变化描述------- #
# 版本      时间        更新描述
# 0.1       2018-10-08  初次编写python3脚本
#0.2        2018-10-10  注释掉执行路径
#---------END -------------# 


## defined variables

### software package
software_pack=Python-3.7.0.tgz
software_dir=$(echo ${software_pack} | awk -F'.tgz' '{print $1}' )
python_version=$(echo ${software_pack} | awk -F'.tgz' '{print $1}' | tr A-Z a-z)
install_dir=/apps/lib
zlib_ver=zlib-1.2.8
openssl_ver=openssl-1.0.2p

###config var
make_proccess=4 
var_file="${HOME}/.bash_profile"

## definde variables End


## function

### tar software package
function  unpack() {
    if  [ -f "${software_pack}" ]
    then
        tar xf ${software_pack}
    else
        echo "${software_pack} : No such file or directory"
        return 1
    fi
}

### check lib
function check_lib() {
    rpm -q libffi-devel >& /dev/null 
    if ! [ $? -eq 0  ]
    then
        Please install  libffi-devel
        return 1 
    fi
    

    [ ! -d "${install_dir}/${openssl_ver}" ]    &&   echo "${install_dir}/${openssl_ver} :  No such file or directory"  && return 1 
    [ ! -d "${install_dir}/${zlib_ver}" ]  &&   echo "${install_dir}/${zlib_ver} : No such file or directory" && return 1 
    echo "check_lib"
}

###  install python
function install_python3()
{
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
    
    cd ${software_dir}
    make clean  
    ./configure --prefix=${install_dir}/${python_version}  --with-openssl=${install_dir}/${openssl_ver}

    if [ $? -eq 0 ] 
    then
    make -j ${make_proccess}  && make install && echo "python3 install successfully" || echo "python3 install failed"  
    else
    echo "python3 install failed" 
    return 1 
    fi
    sleep 3
}

### create soft link 
function create_link() 
{
    cd ${install_dir}
    ln -sv ${python_version}  python3
}

### Defining python3 variables
function definde_python3_var()
{
    egrep "python3" ${var_file}
    if [ $? -eq 0 ]
    then
        echo "Please check the python3 variable.file path:${var_file}"
        egrep "python3" ${var_file}
        return 1 
    else
        echo  "#python3"                                       >> ${var_file}
        echo  "python3_path=${install_dir}/python3"            >> ${var_file}                                                   
        echo  'export PATH=$PATH:${python3_path}/bin'          >> ${var_file}                            
    fi

}

## function End

## main 

unpack 

[ $? -eq 0 ] && check_lib || exit 2

[ $? -eq 0 ] &&  install_python3 || exit 3

[ $? -eq 0 ] && create_link || exit 4

#[ $? -eq 0 ] && definde_python3_var || exit 5


