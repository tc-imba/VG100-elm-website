import os

from backend import app, url_prefix
from flask import send_from_directory

@app.route('%s/api/markdown/<path:name>' % url_prefix, methods=['GET'])
def show_markdown(name):
    markdown_dir = os.path.join(os.path.dirname(app.instance_path), 'markdown')
    return send_from_directory(markdown_dir, name)

