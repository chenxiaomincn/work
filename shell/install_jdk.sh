#!/bin/bash
#Description:install JDK；
#Usage：./install_jdk；
#Date：2018-09-10；
#Author：chenxiaomin；
#Version: 0.1；

# --------版本变化描述------- #
# 版本      时间        更新描述
# 0.1      2018-10-08  修改jdk路径写入变量的问题
# 0.2      2018-10-10  注释掉jdk路径
#
#--------- END ------------#

## defined variables

### software package
jdk_ver="jdk1.8.0_181"
jdk_pack="jdk-8u181-linux-x64.tar.gz"
jdk_install_dir="/apps/svr"

var_file="${HOME}/.bash_profile"

## definde variables End

## function

### unzip software package && install jdk 

function  install_jdk() {
    [  -d  "${jdk_install_dir}/${jdk_ver}" ] && echo "${jdk_install_dir}/${jdk_ver} is exist " && return 1

    if [ -f "${jdk_pack}" ]
    then
        tar xf ${jdk_pack} -C ${jdk_install_dir} &>/dev/null
        cd ${jdk_install_dir}
        ln -sv ${jdk_ver} jdk
    else
        echo "${jdk_pack} : No such file or directory"
        return 1 
    fi

}

### Defining JDK variables
function definde_jdk_var()
{
    egrep "JAVA_HOME|JRE_HOME" ${var_file}
    if [ $? -eq 0 ]
    then
        echo "Please check the JDK variable.file path:${var_file}"
        egrep "JAVA_HOME|JRE_HOME" ${var_file}
    else
        echo  "#JDK"                                                                       >> ${var_file}
        echo  "JRE_HOME=${jdk_install_dir}/jdk"                                            >> ${var_file}
        echo  'CLASS_PATH=$JAVA_HOME/lib/dt.jar:$JAVA_HOME/lib/tools.jar:$JRE_HOME/lib'    >> ${var_file}
        echo  'PATH=$PATH:$JAVA_HOME/bin:$JRE_HOME/bin'                                    >> ${var_file}
        echo  'export JAVA_HOME JRE_HOME CLASS_PATH PATH'                                  >> ${var_file}
    fi

}
## function End

## main 


install_jdk

#[ $? -eq 0 ] &&  definde_jdk_var || exit 11

