# I used ChatGPT to fix a scrolling issue.
# See ChatGPTPrompts.txt file for the list of prompts.

from flask import Flask, render_template, request, session, redirect, url_for

app = Flask(__name__)

@app.route('/')
def main():
    return render_template("pennypulse.html")

if __name__ == '__main__':
    app.run(host="0.0.0.0",debug=True)