#/bin/bash

PKG=ScientificPython
VERSION=2.9.2
DESCRIPTION="A collection of Python modules for scientific computing. It contains support for geometry, mathematical functions, statistics, physical units, IO, visualization, and parallelization."
URL=https://sourcesup.renater.fr/projects/scientific-py/
DOWNLOAD_URL=https://sourcesup.renater.fr/frs/download.php/4153/ScientificPython-2.9.2.tar.gz

. install_scripts/incl.sh

if_done_exit
start_build
download_tarball

# Remove previous source and unpack tarball
echo_and_run rm -rf ${PKG_SRC_DIR}
echo_and_run tar -xzf ${TARBALL}

# Configure and make
pushd ${PKG_SRC_DIR}
module load anaconda
echo_and_run python setup.py install --prefix=${INSTALL_DIR}
popd

# Write modulefile
mkdir -p ${MODULE_DIR}
cat << EOF > ${MODULEFILE}
-- -*- lua -*-
help(
[[
This module loads the ${PKG} python library
It updates the PYTHONPATH environment variable.

Requires a python module be loaded.

Version: ${VERSION}
]])     

local version = "${VERSION}"
local base    = "${INSTALL_DIR}"

whatis("Description: ${DESCRIPTION}")
whatis("URL: ${URL}")

prereq("python")

local pkg_py = pathJoin(base, "lib/python2.7/site-packages")
prepend_path("PYTHONPATH", pkg_py)
EOF

# Remove source
echo_and_run rm -rf ${PKG_SRC_DIR}

finish_build