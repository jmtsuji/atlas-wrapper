#!/bin/bash
# Created Dec 18, 2017
# Copyright Jackson M. Tsuji (Neufeld lab PhD student), 2018
# Description: Wrapper to run ATLAS in a Docker container

# Basic script stuff (Buffalo, 2015):
set -e
set -u
set -o pipefail

script_version=1.0.0
date_code=$(date '+%y%m%d')

# If input field is empty, print help and end script
if [ $# == 0 ]
then
	printf "\n$(basename $0): wrapper to start a Docker container with ATLAS (for metagenome processing).\n"
	printf "Version: ${script_version}\n"
	printf "Contact Jackson Tsuji (jackson.tsuji@uwaterloo.ca; Neufeld research group) for error reports or feature requests.\n\n"
	printf "Usage: $(basename $0) /path/to/database/directory /path/to/metagenome/directory /path/to/output/directory\n\n"
	printf "Usage notes:\n"
	printf "1. /path/to/database/directory: i.e., the database folder downloaded by ATLAS (or the folder where you want to download the ATLAS databases to from within the container).\n"
	printf "2. /path/to/metagenome/directory: should contain all raw fastq files for metagenome analysis. Files should not be in subfolders and (for easiest use).\n"
	printf "3. /path/to/output/directory: the directory where output files from ATLAS should go. Should make a subdirectory within this called 'tmp' for ATLAS to dump temp files during processing. Your config.yaml file should also be in this folder once ready to run (use ATLAS to generate this file for you initially). \n\n"
	exit 1
fi

#################################################################
##### Settings: #################################################
database_dir=$(realpath $1)
fastq_dir=$(realpath $2)
output_dir=$(realpath $3)
atlas_image_name="pnnl/atlas:1.0.22" # for docker to build and run; hard-coded for now
atlas_image_source="github.com/jmtsuji/atlas-wrapper.git" # for docker to build from; hard-coded for now
#################################################################

function test_directories {
	# Description: tests that the input directories exist
	
	# Test that /path/to/metagenome/directory exists, and exit if it does not
	if [ ! -d ${fastq_dir} ]; then
	# From http://stackoverflow.com/a/4906665, accessed Feb. 4, 2017
		print "Did not find metagenome directory at '${fastq_dir}'. Job terminating."
		exit 1
	fi

	# Test that /path/to/output/directory exists, and exit if it does not
	if [ ! -d ${output_dir} ]; then
	# From http://stackoverflow.com/a/4906665, accessed Feb. 4, 2017
		print "Did not find output directory at '${output_dir}'. Job terminating."
		exit 1
	fi

	# Test that /path/to/output/directory/tmp exists, and exit if it does not
	if [ ! -d ${output_dir}/tmp ]; then
	# From http://stackoverflow.com/a/4906665, accessed Feb. 4, 2017
		print "Did not find temp directory at '${output_dir}/tmp'. \
			Please make this folder before starting and use in your .yaml config file for the ATLAS temp folder. \
			Job terminating."
		exit 1
	fi
	
	# Test that /path/to/database/directory exists, and exit if it does not
	if [ ! -d ${database_dir} ]; then
	# From http://stackoverflow.com/a/4906665, accessed Feb. 4, 2017
		print "Did not find database directory at '${database_dir}'. Job terminating."
		exit 1
	fi
}

function setup_atlas {
	# Description: builds the ATLAS container with a specific tag. Doesn't rebuild if the container is already made.
	
	echo "Installing ATLAS docker container (if not already installed)..."
	docker build -t ${atlas_image_name} ${atlas_image_source} > /dev/null 2>&1
	echo ""
	
}

function start_atlas {
	# Description: starts the container
	
	docker run -v ${database_dir}:/home/atlas/databases \
	-v ${fastq_dir}:/home/atlas/data \
	-v ${output_dir}:/home/atlas/output \
	-it ${atlas_image_name} /bin/bash
	
}

function main {
	echo "Running $(basename $0) version $script_version on ${date_code} (yymmdd). Starting ATLAS container..."
	echo ""
	
	test_directories
	setup_atlas
	
	start_time=$(date)
	start_atlas
	end_time=$(date)
	
	echo ""
	echo ""
	echo "$(basename $0): finished."
	echo "Container started at ${start_time} and closed at ${end_time}."
	echo ""

}

main
