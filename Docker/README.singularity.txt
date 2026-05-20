# We want singularity image for ClinSV v1.1.0.
# The only available docker image needs to have a few changes 
# before it can be used to create one.
# The biggest change is the installation of ROOT library files so that
# cnvnator-multi can run without error. 
# We download a tarball from which these files can be added to the image.
#
# To built singularity image:

ROOT_BIN=root_v6.26.14.Linux-ubuntu20-x86_64-gcc9.4.tar.gz
wget https://root.cern/download/${ROOT_BIN}
singularity build clinsv-1.1.0.sif image.def
rm ${ROOT_BIN}