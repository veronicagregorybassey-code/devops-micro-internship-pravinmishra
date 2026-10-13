# Sample application code
import os

# Safe usage: retrieve secrets from environment variables
AWS_ACCESS_KEY = os.getenv("AWS_ACCESS_KEY_ID")
AWS_SECRET_KEY = os.getenv("AWS_SECRET_ACCESS_KEY")

def connect_aws():
    # Safe logging: do not print plain-text secrets
    if AWS_ACCESS_KEY:
        print("Successfully retrieved AWS credentials from environment.")
    else:
        print("AWS credentials not set in environment.")