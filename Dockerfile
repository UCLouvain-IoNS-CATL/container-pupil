# https://github.com/UCL-CATL/cosy-docker-layer
FROM ucl-cosy/cosy-docker-layer:25

MAINTAINER Sébastien Wilmet

WORKDIR /root/

RUN dnf -y builddep libjpeg-turbo

# Install libjpeg-turbo from sources to use the --with-pic flag.
RUN curl -o libjpeg-turbo.tar.gz -L "http://sourceforge.net/projects/libjpeg-turbo/files/1.4.2/libjpeg-turbo-1.4.2.tar.gz/download" && \
	tar xf libjpeg-turbo.tar.gz && \
	cd libjpeg-turbo-1.4.2 && \
	./configure --with-pic && \
	make install

RUN dnf -y install \
		cmake \
		libusb-devel \
		python3-devel \
		python3-numpy \
		python3-scipy \
		ffmpeg \
		ffmpeg-devel \
		glew-devel \
		glfw-devel

RUN dnf -y install \
		opencv-devel \
		opencv-python3 \
		boost-devel \
		boost-python3-devel \
		glog-devel \
		atlas-devel \
		eigen3-devel \
		ceres-solver-devel

# Install libuvc from git.
RUN commit="ebfd4020a7f8eb78c681f3eb645107e8d562a920" && \
	curl -o libuvc.tar.gz -L "https://github.com/pupil-labs/libuvc/archive/${commit}.tar.gz" && \
	tar xf libuvc.tar.gz && \
	cd libuvc-${commit} && \
	mkdir build && \
	cd build && \
	cmake .. && \
	make && \
	make install

# Workaround for libuvc cmake shenanigan.
RUN echo "/usr/local/lib" >> /etc/ld.so.conf && \
	ldconfig

RUN dnf -y install python3-psutil

# Install some Python packages.
RUN pip3 install --upgrade pip

RUN pip3 install \
	numexpr \
	cython \
	pyzmq \
	msgpack_python \
	pyopengl \
	git+https://github.com/zeromq/pyre

RUN dnf -y install redhat-rpm-config

RUN pip3 install git+https://github.com/pupil-labs/PyAV@498516d0df6080018dcfe2f234557ccfcea74435
RUN pip3 install git+https://github.com/pupil-labs/pyuvc@318528148524bd34c092b872c646fe2fd78ffa09
RUN pip3 install git+https://github.com/pupil-labs/pyndsi@095865f7cccaca1f5b6be1a51699d5bb16760429
RUN pip3 install git+https://github.com/pupil-labs/pyglui@5306a0ee8932d82c4c1bd37d102b67717f8c1595

# Set default command
CMD ["/usr/bin/bash"]
