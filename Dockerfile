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

# workdir
RUN mkdir -p /volume/notebook
WORKDIR /volume/notebook

#RUN rm -rf /staging

EXPOSE 8888

CMD jupyter notebook --ip=0.0.0.0 --port=8888 --allow-root
