# RHEL 8 취약점 점검
# VM 생성 이후에 바로 수행해야 함

echo "**************************     START    ******************************"
# U-01
# Root 계정 원격 접속 제한
echo "##############         Root 계정 원격 접속 제한         ##############"
sed -i 's/PermitRootLogin yes/PermitRootLogin no/g' /etc/ssh/sshd_config

# U-02
# 패스워드 복잡성 설정
# ./config_file에서 설정
# minlen = 8
# dcredit = -1
# ucredit = -1
# lcredit = -1
# ocredit = -1

echo "##############          패스워드 복잡성 설정            ##############"
min_opt_count=`cat /etc/security/pwquality.conf | grep minlen | wc -l `
dcre_opt_count=`cat /etc/security/pwquality.conf | grep minlen | wc -l `
ucre_opt_count=`cat /etc/security/pwquality.conf | grep minlen | wc -l `
lcre_opt_count=`cat /etc/security/pwquality.conf | grep minlen | wc -l `
ocre_opt_count=`cat /etc/security/pwquality.conf | grep minlen | wc -l `

if [ -e "/etc/security/pwquality.conf" ] ; then
    if [ "$min_opt_count" -eq 1 ] && [ "$dcre_opt_count" -eq 1 ] && [ "$ucre_opt_count" -eq 1 ] && [ "$lcre_opt_count" -eq 1 ] && [ "$ocre_opt_count" -eq 1 ] ; then
        echo "minlen = 8" >> /etc/security/pwquality.conf
        echo "dcredit = -1" >> /etc/security/pwquality.conf
        echo "ucredit = -1" >> /etc/security/pwquality.conf
        echo "lcredit = -1" >> /etc/security/pwquality.conf
        echo "ocredit = -1" >> /etc/security/pwquality.conf
        #sed -i "s/# ocredit/ocredit = -1/g" /etc/security/pwquality.conf
    fi
fi

# U-45
# su 제한
echo "##############                su - 제한                 ##############"

check_wheel=`ls -al /usr/bin/su | awk '{print $4}'`
if [ "$check_wheel" = "wheel" ] ; then
    chgrp wheel /usr/bin/su
    chmod 4750 /usr/bin/su
fi

# U-46
# 패스워드 최소 길이 제한
echo "##############          패스워드 최소 길이 제한         ##############"
check_min_len=`cat /etc/login.defs | grep -wi pass_min_len | grep -v '\#'`
if [ "$check_min_len" != "8" ] ; then
    sed -i "s/$check_min_len/PASS_MIN_LEN    8/g" /etc/login.defs
fi

# U-47
# 패스워드 최대 사용 기간 설정
echo "##############       패스워드 최대 사용 기간 설정       ##############"
check_max_days=`cat /etc/login.defs | grep -wi pass_max_days | grep -v '\#' | awk '{print $2}'`
check_max_days_opt=`cat /etc/login.defs | grep -wi pass_max_days | grep -v '\#'`
#INT=$((check_max_days))

if [ "$check_max_days" -gt 90 ] ; then
    sed -i "s/$check_max_days_opt/PASS_MAX_DAYS   90/g" /etc/login.defs
fi


# U-48
# 패스워드 최소 사용 기간 설정
echo "##############       패스워드 최소 사용 기간 설정       ##############"
check_min_days=`cat /etc/login.defs | grep -wi pass_min_days | grep -v '\#' | awk '{print $2}'`
check_min_days_opt=`cat /etc/login.defs | grep -wi pass_min_days | grep -v '\#'`

if [ "$check_min_days" -lt 1 ] ; then
    sed -i "s/$check_min_days_opt/PASS_MIN_DAYS   1/g" /etc/login.defs
fi


# U-54
# Session Timeout 600 설정
echo "##############           Session Timeout 설정           ##############"
check_session_timeout_setting=`cat /etc/profile | grep TMOUT`
check_session_timeout_option=`cat /etc/profile | grep TMOUT | awk '{print $2}' | awk -F '=' '{print $2}'`

if [ -n "$check_session_timeout_setting" ] ; then
    if [ "$check_session_timeout_option" -gt 600 ] ; then
       echo "1111"
       sed -i "s/$check_session_timeout_setting/export TMOUT=600/g" /etc/profile
    fi
else
   echo "export TMOUT=600" >> /etc/profile
fi


# U-05
# Root PATH 설정
# $PATH에 "." 또는 ":"이 맨 앞에 존재하는 경우
# 경로변수 사용으로 치환자 @ 사용
echo "##############                PATH 설정                 ##############"
full_str=`cat /root/.bash_profile | grep PATH | head -1 | awk -F '=' '{print $2}'`
semi_str=`cat /root/.bash_profile | grep PATH | head -1 | awk -F '=' '{print $2}' | awk -F ':' '{print $1}'`
first_str_char=`echo "${semi_str:0:1}"`

if [ -z $first_str_char ] ; then
    echo "complete"

elif [ "$first_str_char" = . ] || [ "$first_str_char" = : ] ; then
    new_config=`echo "$full_str" | awk -F ':' '{print substr($0,index($0,$2))}'`
    sed -i "s@PATH="$full_str"@PATH="$new_config"@g" /root/.bash_profile
    echo 111
fi

# U-07
# passwd 파일 644
echo "##############           /etc/passwd 권한 설정          ##############"
chmod 644 /etc/passwd

# U-08
# shadow 파일 400
echo "##############           /etc/shadow 권한 설정          ##############"
chmod 400 /etc/shadow

# U-09
# hosts파일 소유자 root, 600
echo "##############        /etc/hosts 소유자, 권한 설정      ##############"
chown root /etc/hosts
chmod 600 /etc/hosts

# U-10
# xinetd 소유자 root, 600
echo "##############      /etc/xinetd.d 소유자, 권한 설정     ##############"
chown root /etc/xinetd.d
chmod 600 /etc/xinetd.d -R

# U-11
# rsyslog.conf 640
echo "##############    /etc/rsyslog.conf 소유자, 권한 설정   ##############"
chown root /etc/rsyslog.conf
chmod 640 /etc/rsyslog.conf

# U-12
# services 파일 root, 644
echo "##############      /etc/services 소유자, 권한 설정     ##############"
chown root /etc/services
chmod 644 /etc/services

# U-13
# SUID,SGID 설정
echo "##############      /usr/bin/newgrp SID, SGID 설정      ##############"
chmod -s /usr/bin/newgrp

# U-22
# crontab
echo "##############            /etc/cron 권한 설정           ##############"
chmod 640 /etc/cron.*
chmod 640 /etc/crontab

# U-20
# anonymous ftp 접근 불가 설정
# user 삭제하는게 맞는지 모르겠음...
# userdel ftp

# U-22
# crontab 권한 설정
chmod 750 /usr/bin/crontab
chmod 640 /etc/crontab

# U-30
# sendmail 데몬 중지
echo "##############              sendmail 중지               ##############"
is_active=`ps -ef | grep sendmail | grep -v 'grep'`
if [ -n "$is_active" ]; then
    systemctl stop sendmail
fi

# U-72
echo "##############          로그인 경고 문구 설정           ##############"
motd_size=`du -sh /etc/motd | awk '{print $1}'`
issue_size=`du -sh /etc/issue.net  | awk '{print $1}'`

if [ "$motd_size" = 0 ] ; then
   echo "*******************************************************************************"  >> /etc/motd
    echo "*                                                                             *"  >> /etc/motd
    echo "*                       WARNING: Authorized use only                          *"  >> /etc/motd
    echo "*                                                                             *"  >> /etc/motd
    echo "*******************************************************************************"  >> /etc/motd
fi

if [ "$issue_size" = 0 ] ; then
    echo "*******************************************************************************"  >> /etc/issue.net
    echo "*                                                                             *"  >> /etc/issue.net
    echo "*                       WARNING: Authorized use only                          *"  >> /etc/issue.net
    echo "*                                                                             *"  >> /etc/issue.net
    echo "*******************************************************************************"  >> /etc/issue.net
fi

echo "*************************     FINISH    ******************************"

