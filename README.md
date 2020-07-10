# About this repo

This repository contains some material from my consultancy for the Electoral Contention and Violence Data Project (ECAV).

The client agreed to make publicly available all the material that can be found in this repository.

Peer-reviewed articles:

Daxecker U., Amicarelli E. and Alexander Jung. Electoral contention and violence (ECAV): a new dataset, Journal of Peace Research (2019). https://journals.sagepub.com/doi/full/10.1177/0022343318823870

## The ECAV project

The ECAV project is lead by Dr. Ursula Daxecker (University of Amsterdam, UvA). The goal of ECAV is to create a database of nonviolent and violent acts of contestation by state or nonstate actors during period of national elections in uncosolidated regimes. In order to accomplish this goal, trained human coders identify the political events of interests from provided news articles and encode them into machine-readable variables following a set of pre-established coding rules. If for example a newswire is reporting a protest in Cairo, the coders extract information regarding who did what when and where and enter this information in a database.

## The problem

The production of event data can create problems of data quality. Human coders
can vary in their ability to correctly identify and encode the political events of interest. Factors such as a) different levels in the understanding of what has to be considered an event of interest, b) how the coding rules should be applied in order to translate the news reporting in machine-readable variables and c) the effort each coder puts in doing his job, can jeopardize
the quality of the data. For these reasons, the Project Leader was interested in assessing the quality of the data produced and in evaluating the coders’ performances based on objective criteria.
The consulting involved the devise of a sound statistical design to:
1) Assess the performances of the coders in order to orient hiring decisions as well as decisions regarding the targeted provision of further training.
2) Evaluate the quality of the data produced in order to ensure that the information extracted from news articles was correct.
3) Identify the coding rules negatively affecting the data extraction: for example some coding protocols may be not specific enough in order to allow to consistently extract the right bit of information from the news.

## The solution

In order to address the above mentioned problem I have designed and implemented a statistical strategy tailored on the client's needs. 

The following documents produced during this job are available in the "reports" folder:

- 1_ECAV08016_Strategy. This document outlines a strategy to assess the coders’ performances and the data quality for the ECAV project.

- 2_ECAV09016_identification. This document describes the methodology adopted and presents the statistical results regarding the assessment of the coders' identification performances.

- 3_ECAV10016_reliability_and_validity. This document presents the methodology adopted and the statistical results for coders' reliability and validity performances.

- 4_ECAV03017_comparison. This document compares ECAV data with the data produced by a different data project.

In the "functions" folder you can find some relevant R code:

- identification_functions. Functions to calculate true positive rates and precision performances by coder with 95% bootstrapped confidence intervals.

- reliability_functions. A set of functions built around the irr package to calulate and output reliability and validity at the global and invidual level.
