# write_exif

`rake write_exif` takes a CSV of metadata and for each file listed in the metadata, will write the descriptive metadata into the corresponding file.

Adding embedded Exif metadata to images and PDFs is suggested as a best practice for digital preservation and sharing.
Embedded metadata is also required for PDF accessibility.
Since writing new Exif metadata will change the file properties, it is probably not appropriate for some born digital archival content where the exact original content should be preserved.

## Prep

All files should be put into a single directory (by default this is "objects").

Your metadata CSV must have these fields:

- "filename" - exact filename that matches a file in the specified directory
- "title" 

Additional your metadata can have these fields:

- "creator" - 
- "description" - 
- "subject" - 
- "source" -
- "language" - 

## Options

| option | description | default value |
| --- | --- | --- |
| csv_file | the filename of the metadata CSV file | "metadata.csv" |
| directory | the full path of directory containing the file | 'objects' |
