FROM mysql:5.6

# Copy the database initialize script: 
# Contents of /docker-entrypoint-initdb.d are run on mysqld startup
COPY users.sql /docker-entrypoint-initdb.d/

# Default values for passwords and database name. Can be overridden on docker run
ENV MYSQL_ROOT_PASSWORD=secret
ENV MYSQL_DATABASE=userdb
ENV MYSQL_USER=itwb
ENV MYSQL_PASSWORD=itwb

