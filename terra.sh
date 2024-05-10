#!/bin/bash

if [ $# -eq 0 ]; then
    echo "Usage: $0 [terraform_command]"
    exit 1
fi

allowed_commands=("init" "validate" "apply" "plan" "destroy")
[[ "$1" = "apply" ]] && additional_flags="-auto-approve" || additional_flags=""

# us-west-2.console.aws.amazon.com/lambda/home?region=us-west-2#/functions/mati-test-lambda?tab=code

# Check if the provided command is in the collection
case "${allowed_commands[@]}" in
    *"$1"*)
        if [[ "$1" = "init" ]]; then
            terraform -chdir=./working_directories/book_lambda init \
                -backend-config="key=book_lambda.tfstate" \
                -backend-config="bucket=mati-test-terraform-bucket"
        elif [[ "$1" = "destroy" ]]; then
            terraform -chdir=./working_directories/book_lambda "$1" \
                $additional_flags
        else
            terraform -chdir=./working_directories/book_lambda "$1" \
                $additional_flags
        fi
        ;;
    *)
        echo "Usage: $0 [${allowed_commands[@]}]"
        exit 1
        ;;
esac
