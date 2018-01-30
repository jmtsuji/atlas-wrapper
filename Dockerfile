FROM continuumio/miniconda:4.3.27p0
LABEL maintainer="Jackson M. Tsuji <jackson.tsuji@uwaterloo.ca>"

RUN conda create -y --name atlas_env python=3.6 # https://conda.io/docs/user-guide/tasks/manage-environments.html#activate-env, accessed 171207
RUN conda install -y --name atlas_env -c bioconda python=3.6 snakemake bbmap=37.17 click
RUN . activate atlas_env
RUN pip install -U 'pnnl-atlas==1.0.22'
RUN mkdir -p /home/atlas
RUN cd /home/atlas

ENTRYPOINT /bin/bash