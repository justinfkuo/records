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
3. Copy/save the exported CSV over `current-exports/usatf-records.csv`.
4. Commit and push the updated CSV to GitHub.

