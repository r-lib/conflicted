# strict

[![Travis-CI Build Status](https://travis-ci.org/hadley/strict.svg?branch=master)](https://travis-ci.org/hadley/strict)

The goal of strict to make R behave a little more strictly, making base functions more likely to throw an error rather than returning potentially ambiguous results. 

`library(strict)` forces you to confront potential problems now, instead of in the future. This has both pros and cons: often you can most easily fix a potential ambiguity when your working on the code (rather than in six months time when you've forgotten how it works), but it also forces you to resolve ambiguities that might never occur with your code/data.

Current features:

* On package load, set options to warn when partial matching occurs.
