# Build

For the convenience, this project provides two methods for building, using Docker and not using Docker, please choose according to your needs.

> Due to the project build depending on the Linux environment, for Windows and Mac OS users, please use Docker to build first, specifically, Windows users can also use WSL for local building.

Before build, please download the repository completely and enter the repository root directory, you can use the following command to achieve(Git installed required).

```bash
git clone https://github.com/RTS-SYSU/llvmta
cd llvmta
```

## Using Docker

Please make sure Docker is installed on your system, if not, you can visit [Docker](https://docs.docker.com/get-docker/) to install it, then follow the steps below to build:

### Build Docker Image

We provide two Docker image build files, based on Arch and Ubuntu 22.04 respectively, please choose according to your needs, we recommend using Ubuntu 22.04, the build command is

```bash
docker build -t llvmtadocker:latest - < .devcontainer/Dockerfile
```

For you information, if you want to replace the mirror with your own, please modify the content of [Dockerfile](.devcontainer/Dockerfile) by yourself, we have commented out the mirror replacement command in the file.

### Run Docker Container

Please execute the following command in the root directory of the project, else, please manully replace the path in the `-v` parameter with the path of the project root directory:

```bash
docker run -i -d \
    -v `pwd`:/workspaces/llvmta:rw \
    -v `pwd`/build:/workspaces/llvmta/build:rw \
    --name llvmta llvmtadocker:latest
```

### Compile Project

Use the following command to enter the container, if you change the container name, please replace `llvmta` with the name you set:

```bash
docker exec -it llvmta /bin/bash
```

> Note that by default, the user in the container is root, to avoid permission issues, it is recommended to switch to a non-root user in the container for compilation, the container comes with a non-root user named `vscode`, you can use the `su vscode` command to switch to this user once you are in the container, and please use the `sudo chown -R vscode:vscode /workspaces/llvmta` command to change the permissions of the project folder to avoid permission issues

> If you are using the `vscode` user, and facming some compile issues, you may need to refer to some environment variables of the root user, such as $PATH, $LD_LIBRARY_PATH, etc., to avoid compile issues

Then compile according to the following steps

```bash
cd /workspaces/llvmta
./config.sh [dev|rel]
cd build
ninja -j $(nproc)
```

If you want to further develop the project or you want to debug the project, set the configuration to `dev`, otherwise, set it to `rel` for release mode.

After the compilation is completed, you can find the compiled executable file in the `build/bin` directory, and you can run it directly.

## Not Using Docker

For users using Ubuntu 22.04, this project provides a [script](../compile.sh), you can use this script to quickly configure the environment, after running, use `source setup_env.sh` to set the corresponding environment variables, please note that `source setup_env.sh` needs to be re-executed every time you reopen the terminal, and it have to be executed in the root directory of the project.

Then, similar to using Docker, enter the `build` directory and use `ninja` to compile.

## Manual Compilation

If you would like to completely manually compile the project, you can refer to the content in the [script](../compile.sh), here are some explanations of the environment variables needed for the compilation and running process:

- `GUROBI_HOME`: The installation path of Gurobi, make sure there are `lib`, `bin`, and `include` three folders under the path
- `LD_LIBRARY_PATH`: You need to add the path of the `lib` folder of Gurobi to this environment variable, and for users using `LP_SOLVE`, you also need to add the path of the `lib` folder of `lpsolve` to this environment variable, or you can create a soft link to `/usr/lib`
- `PATH`: You need to add the path of the `bin` folder of Gurobi to this environment variable, and please add the path of the `build/bin` folder of the project to this environment variable
- `CPLUS_INCLUDE_PATH`: You need to add the path of the `bin` folder of Gurobi to this environment variable
- `GRB_LICENSE_FILE`: Please add the path of the Gurobi license file to this environment variable
