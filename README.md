# PeaKDEck
"Original PeaKDEck v1.1 (Feb 2014) - Kernel density estimation-based peak caller for DNaseI-seq data, by Michael T. McCarthy."

# PeaKDEck v1.1 (February 2014)

Original Perl-based toolkit for kernel density estimation (KDE) peak calling in DNaseI-seq data, with utilities for SAM file processing. Developed by Michael T. McCarthy at the University of Oxford.

This repository preserves the authentic v1.1 release from the 2014 *Bioinformatics* paper: [PeaKDEck: a kernel density estimator-based peak calling program for DNaseI-seq data](https://academic.oup.com/bioinformatics/article/30/9/1302/235185).

The original website (www.ccmp.ox.ac.uk/peakdeck) is defunct, and a brief 2024 GitHub mirror by the author (@mccarthymt7) was removed. This repo makes it publicly available again, with no modifications except modern notes.

## Features
- **Peak Calling (-P)**: Identifies peaks in sorted SAM files using KDE for background estimation.
- **Density Analysis (-D)**: Generates smoothed WIG tracks.
- **SAM Utilities**: Numerical sorting (-NS), filtering (-F) for MAPQ/UQ/PCR duplicates, random read selection (-R).
- **Top Peaks (-T)**: Sorts BED files by score.
- **GUI Versions**: Perl/Tk wrappers for easier use on macOS/Windows.
- Supports DNaseI-seq, adaptable to ChIP-seq.

## Installation
- **Requirements**: Perl 5.12+ (tested up to 5.38 in 2025). For Windows CLI: `Math::Random::MT` (via CPAN/PPM). For GUI: Perl/Tk and X11/XQuartz on macOS/Linux.
- No install needed—scripts are standalone.
- Clone: `git clone https://github.com/michaeltmccarthy/PeaKDEck.git`
- Run: `perl src/peakdeck_CAP_osx_v1.1.pl -h` (adjust for your OS).

## Usage Examples
From the docs (see `docs/PeaKDEck_GUI_readme.pdf` for full details):

# Numerical sort SAM
perl src/peakdeck_CAP_osx_v1.1.pl -NS input.sam > sorted.sam

# Filter (MAPQ >= 30, remove PCR dups)
perl src/peakdeck_CAP_osx_v1.1.pl -F sorted.sam -g hg38.chrom.sizes -q 30 -PCR ON > filtered.sam

# Density track
perl src/peakdeck_CAP_osx_v1.1.pl -D filtered.sam -g hg38.chrom.sizes -STEP 20 -n 150 -d 50 > density.wig

# Peak calling
perl src/peakdeck_CAP_osx_v1.1.pl -P filtered.sam -g hg38.chrom.sizes -bin 300 -back 3000 -STEP 50 > peaks.bed
