FROM ubuntu:16.04
LABEL maintainer="Cameron Morris"
RUN apt-get update

# Install dependencies
RUN apt-get install -y \
	git \
        xorriso \
	isolinux \
	make 

#CMD ["mknod /dev/loop0 b 7 0"]

#WORKDIR /ipxe/src
CMD ["/bin/bash"]
