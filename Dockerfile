
FROM nvidia/cuda:10.2-cudnn7-devel
LABEL maintainer="zotbinsuci@gmail.com"

# set to number of GPUs used for training
ARG GPUS=1

# dependencies
RUN apt-get update
RUN apt-get install -y \
	git \
	wget \
	vim

# darknet setup
RUN mkdir /src
WORKDIR /src
RUN git clone https://github.com/pjreddie/darknet
WORKDIR /src/darknet
RUN sed -i "s/GPU=.*/GPU=${GPUS}/" Makefile && sed -i "s/CUDNN=.*/CUDNN=1/" Makefile && make -j $(nproc)

# TODO: @Luaak put here what you do for setup
#		for dataset, I think you may want to set up some sort of shared file between docker and host...
RUN wget -q https://pjreddie.com/media/files/yolov3.weights

