#!/bin/bash
#Description:Authorized user privileges ；
#Author：chenxiaomin；

# --------版本变化描述------- #
# 版本      时间        更新描述
# 0.1      2018-10-09  初次编写用户授权脚本
# 0.2      2018-10-10  测试用户授权脚本,但是还有bug:检查ipv4有效性未实现;
#
#--------- END ------------#

## defined variables

user_list=()
passwd_list=()
ip_list=()
database_list=()

SQL_File="User_SQL_$(date +%F_%T).sql"

## definde variables Endp


## function
### 生成脚本钱检查参数是否准确
function pre_check()
{
    # 1.检查用户账号密码是不是对应
    user_list_num=$(echo ${#user_list[*]})
    passwd_list_num=$(echo ${#passwd_list[*]})
    if [ ${user_list_num} -ne ${passwd_list_num} ]
    then
        echo "请检查用户列表和密码列表是否能一一匹配"
        return 1 
    fi
    # 2.检查ip列表是不是为有效的ip地址
    for ip in ${ip_list[*]}
    do
        VALID_CHECK=$(echo $IP|awk -F. '$1<=255&&$2<=255&&$3<=255&&$4<=255{print "yes"}') 
        if echo $IP|grep -E "^[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}$">/dev/null; 
        then
            if  [${VALID_CHECK:-no} != "yes"]
            then
                echo "IP $IP not available!"
                break && return 1 
            fi
        fi

    done
    
}

### 创建数据库
function Create_Database()
{
    echo "# Create_Database" >> ${SQL_File}
    for Data_Name in ${database_list[*]}
    do 
        echo "CREATE DATABASE IF NOT EXISTS \`${Data_Name}\` CHARACTER SET utf8 COLLATE utf8_general_ci;" >> ${SQL_File}
    done
}
### 生成数据库用户
function Crete_User()
{
    echo -e "\n# Crete_User" >> ${SQL_File}
    for ((i=0;i<${#user_list[*]};i++))
    do 
        echo "## Create ${user_list[$i]}" >> ${SQL_File}
        for ip in ${ip_list[*]}
        do
            echo "CREATE USER '${user_list[$i]}'@'${ip}' IDENTIFIED BY '${passwd_list[$i]}'; " >> ${SQL_File}
        done
    done
}
### 生成数据库授权语句
function Grant_User()
{
    echo -e "\n# Grant_User" >> ${SQL_File}
    for  ((i=0;i<${#user_list[*]};i++))
    do
        for ((j=0;j<${#ip_list[*]};j++))
        do
            echo -e "\n## '${user_list[i]}@${ip_list[j]}'" >> ${SQL_File}
            for Data_Name in ${database_list[*]}
            do
                echo "GRANT ALL PRIVILEGES ON \`${Data_Name}\`.* TO '${user_list[i]}'@'${ip_list[j]}'; "    >> ${SQL_File}
            done
        done
    done
    echo -e "\nFLUSH PRIVILEGES;" >>  ${SQL_File}

}
## function End

## main 


pre_check  

[ $? -eq 0 ] && Create_Database  || exit 11 

[ $? -eq 0 ] && Crete_User || exit 12 

[ $? -eq 0 ] &&  Grant_User || exit 13 

