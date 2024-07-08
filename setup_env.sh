#!/usr/bin/env bash
export GUROBI_HOME=`pwd`/thirdParty/gurobi952/linux64
export PATH=`pwd`/build/bin:${GUROBI_HOME}/bin:$PATH
export LD_LIBRARY_PATH=${GUROBI_HOME}/lib:${LD_LIBRARY_PATH}
export CPLUS_INCLUDE_PATH=$CPLUS_INCLUDE_PATH:${GUROBI_HOME}/include
export GRB_LICENSE_FILE=${GUROBI_HOME}/gurobi.lic