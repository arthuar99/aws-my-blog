import json
import os

def lambda_handler(event, context):
    return {
        "statusCode": 200,
        "headers": {"Content-Type": "application/json"},
        "body": json.dumps({
            "message": "api_posts handler stub",
            "table": os.environ.get("TABLE_NAME", "")
        })
    }
