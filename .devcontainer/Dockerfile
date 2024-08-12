# See here for image contents: https://github.com/microsoft/vscode-dev-containers/tree/v0.241.1/containers/ubuntu/.devcontainer/base.Dockerfile

# [Choice] Ubuntu version (use ubuntu-22.04 or ubuntu-18.04 on local arm64/Apple Silicon): ubuntu-22.04, ubuntu-20.04, ubuntu-18.04
ARG VARIANT="jammy"
FROM mcr.microsoft.com/vscode/devcontainers/base:0-${VARIANT}

SHELL ["/bin/bash", "-c"]

# [Optional] Use this to change to a mirror that may speed up the process
RUN sed -i 's/archive.ubuntu.com/mirrors.ustc.edu.cn/g' /etc/apt/sources.list \
       && sed -i 's/security.ubuntu.com/mirrors.ustc.edu.cn/g' /etc/apt/sources.list

# [Optional] Uncomment this section to install additional OS packages.
RUN apt-get update --fix-missing && export DEBIAN_FRONTEND=noninteractive \
        && apt-get -y install --no-install-recommends --fix-missing \
        lldb gcc gdb cmake make ninja-build libboost-all-dev git clangd \
        htop wget fish zsh lld time parallel lp-solve liblpsolve55-dev \
        icecc icecream-sundae libcolamd2 clang-tidy gcc-multilib \
        build-essential ccache python3-pip fakeroot

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

# For jdk-20.0.2
# No need for now, but keep it here for future use.
# RUN cd / ; \
#         mkdir -p jdk; \
#         cd jdk; \
#         wget https://download.java.net/java/GA/jdk20.0.2/6e380f22cbe7469fa75fb448bd903d8e/9/GPL/openjdk-20.0.2_linux-x64_bin.tar.gz; \
#         tar -xvf openjdk-20.0.2_linux-x64_bin.tar.gz; 

# ENV JAVA_HOME="/jdk/jdk-20.0.2"
# ENV CLASSPATH="$CLASSPATH:$JAVA_HOME/lib"
# ENV PATH="$PATH:$JAVA_HOME/bin"

# # Maven
# RUN cd / ;\
#         mkdir -p maven; \
#         cd maven; \
#         wget https://dlcdn.apache.org/maven/maven-3/3.9.8/binaries/apache-maven-3.9.8-bin.tar.gz; \
#         tar -xvf apache-maven-3.9.8-bin.tar.gz; 

# ENV M2_HOME="/maven/apache-maven-3.9.8"
# ENV PATH="$PATH:$M2_HOME/bin"

# # Make these environment variables available for user vscode
# RUN echo "export JAVA_HOME=$JAVA_HOME" >> /home/vscode/.bashrc
# RUN echo "export CLASSPATH=$CLASSPATH" >> /home/vscode/.bashrc
# RUN echo "export PATH=$PATH" >> /home/vscode/.bashrc
# RUN echo "export M2_HOME=$M2_HOME" >> /home/vscode/.bashrc
# RUN echo "export PATH=$PATH" >> /home/vscode/.bashrc

# RUN chmod 0644 /home/vscode/.bashrc
# RUN chown vscode:vscode /home/vscode/.bashrc


#Seting up icecc (icecream) distributed compiler.
#IceCream uses Ports: TCP: 10245 8765 8766 and for UDP 8765
EXPOSE 10245 8766 8765/TCP 8765/UDP
