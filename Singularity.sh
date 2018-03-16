Bootstrap: docker
From: ubuntu

%help
This prepares an environment for the destructive deep learning 
Python package importantly including mlpack for density estimation trees.

%labels
Version v0.1

%post
# Install core utilities
apt-get update
apt-get install -y vim
apt-get install -y wget # Useful utility for downloading files
apt-get install -y bzip2  # Needed for anaconda installation

# Install core make utilities, needed for mlpack compile
apt-get install -y cmake
apt-get install -y git
apt-get install -y build-essential
apt-get install -y doxygen
apt-get install -y txt2man
apt-get install -y pkg-config

# Install important math libraries
apt-get install -y liblapack-dev
apt-get install -y libblas-dev
apt-get install -y libboost-all-dev
apt-get install -y libarmadillo-dev
apt-get install -y libmlpack-dev

# Install anaconda
PROFILE=/etc/profile
ANACONDA_DIR=/opt/anaconda
wget https://repo.continuum.io/archive/Anaconda3-5.1.0-Linux-x86_64.sh
bash Anaconda3-5.1.0-Linux-x86_64.sh -b -p $ANACONDA_DIR
rm Anaconda3-5.1.0-Linux-x86_64.sh
export PATH="$ANACONDA_DIR/bin:$PATH"  # Make anaconda available during build
echo "export PATH=\"$ANACONDA_DIR/bin:\$PATH\"" >> $SINGULARITY_ENVIRONMENT # Make anaconda available in environment

# Install other needed python packages
conda update -y -n base conda
conda install -y scikit-learn numpy scipy seaborn matplotlib plotly cython
conda install -y -c conda-forge pot
yes | pip install anytree

# Install python 2 kernel environment and required packages
conda create -y -n python2 python=2 ipykernel
/bin/bash activate python2
python -m ipykernel install --user

# Install theano with necessary dependencies for MAF
conda install -y pygpu theano
echo "export MKL_THREADING_LAYER=GNU" >> $SINGULARITY_ENVIRONMENT # Don't know if this is needed but keeping just in case

# Install other needed python packages for MAF
conda install -y plotly cython h5py
/bin/bash deactivate # Go back to original python 3 environment

# Install mlpack from source (no longer needed since directly interfacing with library)
#git clone https://github.com/mlpack/mlpack.git
#pushd mlpack
#mkdir build
#pushd build
#cmake -Wno-dev ../
#make -j2 install
#popd
#popd
