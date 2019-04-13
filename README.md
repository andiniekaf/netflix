# General Overview and Objective
This repository aims to build a Netflix movie recommender system using a matrix factorization method. In R, one the ways such method can be applied is through the Recosystem package.

# The Dataset
There are two different kinds of dataset used in this repository: Training Dataset and Probe (Test) Dataset. The training dataset covers 24,053,764 ratings received for 4499 movies, by 470,758 different users, while the test dataset covers 577,213 ratings received for 4353 movies, by 321,679 different users.
Both datasets are in fact the datasets published by Netflix for a Netflix Competition. They are available on https://www.kaggle.com/netflix-inc/netflix-prize-data#combined_data_2.txt.
In order to minimize the size of the file, the training datasets are divided into 4 different parts on the Kaggle website. Since running the whole 4 takes a long time on my computer, I decided to proceed only with Part 1 (refer to file "combined_data_1.txt"). 
