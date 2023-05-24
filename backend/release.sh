# !/bin/sh

set -e

whoami


echo "Running Database migrations and migrating the new changes"
python manage.py makemigrations 

python manage.py migrate --plan
python manage.py migrate --noinput


echo "Running Server"
gunicorn --chdir app wsgi:application --log-file - --log-level debug


echo "Done.."