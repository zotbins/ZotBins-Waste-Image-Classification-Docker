# ZotBins Waste Image Classification Docker

## Why Docker?
ZotBins members will be able to train and classify images without having to worry about hardware/software compatibility or environment 
setup. Everyone will be able to run a few scripts and start training immediately. Additionally, Docker 19.03 integrated GPU
support into containers, simplifying the setup process.

## Prerequisites
* any Linux distribution
* Docker (only 19.03 is guarenteed to work)
* CUDA compatible GPU

## Quickstart
### Install latest Nvidia drivers  
```console
sudo ubuntu-drivers autoinstall
```
Restart machine if new drivers were installed

### Install drivers, Docker, and nvidia-docker  
```console  
chmod +x NvidiaDockerSetup.sh  
./NvidiaDockerSetup.sh  
```

### Build the Docker image  
```console  
sudo docker build .  
```  
Include ```--build-arg GPUS=<num_GPUS>``` flag if using more than one GPU. If you have two GPUS:  
```console  
sudo docker build --build-arg GPUS=2 .  
```  

### Run a Docker container
```console
sudo docker container run --rm -dit --gpus all --name <container_name> <image_id>
```
`container_name` can be any given name for the container, and `<image_id>` can be retrieved by running:
```console
sudo docker image ls
```

### SSH into the Docker container
```console
sudo docker exec -it <container_name> bash
```

### Make sure it ain't broke
```
cd /src/darknet./darknet 
detect cfg/yolov3.cfg yolov3.weights data/dog.jpg
```
It should run really fast (<1 minute)  
If there is an error while loading weights such as an **out of memory** or **assertion** error, you can either
* Open **/src/darnket/yolov3.cfg** and decrease the **batchsize**
* Get a better GPU with more memory

## Common errors/FAQ
### Can I use this Docker on Windows/Mac
No, Docker is compatible but nvidia-docker is not.
### Can I use this Docker if my host machine is a virtual machine?
No, getting CUDA support on a virtual machine would be very tedious, if even possible.
### How do I confirm that my GPU is linked to Nvidia drivers?
```console
sudo lshw -c video
```
You should see **configuration: driver=nvidia**
### Why is my GPU not linked to the Nvidia drivers?
Make sure **secure boot mode** is off, which is often on by default in laptops. This can usually be done in BIOS. 
