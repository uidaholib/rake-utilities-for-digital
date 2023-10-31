# migrate_contentdm

`rake migrate_contentdm` is designed to download a set of files from existing CONTENTdm collections using the CONTENTdm API to set up a static set of the files and add the new information to the metadata.

Prep CDM metadata:

- get metadata from collectionbuilder-cdm-template collection, or if not a current template collection, export metadata from CDM
- ensure column names are lowercase (select row, `Ctrl+Shift+P` to open command palette, start typing lowercase, select "Transform to lowercase")
- ensure "objectid" column exists and values are unique. For new exports, this will have to be generated. Generate the objectid from existing unique identifier or using CDM number. 
- rename "contentdm number" to "cdmid"
- check "format" field to ensure it is correct (for new exports)
- check for compound objects!
- rename columns to follow current standard template if necessary


The options can be changed by passing arguments with the rake command.

| option | description | default value |
| --- | --- | --- |
| csv_file | the filename of the CSV file to migrate | "move.csv" |
| cdm_collection_id | the contentdm collection id / alias | "hwhi" |
| output_dir | the name of the new folder to put the downloaded files in | "new/" |


The order follows [:csv_file,:cdm_collection_id,:output_dir].
For example, 

`rake migrate_contentdm["test.csv","cities","cities"]`
