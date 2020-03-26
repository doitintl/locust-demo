FROM greenbirdit/locust:0.9.0

WORKDIR /app

ADD locustfile.py locustfile.py
ADD run.sh run.sh

# Expose the required Locust ports
EXPOSE 5557 5558 8089

# Set script to be executable
USER root
RUN chmod 755 /app/run.sh
# USER locust

# Start Locust using LOCUS_OPTS environment variable
ENTRYPOINT /app/run.sh
