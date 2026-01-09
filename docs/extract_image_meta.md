# extract_image_meta

`extract_image_meta` allows you to select a directory to extract all metadata embedded in all images files and export as a spreadsheet.

Optionally, it can generate thumbnails for each image file at the same time.

ExifTool must be available on your path (i.e. you can use it in the terminal, `exiftool -v`).
For thumbnail generation you must have ImageMagick installed.

Requirements:

- [ExifTool](https://exiftool.org/)
- [ImageMagick](https://imagemagick.org/script/download.php)

## Options

The options can be changed by passing arguments with the rake command.

| option | description | default value |
| --- | --- | --- |
| directory | the full path of directory to count | '.' |
| recursive | include subfolders | 'true' |
| thumbs | create thumbnails true/false | 'false' |
| output_csv | the filename for new CSV containing the count data | 'pdf_count.csv' |
