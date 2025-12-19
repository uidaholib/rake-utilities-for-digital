# count_pdf_pages

`rake count_pdf_pages` allows you to select a directory to count all PDF files and total PDF pages.

The task outputs a CSV with the count of PDF files, the count of total pages in the PDFs, and list of all filenames that triggered errors.

## Options

The options can be changed by passing arguments with the rake command.

| option | description | default value |
| --- | --- | --- |
| directory | the full path of directory to count | '.' |
| recursive | include subfolders | 'true' |
| output_csv | the filename for new CSV containing the count data | 'pdf_count.csv' |
