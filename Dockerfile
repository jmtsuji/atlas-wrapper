FROM continuumio/miniconda:4.3.27p0
LABEL maintainer="Jackson M. Tsuji <jackson.tsuji@uwaterloo.ca>"

# Install ATLAS
RUN /bin/bash -c "conda create -y --name atlas_env python=3.6"
RUN /bin/bash -c "conda install -y --name atlas_env -c bioconda python=3.6 snakemake bbmap=37.17 click"
RUN /bin/bash -c "source activate atlas_env && pip install -U 'pnnl-atlas==1.0.22'"

# Add lines to Snakefile to force bash shell usage if not already in ATLAS. Can remove in future version of ATLAS.
RUN if ! grep -q "shell\.executable" /opt/conda/envs/atlas_env/lib/python3.6/site-packages/atlas/Snakefile; then \
	sed -i '12i\shell.executable("/bin/bash")\nshell.prefix("set -o pipefail; ")' \
	/opt/conda/envs/atlas_env/lib/python3.6/site-packages/atlas/Snakefile; fi

RUN mkdir -p /home/atlas

# Add code to automatically start atlas_env environment when logging in
RUN echo  "source activate atlas_env" >> /root/.bashrc

ENTRYPOINT cd /home/atlas && \
	echo "Welcome to the ATLAS docker container. Run 'atlas -h' to see run options. Type 'exit' to leave the container." && \
	/bin/bash
