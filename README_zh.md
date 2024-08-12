# 简介

本仓库为萨尔大学所开发的 [LLVMTA](https://gitlab.cs.uni-saarland.de/reineke/llvmta) 的一个分支。

# 构建

为方便，本项目提供了使用 Docker 和不使用 Docker 的两种构建方法，请根据需要自行选择使用。

> 由于项目构建依赖 Linux 环境，对于 Windows 和 Mac OS 用户，请优先使用 Docker 来进行构建，Windows 用户也可以使用 WSL 来进行本地构建

构建前，请将本仓库完整下载并进入到仓库根目录中，可以使用如下的命令来实现

```bash
git clone https://github.com/RTS-SYSU/llvmta
cd llvmta
```

## 方法一：使用 Docker

请先确保系统中已经安装有 Docker，然后按照以下步骤进行构建：

### 构建 Docker 镜像

本项目提供了两份 Docker 镜像构建文件，分别是基于 Arch 和 Ubuntu 22.04，请根据需要自行选择，构建命令为

```bash
docker build -t llvmtadocker:latest - < .devcontainer/Dockerfile
```

需要注意的是，为了方便国内用户使用，构建过程会进行镜像的替换，如有需要替换为自己的镜像，请自行修改 [Dockerfile](.devcontainer/Dockerfile) 的内容。

### 运行 Docker 容器

请在项目仓库根目录下执行如下命令

```bash
docker run -i -d \
    -v `pwd`:/workspaces/llvmta:rw \
    -v `pwd`/build:/workspaces/llvmta/build:rw \
    --name llvmta llvmtadocker:latest
```

### 编译项目

使用如下命令进入容器

```bash
docker exec -it llvmta /bin/bash
```

> 需要注意的是，进入容器后默认用户为 root，为了避免权限问题，建议在容器中切换到普通用户进行编译，容器中自带一个名为 vscode 的普通用户，可以使用 `su vscode` 命令切换到该用户，并使用 `sudo chown -R vscode:vscode /workspaces/llvmta` 命令修改项目文件夹的权限

> 除此之外，你可能还需要参考 root 用户的一些环境变量，例如 $PATH，$LD_LIBRARY_PATH 等，避免编译出现问题

然后按照以下步骤进行编译

```bash
cd /workspaces/llvmta
./config.sh [dev|rel]
cd build
ninja -j $(nproc)
```

其中 `./config.sh dev` 会使用 Debug 模式进行编译，而 `./config.sh rel` 则是以 Release 模式进行编译，请根据需要自行设置

## 方法二：不使用 Docker

对使用 Ubuntu 22.04 的用户，本项目提供了一个[脚本](./compile.sh)，可以使用该脚本进行快速的环境配置，运行完成后，使用 `source setup_env.sh` 来设定对应的环境变量，需要注意的是 `source setup_env.sh` 在每次重新打开终端后都需要重新执行

之后类似使用 Docker 的方法，进入 `build` 目录，使用 `ninja` 进行编译即可

## 方法三：手动进行编译

如果你不想使用 Docker，也不想使用脚本，那么你可以手动进行编译，具体步骤可以参考[脚本](./compile.sh)中的内容，这里对编译和运行过程需要的环境变量进行些许说明：

- `GUROBI_HOME`：Gurobi 的安装路径，需要确保路径下有 `lib`，`bin` 和 `include` 三个文件夹
- `LD_LIBRARY_PATH`：需要将 Gurobi 的 `lib` 文件夹路径添加到该环境变量中，同时对于使用 `LP_SOLVE` 的用户，也需要将 `lpsolve` 的 `lib` 文件夹路径添加到该环境变量中，或者可以创建一个软链接到 `/usr/lib` 中
- `PATH`：需要将 Gurobi 的 `bin` 文件夹路径添加到该环境变量中，同时，请将项目编译后的 `build/bin` 文件夹路径添加到该环境变量中
- `CPLUS_INCLUDE_PATH`：需要将 Gurobi 的 `bin` 文件夹路径添加到该环境变量中
- `GRB_LICENSE_FILE`：请将 Gurobi 的许可文件路径添加到该环境变量中

# 开发

对于使用 VSCode 进行开发的用户，随项目提供有 `.vscode` 文件夹，其中包含了一些配置文件，可以帮助你更好的进行开发，请根据自己的编译环境选择合适的配置文件。