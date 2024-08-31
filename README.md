
```
docker build --build-arg UID=$(id -u) . -t sophus
docker run --rm -it --net=host -e DISPLAY=$DISPLAY -v /tmp/.X11-unix:/tmp/.X11-unix:rw -v $(pwd):/home:rw sophus

cd /home
LD_LIBRARY_PATH=/tmp/Pangolin/build/ /home/cmake-build-debug-sophus/example/trajectoryError
```