from flask import Flask
from dapla import AuthClient

app = Flask(__name__)

@app.route('/credentials', methods=['GET'])
def get_credentials():
    credentials = AuthClient.fetch_google_credentials()
    credentials = {"access_token": credentials.token}
    return credentials

if __name__ == '__main__':
    app.run(host='127.0.0.1', port=5555)