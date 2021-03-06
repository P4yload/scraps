# Mac OS

- [Current directory](#current-directory)
- [Show all files](#show-all-files)
- [Current date and time in UTC](#current-date-and-time-in-utc)
- [Resize pictures preserving aspect ratio](#resize-pictures-preserving-aspect-ratio)
- [Prevent Mac from sleeping](#prevent-mac-from-sleeping)
- [Get your IP address](#get-your-ip-address)
    - [Local](#local)
    - [External](#external)
- [Disable Gatekeeper](#disable-gatekeeper)
- [Discover the biggest files](#discover-the-biggest-files)
    - [Using sort](#using-sort)
    - [Using gsort](#using-gsort)
- [Using find to search in your folders](#using-find-to-search-in-your-folders)
- [Searching for a string in files contents](#searching-for-a-string-in-files-contents)
- [ZIP files](#zip-files)
- [Create a dummy file to occupy space](#create-a-dummy-file-to-occupy-space)
- [Write an ISO image to USB drive](#write-an-iso-image-to-usb-drive)

## Current directory

```bash
pwd
```

## Show all files

```bash
ls -la
```

## Current date and time in UTC

`date '+%d.%m.%Y %H:%M:%S UTC%z'`

This will give something like this:

`09.03.2017 12:56:33 UTC+0100`

## Resize pictures preserving aspect ratio

```bash
sips --resampleWidth 800 -s formatOptions high *.jpg
```

which is the same thing as:

```bash
sips --resampleWidth 800 *.jpg
```

* `--resampleWidth 800` - resizes a picture to 800px width (preserving aspect ratio)
* `-s formatOptions high` - quality settings [`low`|`normal`|`high`|`best`|`100`]
* `*.jpg` - search mask for files that will be processed

## Prevent Mac from sleeping

```bash
caffeinate -u -t 600
```

* `-u` - emulates "user" usage
* `-t 600` - 600 seconds (10 minutes)

## Get your IP address

### Local

```bash
ifconfig | grep "inet" | grep -Fv 127.0.0.1 | grep -Fv ::1 | awk '{print $2}'
```

or without IPv6 addresses (add space after `inet` and remove `::1` filter):

```bash
ifconfig | grep "inet " | grep -Fv 127.0.0.1 | awk '{print $2}'
```

or just:

```bash
ipconfig getifaddr en0
```

* `en0` - your network interface

### External

```bash
curl ipecho.net/plain; echo
```

## Disable Gatekeeper

To allow installing applications from any source.

Check the status:

```bash
spctl --status
```

* `assessments enabled` - feature is turned on (you cannot install apps from any source)
* `assessments disabled` - feature is turned off (you can install from anywhere)

Turn off the feature:

```bash
sudo spctl --master-disable
```

Turn on the feature back:

```bash
sudo spctl --master-enable
```

## Discover the biggest files

And the biggest directories too, of course.

### Using `sort`

```bash
du -sh ~/* | sort -rn | head -10
```

* `du` - utility that displays the file system block usage
    * `-s` - show only top-level folders (without showing subfolders)
    * `-h` - present folders size in a human-readable format
    * `~/*` - count everything from the home directory
* `sort` - utility for sorting results
    * `-r` - reverse the list (because by default it goes ascending)
    * `-n` - sort by numeric values (size, in our case)
* `head` - shows only specified number of lines from result

However, this `sort` sorts only numbers without respecting the data unit (MB, GB, etc):

```bash
username@MacBook-Pro:~$ du -sh ~/* | sort -rn | head -10
880M	/Users/username/Applications
879M	/Users/username/temp
 56G	/Users/username/Library
 34M	/Users/username/Desktop
 23G	/Users/username/Pictures
 11G	/Users/username/Music
9.2G	/Users/username/Documents
```

### Using `gsort`

```bash
du -sh ~/* | gsort -rh | head -10
```

```bash
username@some-MacBook-Pro:~$ du -sh ~/* | gsort -rh | head -10
 56G    /Users/username/Library
 23G    /Users/username/Pictures
 11G    /Users/username/Music
9.2G    /Users/username/Documents
6.3G    /Users/username/Movies
2.3G    /Users/username/Downloads
880M    /Users/username/Applications
879M    /Users/username/temp
```

So, it is all the same, but instead of `sort` we are using `gsort`, which supports `h` option (that respects human-readable data units). If you don't have `gsort` in your system, it can be installed via `brew install coreutils`.

## Using `find` to search in your folders

Let's find all the files (and folders) in your home folder that are related to the **GarageBand** application:

```bash
find ~ -iname "*garage*"
```

Two `*` wildcards will help to find any file (and folder) that contains `garage` in any part of its name.

You can also look for all `.mp4` files in your home directory:

```bash
find ~ -iname "*.mp4"
```

And here's a more complex example: look for all `.mp4` files in your home directory, then sort results by the file size and show only top 10 biggest ones:

```bash
find ~ -iname "*.mp4" -print0 | xargs -0 du -sh | gsort -rh | head -10
```

* `find` - utility for searching
    * `-iname` - look in file names, ignoring case and using `*` wildcard to specify the `.mp4` extension
    * `-print0` - adds a NULL character (instead of newline) after the name of each found file. This is needed for long file names with spaces and stuff
* `xargs` - takes result strings from the previous command and uses them as arguments for the next command in pipe (for `du` in our case)
    * `-0` - tells xargs to expect NULL characters as separators instead of spaces (that aligns with our `-print0` from `find`)
* `gsort` - read about it [here](#discover-the-biggest-files)

## Searching for a string in files contents

Search in files of parent directory only (without going into subfolders):

```bash
grep -ils "sOmE tEXt" *.txt
```

* `grep` - utility for searching text
    * `-i` - ignoring case
    * `-l` - output only file names
    * `-s` - don't show warnings like `Is a directory`
    * `*.txt` - file name pattern, but works only with a single directory level (doesn't apply to subfolders)

Search in subfolders too:

```bash
grep -ilr "sOmE tEXt" *
```

* `-r` - search recursively (in subfolders). Now there is no need in option `-s` (I guess)

Search in particular files only:

```bash
grep -ilr "sOmE tEXt" --include=*.{txt,mark*} *
```

* `--include=` - proper file name pattern that applies to all folder levels. This particular one will process only `.txt` and `.markdown` (all `.mark*` ones, to be precise) files

## ZIP files

``` bash
zip -r9T archiveName.zip folderToArchive -x "*.DS_Store"
```

* `-r` - recursive, including all subfolders
* `-9` - compression level: from `0` (no compression) to `9` (maximum compression)
* `-T` - test archive integrity after finishing

To unpack the archive into current folder:

``` bash
unzip archiveName.zip
```

## Create a dummy file to occupy space

``` bash
dd if=/dev/random of=/tmp/stupidfile.crap bs=20m
```

This will start to create a file, "growing" it with 20 MB chunks of random trash. The process will never stop, so you'll need to break it with `⌃ + C`.

If you want to monitor the file's size in Terminal, install and run `watch` utility:

``` bash
brew install watch
watch ls -alh /tmp/stupidfile.crap
```

## Write an ISO image to USB drive

``` bash
diskutil list
diskutil unmountDisk /dev/YOUR-USB-DRIVE
sudo dd if=/path/to/image.iso of=/dev/rYOUR-USB-DRIVE bs=1m
```
* `r` - raw, makes the writing faster

You can watch the progress by pressing `⌃ + T` combination.

After it's finished, eject the drive:

``` bash
diskutil eject /dev/YOUR-USB-DRIVE
```
