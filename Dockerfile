FROM continuumio/miniconda:4.3.27p0
LABEL maintainer="Jackson M. Tsuji <jackson.tsuji@uwaterloo.ca>"

RUN /bin/bash -c "conda create -y --name atlas_env python=3.6"
RUN /bin/bash -c "conda install -y --name atlas_env -c bioconda python=3.6 snakemake bbmap=37.17 click"
RUN /bin/bash -c "source activate atlas_env && pip install -U 'pnnl-atlas==1.0.22'"
RUN /bin/bash -c "mkdir -p /home/atlas"

ENTRYPOINT cd /home/atlas && /bin/bash -c "source activate atlas_env"

CMD /bin/bash
