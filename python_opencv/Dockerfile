FROM amsterdam/python3.6
MAINTAINER datapunt.ois@amsterdam.nl

ENV PYTHONUNBUFFERED 1
EXPOSE 8000

RUN pip install --no-cache-dir numpy

RUN apt-get update \
	&& apt-get install -y \
		git \
		cmake \
		build-essential \
		pkg-config \
		libjpeg62-turbo-dev \
		libatlas-base-dev \
		python3-dev \
		gfortran


WORKDIR /temp
RUN git clone https://github.com/opencv/opencv.git
RUN git clone https://github.com/opencv/opencv_contrib.git

WORKDIR /temp/opencv_contrib
RUN git checkout 3.4.5

WORKDIR /temp/opencv
RUN git checkout 3.4.5
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

RUN pip install --no-cache-dir 'opencv-python>=3.4.5,<4.0.0'
