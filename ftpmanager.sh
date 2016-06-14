#!/bin/bash
config_path=/work/ftp/vsftpd_config
cd /work/ftp
cat screen.txt
read -p "choose the number £º" caozuo   
case $caozuo in    
0)
read -p "please input the sharing document name:" ftpdocument
read -p "origin user name:" ftpuser
read -p "new user name:" ftpusernew
read -p "new user password:" ftppasswdnew


cd /work/ftp
if [  -d $ftpdocument ]
then
   cd ${config_path}/vuser_conf 
   modifile=`grep -rn $ftpdocument ./$ftpuser`
   if [ ! -f $ftpusernew ] || [ "$ftpusernew"x = "$ftpuser"x ]
   then   
       if [ -f $ftpuser ] && [ -n "$modifile" ] 
       then
       mv $ftpuser $ftpusernew >/dev/null 2>&1
       cd ${config_path}
       num=`cat -n vuser_passwd.txt | grep $ftpuser | awk '{print $1}' | awk 'NR==1{print}'`
       num=$(( $num + 1 ))
       sed -i 's/'"$ftpuser"'/'"$ftpusernew"'/g' vuser_passwd.txt
       sed -i ''"${num}s"'/.*/'"$ftppasswdnew"'/g' vuser_passwd.txt  
       db_load -T -t hash -f /work/ftp/vsftpd_config/vuser_passwd.txt /work/ftp/vsftpd_config/vuser_passwd.db
	   echo "`date` administrator has change the username $ftpuser with newuser $ftpusernew and new password $ftppasswdnew" >> ${config_path}/adminedit.log
       else 
       echo "the origin user is wrong"
       fi
	else
	echo "the user is already in use,input again"
	fi
else
  echo "the sharing document is not exsit"
fi
;;
1)
read -p "please input the sharing document name:" ftpdocument
read -p "user name:" ftpuser
read -p "user password:" ftppasswd
cd /work/ftp
if [ ! -d $ftpdocument ]
then
   mkdir $ftpdocument
   cd /work/ftp/vsftpd_config/vuser_conf
   if [ ! -f $ftpuser ]
   then
   echo $ftpuser>>/work/ftp/vsftpd_config/vuser_passwd.txt
   echo $ftppasswd>>/work/ftp/vsftpd_config/vuser_passwd.txt
   db_load -T -t hash -f /work/ftp/vsftpd_config/vuser_passwd.txt /work/ftp/vsftpd_config/vuser_passwd.db
   cd /work/ftp/vsftpd_config/vuser_conf
   sudo touch $ftpuser
   echo "local_root=/work/ftp/$ftpdocument
write_enable=YES
anon_umask=022
anon_world_readable_only=NO
anon_upload_enable=YES
anon_mkdir_write_enable=YES
anon_other_write_enable=YES">>$ftpuser
echo "`date` administrator has build new focument $ftpdocument with user $ftpuser" >> ${config_path}/adminedit.log
    else
	    cd /work/ftp
		rm -rf $ftpdocument
	    echo "the username is already exist,please input again"
	fi
else
   echo "the sharing document is already exsit,please input again"
fi 
;;
2)
read -p "please input the user name you want to search :" ftpuser
cd ${config_path}
num=`cat -n vuser_passwd.txt | grep $ftpuser | awk '{print $1}' | awk 'NR==1{print}'`
num=$(( $num + 1 ))
cd /work/ftp/vsftpd_config/vuser_conf
   if [  -f $ftpuser ]
   then
   echo "the user password is"
   cd ..
   sed -n ''${num}',1p' vuser_passwd.txt
   echo "the sharing doment name is"
   cd vuser_conf
   cat $ftpuser | awk 'NR==1{print}' | awk -F  "/" '{print $4}'
   else
   echo "the user name is not exist"
   fi
;;
3)
read -p "please input the user name you want to delete (the sharing document will be deleted too) :" ftpuser
cd ${config_path}
num=`cat -n vuser_passwd.txt | grep $ftpuser | awk '{print $1}' | awk 'NR==1{print}'`
cd vuser_conf
if [  -f $ftpuser ]
then
filename=`cat $ftpuser | awk 'NR==1{print}' | awk -F  "/" '{print $4}'`
cd ..
sed -i ''${num}'d' vuser_passwd.txt 
sed -i ''${num}'d' vuser_passwd.txt
cd /work/ftp
rm -rf $filename
cd ${config_path}/vuser_conf
rm -rf $ftpuser
echo "`date` administrator has delete the user $ftpuser" >> ${config_path}/adminedit.log
else
echo "the user name is no exist"
fi
;;
4)
cd ${config_path}/vuser_conf
ls -l | awk '{print $9}'
;;
5)
cd /var/log
cat vsftpd.log
;;
6)
read -p "which user you want to search log :" ftpuser
cd /var/log
cat vsftpd.log | grep $ftpuser
;;
7)
cat ${config_path}/adminedit.log
;;
*) 
        echo "please choose the number again" 
;; 
esac
