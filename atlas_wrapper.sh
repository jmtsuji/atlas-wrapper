#!/bin/bash
# Created Dec 18, 2017
# Copyright Jackson M. Tsuji (Neufeld lab PhD student), 2017
# Description: Wrapper to run ATLAS in a Docker container

# Basic script stuff (from Vince Buffalo's "Bioinformatics Data Skills" (1st Ed.) chapter 12, pg 397):
set -e
set -u
set -o pipefail

script_version=1.0.0
date_code=$(date '+%y%m%d')

# If input field is empty, print help and end script
if [ $# == 0 ]
then
printf "    $(basename $0): wrapper to start a Docker container with ATLAS (for metagenome processing).\nVersion: ${script_version}\nContact Jackson Tsuji (jackson.tsuji@uwaterloo.ca; Neufeld research group) for error reports or feature requests.\n\nUsage: $(basename $0) /path/to/metagenome/directory /path/to/output/directory\n\n***Requirements:\n1. /path/to/metagenome/directory: should contain all raw fastq files for metagenome analysis. Files should not be in subfolders and (I think) should not be gzipped.\n2. /path/to/output/directory: the directory where output files from ATLAS should go. Should make a subdirectory within this called 'tmp' for ATLAS to dump temp files during processing. Your config.yaml file should also be in this folder once ready to run (use ATLAS to generate this file for you initially). \n**Ideally, use folders on Hippodrome to prevent excessive input/output on Winnebago.\n\n"
exit 1
fi
# Using printf: http://stackoverflow.com/a/8467449 (accessed Feb 21, 2017)
# Test for empty variable: Bioinformatics Data Skills Ch. 12 pg 403-404, and http://www.tldp.org/LDP/Bash-Beginners-Guide/html/sect_09_07.html and http://stackoverflow.com/a/2428006 (both accessed Feb 21, 2017)


#################################################################
##### Settings: #################################################
fastq_dir=$1
output_dir=$2
database_dir="/Hippodrome/atlas/databases" # hard-coded for now
#################################################################

#echo "Running $(basename $0) version $script_version on ${date_code} (yymmdd). Will use ${threads} threads (hard-coded into script for now)."
#echo ""

# Test that /path/to/metagenome/directory exists, and exit if it does not
if [ ! -d ${fastq_dir} ]; then
# From http://stackoverflow.com/a/4906665, accessed Feb. 4, 2017
    print "Did not find /path/to/metagenome/directory exists ${fastq_dir}. Job terminating."
    exit 1
fi

# Test that /path/to/output/directory exists, and exit if it does not
if [ ! -d ${output_dir} ]; then
# From http://stackoverflow.com/a/4906665, accessed Feb. 4, 2017
    print "Did not find /path/to/output/directory ${output_dir}. Job terminating."
    exit 1
fi

# Test that /path/to/output/directory/tmp exists, and exit if it does not
if [ ! -d ${output_dir}/tmp ]; then
# From http://stackoverflow.com/a/4906665, accessed Feb. 4, 2017
    print "Did not find /path/to/output/directory/tmp ${output_dir}/tmp. Please make this folder before starting. Job terminating."
    exit 1
fi

start_time=$(date)

# Start the container (will this work??? Not yet tested - 171218)
docker run --rm -v ${database_dir}:/home/atlas/databases \
-v ${fastq_dir}:/home/atlas/data \
-v ${output_dir}:/home/atlas/output \
-it jmtsuji/atlas:version1

end_time=$(date)

echo ""
echo ""
echo "Done."
echo ""

echo "$(basename $0): finished."
echo "Started at ${start_time} and finished at ${end_time}."
echo ""
