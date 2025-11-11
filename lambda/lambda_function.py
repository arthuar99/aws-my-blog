import boto3
import os
from PIL import Image
import io

s3 = boto3.client('s3')

THUMBNAIL_BUCKET = os.environ['THUMBNAIL_BUCKET']  

def lambda_handler(event, context):
   
    for record in event['Records']:
        bucket = record['s3']['bucket']['name']
        key    = record['s3']['object']['key']

       
        response = s3.get_object(Bucket=bucket, Key=key)
        image_content = response['Body'].read()

    
        img = Image.open(io.BytesIO(image_content))
        img.thumbnail((256, 256)) 

      
        buffer = io.BytesIO()
        img.save(buffer, img.format)
        buffer.seek(0)

        thumbnail_key = f"thumbnail-{key}"

     
        s3.put_object(
            Bucket=THUMBNAIL_BUCKET,
            Key=thumbnail_key,
            Body=buffer,
            ContentType=response['ContentType']
        )

        print(f"Thumbnail created: {thumbnail_key} in bucket {THUMBNAIL_BUCKET}")
