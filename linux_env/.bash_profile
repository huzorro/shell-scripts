#-------------------------------------------------------------------------------
#   \e[    --- again color
#   x;ym   --- code color 
#       black 0;30
#       blue  0;34
#       green 0;32
#       cyan  0;36
#       red   0;31
#       purple 0;35
#       brown  0;33
#   \e[m   --- end color
#-------------------------------------------------------------------------------
STARTCOLOR='\e[0;32m';
#STARTGCOLOR="\e[44m"
ENDCOLOR="\e[0m"

#histtimeformat
export HISTTIMEFORMAT='%F %T| '
#histsize
export HISTSIZE=2000
#ignoredups
#HISTCONTROL=ignoredups
#all history ignoredups
export HISTCONTROL=erasedups
#ignorespace head command 
#export HISTCONTROL=ignorespace
#histignore
export HISTIGNORE="pwd:ls: "

#cd w<tab><tab> will ignore W.. w..
bind "set completion-ignore-case on"

#terminal colors
alias ls="ls --color=auto"


function dir_files_sizes ()
{
for filesize in $(ls -l . | grep "^-" |awk '{print $5}')
do
    let totalsize=$totalsize+$filesize
done
echo -n "$totalsize"
}    # ----------  end of function dir_files_sizes  ----------

function get_progress_num ()
{
    ps aux |grep $1| grep -v grep | wc -l
}    # ----------  end of function get_progress_num  ----------

function ps1 (){
    export PS1="$STARTCOLOR$STARTGCOLOR\u\h \w [\t]\\$ $ENDCOLOR"
    
    #PS4 the scripts output format
    export PS4='$(date) $0.$LINENO++'
    
    #automatically correct mistyped Directory nmaes.
    shopt -s cdspell
}

function ps2 (){
    export PS1="$STARTCOLOR$STARTGCOLOR\u\h \w [\t](`get_progress_num $1`)\\$ $ENDCOLOR"
}


function ps3 ()
{
    export PS1="$STARTCOLOR$STARTGCOLOR\u\h \w [\t](`dir_files_sizes` bytes)\\$ $ENDCOLOR"
}    # ----------  end of function ps3----------

function psgrep ()
{
    ps aux| grep "$1" |grep -v grep
}    # ----------  end of function psgrep  ----------

function psterm ()
{
    [ ${#} -eq 0 ] && echo "Usage: $FUNCNAME STRING" && return 0
    local pid
    pid=`ps ax |grep "$1" |grep -v grep |awk '{print $1}'|xargs`
    echo -e "terminating $1 / process(es):\n$pid"
    kill -SIGKILL $pid
}    # ----------  end of function psterm  ----------
