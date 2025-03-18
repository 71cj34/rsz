# Load the System.Drawing assembly
Add-Type -AssemblyName System.Drawing

# Define parameters
param (
    [Parameter(Mandatory=$false)]
    [Alias("d")]
    [string]$directory = (Get-Location).Path,
    
    [Parameter(Mandatory=$false)]
    [Alias("fs")]
    [double]$filesize = 3,
    
    [Parameter(Mandatory=$false)]
    [Alias("rs")]
    [double]$resize = 80,
    
    [Parameter(Mandatory=$false)]
    [Alias("r")]
    [switch]$recurse = $false
)

# Normalize resize value (convert decimal to percentage if needed)
if ($resize -lt 1) {
    $resize = $resize * 100
}
# Ensure resize is between 1 and 100
$resize = [Math]::Max(1, [Math]::Min(100, $resize)) / 100

# Convert filesize to MB
$filesizeInBytes = $filesize * 1MB

# Validate directory
if (-not (Test-Path -Path $directory -PathType Container)) {
    Write-Host "Error: Directory '$directory' does not exist."
    exit 1
}

# Get all image files in the directory
$imageFiles = Get-ChildItem -Path $directory -Include *.jpg, *.jpeg, *.png, *.bmp, *.gif -Recurse:$recurse

# Process each image
foreach ($file in $imageFiles) {
    $originalFilePath = $file.FullName
    Write-Host "Processing $originalFilePath (Original Size: $([math]::Round($file.Length / 1MB, 2)) MB)"
    
    try {
        # Check if the file size is above the threshold
        for ($i = 1; $i -le 3; $i++) {
            $currentFile = Get-Item $originalFilePath
            if ($currentFile.Length -gt $filesizeInBytes) {
                Write-Host "Cycle $($i): File is above $filesize MB ($([math]::Round($currentFile.Length / 1MB, 2)) MB). Resizing..."
                
                # Create a temporary file path with the correct extension
                $tempFilePath = [System.IO.Path]::GetTempFileName()
                $tempFileWithExt = [System.IO.Path]::ChangeExtension($tempFilePath, $currentFile.Extension)
                if (Test-Path $tempFileWithExt) {
                    Remove-Item -Path $tempFileWithExt -Force
                }
                Rename-Item -Path $tempFilePath -NewName ([System.IO.Path]::GetFileName($tempFileWithExt)) -Force
                
                # Use a different approach to resize the image
                $image = [System.Drawing.Image]::FromFile($originalFilePath)
                
                # Calculate new dimensions based on resize percentage
                $newWidth = [int]($image.Width * $resize)
                $newHeight = [int]($image.Height * $resize)
                
                # Create a new bitmap with the calculated dimensions
                $resizedImage = New-Object System.Drawing.Bitmap($newWidth, $newHeight)
                
                # Create a graphics object from the bitmap
                $graphics = [System.Drawing.Graphics]::FromImage($resizedImage)
                
                # Set the interpolation mode for better quality
                $graphics.InterpolationMode = [System.Drawing.Drawing2D.InterpolationMode]::HighQualityBicubic
                $graphics.SmoothingMode = [System.Drawing.Drawing2D.SmoothingMode]::HighQuality
                $graphics.PixelOffsetMode = [System.Drawing.Drawing2D.PixelOffsetMode]::HighQuality
                
                # Draw the original image onto the bitmap at the new size
                $graphics.DrawImage($image, (New-Object System.Drawing.Rectangle(0, 0, $newWidth, $newHeight)))
                
                # Save the resized image
                $encoder = [System.Drawing.Imaging.ImageCodecInfo]::GetImageEncoders() | 
                    Where-Object { $_.FormatDescription -eq "JPEG" }
                
                $encoderParams = New-Object System.Drawing.Imaging.EncoderParameters(1)
                $encoderParams.Param[0] = New-Object System.Drawing.Imaging.EncoderParameter(
                    [System.Drawing.Imaging.Encoder]::Quality, 90L)
                
                $resizedImage.Save($tempFileWithExt, $encoder, $encoderParams)
                
                # Clean up
                $graphics.Dispose()
                $image.Dispose()
                $resizedImage.Dispose()
                
                # Replace the original file with the resized one
                Remove-Item -Path $originalFilePath -Force
                Move-Item -Path $tempFileWithExt -Destination $originalFilePath -Force
            } else {
                Write-Host "Cycle $($i): File is below $filesize MB ($([math]::Round($currentFile.Length / 1MB, 2)) MB). Skipping..."
                break # Exit the loop if the file is below the threshold
            }
        }
    } catch {
        Write-Host "Error processing $originalFilePath`: $_"
        Write-Host $_.Exception.Message
        Write-Host $_.ScriptStackTrace
    } finally {
        Write-Host "Finished processing $originalFilePath"
    }
}

Write-Host "Image processing complete."
