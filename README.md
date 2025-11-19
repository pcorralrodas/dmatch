# `dmatch`: Nonparametric Distribution Matching for Stata

`dmatch` is a Stata command that matches two datasets using a **nonparametric distribution-matching method**, commonly used when merging expenditure surveys with labor force surveys. The method draws a random sample with replacement from the source dataset and performs a 1:1 distributional pairing based on a specified matching variable.

This approach allows users to bring over multiple variables simultaneously while preserving the distributional properties of the matching variable—substantially reducing computational burden relative to parametric approaches.

Before running `dmatch`, users must **append the source dataset to the target dataset**, resulting in a *single long-format dataset*.

## ⭐ Features

- Nonparametric distribution matching
- 1:1 pairing between target and source observations
- Supports:
  - Strata-based matching
  - Outlier trimming
  - Weight-based expansion
  - Predicting multiple missing variables in the target dataset
- Reproducible results via random seeds

## 🔧 Syntax

```
dmatch {matchvar} [{predictvars}] [if] [in] , uniqid(varlist) todata(varlist) [options]
```

### Required Arguments

| Argument | Description |
|---------|-------------|
| **{matchvar}** | Variable used to rank distributions and perform the match. Must exist in both datasets. |
| **{predictvars}** | Variables to be predicted in the target data (missing in target, present in source). |
| **uniqid(varlist)** | Variables uniquely identifying each observation in the appended data. |
| **todata(varlist)** | Binary indicator: 1 = target data, 0 = source data. |

## ⚙️ Optional Options

| Option | Description |
|--------|-------------|
| `seed(integer)` | Random seed for replicability (default: 12345). |
| `strata(varname)` | Strata identifier (e.g., region). Matching is performed within strata. |
| `trimvar(varname)` | Variable used for trimming (default = matchvar). |
| `trimup(#)` | Drop observations above percentile (90–99). |
| `trimlow(#)` | Drop observations below percentile (1–10). |
| `expand(varname)` | Expands source data before sampling—typically inverse sampling weights. |

## 📘 Description

`dmatch` performs a nonparametric matching between a target and a source dataset. The workflow:

1. Append source and target data.
2. Flag target vs. source using `todata()`.
3. Randomly sample with replacement from the source to create a synthetic sample of equal size to the target.
4. Match distributions of `matchvar` between the target and the synthetic sample using a ranking-based algorithm.
5. Bring over all specified `predictvars` to the target data through the 1:1 pairing.

This method is often used in survey-to-survey imputation, especially when combining labor force surveys with household expenditure surveys.

## 📌 Example

```stata
sysuse auto, clear
set seed 12345
gen random = runiformint(1,74)

gen target     = 1 if random < 11
replace target = 0 if random >= 11

replace weight = . if random < 11
replace trunk  = . if random < 11

gen id = _n

dmatch length weight trunk, ///
    uniqid(id) todata(target) ///
    strata(foreign) trimvar(length) trimlow(1) trimup(95)
```

## 📥 Installation

```stata
github install pcorralrodas/dmatch
```

## 👤 Authors

**Paul Corral**  
Poverty & Equity Global Practice, The World Bank  
Washington, DC  
Corresponding author  
pcorralrodas@worldbank.org

**Jia Gao**  
Poverty & Equity Global Practice, The World Bank  
Washington, DC  
Corresponding author  
jgao4@worldbank.org

## ⚠️ Disclaimer

All errors or omissions are the responsibility of the authors alone. This software is provided as-is, without warranty.


