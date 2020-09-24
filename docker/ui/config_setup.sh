#!/bin/sh

# Create a postfix mail server if an admin email address
# was supplied as an environment variable.
if [ -n "${ADMIN_EMAIL}" ];
then
  debconf-set-selections < "postfix postfix/mailname string your.hostname.com" && \
  debconf-set-selections < "postfix postfix/main_mailer_type string 'Internet Site'"
  DEBIAN_FRONTEND=noninteractive apt-get install -y postfix mailutils

  cat <<- EOF > /etc/postfix/main.cf
  myhostname = $hostname
  mailbox_size_limit = 0
  recipient_delimiter = +
  inet_interfaces = localhost
EOF
  service postfix restart;
fi

## Datacube connection settings
echo "\
[datacube] \n\
db_hostname: ${DB_HOSTNAME} \n\
db_database: ${DB_DATABASE} \n\
db_username: ${DB_USER} \n\
db_password: ${DB_PASSWORD} \n" > config/.datacube.conf \
    && cp config/.datacube.conf /etc/.datacube.conf \
    && mkdir -p /home/localuser/Datacube/data_cube_ui/config/ \
    && mkdir -p /home/${USER}/Datacube/data_cube_ui/config/ \
    && cp config/.datacube.conf /home/localuser/Datacube/data_cube_ui/config/.datacube.conf \
    && cp config/.datacube.conf /home/${USER}/Datacube/data_cube_ui/config/.datacube.conf

## Postgres pgpass configuration.
## https://github.com/ceos-seo/data_cube_ui/blob/72dd9eb05d7c6747892ef8d427475b0dcc0064df/docs/ui_install.md#faqs
### .pgpass is required for the Data Cube On Demand functionality.
echo "${DB_HOSTNAME}:${DB_PORT}:${DB_DATABASE}:${DB_USER}:${DB_PASSWORD}" > config/.pgpass
cp config/.pgpass ~/.pgpass
chmod 600 ~/.pgpass

# Wait for Postgres to start.
until PGPASSWORD=$DB_PASSWORD psql -h "$DB_HOSTNAME" -U "$DB_USER" $DB_DATABASE -c '\q'; do
  >&2 echo "Postgres is unavailable - sleeping"
  sleep 1
done
>&2 echo "Postgres is running..."

>&2 echo "Create ui_results directory"
# From: https://github.com/ceos-seo/data_cube_ui/blob/72dd9eb05d7c6747892ef8d427475b0dcc0064df/docs/ui_install.md#faqs
mkdir -p /datacube/ui_results && chmod 777 /datacube/ui_results
mkdir -p /datacube/ui_results/data_cube_manager/ingestion_configurations/

>&2 echo "fix app metadata"
sed -i "s/app_info=/app_info=get_app_metadata(None),#/g" /usr/local/lib/python3.6/dist-packages/datacube-1.7+0.g98cf9ba3.dirty-py3.6.egg/datacube/scripts/ingest.py

>&2 echo "Migrating!"
# Perform Django migrations and initial data import.
python3 manage.py makemigrations {accounts,custom_mosaic_tool,cloud_coverage, coastal_change, data_cube_manager,dc_algorithm,fractional_cover,slip,spectral_indices,task_manager,tsm,urbanization,water_detection,data_cube_ui}
python3 manage.py makemigrations
python3 manage.py migrate
python3 manage.py loaddata db_backups/init_database.json

>&2 echo "Update datacube details"
python3 manage.py shell < update_datacubes.py

>&2 echo "Running redis-server"
redis-server &

>&2 echo "Running celery"
export C_FORCE_ROOT="true"

celery -A data_cube_ui worker -l info -c 4 &
celery multi start -A data_cube_ui task_processing data_cube_manager -c:task_processing 10 -c:data_cube_manager 2 --max-tasks-per-child:data_cube_manager=1  -Q:data_cube_manager data_cube_manager -Ofair
celery -A data_cube_ui beat &

exec "$@"
