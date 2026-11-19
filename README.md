# USA Track & Field — American Records

Official master CSV export and handover documentation for maintaining USA Track & Field (USATF) American Records.

## Repository Structure

- `current-exports/usatf-american-records.csv` — The active master CSV currently published on the USATF website. Overwriting this single filename on every update lets GitHub track line-by-line record changes.
- `schema-and-templates/` — Sample CSV formatting, upload reference screenshots, and event rules (such as mixed-gender races).
- `scripts/` — Helper scripts for verifying and maintaining records.
- `_local-only/` *(Ignored by Git — stored locally only)*:
  - `database/` — Master FileMaker Pro 7.0 (`.fp7`) database, dated snapshots, and full historical exports.
  - `pending-ratifications/` & `ratified-packets/` — Supporting record documentation.
  - `personal-shortcuts/` — Local workstation shortcuts and credentials.

## Active CSV vs. Full Historical Database

- **Website CSV (`current-exports/usatf-american-records.csv`):** Contains **active records only** (marks currently listed on the USATF website).
- **FileMaker Pro 7.0 Database (`_local-only/database/*.fp7`):** Contains **both active and superseded historical records**.
- **Biannual Archiving:** At least twice a year, save a dated copy of the `.fp7` file (e.g., `2026-11-19_USATF_American_Records.fp7`) plus a plain-text CSV export of **all records and all fields** into `_local-only/database/` so future maintainers can read the complete history even without FileMaker Pro 7.0.

## Routine Update Steps

1. Back up the master FileMaker Pro 7.0 (`.fp7`) database into `_local-only/database/`.
2. Export the active-records CSV from FileMaker Pro 7.0 (verify Windows-1252 vs. UTF-8 encoding) and upload it to the USATF admin portal.
3. Copy/save the exported CSV over `current-exports/usatf-american-records.csv`.
4. Commit and push the updated CSV to GitHub.

## Existing Notes (Imported from _READ_ME_FIRST.txt)

```text
September 4, 2025: I created a Macro in Textpad to help convert the records file to a format ready for uploading to the USATF.ORG website. The macro, "records-for-upload.TPM", is available by clicking on the Macros menu and navigating to the bottom of the pop-up menu. Here are the macro details:

File name: records-for-upload.TPM

Full path:  C:\Users\justi\AppData\Roaming\Helios\TextPad\9\records-for-upload.TPM

Display Name:  Prepare records for upload to USATF.org

Description:  Prepare CSV records for uploading to USATF.org records page.

Prepare records for upload to USATF.org




August 8, 2025 - The CSV file that I create in FileMaker must be edited before uploading to the USATF website. Here are the steps for making the changes in TEXTPAD.  The macro is named: records-for-upload.TPM.  

1) open the CSV file containing the records in TEXTPAD. Each value in the file will be surrounded by double quotes.

2) Add sequential number as the first item for every row.

From the first line, run the following search / replace. Be sure the regular expression is checked.

   find:     ^(.+)
   replace:  "\i",\1

   then press "Replace All"
   then "Close" 

3) Use regular expression to move the last line of the file to the first line.

Run the following search / replace. Be sure the regular expression is checked.

   find:     ^([\s\S]*)\n(.+)
   replace:  \2\n\1

   then press "Replace All"
   then "Close" 

4) Use regular expression to edit the first line to replace selected fields.

   find:     ^".*?",(.*?,")\?","\?(".*?,)(.+\n)([\s\S]*)
   replace:  "externalid",\1event date","event date end\2\3\4

   then press "Replace All"
   then "Close" 

5) save the file.

The file is ready to be imported on the  USATF Records page.

Go to:  https://www.usatf.org/admin/

Select: Records

Enter "testing" at the "Reason for import" prompt.

Press the "Choose File" button and select the csv file with the records data.

Press the green "Upload File" button.


April 8, 2025 - I struggled to get the 20250408-records.csv file to upload. After editing the CSV file in SOFFICE and found the file had characters that did not belong like:

ACO-08+ACO-06+ACO-27

To correct, when importing the CSV file into SOFFICE, I changed the Character set from Unicode (UTF-7) to Unicode (UTF-8).  

For the future, I will need to make sure the Character set is Unicode (UTF-8).  


# # #

 
```