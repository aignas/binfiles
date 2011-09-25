#!/bin/bash
#
# Copied over from Uli Schlachter (psychon) and adjusted until it suited my needs.
# Written by Ignas Anikevicius and the code is licensed under GPL v3.

# For every file and dir in ., this scripts checks if a file with .<name>
# exists in ~ and copies it into the current directory

DIR_TO=
DIR_FROM=~/bin/

if [[ -z $1 ]]; then
    utype="repo"
elif [[ "$1" == "repo" || "$1" == "local" ]];then
    utype="$1"
fi
if [[ "$utype" != "repo" ]]; then
    local DIR_TMP="$DIR_FROM"
    DIR_FROM="$DIR_TO"
    DIR_TO="$DIR_TMP"
fi

high_skip="\033[1;33m"
high_unknown="\033[1;37m"
high_update="\033[1;34m"
high_outdate="\033[1;31m"
high_end="\033[0;37m"

update ()
{
    file=${DIR_TO}$@
    base_file=${DIR_FROM}$file

    if [ -f "$base_file" ]
    then
        if diff "$base_file" "$file" > /dev/null; then
            # File did not change
            #echo -e "${high_skip}Skipping${high_end} $file (no changes)"
            return
        else
            if [[ `stat -c %Y $base_file` -lt `stat -c %Y $file` ]]; then
                echo -e "${high_outdate}Skipping${high_end} $file"
                echo -e "        (local copy is different and older than the repo copy)"
                return
            fi
            # Normal files are just copied
            echo -e "${high_update}Updating${high_end} $file" >& 2
            cp -R "$base_file" "$file"
            return
        fi
    fi

    if [ -d "$base_file" ]
    then
        # Dirs are handled recursively
        #echo "Recursively updating $file..."
        update_dir $file/
        return
    fi

    echo -e "${high_unknown}Skipping${high_end} $file (unknown type)"
}


update_dir ()
{
    for file in $@*
    do
        case $file in
            update.sh|README|Rakefile)
                continue
                ;;
        esac

        update "$file"
    done
}

update_dir

echo -e "\033[1mEverything is up to date\033[0m"

# vim: tw=80
