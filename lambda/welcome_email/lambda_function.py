import json
import os

def lambda_handler(event, context):
    return {
        "statusCode": 200,
        "headers": {"Content-Type": "application/json"},
        "body": json.dumps({
            "message": "welcome_email handler stub",
            "email": os.environ.get("SES_EMAIL", "")
        })
    }
