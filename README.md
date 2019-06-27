# Intro

This is a jupyter ~notebook~ lab with several kernels installed.

It is currently based on Ubuntu:18.04.

# Usage

Step 1) Launch notebook server

Notebooks will be created in your local ./notebook folder. If it doesn't exist, it will be created.

```bash
docker run -it --rm -p 8888:8888 -v $(pwd)/notebook:/volume/notebook --name jupyter-notebook rcon2/jupyter
```

Step 2) Get token

```bash
docker exec -it jupyter-notebook jupyter notebook list | tail -n1 | perl -pe 's,^.*?token=(.*?) ::.*,\1,'
```

Step 3) Copy token and navigate to http://127.0.0.1:8888/?token=TOKEN


---

# Current Kernels

Planning to add to this over time.

- Bash
- C (https://github.com/brendan-rius/jupyter-c-kernel)
- Go (https://github.com/gopherdata/gophernotes)
- Java (https://github.com/SpencerPark/IJava.git)
- Javascript (https://github.com/n-riesco/ijavascript)
- Octave
- Perl (https://github.com/EntropyOrg/p5-Devel-IPerl)
- PHP (https://github.com/Litipk/Jupyter-PHP)
- Powershell (https://github.com/Jaykul/Jupyter-PowerShell)
- Python3
- R
- Ruby (https://github.com/SciRuby/iruby)
- Rust (https://github.com/google/evcxr)
- SoS
- TypeScript (https://www.npmjs.com/package/itypescript)

# Links

- Docker: https://hub.docker.com/r/rcon2/jupyter
- Source: https://github.com/rc2/docker-jupyter
