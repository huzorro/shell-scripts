自动化运维时遇到的一些交互输入问题解决：（下面可以根据需要嵌入到shell脚本中）

1.Automatic installation apt-get install -y mysql
 在ubuntu上apt-get -y install mysql-server 需要手动输入password，自动输入方法有两种：

##Method One
 export DEBIAN_FRONTEND=noninteractive
 apt-get -q -y install mysql-server
##then change password:
 mysqladmin -u root password mysecretpasswordgoeshere

##Method Two 
 debconf-set-selections <<< 'mysql-version mysql-server/root_password password redhat'
 debconf-set-selections <<< 'mysql-version mysql-server/root_password_again password redhat'
 apt-get -y install mysql-server
 ##such as： mysql-version=mysql-server-5.1

2.非交互式apt-get install msttcorefonts
 echo ttf-mscorefonts-installer msttcorefonts/accepted-mscorefonts-eula select true| debconf-set-selections
 apt-get -y install msttcorefonts

3.expect使用
使用第一次svn checkout 代码，需要交互是输入，比如我们写更新脚本不想执行更新时有输入，解决方法在shell脚本中嵌入expect脚本
expect_func(){
               expect << EOF
                set timeout 1000  #设置超时时间，要大于spawn后的命令执行时间
                spawn svn co $SVN_URL --username $SVN_USERNAME --password $SVN_PASSWORD -r $SVN_VERSION"
                expect {
                 "(p)" { send "p\r";exp_continue}
                 "(yes/no)" { send "yes\r";exp_continue}
                 "cancel:" { send "yes\r";exp_continue}
                }
EOF
}

