#!/bin/bash
read -p "please input the ftp user name:" ftpuser
read -p "please input the user password:" ftppasswd
read -p "please input the document name you want to get:" ftpdocument
ftp -i -in << !
open 192.168.100.184
user $ftpuser $ftppasswd
passive
bin
mget $ftpdocument
bye
!