FROM python:3.5
MAINTAINER datapunt.ois@amsterdam.nl

ENV PYTHONUNBUFFERED 1
EXPOSE 8000

RUN apt-get update \
	&& apt-get install -y \
		libopencv-dev \
		libtesseract-dev \
		git \
		cmake \
		build-essential \
		libleptonica-dev \
        python3-dev \
		liblog4cplus-dev \
		libboost-python-dev \
		libcurl3-dev \
		pkg-config \
        libjpeg62-turbo-dev \
        libatlas-base-dev \
        gfortran

# -- START Build recipe found on https://github.com/openalpr/openalpr/wiki/Compilation-instructions-(Ubuntu-Linux)
# Clone the latest code from GitHub
WORKDIR /temp
RUN git clone https://github.com/openalpr/openalpr.git

# ADDED STEP: choose latest versioned git-tag
WORKDIR /temp/openalpr
RUN git checkout v2.3.0

# Setup the build directory
WORKDIR /temp/openalpr/src
RUN mkdir build

# setup the compile environment
WORKDIR /temp/openalpr/src/build
RUN cmake -DCMAKE_INSTALL_PREFIX:PATH=/usr -DCMAKE_INSTALL_SYSCONFDIR:PATH=/etc ..

# compile the library
WORKDIR /temp/openalpr/src/build
RUN make

# Install the binaries/libraries to your local system (prefix is /usr)
WORKDIR /temp/openalpr/src/build
RUN make install
# -- END Build recipe found on https://github.com/openalpr/openalpr/wiki/Compilation-instructions-(Ubuntu-Linux)

WORKDIR /app
RUN mkdir openalpr
RUN cp /temp/openalpr/src/bindings/python/openalpr/* /app/openalpr/
RUN rm -rf /temp/openalpr
# -- END Build OpenALPR

RUN pip install --no-cache-dir dlib

# -- START Build recipe OpenCV
RUN pip install --no-cache-dir numpy

WORKDIR /temp
RUN git clone https://github.com/opencv/opencv.git
RUN git clone https://github.com/opencv/opencv_contrib.git

WORKDIR /temp/opencv_contrib
RUN git checkout 3.1.0

WORKDIR /temp/opencv
RUN git checkout 3.1.0
RUN mkdir build

WORKDIR /temp/opencv/build
RUN cmake -D CMAKE_BUILD_TYPE=RELEASE \
    	-D CMAKE_INSTALL_PREFIX=/usr/local \
    	-D INSTALL_C_EXAMPLES=OFF \
    	-D INSTALL_PYTHON_EXAMPLES=OFF \
    	-D OPENCV_EXTRA_MODULES_PATH=/temp/opencv_contrib/modules \
    	-D BUILD_EXAMPLES=OFF ..

WORKDIR /temp/opencv/build
RUN make

WORKDIR /temp/opencv/build
RUN make install
RUN ldconfig

WORKDIR /app
RUN rm -rf /temp/opencv_contrib
RUN rm -rf /temp/opencv
# -- END Build recipe OpenCV
