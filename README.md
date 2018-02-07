# atlas-wrapper
A convenient method to reproducibly deploy and use the [PNNL ATLAS pipeline](https://github.com/pnnl/atlas).

Copyright Jackson M. Tsuji, 2018

Neufeld Research Group, University of Waterloo, Canada

Note: this project is still under active development.

## Usage
This repo contains the `Dockerfile` to build a Docker container (like a lightweight virtual machine) with ATLAS pre-installed and the simple wrapper script `enter-atlas` to automatically install and use the Docker container.

To get started:
```
# cd to the directory where you want to download the repo
git clone https://github.com/jmtsuji/atlas-wrapper.git
sudo chmod 755 atlas-wrapper/enter-atlas # to give run permissions
sudo cp atlas-wrapper/enter-atlas /usr/local/bin # to install for all users; can skip this if you'd like and just run it locally
rm -r enter-atlas # can now delete the git repo, although you might need sudo privileges for this
```
Then run ATLAS, providing the locations of three important directories (but consider starting a service like `screen` or `byobu` before doing this, in case some processes take a while):
```
enter-atlas [path_to_database_directory] [path_to_metagenome_directory] [path_to_output_directory]
```
1. `path_to_database_directory`: directory where the ATLAS databases are stored (or mount an empty directory of your choice if you haven't downloaded the databases yet, and use `atlas` to download them as per the example below).
2. `path_to_metagenome_directory`: directory containing all raw metagenome (FastQ) files for analysis by ATLAS.
3. `path_to_output_directory`: directory where ATLAS will store output analyses. You can also make a `tmp` subdirectory within this directory if you'd like for where ATLAS can store its temp files (see below).

The first time you run this, `enter-atlas` will automatically install and build the ATLAS docker container for you. (For advanced users: the docker image will be saved as `pnnl/atlas:1.0.22` or whatever the latest ATLAS release is.) The first install could take a few minutes.

After checking whether or not the container has already been installed, `enter-atlas` will then enter the Docker container. You'll find yourself in the working folder `/home/atlas` as the `root` user. The directories you gave to `enter-atlas` as arguments (above) will be mounted to the following directories:

1. `path_to_database_directory` --> /home/atlas/databases
2. `path_to_metagenome_directory` --> /home/atlas/data
3. `path_to_output_directory` --> /home/atlas/output

From here, you're set to try to run ATLAS! Example workflows:
* Download ATLAS databases (only needed on first use): `atlas download -o /home/atlas/databases`
* Create `config.yaml` file: `atlas make-config --database-dir databases output/config.yaml data`
* Start ATLAS run: `atlas assemble --jobs [number_of_jobs] --out-dir output output/config.yaml 2>&1 | tee output/atlas_run.log`

Once you're finished working in the container, simply type `exit` to leave the container.

#### Some additional notes:
* Filepaths: Keep in mind that file paths within the Docker container will be different than outside the container. As such, the `config.yaml` file you create in the Docker container will show the metagenome filepaths as something like `/home/atlas/data/metagenome_1.fastq.gz`, even though they might be stored in a different directory outside the container. This is completely fine for using ATLAS within the container, but you'll need to make a new `config.yaml` file if you ever want to use ATLAS directly installed on your machine.
* Root privileges: the Docker user has root privileges! You'll have the power to delete any of your files without being warned -- be careful. Also, ATLAS output will not be writable by a normal user. If you'd like to be able to write to ATLAS output, use the following command outside the Docker container to make the files belong to you: `sudo chown -R ${USER} [path_to_output_directory]`
* tmpdir: If you'd like to set the ATLAS temp folder within your `output_directory`, I recommend creating a folder in the output directory called `tmp`. Use this as the `tmpdir` in your config.yaml file as `/home/atlas/output/tmp`.

## Info for advanced users: running the Docker container outside `enter-atlas`
`enter-atlas` is not strictly needed to run the Docker container. You could use it manually with the following command:

```
# Build the container
docker build -t pnnl/atlas:1.0.22 github.com/jmtsuji/atlas-wrapper.git # Or set the tag to whatever you want
# Run the container
docker run -it pnnl/atlas:1.0.22 /bin/bash
atlas -h # Can see ATLAS options once inside the container.
```
You won't be able to do much with the `docker run` example above because you need to mount your database and metagenome files in the container to use ATLAS meaningfully. This will be handled by the `enter-atlas`, but you coudld do this manually using the `-v` or `--mount` flags.

