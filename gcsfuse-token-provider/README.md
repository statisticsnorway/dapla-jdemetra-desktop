# gcsfuse token provider
This Flask application provides a simple endpoint (/credentials) for fetching Google credentials using [dapla-toolbelt](https://github.com/statisticsnorway/dapla-toolbelt).
It's designed to integrate with gcsfuse, a tool that allows you to mount GCS buckets as a file system.

## Example
**Run the API**:
```python3 -m gcsfuse_token_provider```

**Use with gcsfuse**:
```gcsfuse --token-url="http://127.0.0.1:5000/credentials" your-bucket-name /path/to/mount```