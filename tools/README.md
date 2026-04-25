# Tools

Helper scripts for analyzing Bash Bunny NAND dumps, firmware archives, and mounted filesystem images.

## Layout

```text
tools/
├─ nand/
│  └─ analyze_nands.sh
├─ extract/
├─ mount/
└─ diff/
```

## NAND analysis

Run from anywhere:

```bash
bash tools/nand/analyze_nands.sh /path/to/nand/images /path/to/output
```

Default paths if no arguments are supplied:

```text
NAND input: ~/bb/nand
Output:     ~/bb/analysis
```

The script creates reports, strings output, headers, binwalk output, entropy output, and filesystem detection notes.

Do not commit generated output or firmware blobs.
