library(readr)
library(dplyr)

# Set input and output folder paths
input_folder <- "G:/MJ/birddata/raw"
output_folder <- "G:/MJ/birddata/split"

# Get all CSV files in the input folder
files <- list.files(input_folder, pattern = "\\.csv$", full.names = TRUE)

# Loop through each file
for (file in files) {
  # Read CSV file
  data <- read_csv(file, show_col_types = FALSE)
  
  # Get base file name
  base_name <- tools::file_path_sans_ext(basename(file))
  
  # Get unique values from individual-local-identifier column
  identifiers <- unique(data$`individual-local-identifier`)
  
  # Loop through each unique identifier
  for (id in identifiers) {
    # Filter data for this identifier
    subset_data <- data %>% filter(`individual-local-identifier` == id)
    
    # Get individual taxon canonical name
    taxon_name <- unique(subset_data$`individual-taxon-canonical-name`)
    
    # Remove illegal characters from identifier
    safe_id <- gsub("[^a-zA-Z0-9]", "", id)
    
    # Remove illegal characters from taxon name
    taxon_name <- gsub("[^a-zA-Z0-9]", "", taxon_name)
    
    # Generate new file name
    new_file_name <- paste0(base_name, "_", taxon_name, "_", safe_id, ".csv")
    
    # Generate full output file path
    output_path <- file.path(output_folder, new_file_name)
    
    # Write filtered data to new file
    write_csv(subset_data, output_path)
    
    # Print export information
    print(paste("Exported file:", output_path))
  }
}