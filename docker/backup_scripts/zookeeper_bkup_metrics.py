import os.path
from flask import Flask, make_response
app = Flask(__name__)


def get_metrics():
    gen_metrics = ""
    if os.path.isfile('zookeeper_backup.metrics'):
        with open("zookeeper_backup.metrics", "r") as file:
            content = file.readlines()
            for line in content:
                gen_metrics = gen_metrics + line
    return gen_metrics


@app.route('/metrics')
def metrics():
    response = make_response(get_metrics(), 200)
    response.mimetype = "text/plain"
    return response


if __name__ == "__main__":
    app.run(host="0.0.0.0")
