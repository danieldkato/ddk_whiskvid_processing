"""
ddk_whiskvid_processing.py

DOCUMENTATION TABLE OF CONTENTS:
I. OVERVIEW
II. USAGE
III. REQUIREMENTS
IV. INPUTS
V. OUTPUTS

last updated DDK 2017-11-03

################################################################################
I. OVERVIEW:

This script acts as a wrapper for Chris Rodgers' WhiskiWrap, which is itself a wrapper
for Nathan Clack's whisk. I use this to organize the inputs and outputs in a
way that I like and fits in with my workflow; all input paths and analysis 
parameters are saved in a parameters JSON file, and analysis metadata is saved
in a format consistent with the rest of my analyses.


################################################################################
II. USAGE:

To use this funciton, enter the following into the command line:

python ddk_whiski_wrapper.py /path/to/params/file


################################################################################
III. REQUIREMENTS:

1) WhiskiWrap, available at https://github.com/cxrodgers/WhiskiWrap/.git. Note that
   this package itself has a number of dependencies, including: 
        a) whisk, 
        b) tifffile, and
        c) my, another module available on cxrodgers' github.

2) The module `utilities`, available at https://github.com/danieldkato/utilities.git


################################################################################
IV. INPUTS:

This function takes a single command line input, namely, a path to a parameters
JSON file (see USAGE above). Example contents of such a file could include:

{
    "inputs":[
                {"path": </path/to/input/video>}
            ],
    "params":["n_trace_processes": <number of parallel processes to start>]
}

Note this assumes that the input video depicts black whiskers on a white 
background. If this is not the case, first run ffmpeg on the input video
to invert the colors.


################################################################################
V. OUTPUTS:

This function saves to secondary storage an hdf5 file containing the output of 
whisk. It also creates a large number of temporary files used to parallelize
and segment the operation of whisk.


################################################################################
"""
import WhiskiWrap
import sys
import json 
import os
import subprocess
from utilities.Metadata import Metadata, write_metadata

# Get path to paramters file from command line:
params_file_path = sys.argv[1]

# Get parameters from JSON file:
with open(params_file_path) as data_file:
    json_data = json.load(data_file)

# Get inputs and parameters
input_path = json_data["inputs"][0]["path"]
num_cores = json_data["params"]["n_trace_processes"]

"""
# Invert the video using ffmpeg (acquired as white on black; trace requires black on white)
raw_vid_name = os.path.basename(input_path)[0:-3]
inverted_vid_path = os.path.dirname(input_path) + os.path.sep + raw_vid_name + '.mp4'
subprocess.Popen(['ffmpeg', '-i', input_path, '-vf', 'lutyuv=y=negval', '-vcodec', 'mpeg4', '-q', '2', inverted_vid_path])
"""

# Auto-generate name of output file:
output_path = os.path.dirname(input_path) + os.path.sep + 'whiski_output.hdf5'

# Run WhiskiWrap:
print("Running WhiskiWrap...")
WhiskiWrap.pipeline_trace(input_path,output_path,n_trace_processes = num_cores)

# Create Metadata object:
print("Getting metadata...")
M = Metadata()
M.add_input(input_path)
M.add_output(output_path)
M.dict["parameters"] = json_data["params"]
metadata_path = os.path.dirname(input_path) + os.path.sep + 'whiski_wrap_metadata.json'
write_metadata(M, metadata_path)


