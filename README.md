# centos-build-media 

### Pre-Requirements
* Have git installed 
* Have Docker installed  
* Download a CentOS 7 minimal iso

##### Packages: 

### Building Media
* Git clone this repository 

$ git clone git@github.com:camarox53/centos-build-media.git

* Run the `build_container.sh` script

$ ./build_container.sh

* Run the `build_media.sh` script and pass it the mini.iso and kickstart file

$ ./build_media.sh -k base.cfg -i mini.iso

Note: Your new .iso will be created in your current working directory. 
