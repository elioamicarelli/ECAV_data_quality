# About this repo

In 2016 I provided statistical consultancy services to the Electoral Contention and Violence Data Project (ECAV). This repository contains some of the material produced for this job.

## ECAV in brief

The ECAV project is based at the University of Amsterdam (UvA) where it is lead by Dr. Ursula Daxecker. The goal of ECAV is to create a database of nonviolent and violent acts of contestation by state or nonstate actors during period of national elections in uncosolidated regimes. In order to accomplish this goal, 11 trained human coders identify the political events of interests from provided news articles and encode them into machine-readable variables following a set of pre-established coding rules.

## The problem

The manual production of event data can create problems of data quality. Human coders
can vary in their ability to correctly identify and encode the political events of interest. Factors such as a) different levels in the understanding of what has to be considered an event of interest, b) how the coding rules should be applied in order to translate the news reporting in machine-readable variables and c) the effort each coder puts in doing his job, can jeopardize
the quality of the data. For these reasons, the Project Leader was interested in assessing the quality of the data produced and in evaluating the coders’ performances based on objective criteria.

## The solution

In order to address the above mentioned problem I have designed and implemented a statistical strategy tailored on the client's needs. In the "reports" folder contained in this repository you can find the following documents produced during this job:

- ECAV08016_Strategy. This document outlines a strategy to assess the coders’ performances and the data quality for the ECAV project.

- ECAV09016_identification. This document describes the methodology adopted and presents the statistical results regarding the assessment of the coders' identifincation performances.

- ECAV10016_reliability_and_validity. This document presents the methodology adopted and the statistical results for coders' reliability and validity performances.

In the "functions" folder you can find some relevant R code written for this job:

- identification_functions. Functions to calculate true positive rates and precision performances by coder with 95% bootstrapped confidence intervals.

- reliability_functions. A set of functions built around the irr package to calulate and output reliability and validity at the global and invidual level.
