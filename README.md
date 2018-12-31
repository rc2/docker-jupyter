# Intro

This is a jupyter notebook with several kernels installed.

It is currently based on Ubuntu:18.04.

# Usage

Launch notebook

**NOTE**: make sure to download the notebooks that you want to save because the `--rm` will remove container when complete).

```bash
docker run -it --rm -p 8888:8888 rcon2/jupyter
```

The default working directory is `/volume/notebook`. To mount that you could do

```bash
docker run -it --rm -p 8888:8888 -v $(pwd)/notebook:/volume/notebook rcon2/jupyter
```

---

# Current Kernels

Planning to add to this over time.

- javascript (https://github.com/n-riesco/ijavascript)
- bash
- octave
- powershell (https://github.com/Jaykul/Jupyter-PowerShell)
- python3
- sos

# Links

- Docker: https://hub.docker.com/r/rcon2/jupyter
- Source: https://github.com/rc2/docker-jupyter
