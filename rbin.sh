#!/bin/bash

#-------------- How to use -----------------#
# 1 move this file to /usr/bin
# 2 sudo chmod 777 /usr/bin/rbin.sh
# 3 re-open terminal
# 4 you should install fontawesome
#-------------------------------------------#

#------------ COLOR TERMINAL ------------
#Black        0;30     Dark Gray     1;30
#Red          0;31     Light Red     1;31
#Green        0;32     Light Green   1;32
#Brown/Orange 0;33     Yellow        1;33
#Blue         0;34     Light Blue    1;34
#Purple       0;35     Light Purple  1;35
#Cyan         0;36     Light Cyan    1;36
#Light Gray   0;37     White         1;37
#----------------------------------------


#-------------------------------- Update -------------------------------------------------------------------#
#-------+---------------------------------------------------------------------------------------------------#
#  Ver  |   Detail                                                                                          |
#-------+---------------------------------------------------------------------------------------------------#
#  1.1  | - Show Detail when disable/enable font awesome by run sudo rm -f {value}                          |
#-------+---------------------------------------------------------------------------------------------------#
#  1.2  | - use "rm -u" or "rm -user" to show current user                                                  |
#-------+---------------------------------------------------------------------------------------------------#
#       | - No Init require when first start                                                                |
#  2.0  | - Change config file from /var/config to ~/.local/rbin/config                                     |
#       | - Remove "init" argument                                                                          |
#-------+---------------------------------------------------------------------------------------------------#
#  2.1  | - Change config file from "~/.local/rbin/.rbinrc" to "~/.local/rbin/config"                       |
#-------+---------------------------------------------------------------------------------------------------#
#  2.2  | - Add Details to help (-h)                                                                        |
#-------+---------------------------------------------------------------------------------------------------#
#  2.3  | - Fixed color bug. when delete failed (rm -c)                                                                        |
#-------+---------------------------------------------------------------------------------------------------#

VERSION="2.3"


#COLOR VAR
C_DIR='\033[1;34m'
C_FILE='\033[1;37m'
C_NUM='\033[1;35m'
C_NC='\033[0m'
C_OK='\033[1;32m'
C_FAIL='\033[1;31m'

#Get Logined User
CURRENTUSER=$(who | cut -d' ' -f1)

#Variable
ROOT="/home/$CURRENTUSER/.local/.rbin"
CONFIG_FILE="/home/$CURRENTUSER/.config/rbin/config"
CONFIG_DIR="/home/$CURRENTUSER/.config/rbin/"

#Config KEY
CONF_K_FONT="ENABLE_FONT"

ITEM_LIST=()


# Decleare Function
End()
{
    echo ""
    exit 1
}

CheckInit()
{
    #Check if no config, and generate it
    if [ ! -f $CONFIG_FILE ]; then
        if [ ! -d $CONFIG_DIR ]; then
            mkdir -p $CONFIG_DIR
        fi
        echo "#Enable Font Awesome" >> $CONFIG_FILE
        echo "$CONF_K_FONT=1" >> $CONFIG_FILE
    fi

    #Read Config
    source $CONFIG_FILE

    #Font Enable
    if [ "$ENABLE_FONT" == "1" ]; then
        I_DIR="${C_DIR}\xef\x81\xbc${C_NC}"
        I_FILE="${C_FILE}\xef\x85\x9c${C_NC}"
        I_DIR2="${C_DIR}\xef\x81\xbc${C_NC}"
        I_FILE2="${C_FILE}\xef\x85\x9c${C_NC}"
        I_LINE="${C_DIR}\xef\x81\xa8\xef\x81\xa8\xef\x81\xa8\xef\x81\xa8\xef\x81\xa8\xef\x81\xa8\xef\x81\xa8\xef\x81\xa8\xef\x81\xa8\xef\x81\xa8\xef\x81\xa8\xef\x81\xa8${C_NC}"
        I_OK="${C_OK}\xef\x81\x98${C_NC}"
        I_FAIL="${C_FAIL}\xef\x81\x97${C_NC}"
        I_ARROW="${C_DIR}\xef\x85\xb8${C_NC}"
        I_BIN="${C_DIR}\xef\x87\xb8${C_NC}"
        I_EMTYPE="${C_FAIL}\xef\x87\xb8${C_NC}"
        I_SP="\xef\x83\x9a"

    else
        I_DIR="${C_DIR}Dir${C_NC}"
        I_FILE="${C_FILE}File${C_NC}"
        I_DIR2="${C_DIR}+${C_NC}"
        I_FILE2="${C_FILE}-${C_NC}"
        I_LINE="${C_DIR}-------------------${C_NC}"
        I_OK="${C_FILE}[ ${C_OK}OK ${C_FILE}]${C_NC}"
        I_FAIL="${C_FILE}[${C_FAIL}FAIL${C_FILE}]${C_NC}"
        I_ARROW="${C_DIR}->${C_NC}"
        I_BIN="${C_DIR}Bin${C_NC}"
        I_EMTYPE="${C_FAIL}Error${C_NC}"
        I_SP=":"
    fi
}

#Method to Check if array exist
ArrayExist() {
    local seeking=$1; shift
    local in=1
    for element; do
        if [[ "$element" == "$seeking" ]]; then
            in=0
            break
        fi
    done
    return $in
}

#Get all file in bin by order: hidden folder -> hidden file -> folder -> file
GetAllFile()
{
    ITEM_LIST=()

    #Get All Hidden Folder
    FILES="$ROOT/.[^.]*/"
    for entry in $FILES
    do
        if [ -e $entry ]; then
            ITEM_LIST+=("$entry")
        fi
    done

    #Get All Hidden File
    FILES="$ROOT/.[^.]*"
    for entry in $FILES
    do
        ArrayExist "$entry/" "${ITEM_LIST[@]}" && HAVE=1 || HAVE=0 
        if [ $HAVE -eq 0 ]; then
            if [ -e $entry ]; then
                ITEM_LIST+=("$entry")
            fi
        fi

    done

    #Get All Unhidden Folder
    FILES="$ROOT/[^.]*/"
    for entry in $FILES
    do
        if [ -e $entry ]; then
            ITEM_LIST+=("$entry")
        fi
    done

    #Get All Unhidden File 
    FILES="$ROOT/[^.]*"
    for entry in $FILES
    do
        ArrayExist "$entry/" "${ITEM_LIST[@]}" && HAVE=1 || HAVE=0 
        if [ $HAVE -eq 0 ]; then
            if [ -e $entry ]; then
                ITEM_LIST+=("$entry")
            fi
        fi
    done
}

ShowHelp()
{
    echo -e " ${C_DIR}Render font with FontAwesome or with Normal Text${C_NC}"
    echo -e " ${C_OK}Enable Font: sudo rbin.sh -f {VALUE}${C_NC}"
    echo -e "          Ex. sudo rbin.sh -f 0"
    echo -e "          Ex. sudo rbin.sh -f 1"
    echo -e ""
    echo -e " ${C_DIR}Show all file in Recycle bin${C_NC}"
    echo -e " ${C_OK}List(Short): rbin.sh -L${C_NC}"
    echo -e ""
    echo -e " ${C_DIR}Show all file in Recycle bin with Date and Time${C_NC}"
    echo -e " ${C_OK}List (Long): rbin.sh -l${C_NC}"
    echo -e ""
    echo -e " ${C_DIR}Remove file to Recycle bin${C_NC}"
    echo -e "      ${C_OK}Remove: rbin.sh {FILE}${C_NC}"
    echo -e "          Ex. rbin.sh file1.txt file2.txt file3.txt"
    echo -e "          Ex. rbin.sh *"
    echo -e ""
    echo -e " ${C_DIR}Restore file from Recycle bin to path${C_NC}"
    echo -e "     ${C_OK}Restore: rbin.sh -r {INDEX} {TARGET}${C_NC}"
    echo -e "          Ex. rbin.sh -r 0,1,2 ~/bar"
    echo -e "          Ex. rbin.sh -r . ~/bar"
    echo -e ""
    echo -e " ${C_DIR}Delete file from path${C_NC}"
    echo -e "      ${C_OK}Delete: rbin.sh -d {FILE}${C_NC}"
    echo -e "          Ex. rbin.sh -d file1.txt file2.txt"
    echo -e "          Ex. rbin.sh -d *"
    echo -e ""
    echo -e " ${C_DIR}Delete file from Recycle bin${C_NC}"
    echo -e "       ${C_OK}Clean: rbin.sh -c {INDEX}${C_NC}"
    echo -e "          Ex. rbin.sh -c 0,1,2"
    echo -e ""
    echo -e " ${C_DIR}Show Recycle bin's size${C_NC}"
    echo -e "        ${C_OK}Size: rbin.sh -s${C_NC}"
    echo -e ""
    echo -e " ${C_DIR}Show current version${C_NC}"
    echo -e "     ${C_OK}Version: rbin.sh -v${C_NC}"
    echo -e ""
    echo -e " ${C_DIR}Show current user${C_NC}"
    echo -e "${C_OK}Current User: rbin.sh -u${C_NC}"
}

SetFont()
{
    #Check if null
    if [[ $ENABLE_FONT = "" ]]; then
        echo "ENABLE_FONT=$2" >> $CONFIG_FILE
    else
        sed -i "s/\($CONF_K_FONT *= *\).*/\1$2/" $CONFIG_FILE
    fi

    if [ "$2" == "1" ]; then
        echo -e "${C_OK}Enable ${C_FILE}Font Awesome"
    else
        echo -e "${C_FAIL}Disable ${C_FILE}Font Awesome"
    fi
}

ListFile()
{
    if [ ! "$(ls -A $ROOT)" ]; then
        echo -e "${I_EMTYPE} ${C_FAIL}No Item in recycle bin"
    else
        ITEM_DIR=0
        ITEM_FILE=0
        COUNT_NUM=0

        GetAllFile

        #Check Count
        for entry in ${ITEM_LIST[@]}
        do
            if [ -d $entry ]; then
                ((ITEM_DIR++))
            else
                ((ITEM_FILE++))
            fi
        done

        echo -e "${I_LINE}"
        echo -e "${I_DIR}  ${C_DIR}$ITEM_DIR ${C_NC}  ${I_FILE}  ${C_FILE}$ITEM_FILE" ${C_NC}
        echo -e "${I_LINE}"

        #Sorting
        for entry in ${ITEM_LIST[@]}
        do
            FILENAME=""
            if [ -d $entry ]; then
                if [ "$1" == "-L" ]; then
                    FILENAME="$(stat -c %y "$entry" | cut -d'.' -f1) ${I_SP} $(basename "$entry")/"
                else
                    FILENAME="$(basename "$entry")/"
                fi
                echo -e ${C_NUM}$COUNT_NUM". "${C_DIR}$FILENAME ${C_NC}
            else
                if [ "$1" == "-L" ]; then
                    FILENAME="$(stat -c %y "$entry" | cut -d'.' -f1) ${I_SP} $(basename "$entry")"
                else
                    FILENAME="$(basename "$entry")"
                fi
                echo -e ${C_NUM}$COUNT_NUM". "${C_FILE}$FILENAME ${C_NC}
            fi
            ((COUNT_NUM++))
        done
    fi
}

RestoreFile()
{
    cd $PWD
    if [ "$3" == "" ]; then
        FULL_PATH="$(readlink -m ".")"
    else
        LAST="${@: -1}"
        FULL_PATH="$(readlink -m $LAST)"
    fi

    GetAllFile

    #if second parameter == *, will do all 
    if [ "$2" == "." ]; then
        COUNT=0
        TOTAL=""
        for i in "${ITEM_LIST[@]}"
        do
            TOTAL="$TOTAL$COUNT"
            if [ "$COUNT" != "$((${#ITEM_LIST[@]} - 1))" ]; then
                TOTAL="$TOTAL,"
            fi
            ((COUNT++))
        done
        OIFS=$IFS
        IFS=','
        INPUT=$TOTAL
    elif [ "$2" == "" ]; then
        echo -e "${I_FAIL} ${C_FAIL}parameter is not correct (see -h)"
        End
    else
        OIFS=$IFS
        IFS=','
        INPUT=$2
    fi

    #Restore It
    echo -e "${I_BIN} ${I_ARROW} ${I_DIR}  ${C_FILE}$FULL_PATH${C_NC}"
    if [ -d $FULL_PATH ]; then
        for i in $INPUT
        do
            regex='^[0-9]+$'
            if [[ $i =~ $regex ]] ; then
                if [ $(($i)) -lt ${#ITEM_LIST[@]} ]; then
                    ENDLINE=""
                    mv ${ITEM_LIST[$i]} $FULL_PATH &> /dev/null
                    if [ -d "${ITEM_LIST[$i]}" ]; then
                        ENDLINE="/"
                    fi

                    if [ $? -eq 0 ]; then
                        echo -e "${I_OK} ${C_OK}Restore: $(basename ${ITEM_LIST[$i]})$ENDLINE" 
                    else
                        echo -e "${I_FAIL} ${C_FAIL}Restore: $(basename ${ITEM_LIST[$i]})$ENDLINE" 
                    fi
                else
                    echo "Index " $i " out of length"
                fi

            else
                echo $i " is not number."
            fi
        done
    else
        echo "${I_FAIL} ${C_FAIL}No directory exist"
    fi

    IFS=OIFS
}

CleanFile()
{
    cd $PWD

    GetAllFile

    #if no second parameter, will do all 
    if [ "$2" == "" ]; then
        COUNT=0
        TOTAL=""
        for i in "${ITEM_LIST[@]}"
        do
            TOTAL="$TOTAL$COUNT"
            if [ "$COUNT" != "$((${#ITEM_LIST[@]} - 1))" ]; then
                TOTAL="$TOTAL,"
            fi
            ((COUNT++))
        done
        OIFS=$IFS
        IFS=','
        INPUT=$TOTAL
    else
        OIFS=$IFS
        IFS=','
        INPUT=$2
    fi

    #Restore It
    echo -e "${C_NUM}List of file(s) will delete from recycle bin"

    #Show List file will delete
    for i in $INPUT
    do
        regex='^[0-9]+$'
        if [[ $i =~ $regex ]] ; then
            if [ $(($i)) -lt ${#ITEM_LIST[@]} ]; then
                if [ -d ${ITEM_LIST[$i]} ]; then
                    echo -e "${I_DIR2} ${C_DIR}$(basename ${ITEM_LIST[$i]})/" ${C_NC}
                else
                    echo -e "${I_FILE2} ${C_FILE}$(basename ${ITEM_LIST[$i]})" ${C_NC} 
                fi
            else
                echo -e "${I_FAIL} ${C_FAIL}index $i out of length"
            fi

        else
            echo -e "${I_FAIL} ${C_FAIL}$i is not number"
        fi
    done

    #Read Input yes or no
    echo ""
    read -p "Do you want to delete? [y=yes, other=no]: " RESULT 

    #if no input
    if [[ $RESULT = "" ]]; then
        echo ""
        echo -e "${I_FAIL} ${C_FAIL}Canceled"
        End
    fi

    #if inputed
    if [ $RESULT == "y" ] || [ $RESULT == "Y" ] || [ $RESULT == "yes" ] || [ $RESULT == "YES" ]; then
        echo ""
        echo -e "${I_BIN} ${C_DIR}Delete file(s)"
    else
        echo ""
        echo -e "${I_FAIL} ${C_FAIL}Canceled"
        End
    fi

    #Deleting
    for i in $INPUT
    do
        regex='^[0-9]+$'
        if [[ $i =~ $regex ]] ; then
            if [ $(($i)) -lt ${#ITEM_LIST[@]} ]; then
                rm -rf ${ITEM_LIST[$i]} &> /dev/null
                if [ $? -eq 0 ]; then
                    echo -e "${I_OK} ${C_OK}Delete: $(basename ${ITEM_LIST[$i]})" 
                else
                    echo -e "${I_FAIL} ${C_FAIL}Delete: $(basename ${ITEM_LIST[$i]})" 
                fi
            else
                echo -e "${I_FAIL} index ${C_FAIL}$i out of length"
            fi

        else
            echo -e "${I_FAIL} ${C_FAIL}$i is not number"
        fi
    done
    IFS=OIFS

}

RemoveFile()
{
    cd $PWD
    for var in "$@"
    do
        mv  $var $ROOT &> /dev/null
        if [ $? == 0 ]; then
            echo -e "${I_OK} ${C_OK}Remove $var successfully"
        else
            NAME=$(basename $var)
            ERROR=""
            if [ ! -e $var ]; then
                mRROR="[No Exist]"
            elif [ -d "$ROOT/$NAME" ] || [ -f "$ROOT/$NAME" ]; then
                ERROR="[Overwrite]"
            fi

            echo -e "${I_FAIL} ${C_FAIL}Remove $var failed $ERROR"
        fi
    done
}

DeleteFile()
{
    cd $PWD
    echo -e "${C_NUM}List File(s) will delete from path${C_NC}"
    for var in "$@"
    do
        if [ "$var" != "-d" ] && [ -e $var ]; then
            if [ -d $var ]; then
                echo -e "${I_DIR2} ${C_DIR}$var/${C_NC}"
            else
                echo -e "${I_FILE2} ${C_FILE}$var${C_NC}"
            fi
        fi
    done
    echo ""

    read -p "Do you want to delete? [y=yes, other=no]: " RESULT 

    #if no input
    if [[ $RESULT = "" ]]; then
        echo ""
        echo -e "${I_FAIL} ${C_FAIL}Canceled"
        End
    fi

    #if inputed
    if [ $RESULT == "y" ] || [ $RESULT == "Y" ] || [ $RESULT == "yes" ] || [ $RESULT == "YES" ]; then
        echo ""
        echo -e "${I_BIN} ${C_DIR}Delete file(s)"
    else
        echo ""
        echo -e "${I_FAIL} ${C_FAIL}Canceled"
        End
    fi

    for var in "$@"
    do
        if [ "$var" != "-d" ]; then
            rm -rf $var &> /dev/null
            if [ $? == 0 ]; then
                echo -e "${I_OK} ${C_OK}Delete $var successfully"
            else
                ERROR=""
                if [ ! -e $var ]; then
                    ERROR="[No Exist]"
                fi

                echo -e "${I_FAIL} ${C_FAIL}Delete $var failed $ERRPR"
            fi
        fi
    done
}


#==================== MAIN ========================#

CheckInit


#if no bin folder, make it
if [ ! -d $ROOT ]; then
    mkdir -p $ROOT &> /dev/null
fi


if [ "$1" == "" ] || [ "$1" == "-h" ] || [ "$1" == "-help" ] || [ "$1" == "--h" ] || [ "$1" == "--help" ]; then
    ShowHelp
elif [ "$1" == "-l" ] || [ "$1" == "-L" ]; then
    ListFile $1
elif [ "$1" == "-r" ] || [ "$1" == "-restore" ]; then
    RestoreFile $1 $2 $3
elif [ "$1" == "-c" ] || [ "$1" == "-clean" ]; then
    CleanFile $1 $2
elif [ "$1" == "-d" ] || [ "$1" == "-delete" ]; then
    DeleteFile $@
elif [ "$1" == "-s" ]; then
    echo -e "${C_DIR}Total size is ${C_FILE}$(du -hs $ROOT | cut -f1)"
elif [ "$1" == "-f" ] || [ "$1" == "-font" ]; then
    SetFont $1 $2
elif [ "$1" == "-v" ] || [ "$1" == "-version" ]; then
    echo "[RBin] version: " $VERSION
elif [ "$1" == "-u" ] || [ "$1" == "-user" ]; then
    echo -e "${C_FILE}Current user is ${C_OK}"$CURRENTUSER
else
    RemoveFile $@
fi

echo ""

