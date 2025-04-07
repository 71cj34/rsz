# rsz

This repo contains a function-forward Powershell script `rsz.ps1` that resizes directories of images to fit under a specified size.

Take your storage utilization from this to this!
![image of two google drive interfaces. one is using significantly less storage](https://jasoncheng.me/img/rsz_b&a.png)

## QuickStart

A file `example.bat` with example parameters is provided for convenience. The `.ps1` may be ran by right clicking and selecting "Run With Powershell". If you do not see this option, turn on [Script Execution Policy](https://learn.microsoft.com/en-us/powershell/module/microsoft.powershell.security/set-executionpolicy?view=powershell-7.5).

## Parameters

### `-d`

Specify a directory the script will use. Script not tested with paths that contain spaces.

Defaults to the directory the script is in. Accepts strings.

```
rsz.ps1 -d "C:\Users\Default\img.jpg"
```

### `-fs`

Specify the file size threshold (in MB) per image the resizing algorithm will activate for. 

Defaults to 3. Accepts floats.

```
rsz.ps1 -fs 1.5
```

### `-rs`

Specify the image dimension size threshold (in percentage) per image the resizing algorithm will use. For example, 80% will resize the image's dimensions to 80% of what they were on each succeeding resizing check.

Defaults to 80%. Accepts floats and decimals.

```
rsz.ps1 -fs 90
```

```
rsz.ps1 -fs 0.55
```

### `-ext`

Specify a list of file extensions the script will search for. 

Syntax: "ext1 ext2 .... extN"

Defaults to "jpg jpeg png bmp gif". Note that using this binding will **replace** this default set with the one you specify, not add to it.

```
rsz.ps1 -ext "tiff bmp"
```

### `-r`

Whether to search for files recursively in the target directory, allowing it to target folders and subfolders.

Defaults to false. Include to turn on.

```
rsz.ps1 -r
```

### `-v`

Verbose logging. Outputs breakpoints, script position updates, and statistics at the end.

Defaults to false. Include to turn on.

```
rsz.ps1 -v
```

## Parameters (Advanced)

Unless you know exactly why you need the parameters in this section, you probably don't need them.

### `-intm`

Sets the interpoleration mode in the .NET `Drawing2D` namespace. Find a list of possible values [on the .NET docs](https://learn.microsoft.com/en-us/dotnet/api/system.drawing.drawing2d.interpolationmode?view=windowsdesktop-9.0).

Defaults to HighQualityBicubic, the highest quality setting. Accepts strings.

```
rsz.ps1 -intm "NearestNeighbor"
```

### `-smtm`

Sets the smoothing mode in the .NET `Drawing2D` namespace. Find a list of possible values [on the .NET docs](https://learn.microsoft.com/en-us/dotnet/api/system.drawing.drawing2d.smoothingmode?view=windowsdesktop-9.0). Set this option to something else to disable antialiasing in case there are artifacts or visual errors on the outputs.

Defaults to AntiAlias. Accepts strings.

```
rsz.ps1 -smtm "None"
```

## License

Available under Apache 2.0.

By Jason Cheng
