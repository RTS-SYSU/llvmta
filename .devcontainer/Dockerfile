# See here for image contents: https://github.com/microsoft/vscode-dev-containers/tree/v0.241.1/containers/ubuntu/.devcontainer/base.Dockerfile

# [Choice] Ubuntu version (use ubuntu-22.04 or ubuntu-18.04 on local arm64/Apple Silicon): ubuntu-22.04, ubuntu-20.04, ubuntu-18.04
ARG VARIANT="jammy"
FROM mcr.microsoft.com/vscode/devcontainers/base:0-${VARIANT}

SHELL ["/bin/bash", "-c"]

# [Optional] Uncomment this section to install additional OS packages.
RUN apt-get update --fix-missing && export DEBIAN_FRONTEND=noninteractive \
        && apt-get -y install --no-install-recommends --fix-missing \
        lldb gcc gdb cmake make ninja-build libboost-all-dev git clangd \
        htop wget fish zsh lld time parallel lp-solve liblpsolve55-dev \
        icecc icecream-sundae libcolamd2 clang-tidy gcc-multilib \
        build-essential ccache python3-pip

RUN pip3 install numpy


# Set environment variables
ENV PATH=$PATH:/workspaces/llvmta/build/bin
ENV PATH=$PATH:/workspaces/llvm/build/bin
# ENV CPLUS_INCLUDE_PATH=$CPLUS_INCLUDE_PATH:/llvm/lib/Target/ARM
# ENV CPLUS_INCLUDE_PATH=$CPLUS_INCLUDE_PATH:/llvm/lib/Target/RISCV
RUN mv /usr/lib/lp_solve/liblpsolve55.so /usr/lib/liblpsolve55.so
#RUN echo "/usr/lib/lp_solve" >> /etc/ld.so.conf.d/lpsolve.conf ; ldconfig

# Install Gurobi
RUN cd /opt ; \
        wget -nv \
        https://packages.gurobi.com/9.5/gurobi9.5.2_linux64.tar.gz ; \
        tar xfz *.tar.gz ; \
        cd
ENV GUROBI_HOME="/opt/gurobi952/linux64"
ENV PATH="${PATH}:${GUROBI_HOME}/bin"
ENV LD_LIBRARY_PATH="${LD_LIBRARY_PATH}:${GUROBI_HOME}/lib"
ENV CPLUS_INCLUDE_PATH="$CPLUS_INCLUDE_PATH:${GUROBI_HOME}/include"
ENV GRB_LICENSE_FILE=/workspaces/llvmta/dependencies/gurobi.lic
RUN ln -s $GUROBI_HOME/lib/libgurobi95.so /usr/lib/libgurobi.so

RUN echo "set completion-ignore-case on" >> /etc/inputrc

#Seting up icecc (icecream) distributed compiler.
#IceCream uses Ports: TCP: 10245 8765 8766 and for UDP 8765
EXPOSE 10245 8766 8765/TCP 8765/UDP
