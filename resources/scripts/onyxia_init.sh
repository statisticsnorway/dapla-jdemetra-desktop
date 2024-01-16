nohup python3 -m gcsfuse_token_provider &> "$HOME/.gcsfuse_token_provider.out" &
if [ -n "$GCS_MOUNT_BUCKET" ]; then
  mkdir "$HOME/mnt/$GCS_MOUNT_BUCKET"
  gcsfuse --token-url="http://127.0.0.1:5555/credentials" "$GCS_MOUNT_BUCKET" "$HOME/mnt/$GCS_MOUNT_BUCKET"
fi
echo "execution of $*"
exec "$@" "$INIT_PATH"