#!/bin/bash
#脚步目的是为centos6和centos7安装阿里base和eple源
os=`awk '{print $1}' /etc/redhat-release `
os_version=`awk '{print $4}' /etc/redhat-release | awk -F'.' '{print $1}'`

#判断系统是否为centos
if [ ${os} != "CentOS" ]
then
    echo "本脚步只能为Cent6和Cent7安装阿里的yum源"
fi

if !  `rpm -q wget  &>/dev/null `
then
    echo "请安装wget" && exit
fi

#安装base源和eple源
mv /etc/yum.repos.d/CentOS-Base.repo /etc/yum.repos.d/CentOS-Base.repo.backup
if [ ${os_version} = 7 ]
then
    wget -O /etc/yum.repos.d/CentOS-Base.repo http://mirrors.aliyun.com/repo/Centos-7.repo &> /dev/null
    wget -O /etc/yum.repos.d/epel.repo http://mirrors.aliyun.com/repo/epel-7.repo &>/dev/null
elif [ ${os_version} = 6 ]
then
    wget -O /etc/yum.repos.d/CentOS-Base.repo http://mirrors.aliyun.com/repo/Centos-6.repo &> /dev/null
    wget -O /etc/yum.repos.d/epel.repo http://mirrors.aliyun.com/repo/epel-6.repo &>/dev/null
else
    echo "仅支持cent6和cent7"
fi

