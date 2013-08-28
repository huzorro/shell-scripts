#!/bin/bash

#tmux new -s session #建立会话
#tmux new -s session -d #在后台建立会话 
#tmux ls #列出会话 
#tmux attach -t session #进入某个会话 
#or
#tmux -S /dir/file #建立会话
#tmux -S /dir/file attach   #进入某个会话 
#tmux -S /dir/file ls #列出会话
#tmux attach -t session -r  or  mux -S /dir/file attach -r #以只读的方式进入会话

#user=student  password=student
USER="student"
PASSWORD="student"
USER_HOME="/home/student"
USER_LOGIN="/usr/bin/login_excute"
TMUX_TMP_FILE="$USER_HOME/tmp"

####add user#####
add_user(){
	
	#add user student or modify
	if id $USER >>/dev/null 2>&1 ;then
		usermod -d $USER_HOME -s $USER_LOGIN $USER 
		echo $USER:$PASSWORD | chpasswd
	else
		useradd -m -s $USER_LOGIN $USER
		echo $USER:$PASSWORD | chpasswd
	fi
}

#modify login_excute file
modify_login_excute(){
	#create login_excute file
	if [ ! -f $USER_LOGIN ];then 
	        touch $USER_LOGIN 
		chmod +x $USER_LOGIN
	## add content ,when student login to excute
		echo -e "#!/bin/bash\ntmux -S $TMUX_TMP_FILE attach -r" > $USER_LOGIN
		chown $USER.$USER $USER_LOGIN
	fi
}

create_tmx_session(){
	add_user
	sleep 1
	modify_login_excute
	sleep 1
	#install tmux
	if ! dpkg -s tmux >>/dev/null 2>&1;then
		apt-get update && apt-get install tmux
	fi

	#It is very important. It make student to login in excuting tmux command
	(sleep 5 && tmux -S /home/student/tmp send "chmod o+w /home/student/tmp" ENTER)&
	#create a tmux session
	tmux -S $TMUX_TMP_FILE 
}

create_tmx_session
