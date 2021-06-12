# Using my own ubuntu image for this, which is just the official one plus node carbon, git, etc.
FROM apbarratt/ubuntu-18-with-node-carbon

# TODO: Find way of setting TZ from host machine timezone.
ENV TZ=Europe/Isle_of_Man
ENV DEBIAN_FRONTEND=noninteractive

# Install all the things! (if only it were all this easy)
RUN apt-get update
RUN apt-get -yq --no-install-recommends install \
    postgresql \
    postgresql-10-postgis-2.4 \
    postgresql-server-dev-10 \
    postgresql-10-postgis-2.4-scripts \
    postgresql-contrib-10 \
    postgresql-client-10

# clean up
RUN apt-get clean -y
RUN rm -rf /var/lib/apt/lists/*

#Postgis
USER postgres
RUN /etc/init.d/postgresql start && \
    psql -c "CREATE USER docker WITH SUPERUSER PASSWORD 'docker';" && \
    psql -c "CREATE DATABASE gis;" && \
    psql -d gis -c "CREATE EXTENSION IF NOT EXISTS postgis;" && \
    psql -d gis -c "CREATE EXTENSION IF NOT EXISTS postgis_topology;" && \
    psql -d gis -c "CREATE EXTENSION IF NOT EXISTS fuzzystrmatch;"
RUN echo "host all all 0.0.0.0/0 md5" >> /etc/postgresql/10/main/pg_hba.conf
RUN echo "listen_addresses='*'" >> /etc/postgresql/10/main/postgresql.conf

#Set all environment variables to use everything we just set up
ENV PGHOST=localhost
ENV PGDATABASE=gis
ENV PGUSER=docker
ENV PGPASSWORD=docker