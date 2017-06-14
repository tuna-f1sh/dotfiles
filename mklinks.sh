#!/bin/bash

# Get utility functions for script
eval ". utils.sh"

ARG1=${1:-link}

create_symlinks() {
    local i=""
    local sourceFile=""
    local targetFile=""
    local skipQuestions=false

    DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

    # Create empty APIs file if none is present
    if [ ! -e "$HOME/.secrets" ]; then
      echo "Creating empty .secrets file"
      execute "touch $HOME/.secrets"
    fi
    
    for i in $DIR/$ARG1/*; do
        echo $i

        sourceFile="$i"
        if [ $ARG1 == "link" ]; then
          targetFile="$HOME/.$(printf "%s" "$i" | sed "s/.*\/\(.*\)/\1/g")"
        else
          targetFile="$HOME/$ARG1/$(printf "%s" "$i" | sed "s/.*\/\(.*\)/\1/g")"
        fi

        echo $targetFile

        if [ ! -e "$targetFile" ] || $skipQuestions; then
            ask_for_confirmation "Create '$targetFile' link?"
            if answer_is_yes; then

                execute \
                    "ln -fs $sourceFile $targetFile" \
                    "$targetFile → $sourceFile"
            fi

        elif [ "$(readlink "$targetFile")" == "$sourceFile" ]; then
            print_success "$targetFile → $sourceFile"
        else

            if ! $skipQuestions; then

                ask_for_confirmation "'$targetFile' already exists, do you want to overwrite it?"
                if answer_is_yes; then

                    rm -rf "$targetFile"

                    execute \
                        "ln -fs $sourceFile $targetFile" \
                        "$targetFile → $sourceFile"

                else
                    print_error "$targetFile → $sourceFile"
                fi

            fi

        fi

    echo "Dotfile linking complete. Manually create .config folder links"
    done

}

create_symlinks
