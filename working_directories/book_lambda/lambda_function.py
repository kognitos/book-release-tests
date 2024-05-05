def lambda_handler(event, context):
    print("Hello from Lambda!")
    bodyStr = f'Hello from Lambda! IN BODY\n{str(event)}\n{str(context)}'
    print(bodyStr)
    print("MY TEST YUPPY!!!!!!!")
    return {
        'statusCode': 200,
        'body': bodyStr
    }
