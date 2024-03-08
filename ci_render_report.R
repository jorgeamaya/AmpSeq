library(argparse)
library(rmarkdown)

# Create ArgumentParser object
parser <- ArgumentParser()

# Add arguments
parser$add_argument("--data_dir", type = "character", help = "Directory that contains the data")
parser$add_argument("--out_dir", type = "character", help = "Directory that will contain the output")
parser$add_argument("--path_to_flist", type = "character", help = "Path to list of files")
parser$add_argument("--joined_threshold", type = "character", help = "Minimum threshold for joined reads")
parser$add_argument("--contamination_threshold", type = "character", help = "Minimum threshold to consider a well as contiminated")
parser$add_argument("--missing_files", type = "character", help = "List of missing files")

# Parse command-line arguments
args <- parser$parse_args()

print(args)
getwd()
  
# Assign variables based on command-line arguments
render("/ci_report_layouting.Rmd", params = list(
  data_dir = args$data_dir, 
  out_dir = args$out_dir,
  path_to_flist = args$path_to_flist, 
  joined_threshold = args$joined_threshold,
  contamination_threshold = args$contamination_threshold,
  missing_files = args$missing_files
),
  output_dir = "/cromwell_root/Results/")
print("Leaving render script")
