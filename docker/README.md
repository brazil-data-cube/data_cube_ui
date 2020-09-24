## build datacube-ui

The realization of the datacube-ui build process using docker is done with just a few steps. The steps are presented below.

1 - **Changing configuration files**: In this step, it is necessary to insert the connection information with the database in the `.env` file, present in the same directory as `docker-compose.yaml`

2 - **Build and Run!**: After configuring the `.env` file, build it and then run it.

```shell
docker-compose build --parallel
docker-compose up -d
```
