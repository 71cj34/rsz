# rsz

This repo contains a functional Powershell script `rsz.ps1` that resizes directories of images to fit under a specified size.

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

### `-r`

Whether to search for files recursively in the target directory, allowing it to target folders and subfolders.

Defaults to false.

```
rsz.ps1 -r
```

## License

Available under Apache 2.0.

By Jason Cheng