FROM amsterdam/panorama_image_processing:python_face_detection
MAINTAINER datapunt.ois@amsterdam.nl

# -- START Build recipe found on https://github.com/openalpr/openalpr/wiki/Compilation-instructions-(Ubuntu-Linux)
RUN apt-get update \
	&& apt-get install -y \
		libtesseract-dev \
		libleptonica-dev \
		liblog4cplus-dev \
		libcurl3-dev

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
