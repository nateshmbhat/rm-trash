#!/bin/bash

# TODO : handle sudo  , handle directories

NOOPERAND=1
NOSUCHFILE=2

TRASHPATH="/home/$USER/.local/share/Trash"
TRASHPATHROOT="/root/.local/share/Trash"

RECURSIVE_FLAG=0
OPTIONAL_ARGS=()
FILE_ARGS=()


usage(){
# $1 = error code ,  $2 = any file or argument name to be shown(like a file name when getting NOSUCHFILE error)
    case $1 in

    "$NOOPERAND")
        echo "$0 : missing operand" ;
        echo "Try '$0 --help' for more information" ;;
    
    "$NOSUCHFILE")
        echo "rm: cannot remove '$2': No such file or directory" ;;

    "$HELP")
        echo "This is the help section which is incomplete" ;;


    *)
        echo "some other parameter";;
    
    esac
}



deleteFromTrash(){
    if [ -e "$TRASHPATH/files/$filebasename" ]; then 
        rm -r "$TRASHPATH/files/$filebasename" ; 
        rm "$TRASHPATH/info/$filebasename.trashinfo"
    fi
}



copyToTrashAndWriteInfo(){

# $1 = relative filepath that is exisiting in the filesystem

echo "Args = $@"
filebasename="$(basename $1)"
filefullpath="$(realpath $1)"
filedirname="$(dirname $filefullpath)"

filename="$1"  # Original filename

copyToTrash(){
    # $1 = relative filepath that is exisiting in the filesystem

    if ! test -e $filename
    then echo $filename does not exist ! ; return 1
    fi

    # start the copy process
    duplicateNumber=0

    while test 1 -eq 1
    do
    echo "duplicate Number = $duplicateNumber"

    # first time try to move to trash
    if test "$duplicateNumber" -eq 0
        then
            if ! test -e "$TRASHPATH/files/$filebasename"
            then
                cp -r "$filename"  "$TRASHPATH/files/$filebasename" -n
                if test $? -eq 0
                    then 
                    return 0 ; 
                else 
                    echo "Error copying the $filename to trash. Trying to move $filename with the name $filename ($duplicateNumber)"
                    return 1 ; 
                fi
            fi

    # if file already present write duplicate filenames followed by duplicate Number
        else
            if ! test -e "$TRASHPATH/files/$filebasename ($duplicateNumber)"
            then
                cp -r "$filename" "$TRASHPATH/files/$filebasename ($duplicateNumber)"
                if test $? -eq 0
                then
                    filebasename="$filebasename ($duplicateNumber)" 
                    filefullpath="$(realpath $filedirname/"$filebasename")"
                    return 0 ; 
                else
                    echo "Error copying the $filename to trash. Trying to move $filename with the name $filename ($duplicateNumber)"
                    return 1 ; 
                fi
            fi
    fi
    
    ((duplicateNumber++))

    done
    }

    writeTrashInfo(){
        #function Depends on variables filefullpath , filebasename
        # The filefullpath can also be modified filename with the duplicate number
        # The filebasename can  also be modified filename with the duplicate number

        trashmsg="[Trash Info]\nPath=$(realpath $filename)\nDeletionDate=$(date -Is)"
        echo -e "$trashmsg" | tee "$TRASHPATH/info/$filebasename.trashinfo"
    }

    copyToTrash  &&  writeTrashInfo  # main calls
}



main(){

    echo "RECURSION : $RECURSIVE_FLAG" ; 
    for file in ${FILE_ARGS[@]}
    do
        if test -e "$file" && test -r "$file"
        then
            if [ -d "$file" -a "$RECURSIVE_FLAG" == "0" ] ; then 
                continue ;
            fi
            copyToTrashAndWriteInfo "$file"
            rm "$OPTIONAL_ARGS" "$file"  || deleteFromTrash
        fi

        if [ ! -e "$file" ];  then
            rm $OPTIONAL_ARGS "$file"
        fi
    done
}


handleArguments(){
    # requires the argument array of the script $@

    if [ $# -eq 0 ] ; then 
        usage 1
        exit 1
    fi

    for arg in $@ ; do 

        if [ "${arg:0:1}" == '-' ] ; then
            OPTIONAL_ARGS+=($arg)
        else 
            FILE_ARGS+=($arg)
        fi

        case "$arg" in 
            '--recursive') RECURSIVE_FLAG=1 ;; 
            '-r') RECURSIVE_FLAG=1 ;;
            '-R') RECURSIVE_FLAG=1 ;;
            *)
                if [ "${arg:0:1}" == '-' -a "${arg:1:1}" != '-' ] ;then
                    for (( i=0; i<${#arg}; i++ )) ; do
                        if [ "${arg:$i:1}" == 'r'  -o  "${arg:$i:1}" == 'R' ] ; then
                            RECURSIVE_FLAG=1 
                        fi
                    done
                fi
        esac
    done

}



handleArguments $@
echo ${OPTIONAL_ARGS[@]}
echo ${FILE_ARGS[@]}
main $@