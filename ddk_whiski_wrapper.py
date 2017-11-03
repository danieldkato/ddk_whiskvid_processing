import WhiskiWrap
import sys
import json 
import os
from utilities.Metadata import Metadata, write_metadata

# Get path to paramters file from command line:
params_file_path = sys.argv[1]

# Get parameters from JSON file:
with open(params_file_path) as data_file:
    json_data = json.load(data_file)

# Get inputs and parameters
input_path = json_data["inputs"][0]["path"]
num_cores = json_data["params"]["n_trace_processes"]

# Auto-generate name of output file:
output_path = os.path.dirname(input_path) + os.path.sep + 'whiski_output.hdf5'

# Run WhiskiWrap:
WhiskiWrap.pipeline_trace(input_path,output_path,n_trace_processes = num_cores)

# Create Metadata object:
M = Metadata()
M.add_input(input_path)
M.add_output(output_path)
M.dict["parameters"] = json_data["params"]
metadata_path = os.path.dirname(input_path) + os.path.sep + 'whiski_wrap_metadata.json'
write_metadata(M, metadata_path)


