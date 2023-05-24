# !/bin/sh

set -e

# ls -la /app/staticfiles/
# ls -la /app/static/
ls -la staticfiles/
ls -la static/

whoami


# echo "Waiting for MySQL"
# until echo '\q' | mysql -h"$DB_HOST" --port "$DB_PORT" -uroot -p"$DB_PASSWORD" --protocol=TCP $DB_NAME; do
#     >&2 echo "MySQL is unavailable - Sleeping..."
#     sleep 2
# done

# echo -e "\nMySQL ready!"

echo "Running Release Tasks"

# python manage.py wait_for_db
# python manage.py collectstatic --noinput

echo "Running Database migrations and migrating the new changes"
python manage.py makemigrations 
# python manage.py makemigrations api

python manage.py migrate --plan
python manage.py migrate --noinput

echo "Running Server"
# python manage.py createsuperuser --noinput
# uwsgi --socket :8000 --workers 4 --master --enable-threads --module app.wsgi
gunicorn --chdir app wsgi:application --log-file - --log-level debug

echo "Done.."