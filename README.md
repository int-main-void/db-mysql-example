# db-mysql-example

example schema and tools for setting up and running a Mysql db with Docker

## Usage

Usage of the shell script requires Docker to be installed on the host.

1. Clone the repository
2. Make any necessary edits to the schema.sql package (in the src/sql directory)
3. Set the root password in your environment and start the db server:
```MYSQL_ROOT_PW=<your_pw_here> ./tools/db_docker_util.sh start```
4. Install the schema
```MYSQL_ROOT_PW=<your_pw_here> ./tools/db_docker_util.sh schema```


And you can then connect to the db with a user from your client of choice.

