# This is old version. Please, find the actual version [here](https://github.com/puzl-ee/docker-images/tree/dev/images/pytorch).

Pytorch framework with various python runtime. Used by puzl.ee Kubernetes cloud provider.

#### Build:

```
docker build \
    --build-arg INTERPRETER=python3.8 \
    --build-arg INTERPRETER_VERSION=3.8 \
    -t puzlcloud/pytorch:python3.8 .
```
