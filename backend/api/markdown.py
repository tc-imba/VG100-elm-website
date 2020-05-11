import os

from backend import app
from flask import send_from_directory

@app.route('/api/markdown/<path:name>', methods=['GET'])
def show_markdown(name):
    #name = name.replace('/', '.')
    markdown_dir = os.path.join(os.path.dirname(app.instance_path), 'markdown')
    #content = ''
    #with open(markdown_file) as f:
    #    return f.

    #print(markdown_dir)
    return send_from_directory(markdown_dir, name)

