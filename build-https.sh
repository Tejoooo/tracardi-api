docker build . --rm --no-cache -f docker.ssl.Dockerfile -t tracardi/tracardi-api-ssl:0.8.1
docker push tracardi/tracardi-api-ssl:0.8.1