# Docker for Stabilizer
This Dockerfile sets up **ubuntu-12.04** with [stabilizer](https//www.github.com/ccurtsinger/stabilizer)and llvm 3.1 ready to be used. All the installation is performed inside the `app` folder.

Keep in mind that the environment of this installation is super old (`gcc-4.6`, `llvm-3.1` with `c++0x`) and the stabilizer is old as well but it\'s still a valuable tool for research. This obsolescence introduced some issues with the `Heap-Layers` dependency since cloning the HEAD of the master branch make the compilation fail with this old compiler versions. The only solution was to check out and old version of it (i.e. the one related to stabilizer).

## Quickstart
Setup the system:

```
  #Clone this repo and change directory:
  git clone https://www.github.com/mfusi/stabilizer-docker
  cd stabilizer-docker
  #Build the docker image
  docker build -t stabilizer .
```

Enter in the docker mounting a host folder inside `/mnt`:
```
  docker run -v <your-path-to-folder>:/mnt -it stabilizer
```

