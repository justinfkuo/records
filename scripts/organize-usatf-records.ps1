$ErrorActionPreference = "Stop"

$OldDir = "D:\records"
$NewDir = "D:\usatf-records"

Write-Host "Building clean USATF records folder at $NewDir..." -ForegroundColor Cyan

# 1. Create the directory layout on D:\
$Folders = @(
    "$NewDir\current-exports",
    "$NewDir\schema-and-templates",
    "$NewDir\scripts",
    "$NewDir\_local-only\database",
    "$NewDir\_local-only\pending-ratifications",
    "$NewDir\_local-only\ratified-packets",
    "$NewDir\_local-only\personal-shortcuts",
    "$NewDir\_local-only\_unsorted-legacy"
)

foreach ($Folder in $Folders) {
    New-Item -ItemType Directory -Path $Folder -Force | Out-Null
}

# Helper to write UTF-8 files without a Byte Order Mark (BOM)
$Utf8NoBom = New-Object System.Text.UTF8Encoding $false

# 2. Create hardened .gitignore (blocks _local-only, passwords, and shortcuts)
$GitIgnoreContent = @'
# Local-only databases, backups, and personal shortcuts
_local-only/

# Safety net: never allow credential files or Windows shortcuts on GitHub
*credential*
*password*
*.lnk
*.url

# FileMaker Pro 7.0 & Windows temporary files
*.fp7.lock
*.tmp
Thumbs.db
desktop.ini

# Python artifacts (for future scripts in scripts\)
__pycache__/
*.py[cod]
.venv/
venv/
.env
'@
[System.IO.File]::WriteAllText("$NewDir\.gitignore", $GitIgnoreContent, $Utf8NoBom)

# 3. Copy and organize existing files from D:\records safely (non-destructive)
if (Test-Path $OldDir) {
    # Copy the newest active-records CSV to a single canonical filename for Git diff tracking
    $LatestCsv = Get-ChildItem "$OldDir\*-RECORDS.csv" -ErrorAction SilentlyContinue |
        Sort-Object LastWriteTime -Descending |
        Select-Object -First 1

    if ($LatestCsv) {
        Copy-Item -Path $LatestCsv.FullName -Destination "$NewDir\current-exports\usatf-american-records.csv" -Force
        Write-Host "  Copied latest CSV ($($LatestCsv.Name)) -> current-exports\usatf-american-records.csv"
    }

    # Copy documentation and reference files
    if (Test-Path "$OldDir\20250711-mixed-gender-races.txt") {
        Copy-Item -Path "$OldDir\20250711-mixed-gender-races.txt" -Destination "$NewDir\schema-and-templates\mixed-gender-races.txt" -Force
    }
    if (Test-Path "$OldDir\chrome_8047RQB8aK.png") {
        Copy-Item -Path "$OldDir\chrome_8047RQB8aK.png" -Destination "$NewDir\schema-and-templates\usatf-upload-reference.png" -Force
    }
    Get-ChildItem "$OldDir\sample_from_jordan*.csv" -ErrorAction SilentlyContinue | ForEach-Object {
        Copy-Item -Path $_.FullName -Destination "$NewDir\schema-and-templates\$($_.Name)" -Force
    }

    # Copy local-only files (credentials, shortcuts, FileMaker backups, legacy folder)
    if (Test-Path "$OldDir\login-in-credentials.txt") {
        Copy-Item -Path "$OldDir\login-in-credentials.txt" -Destination "$NewDir\_local-only\login-in-credentials.txt" -Force
    }
    Get-ChildItem "$OldDir\*.lnk", "$OldDir\*.url" -ErrorAction SilentlyContinue | ForEach-Object {
        Copy-Item -Path $_.FullName -Destination "$NewDir\_local-only\personal-shortcuts\$($_.Name)" -Force
    }
    if ((Test-Path "$OldDir\fm-backup") -and ((Get-ChildItem "$OldDir\fm-backup" -Force).Count -gt 0)) {
        Copy-Item -Path "$OldDir\fm-backup\*" -Destination "$NewDir\_local-only\database\" -Recurse -Force
    }
    if (Test-Path "$OldDir\2024 records") {
        Copy-Item -Path "$OldDir\2024 records" -Destination "$NewDir\_local-only\_unsorted-legacy\2024-records" -Recurse -Force
    }
}

# 4. Build README.md and append existing _READ_ME_FIRST.txt notes
$ReadmeHeader = @'
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
'@

$FinalReadme = $ReadmeHeader
if (Test-Path "$OldDir\_READ_ME_FIRST.txt") {
    $ExistingNotes = Get-Content "$OldDir\_READ_ME_FIRST.txt" -Raw
    $FinalReadme += "`r`n`r`n## Existing Notes (Imported from _READ_ME_FIRST.txt)`r`n`r`n``````text`r`n$ExistingNotes`r`n``````"
}

[System.IO.File]::WriteAllText("$NewDir\README.md", $FinalReadme, $Utf8NoBom)

Write-Host "`nDone! Clean repository created at: $NewDir" -ForegroundColor Green
Write-Host "Original folder ($OldDir) was not modified." -ForegroundColor Yellow
Get-ChildItem $NewDir