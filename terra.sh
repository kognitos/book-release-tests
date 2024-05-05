#!/bin/bash

if [ $# -eq 0 ]; then
    echo "Usage: $0 [terraform_command]"
    exit 1
fi

allowed_commands=("init" "validate" "apply" "plan" "destroy")
book_version="1_0_1"
lambda_role_name="mati_test_lambda_role"
[[ "$1" = "apply" ]] && additional_flags="-auto-approve" || additional_flags=""

# us-west-2.console.aws.amazon.com/lambda/home?region=us-west-2#/functions/mati-test-lambda-1_0_0?tab=code

# Check if the provided command is in the collection
case "${allowed_commands[@]}" in
    *"$1"*)
        if [[ "$1" = "init" ]]; then
            terraform -chdir=./working_directories/initial_configuration init
            terraform -chdir=./working_directories/book_lambda init \
                -backend-config="key=$book_version.book_lambda.tfstate"
        elif [[ "$1" = "destroy" ]]; then
            terraform -chdir=./working_directories/book_lambda "$1" \
                -state=./$book_version.book_lambda.tfstate \
                -var book_version=$book_version \
                -var lambda_role_name=$lambda_role_name \
                $additional_flags
            terraform -chdir=./working_directories/initial_configuration "$1" \
                -state=./role_configuration.tfstate \
                -var lambda_role_name=$lambda_role_name \
                $additional_flags
        else
            # terraform -chdir=./working_directories/initial_configuration "$1" -state=./role_configuration.tfstate -var lambda_role_name=$lambda_role_name $additional_flags
            # terraform -chdir=./working_directories/book_lambda "$1" -state=./$book_version.book_lambda.tfstate -var book_version=$book_version -var lambda_role_name=$lambda_role_name $additional_flags
            terraform -chdir=./working_directories/initial_configuration "$1" \
                -var lambda_role_name=$lambda_role_name \
                $additional_flags
            terraform -chdir=./working_directories/book_lambda "$1" \
                -var book_version=$book_version \
                -var lambda_role_name=$lambda_role_name \
                $additional_flags
        fi
        ;;
    *)
        echo "Usage: $0 [${allowed_commands[@]}]"
        exit 1
        ;;
esac
