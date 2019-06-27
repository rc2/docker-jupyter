FROM ubuntu:latest

RUN mkdir -p /staging

ENV DOTNET_CLI_TELEMETRY_OPTOUT 1

# package management
RUN apt-get update
RUN apt-get install -y python3-pip
RUN python3 -m pip install --upgrade pip

# utilities
RUN apt-get install -y curl
RUN apt-get install git -y

# install: juypter
RUN python3 -m pip install jupyter
RUN python3 -m pip install sos
RUN python3 -m pip install sos-notebook
RUN python3 -m sos_notebook.install

# install: node
RUN curl -sL https://deb.nodesource.com/setup_10.x | bash -
RUN apt-get install -y nodejs

# install: dotnet + powershell
RUN cd /staging && curl -O https://packages.microsoft.com/config/ubuntu/18.04/packages-microsoft-prod.deb
RUN dpkg -i /staging/packages-microsoft-prod.deb
RUN rm /staging/packages-microsoft-prod.deb
RUN apt-get update
RUN apt-get install -y dotnet-sdk-2.2
RUN apt-get install -y powershell

# install kernels init

# install-kernel: javascript
RUN npm config set unsafe-perm=true
RUN npm install -g ijavascript
RUN ijsinstall --spec-path=full

# install-kernel: bash
RUN pip3 install bash_kernel
RUN python3 -m bash_kernel.install

# install-kernel: octave
RUN apt-get install -y octave
RUN pip3 install octave_kernel
RUN python3 -m octave_kernel install

# install-kernel: powershell
RUN mkdir -p /usr/local/support/jupyter
RUN apt-get install -y libunwind-dev
RUN cd /staging && git clone https://github.com/Jaykul/Jupyter-PowerShell.git jupyter-powershell
RUN cd /staging/jupyter-powershell && pwsh build.ps1
RUN mv /staging/jupyter-powershell/Output/Release/Linux /usr/local/support/jupyter/powershell
RUN perl -i -p -e 's,"PowerShell-Kernel","/usr/local/support/jupyter/powershell/PowerShell-Kernel",' /usr/local/support/jupyter/powershell/kernel.json
RUN jupyter kernelspec install /usr/local/support/jupyter/powershell

# install-kernel: go
RUN apt-get install -y golang
RUN mkdir -p /usr/local/go
ENV GOPATH "/usr/local/go"
ENV PATH "$PATH:$GOPATH/bin"
RUN apt-get install -y libczmq-dev
RUN GOPATH="/usr/local/go" go get -u github.com/gopherdata/gophernotes
RUN perl -i -p -e 's,gophernotes,/usr/local/go/bin/gophernotes,' /usr/local/go/src/github.com/gopherdata/gophernotes/kernel/kernel.json
RUN mkdir $(jupyter --data-dir)/kernels/go
RUN cp usr/local/go/src/github.com/gopherdata/gophernotes/kernel/kernel.json $(jupyter --data-dir)/kernels/go

# install-kernel: r
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y tzdata
RUN apt-get install -y r-base r-base-dev 
RUN echo "install.packages('IRkernel')" | R --no-save
RUN echo "IRkernel::installspec(user = FALSE)" | R --no-save

# install-kernel: java
RUN apt-get install -y openjdk-11-jdk-headless
RUN cd /staging && git clone https://github.com/SpencerPark/IJava.git ijava
RUN cd /staging/ijava && chmod u+x gradlew && ./gradlew installKernel

# install-kernel: c
RUN pip3 install jupyter-c-kernel
RUN install_c_kernel

# install-kernel: php
RUN apt-get install -y composer
RUN apt-get install -y php-zmq
RUN mkdir /staging/jupyter-php
RUN cd /staging/jupyter-php
RUN curl https://litipk.github.io/Jupyter-PHP-Installer/dist/jupyter-php-installer.phar > /staging/jupyter-php/installer.phar
RUN cd /staging/jupyter-php && php installer.phar install
RUN mkdir /staging/jupyter-php/php
RUN cp /usr/local/share/jupyter/kernels/jupyter-php/kernel.json /staging/jupyter-php/php/kernel.json
RUN yes | jupyter kernelspec uninstall jupyter-php
RUN cd /staging/jupyter-php && jupyter kernelspec install php

# install-kernel: ruby
RUN apt-get install -y libtool libffi-dev ruby ruby-dev make libzmq3-dev libczmq-dev
RUN gem install cztop iruby
RUN iruby register --force

# install-kernel: perl
RUN yes | cpan Devel::IPerl
RUN iperl kernel

# install-kernel: rust
RUN apt-get install -y rustc cargo
RUN cargo install evcxr_jupyter
RUN /root/.cargo/bin/evcxr_jupyter --install

# install-kernel: typescript
RUN npm install -g itypescript
RUN its --install=global

# workdir
RUN mkdir -p /volume/notebook
WORKDIR /volume/notebook

#RUN rm -rf /staging

EXPOSE 8888

CMD jupyter notebook --ip=0.0.0.0 --port=8888 --allow-root
