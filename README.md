# ZotBins Waste Image Classification Docker

## Why Docker?
ZotBins members will be able to train and classify images in portable Docker containers without having to worry about hardware/software compatibility or environment setup.  
Everyone will be able to run a few scripts and start training immediately. Additionally, Docker 19.03 integrated GPU support into containers, simplifying the setup process.

## Portability Limitations
The portability of the included Docker script may be limited in the future. It pulls the image for CUDA 10.2, which is the latest version at the time of first commit. Future Nvidia GPUS may only be compatible with new versions of CUDA.  It is also possible that newer CUDA versions are incompatible with darknet or other unmaintained tools. We ask that users please notify the authors if the repository is out of date.
* Nvidia docker hub: https://hub.docker.com/r/nvidia/cuda/
* Compatibility information: https://docs.nvidia.com/deploy/cuda-compatibility/index.html

## Prerequisites
* any Linux distribution
* Docker (only 19.03 is guarenteed to work)
* CUDA compatible GPU

## Quickstart
#### Install latest Nvidia drivers  
```console
sudo ubuntu-drivers autoinstall
```
There should be equivalent command for different distributions of linux  
Restart machine if new drivers were installed  
#### Confirm drivers installed successfully
```
sudo lshw -c display
```
You should see this entry under your nvidia graphics card: `configuration: driver=nvidia`

#### Install drivers, Docker, and nvidia-docker  
```console  
chmod +x NvidiaDockerSetup.sh  
./NvidiaDockerSetup.sh  
```

#### Build the Docker image  
```console  
sudo docker build . -t <image name>
```  
Where `<image name>` is in all lowercase. Include ```--build-arg GPUS=<num_GPUS>``` flag if using more than one GPU.   
For exmample, to build an image named `zotbinsdl` with two GPUS:  
```console  
sudo docker build -t zotbinsdl --build-arg GPUS=2 .  
```  

#### Run a Docker container
```console
sudo docker container run --rm -dit --gpus all --name <container_name> <image_id>
```
`container_name` can be any given name for the container, and `<image_id>` can be retrieved by running:
```console
sudo docker image ls
```

#### SSH into the Docker container
```console
sudo docker exec -it <container_name> bash
```

#### Make sure it ain't broke
```
cd /src/darknet
./darknet detect cfg/yolov3.cfg yolov3.weights data/dog.jpg
```
It should run really fast (<1 minute)  
If there is an error while loading weights such as an **out of memory** or **assertion** error, you can either
* Open **cfg/yolov3.cfg** and decrease the **batchsize**
* Get a better GPU with more memory

## Common errors/FAQ
#### Can I use this Docker on Windows/Mac
No, Docker is compatible but nvidia-docker is not.
#### Can I use this Docker if my host machine is a virtual machine?
No, getting CUDA support on a virtual machine would be very tedious, if even possible.
#### How do I confirm that my GPU is linked to Nvidia drivers?
```console
sudo lshw -c video
```
You should see **configuration: driver=nvidia**
#### Why is my GPU not linked to the Nvidia drivers?
Make sure **secure boot mode** is off, which is often on by default in laptops. This can usually be done in BIOS.  
There can be many other reasons why the drivers were not installed correctly, and its best to google your specific issues.
