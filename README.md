# README

This README would normally document whatever steps are necessary to get the
application up and running.

Things you may want to cover:

- Ruby version

- System dependencies

- Configuration

- Database creation

- Database initialization

- How to run the test suite

- Services (job queues, cache servers, search engines, etc.)

- Deployment instructions

- ...

# Docker

```
docker build --platform linux/amd64 . -t pokemon:latest
docker tag pokemon:latest <AWS ID>.dkr.ecr.<Region>.amazonaws.com/pokemon:latest
docker push <AWS ID>.dkr.ecr.<Region>.amazonaws.com/pokemon:latest

docker pull <AWS ID>.dkr.ecr.<Region>.amazonaws.com/pokemon:latest
```
