# Fuzzy Logic Restoration Scheme for Martian Imagery from Perseverance Rover

**Associated Manuscript:**  
*A Fuzzy Logic Restoration Scheme for Martian Imagery from Perseverance Rover*  
Fousia M Shamsudeen, Vipin Venugopal *(Corresponding Author)*, Anoop B N

---

## Table of Contents

- [Overview](#overview)
- [Motivation](#motivation)
- [Algorithm Description](#algorithm-description)
  - [Fuzzy Membership Function](#1-fuzzy-membership-function)
  - [Intensification of Fuzzy Membership Function (IFMF)](#2-intensification-of-fuzzy-membership-function-ifmf)
  - [Defuzzification](#3-defuzzification)
- [Functions](#functions)
  - [FCI\_Colour](#fci_colour)
  - [FCI](#fci)
- [Parameters](#parameters)
- [Mathematical Formulation](#mathematical-formulation)
- [Usage](#usage)
- [Requirements](#requirements)
- [Performance Metrics](#performance-metrics)
- [Results Summary](#results-summary)
- [Authors & Affiliations](#authors--affiliations)
- [Citation](#citation)
- [License](#license)

---

## Overview

This repository contains the MATLAB implementation of the **Fuzzy Colour Image (FCI) Enhancement** algorithm, also referred to as the **Fuzzy Transformation Function (FTF)** in the associated manuscript. The algorithm is specifically designed to improve the visibility of low-light and shadow-masked regions in Martian photographs (MPs) captured by NASA's Perseverance rover.

---

## Motivation

Martian photographs are a primary resource for geologic analysis of Mars. However, many images suffer from:

- **Low-light conditions** due to the distance from the Sun
- **Shadow masking** caused by terrain topology
- **Poor object visibility** in specific regions

Existing enhancement techniques — including demosaicing, dust correction, super-resolution, pansharpening, histogram equalisation (HE) and its variants — do not directly address these visibility issues. The proposed Fuzzy Transformation Function (FTF) fills this gap by operating directly in the fuzzy domain across all three colour channels (R, G, B).

---

## Algorithm Description

The algorithm processes each RGB colour channel independently through three sequential stages:

### 1. Fuzzy Membership Function

Each pixel intensity is mapped to a fuzzy membership value (FMV) in the range [0, 1] using:

```
μ(x) = (1 + (X_max - x) / DFP)^(-EFP)
```

Where:
- `x` — pixel intensity value
- `X_max` — maximum intensity in the image channel
- `DFP` — Denominational Fuzzification Parameter (fixed at 127)
- `EFP` — Exponential Fuzzification Parameter (user-defined)

### 2. Intensification of Fuzzy Membership Function (IFMF)

A nonlinear operator compresses membership values at the extrema and stretches intermediate values:

```
IFMF(i,j) = 2 * μ(i,j)²                        if μ(i,j) ≤ 0.5
IFMF(i,j) = 1 - 2 * (1 - μ(i,j))²              if μ(i,j) > 0.5
```

### 3. Defuzzification

The enhanced pixel intensities are recovered from the modified membership values by inverting the fuzzification:

```
x' = X_max - ((IFMF^(-1/EFP) - 1) * DFP)
```

The result is cast back to `uint8`.

---

## Functions

### `FCI_Colour`

**Signature:**
```matlab
Enhanced_Image_Colour = FCI_Colour(Input_Image_Colour, Exponential_Fuzzification_Parameter)
```

**Description:**  
Wrapper function that applies the FCI enhancement to a 3-channel (RGB) colour image by processing each channel independently.

**Inputs:**

| Parameter | Type | Description |
|-----------|------|-------------|
| `Input_Image_Colour` | uint8 H×W×3 | Input RGB image |
| `Exponential_Fuzzification_Parameter` | double (scalar) | Controls the degree of fuzzification |

**Output:**

| Parameter | Type | Description |
|-----------|------|-------------|
| `Enhanced_Image_Colour` | uint8 H×W×3 | Enhanced RGB image |

**Internal constant:**
- `Denominational_Fuzzification_Parameter = 127` (hardcoded, midpoint of [0, 255])

---

### `FCI`

**Signature:**
```matlab
Enhanced_Image = FCI(Input_Image, EFP, DFP)
```

**Description:**  
Core enhancement function. Operates on a single-channel (grayscale or one colour plane) image. Implements fuzzification → intensification → defuzzification pipeline.

**Inputs:**

| Parameter | Type | Description |
|-----------|------|-------------|
| `Input_Image` | uint8 H×W | Single-channel image |
| `EFP` | double | Exponential Fuzzification Parameter |
| `DFP` | double | Denominational Fuzzification Parameter |

**Output:**

| Parameter | Type | Description |
|-----------|------|-------------|
| `Enhanced_Image` | uint8 H×W | Enhanced single-channel image |

---

## Parameters

| Parameter | Symbol | Recommended Value | Description |
|-----------|--------|-------------------|-------------|
| Exponential Fuzzification Parameter | EFP | 2 (typical) | Controls stretch/compression of membership values. Higher values yield stronger contrast enhancement. |
| Denominational Fuzzification Parameter | DFP | 127 (fixed) | Normalises the intensity range; set to the midpoint of [0, 255]. |

---

## Mathematical Formulation

The complete transformation pipeline for each pixel intensity `x` in a channel:

**Step 1 — Fuzzify:**
```
μ = (1 + (X_max - x) / 127)^(-EFP)
```

**Step 2 — Intensify:**
```
       ⎧ 2μ²              if μ ≤ 0.5
IFMF = ⎨
       ⎩ 1 - 2(1-μ)²      if μ > 0.5
```

**Step 3 — Defuzzify:**
```
x' = X_max - ((IFMF^(-1/EFP) - 1) × 127)
```

---

## Usage

```matlab
% Read a Martian image
img = imread('martian_image.jpg');

% Apply FCI enhancement with EFP = 2
EFP = 2;
enhanced_img = FCI_Colour(img, EFP);

% Display original and enhanced images
figure;
subplot(1,2,1); imshow(img);      title('Original');
subplot(1,2,2); imshow(enhanced_img); title('FCI Enhanced');

% Save output
imwrite(enhanced_img, 'enhanced_martian.jpg');
```

---

## Requirements

- **MATLAB** R2016b or later (no additional toolboxes required)
- Input image: any standard format readable by `imread` (JPEG, PNG, TIFF, etc.)
- Input image must be **RGB (3-channel)**; for grayscale images use `FCI` directly

---

## Performance Metrics

The FTF was evaluated on 100 Martian photographs using four objective metrics:

| Metric | Description | Desired Direction |
|--------|-------------|-------------------|
| **VSI** — Visual Saliency-Induced Index | Measures preservation of visual saliency | Higher is better |
| **SFF** — Sparse Feature Fidelity | Measures structural fidelity of sparse features | Higher is better |
| **LOM** — Lightness Order Measure | Measures violations of natural lightness ordering | Lower is better |
| **LOE** — Lightness Order Error | Measures colour distortion and unnatural lightness changes | Lower is better |

---

## Results Summary

Comparative evaluation against state-of-the-art image enhancement methods on 100 Martian photographs:

| Method | VSI ↑ | SFF ↑ | LOM ↓ | LOE ↓ |
|--------|--------|--------|--------|--------|
| **FTF (Proposed)** | **0.9861 ± 0.0026** | **0.9801 ± 0.0055** | **117.8 ± 15.4605** | **0.9 ± 1.4681** |
| Histogram Equalisation | — | — | — | — |
| Other compared methods | — | — | — | — |

The FTF achieved the **highest VSI and SFF** and the **lowest LOM and LOE**, demonstrating superior visibility enhancement without information loss or colour distortion.

---

## Authors & Affiliations

| Author | Affiliation | Contact |
|--------|-------------|---------|
| **Fousia M Shamsudeen** | Department of MCA, TKM College of Engineering, Kollam, Kerala 691005, India | fousiasahala@gmail.com |
| **Vipin Venugopal** *(Corresponding)* | Amrita School of Artificial Intelligence, Amrita Vishwa Vidyapeetham, Coimbatore 641112, India | v_vipin@cb.amrita.edu |
| **Anoop B N** | School of Computer Science and Engineering, Manipal Institute of Technology, MAHE, Manipal, Karnataka 576104, India | anoop.bn@manipal.edu |

---

## Citation

If you use this code in your research, please cite:

```bibtex
@article{shamsudeen2024fuzzy,
  title     = {A Fuzzy Logic Restoration Scheme for Martian Imagery from Perseverance Rover},
  author    = {Shamsudeen, Fousia M and Venugopal, Vipin and B N, Anoop},
  journal   = {[Journal Name]},
  year      = {[Year]},
  volume    = {[Volume]},
  pages     = {[Pages]},
  doi       = {[DOI]}
}
```

---

## License

This code is released for academic and research use in association with the manuscript listed above. Please contact the corresponding author (v_vipin@cb.amrita.edu) for permissions regarding commercial use or redistribution.

