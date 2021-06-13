# Using my own ubuntu image for this, which is just the official one plus node carbon, git, etc.
FROM apbarratt/ubuntu-18-with-node-carbon

# We'll just stick that fix to the mesg nonsense docker ubuntu does in here
RUN sed -i ~/.profile -e 's/mesg n || true/tty -s \&\& mesg n/g'

# And make sure we're using the right shell
SHELL ["/bin/bash", "-l", "-c"]

# TODO: Find way of setting TZ from host machine timezone.
ENV TZ=Europe/Isle_of_Man
ENV DEBIAN_FRONTEND=noninteractive
ENV POSTGIS_DB="template_postgis"
ENV OSM_DB="osm"

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

# start
COPY ubuntu-18-with-node-carbon-postgis.sh /apbarratt/ubuntu-18-with-node-carbon-postgis.sh
RUN chmod 777 /apbarratt/ubuntu-18-with-node-carbon-postgis.sh
CMD /apbarratt/ubuntu-18-with-node-carbon-postgis.sh