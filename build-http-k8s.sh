git rev-parse HEAD > app/tracker/revision.txt
docker build . --rm -f docker.k8s.Dockerfile -t tracardi/tracardi-api-k8s:0.8.1
docker push tracardi/tracardi-api-k8s:0.8.1