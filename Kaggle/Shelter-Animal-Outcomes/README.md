# [Shelter Animal Outcomes Kaggle competiton](https://www.kaggle.com/c/shelter-animal-outcomes)

#### Help improve outcomes for shelter animals

## Overview

### Description

Every year, approximately 7.6 million companion animals end up in US shelters. Many animals are given up as unwanted by their owners, while others are picked up after getting lost or taken out of cruelty situations. Many of these animals find forever families to take them home, but just as many are not so lucky. 2.7 million dogs and cats are euthanized in the US every year.

![alt text](https://kaggle2.blob.core.windows.net/competitions/kaggle/5039/media/kaggle_pets2.png)

Using a dataset of intake information including breed, color, sex, and age from the [Austin Animal Center](http://www.austintexas.gov/department/animal-services), we're asking Kagglers to predict the outcome for each animal.

We also believe this dataset can help us understand trends in animal outcomes. These insights could help shelters focus their energy on specific animals who need a little extra help finding a new home. We encourage you to publish your insights on [Scripts](https://www.kaggle.com/c/shelter-animal-outcomes/scripts) so they are publicly accessible.

### Acknowledgements

Kaggle is hosting this competition for the machine learning community to use for data science practice and social good. The dataset is brought to you by [Austin Animal Center](http://www.austintexas.gov/department/animal-services). Shelter animal statistics were taken from the [ASPCA](http://www.aspca.org/animal-homelessness/shelter-intake-and-surrender/pet-statistics).

*Glamour shots of Kaggle's shelter pets are pictured above. From left to right: Shelby, Bailey, Hazel, Daisy, and Yeti.*

### Evaluation

Submissions are evaluated using the [multi-class logarithmic loss](https://www.kaggle.com/wiki/MultiClassLogLoss). Each incident has been labeled with one true class. For each animal, you must submit a set of predicted probabilities (one for every class). The formula is then,

<!--
$$log loss = -\frac{1}{N}\sum_{i=1}^N\sum_{j=1}^My_{ij}\log(p_{ij}),$$
-->


<p align="center">
  <img src="https://latex.codecogs.com/svg.latex?log&space;loss&space;=&space;-\frac{1}{N}\sum_{i=1}^N\sum_{j=1}^My_{ij}\log(p_{ij})," title="log loss = -\frac{1}{N}\sum_{i=1}^N\sum_{j=1}^My_{ij}\log(p_{ij}),">
</p>

where N is the number of animals in the test set, M is the number of outcomes, <img src="https://latex.codecogs.com/svg.latex?\inline&space;log" title="log" /> is the natural logarithm, <img src="https://latex.codecogs.com/svg.latex?\inline&space;y_{ij}" title="y_{ij}" /> is 1 if observation <img src="https://latex.codecogs.com/svg.latex?\inline&space;i" title="i" /> is in outcome <img src="https://latex.codecogs.com/svg.latex?\inline&space;j" title="j" /> and 0 otherwise, and <img src="https://latex.codecogs.com/svg.latex?p_{ij}" title="p_{ij}" /> is the predicted probability that observation <img src="https://latex.codecogs.com/svg.latex?\inline&space;i" title="i" /> belongs to outcome <img src="https://latex.codecogs.com/svg.latex?\inline&space;j" title="j" />.

The submitted probabilities for a given animal are not required to sum to one because they are rescaled prior to being scored (each row is divided by the row sum). In order to avoid the extremes of the log function, predicted probabilities are replaced with <img src="https://latex.codecogs.com/svg.latex?max(min(p,1-10^{-15}),10^{-15})" title="max(min(p,1-10^{-15}),10^{-15})" />

### Submission Format

You must submit a csv file with the animal id, all candidate outcome names, and a probability for each outcome. The order of the rows does not matter. The file must have a header and should look like the following:

```
AnimalID,Adoption,Died,Euthanasia,Return_to_owner,Transfer
A715022,1,0,0,0,0
A677429,0.5,0.3,0.2,0,0
...
etc.
```