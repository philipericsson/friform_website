#!/bin/bash

# Create output directories if they don't exist
mkdir -p static/images/optimized/{desktop,mobile}

# Function to convert and optimize images
optimize_image() {
    local input_path="$1"
    local output_path="$2"
    local quality="$3"
    local width="$4"

    # Convert to WebP with specified quality and width
    cwebp -q $quality -resize $width 0 "$input_path" -o "$output_path"
}

# Process images with optimal sizes
for image in static/images/raw/*.png static/images/raw/*.jpg; do
    base_name=$(basename "$image" .png)
    base_name=$(basename "$base_name" .jpg)
    base_name=$(basename "$base_name" .JPG)
    
    # Desktop version - 880px width (2x the display size for retina)
    optimize_image "$image" "static/images/optimized/desktop/${base_name}.webp" 95 880
    
    # Mobile version - 750px width (2x the display size for retina)
    optimize_image "$image" "static/images/optimized/mobile/${base_name}-mobile.webp" 90 750

done

# Print optimization results
echo "Optimization complete!"
echo "Desktop images are in: static/images/optimized/desktop/"
echo "Mobile images are in: static/images/optimized/mobile/"
