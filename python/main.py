import json
import os
import boto3

from datetime import datetime

cold_start = time.time()

def is_prime(n):
    if n <= 1:
        return False

    for i in range(2, int(n**0.5) + 1):
        if n % i == 0:
            return False

    return True

def lambda_handler(event, context):
    N = int(os.environ['N'])
    
    bucket_name = os.environ['BUCKET_NAME']
    start_time = datetime.utcnow()
    
    is_prime(N)
    end_time = datetime.utcnow()

    result = {
        "language": "Python",
        "cold_started_at": cold_start.isoformat(),
        "warm_started_at": start_time.isoformat(),
        "finished_at": end_time.isoformat(),
        "cold_elapsed_time": str(end_time - cold_start),
        "warm_elapsed_time": str(end_time - start_time),
        "n": N
    }

    s3 = boto3.client('s3')
    s3.put_object(Bucket=bucket_name, Key='result_python.json', Body=json.dumps(result))

    return f"Dados salvos no S3: {result}"