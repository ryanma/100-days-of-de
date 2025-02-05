# Run the latest postgres container, while loading any sql files in the ~/workspace/practice-dbs/ directory by default
# Mount the container on the host's 5432 port
docker run --name some-postgres -e POSTGRES_PASSWORD=mysecretpassword -v ~/workspace/practice-dbs:/docker-entrypoint-initdb.d -d -p 5432:5432 postgres
