#!/bin/bash

NOOPERAND=1
NOSUCHFILE=2

TRASHPATH="/home/$USER/.local/share/Trash"
TRASHPATHROOT="/root/.local/share/Trash"

usage(){
# $1 = error code ,  $2 = any file or argument name to be shown(like a file name when getting NOSUCHFILE error)
    case $1 in

    $NOOPERAND)
        echo "$0 : missing operand" ;
        echo "Try '$0 --help' for more information" ;;
    
    $NOSUCHFILE)
        echo "rm: cannot remove '$2': No such file or directory" ;;
    *)
        echo something else ;;
    esac
}




copyToTrashAndWriteInfo(){

# $1 = relative filepath that is exisiting in the filesystem

echo "Args = $@"
filebasename=$(basename $1)
filefullpath=$(realpath $1)
filedirname=$(dirname $filefullpath)

filename=$1

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
    set -x

    # first time try to move to trash
    if test $duplicateNumber -eq 0
        then
            if ! test -e "$TRASHPATH/files/$filebasename"
            then
                cp "$filename"  "$TRASHPATH/files/$filebasename" -n
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
                cp $filename "$TRASHPATH/files/$filebasename ($duplicateNumber)"
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
    set +x

    done
    }

    writeTrashInfo(){
        # Depends on filefullpath , filebasename
        # The filefullpath can also be modified filename with the duplicate number
        # The filebasename can  also be modified filename with the duplicate number

        trashmsg="[Trash Info]\nPath=$(realpath $filename)\nDeletionDate=$(date -Is)"
        echo -e $trashmsg | tee "$TRASHPATH/info/$filebasename.trashinfo"
    }

    copyToTrash  &&  writeTrashInfo  # main calls
}


main(){
    for file in $@
    do
        if test -e $file && test -r $file
        then
            copyToTrashAndWriteInfo $file
        fi
    done
}


copyToTrashAndWriteInfo f8