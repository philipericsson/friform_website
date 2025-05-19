#!/bin/bash

# Create output directories if they don't exist
mkdir -p static/images/optimized/{desktop,mobile}
mkdir -p static/images/optimized/favicon

# Function to convert and optimize images
optimize_image() {
    local input_path="$1"
    local output_path="$2"
    local quality="$3"
    local width="$4"

    # Convert to WebP with specified quality and width
    # -alpha_q 100 ensures high quality transparency
    cwebp -alpha_q 100 -q $quality -resize $width 0 "$input_path" -o "$output_path"
}

# Process project images with optimal sizes
for image in static/images/desktop/*.png static/images/desktop/*.jpg static/images/desktop/*.JPG; do
    base_name=$(basename "$image" .png)
    base_name=$(basename "$base_name" .jpg)
    base_name=$(basename "$base_name" .JPG)
    
    # Desktop version - 880px width (2x the display size for retina)
    optimize_image "$image" "static/images/optimized/desktop/${base_name}.webp" 95 880
    
    # Mobile version - 750px width (2x the display size for retina)
    optimize_image "$image" "static/images/optimized/mobile/${base_name}-mobile.webp" 90 750

done

# Optimize logo
if [ -f "static/images/logo.png" ]; then
    # Desktop logo (160px - 2.5x the display size for high-DPI)
    optimize_image "static/images/logo.png" "static/images/optimized/desktop/logo.webp" 95 160
    
    # Mobile logo (120px)
    optimize_image "static/images/logo.png" "static/images/optimized/mobile/logo.webp" 90 120
    
    echo "Logo optimized"
fi

# Optimize favicon
if [ -f "static/favicon.png" ]; then
    # Standard favicon sizes
    optimize_image "static/favicon.png" "static/images/optimized/favicon/favicon-16.webp" 95 16
    optimize_image "static/favicon.png" "static/images/optimized/favicon/favicon-32.webp" 95 32
    optimize_image "static/favicon.png" "static/images/optimized/favicon/favicon-48.webp" 95 48
    optimize_image "static/favicon.png" "static/images/optimized/favicon/favicon-192.webp" 95 192
    optimize_image "static/favicon.png" "static/images/optimized/favicon/favicon-512.webp" 95 512
    
    # Also create PNG versions for browsers that don't support WebP
    # The -alpha on option ensures transparency is preserved
    convert "static/favicon.png" -resize 16x16 -alpha on "static/images/optimized/favicon/favicon-16.png"
    convert "static/favicon.png" -resize 32x32 -alpha on "static/images/optimized/favicon/favicon-32.png"
    convert "static/favicon.png" -resize 48x48 -alpha on "static/images/optimized/favicon/favicon-48.png"
    convert "static/favicon.png" -resize 192x192 -alpha on "static/images/optimized/favicon/favicon-192.png"
    convert "static/favicon.png" -resize 512x512 -alpha on "static/images/optimized/favicon/favicon-512.png"
    
    echo "Favicon optimized"
fi

# Print optimization results
echo "Optimization complete!"
echo "Desktop images are in: static/images/optimized/desktop/"
echo "Mobile images are in: static/images/optimized/mobile/"
echo "Favicon images are in: static/images/optimized/favicon/"
