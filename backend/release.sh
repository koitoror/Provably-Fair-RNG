# !/bin/sh

set -e

whoami

# alias python3.9 available in vercel
alias python='python3.9'

# Update pip
python -m pip install --upgrade pip
# Install requirements
pip install -r requirements.txt

# Collect Static Files on Deploy
python manage.py collectstatic

echo "Running Database migrations and migrating the new changes"
python manage.py makemigrations 

python manage.py migrate --plan
python manage.py migrate --noinput


echo "Running Server"
gunicorn --chdir app wsgi:application --log-file - --log-level debug

echo "Done.."
