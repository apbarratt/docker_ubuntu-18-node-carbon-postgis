service postgresql start
sleep 10
createdb -U root root
createdb -U root ${POSTGIS_DB}
psql -U ${DB_USERNAME} -d ${POSTGIS_DB} -c "create extension postgis;"
psql -U ${DB_USERNAME} -d ${POSTGIS_DB} -c "create extension hstore;"
psql -U ${DB_USERNAME} -d ${POSTGIS_DB} -c "create extension postgis_topology;"
psql -U ${DB_USERNAME} -d ${POSTGIS_DB} -c "create extension fuzzystrmatch;"
createdb -U ${DB_USERNAME} ${OSM_DB} -T ${POSTGIS_DB}