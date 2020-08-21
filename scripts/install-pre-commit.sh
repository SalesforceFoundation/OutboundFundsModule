if [ ! -d node_modules ] || [ \"$(cat .node_hash)\" != \"$(cat yarn.lock | npx hasha)\" ]; 
then 
    . scripts/update-dependencies.sh 
fi
if [ ! -d venv ] || [ \"$(cat .python_hash)\" != \"$(cat requirements.txt | npx hasha)\" ]; 
then 
    . scripts/update-python-dependencies.sh
fi