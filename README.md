# mariadb

docker's image for mariadb based on alpine

## Usage

```bash
docker run -d \
  --name mariadb \
  -e MYSQL_DATABASE=test \
  -e MYSQL_USER=test \
  -e MYSQL_PASSWORD=test \
  -e MYSQL_ROOT_PASSWORD=test \
  -v ./data:/var/lib/mysql \
  -v ./init:/docker-entrypoint-initdb.d \
  -p 3306:3306 \
  damienmillet/mariadb:latest
```

## Environment variables

|Name|Default Value|Description|
|----|-----|-----------|
|MYSQL_DATABASE|`null`|Database name|
|MYSQL_USER|`null`|Database user|
|MYSQL_PASSWORD|`null`|Database password|
|MYSQL_ROOT_PASSWORD|`null`|Database root password|

## Volumes

|Path|Description|
|----|-----------|
|/var/lib/mysql|Database data|

## Ports

|Port|Description|
|----|-----------|
|3306|Database port|

## Init scripts

|Path|Description|
|----|-----------|
|/docker-entrypoint-initdb.d|Init scripts path|

## Docker compose example

```yaml
services:
  mariadb:
    image: 'damienmillet/mariadb:latest'
    container_name: 'mariadb'
    restart: 'unless-stopped'
    environment:
      MYSQL_DATABASE: 'test'
      MYSQL_USER: 'test'
      MYSQL_PASSWORD: 'test'
      MYSQL_ROOT_PASSWORD: 'test'
    volumes:
      - './data:/var/lib/mysql'
      - './init:/docker-entrypoint-initdb.d'
    ports:
      - '3306:3306'
```

every scripts in `./init` will be executed at the first start of the container
the order of execution is alphabetical and case-insensitive (0-9a-zA-Z)

you can use .sh, .sql or .sql.gz files
