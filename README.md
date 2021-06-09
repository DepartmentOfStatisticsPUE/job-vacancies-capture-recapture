# Estimating the number of entities with vacancies using administrative and online data

Replicating results from the paper "Estimating the number of entities with vacancies using administrative and online data" by Maciej Beręsewicz, Herman Cherniaiev and Robert Pater

**Abstract**

In the paper we focus on estimating the number of entities with at least one vacancy in Poland for 4 quarters of 2018.  To achieve this goal we propose an alternative methodology that is based solely on administrative (i.e. job vacancies registered at Public Employment Offices) and online data (i.e. Pracuj.pl, one of the biggest service) and capture-recapture techniques. 

As these sources do not cover the whole reference population and the number of common units is small, we used developed a capture-recapture estimator for negatively dependent sources based on recent work of \citet{Chatterjee2019a}. To achieve the main goal we conducted a~thorough data cleaning procedure to remove out-of-scope units, identify entities from the target survey population and link them by identifiers to reduce linkage errors. We verified effectiveness of the proposed estimator by simulation studies.

From the practical point of view, our results show that current vacancy survey in Poland underestimate number of entities at least one vacancy by about 10-15\%. The main reasons are non-sampling errors i.e. non-response and under-reporting which is identified by comparing with admin data.  

The proposed methodology uses existing data, instead of creating new ones, and may allow to estimate job vacancy statistics more frequently and reduce burden for respondents. We believe that the proposed methodology may be applied in other countries as similar admin and online data are available. To make it more accessible we make all codes available publicly. 


## Replication information

1. Go to https://julialang.org/downloads/ and download at least `julia 1.6.0` (tested under this version)
2. Clone this repository with `git clone https://github.com/DepartmentOfStatisticsPUE/job-vacancies-capture-recapture`
3. Go to this folder and run the following command: 

```
julia -e 'using Pkg; Pkg.activate("."); Pkg.instantiate()'
```

4. After installing all required packages run the notebooks from the folder `codes/`
5. Please consult `data/data-for-capture-recapture.md` for the description of the data

## System

```julia
Julia Version 1.6.0
Commit f9720dc2eb (2021-03-24 12:55 UTC)
Platform Info:
  OS: macOS (x86_64-apple-darwin19.6.0)
  CPU: Intel(R) Core(TM) i7-4850HQ CPU @ 2.30GHz
  WORD_SIZE: 64
  LIBM: libopenlibm
  LLVM: libLLVM-11.0.1 (ORCJIT, haswell)
```

Packages

```
  [336ed68f] CSV v0.8.5
  [13f3f980] CairoMakie v0.5.6
  [a93c6f00] DataFrames v1.1.1
  [31c24e10] Distributions v0.25.2
  [f6369f11] ForwardDiff v0.10.18
  [b6b21f68] Ipopt v0.6.5
  [4076af6c] JuMP v0.21.8
  [b964fa9f] LaTeXStrings v1.2.1
  [23fbe1c1] Latexify v0.15.6
  [ee78f7c6] Makie v0.13.11
  [15e1cf62] NPZ v0.4.1
  [b98c9c47] Pipe v1.3.0
  [91a5bcdd] Plots v1.16.0
  [92933f4c] ProgressMeter v1.7.1
  [2913bbd2] StatsBase v0.33.8
  [a5390f91] ZipFile v0.9.3
  [8ba89e20] Distributed
  [37e2e46d] LinearAlgebra
  [9a3f8284] Random
  [10745b16] Statistics
```
