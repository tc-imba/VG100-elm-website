from backend import app

@app.route('/api/markdown/<name>', methods=['GET'])
def show_markdown(name):
    return '## %s \n Hello World!' % name
