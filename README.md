# ANOVA
[![Build Status](https://travis-ci.org/grero/ANOVA.jl.svg?branch=master)](https://travis-ci.org/grero/ANOVA.jl)

Basic two way ANOVA and repeated measures ANOVA in Julia.

## Usage

```julia
#data taken from https://people.richland.edu/james/ictcm/2004/twoway.html    
using ANOVA
Y = [54, 49, 59, 39, 55, 25, 29, 47, 26, 28,53, 72, 43, 56, 52,46, 51, 33, 47, 41,33, 30, 26, 25, 29,18, 21, 34, 40, 24]
_race = ["Caucasian", "African-American", "Hispanic"]
race = [r for i in 1:10, r in _race][:]
G = ["Male", "Female"]
gender = [g for i = 1:5, g in G,j in 1:3][:]
P = ANOVA.anova(Y, race, gender)
```
