# centos-build-media 

### Prerequisites - Docker
* Have git installed 
* Have Docker installed  
* Clone this repo
* Download a CentOS 7 minimal iso

### Prerequisites - Local
* Tested on Ubuntu 16.04

##### Packages:
* git
* xorriso
* isolinux
* make

### Building Media - Docker
* Git clone this repository 
```
$ git clone git@github.com:camarox53/centos-build-media.git
```
* Run the `build_container.sh` script
```
$ ./build_container.sh
```
* Run the `build_media.sh` script and pass it the mini.iso and kickstart file
```
$ ./build_media.sh -k base.cfg -i mini.iso
```
Note: Your new .iso will be created in your current working directory. 

###### This is an automated build on the dockerhub. Pull camarox53/centos-build-media
