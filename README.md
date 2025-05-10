# ClamAVContextMenuScanReportWin
Windows ClamAV Context menu Scan and Generate HTML report with Virus references

# ClamAV Right-Click Scan Tool for Windows

This tool integrates ClamAV with Windows Explorer's right-click context menu, allowing you to scan any file or folder and generate a professional-looking HTML report with VirusTotal links and signature info.

---

## 📦 Prerequisites

- **ClamAV for Windows**
  - Install to: `C:\Program Files\ClamAV`
  - Download: [https://www.clamav.net/downloads](https://www.clamav.net/downloads)
  NOTE: If you install in a different location make path changes accordingly in the .reg file and in .ps1 file

- Ensure the following files are present:
C:\Program Files\ClamAV\clamscan.exe
C:\Program Files\ClamAV\clamdscan.exe
C:\Program Files\ClamAV\freshclam.exe
C:\Program Files\ClamAV\clamd.conf
C:\Program Files\ClamAV\freshclam.conf



- **Update virus definitions** using:
"C:\Program Files\ClamAV\freshclam.exe"

---

## 📁 clamav_scan_tool Installation

1. Extract the contents of `clamav_scan_tool.zip` to:

C:\Program Files\ClamAV
├── clamav_scan.bat
├── claav_context_menu.reg
├── scan.ps1
└── assets
   ├── clean.png
   └── virus.png
   └── file.png


---

## 🖱️ Enable Right-Click "Scan with ClamAV"

1. Create or open a file named `clamav_context_menu.reg` with the following contents:

🚀 How to Use

    Right-click any file or folder

    Click "Scan with ClamAV"

    A PowerShell window opens, showing scan progress

    After scan completes:

        An HTML report will be saved on your Desktop

        If threats are found, the report includes:

            File path

            Signature name

            SHA256 hash

            VirusTotal and ClamAV signature links

❓ Troubleshooting

    No scan results?

        Ensure ClamAV is installed and virus definitions are up to date.

    HTML report missing?

        Check if PowerShell has permission to write to your Desktop.

        Review console for errors.

    Slow scans?

        Avoid clamscan.exe; prefer clamdscan.exe.

        Avoid scanning entire C:\ drive unless necessary.

