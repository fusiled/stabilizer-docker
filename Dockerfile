FROM ubuntu:12.04

# Set the working directory to /app
WORKDIR /app


RUN echo "[1/3]----- Setting up system ----[1/3]"
RUN apt-get update -y
# Install any needed packages specified in requirements.txt
RUN apt-get install xz-utils build-essential python wget zlib1g-dev  cmake -y
#set gcc-4.6/g++-4.6 as default
#RUN update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-4.8 30
#RUN update-alternatives --install /usr/bin/g++ g++ /usr/bin/g++-4.8 30


RUN echo "[2/3]----- Installing llvm/clang ----[2/3]"
#Download llvm/clang
RUN wget http://releases.llvm.org/3.1/llvm-3.1.src.tar.gz
RUN tar xpf llvm-3.1.src.tar.gz
RUN mv llvm-3.1.src llvm
#RUN wget http://releases.llvm.org/3.2/llvm-3.2.src.tar.xz
#RUN tar xvJf llvm-3.5.2.src.tar.xz
#RUN mv llvm-3.5.2.src llvm
WORKDIR /app/llvm/tools
#RUN wget http://releases.llvm.org/3.5.2/cfe-3.5.2.src.tar.xz
#RUN tar xvJf cfe-3.5.2.src.tar.xz
#RUN mv cfe-3.5.2.src  clang
RUN wget http://releases.llvm.org/3.1/clang-3.1.src.tar.gz
RUN tar xpf clang-3.1.src.tar.gz
RUN mv clang-3.1.src clang
WORKDIR /app

#build llvm/clang
RUN mkdir llvm_build
WORKDIR /app/llvm_build
RUN cmake -G "Unix Makefiles" ../llvm
RUN make -j6
RUN make install
WORKDIR /app

RUN ldconfig


RUN apt-get install libgmp-dev gcc-4.6-plugin-dev -y

RUN wget http://releases.llvm.org/3.1/dragonegg-3.1.src.tar.gz
RUN tar xpf dragonegg-3.1.src.tar.gz
RUN mv dragonegg-3.1.src dragonegg

#RUN wget http://releases.llvm.org/3.5.2/dragonegg-3.5.2.src.tar.xz
#RUN tar xvJf dragonegg-3.5.2.src.tar.xz
#RUN mv dragonegg-3.5.2.src  dragonegg

WORKDIR dragonegg
RUN make
RUN cp ./dragonegg.so /usr/lib/gcc/x86_64-linux-gnu/4.6/plugin/
WORKDIR /app


RUN apt-get install git -y

COPY patch /app/patch


#Download and build stabilizer
RUN git clone https://github.com/ccurtsinger/stabilizer
WORKDIR /app/stabilizer
#Naively overwrite the common.mk
RUN cp /app/patch/common.mk common.mk
RUN make
RUN echo "export LD_LIBRARY_PATH=/app/stabilizer:$LD_LIBRARY_PATH" >> ~/.bashrc
WORKDIR /app

RUN apt-get install vim -y
