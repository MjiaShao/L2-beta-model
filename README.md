# L2-beta-model

Each simulation/data example has its own main file.  See the details below.

<h2>Reference:</h2>

* <a href="https://www.asc.ohio-state.edu/zhang.7824/L2BetaModel.pdf">L-2 regularized maximum likelihood for $\beta$-model in large and sparse networks</a><br />
<i>Meijia Shao, Yu Zhang, Qiuping Wang, Yuan Zhang, Jing Luo and Ting Yan</i><br>

Citation:
```bibtex
@article{shao2023L2,
    AUTHOR = {Shao, Meijia and Zhang, Yu and Wang, Qiuping and Zhang, Yuan and Luo, Jing and Yan, Ting},
     TITLE = {L-2 regularized maximum likelihood for $\beta$-model in large and sparse networks},
   JOURNAL = {ArXiv preprint arXiv:2110.11856},
      YEAR = {2023},
}


```

<h2>Contents:</h2>
This README file contains step-by-step instructions on how to reproduce the simulation and data example results in the <a href="https://www.asc.ohio-state.edu/zhang.7824/L2BetaModel.pdf">Main Paper</a>.


<h2>Remarks:</h2>
<ul>
  <li> The original coding files for implementing <a href="https://doi.org/10.1111/rssb.12444"><i>Chen et al. (2021)</i></a> and <a href="https://arxiv.org/abs/2010.13604"><i>Stein and Leng (2020)</i></a> in 'simulation_2_chen.R' and 'simulation_2_stein.R' are not included in this repository.  Please contact the authors of those papers to request the code.
</ul>


<h2>Subroutine list</h2>

1. 'generate_A.m'
2. 'generate_beta.m'
3. 'Fast_Newton_method.m'
4. 'Fast_gradient_method.m'  
5. 'AIC_criterion_function.m'
6. 'objective_function.m'
7. 'outlier_elim.m'
8. 'shadedErrorBar.m'  (publically available routine, https://github.com/raacampbell/shadedErrorBar)



<h2>Instructions for result reproduction</h2>

<h3>Preparation:</h3>

Before running our code, please:

1. Place all coding files in your local working folder and create four subfolders named 'results','plots','data' and 'parameters', respectively;
2. Download data sets from the sources printed in the <a href="https://www.asc.ohio-state.edu/zhang.7824/L2BetaModel.pdf">paper</a> and place the data files under the subfolder 'data'.

<h3>To reproduce simulation 1 results in Section 5.1:</h3>

1. Run 'simulation_1_part1a.m' to reproduce Row 1 of Figure 1;
2. Run 'simulation_1_part1b.m' to reproduce Row 2 & 3 of Figure 1;
2. Run 'simulation_1_part2.m' to reproduce Figure 2 & 3.

<h3>To reproduce simulation 2 results in Section 5.2:</h3>

1. Run 'parameters.m' to prepare network setting for all methods;
2. Run 'simulation_2_our_method.m' to reproduce simulation results by our method;
3. Run 'simulation_2_stein.R' to reproduce simulation results by Stein and Leng (2020)'s method;  <br><b>(Please request the code for Stein and Leng (2020) from its authors and place it under the working directory.)</b>
4. Run 'simulation_2_chen.R' to reproduce simulation results by Chen et al. (2021)'s method;    <br><b>(Please request the code for Chen et al. (2021) from its authors and place it under the working directory.)</b>
5. Run 'plot_simulation2_part1.R' to reproduce Row 1 of Figure 4;
6. Run 'plot_simulation2_part2.R' to reproduce Row 2 of Figure 4.

<h3>To reproduce simulation 3 results in Section 5.3:</h3>

1. Run 'simulation_3.m' to reproduce Row 1 of Figure 5.

<h3>To reproduce data example 1 results in Section 6.1:</h3>

1. Preparation: download data 'anon_data.RData' from https://osf.io/muknv/ and place it under the 'data' folder;
2. Run 'data_example1_preposessing.R' for prepossessing data and it will automatically saved preprocessed data 'marginal-2019-09.csv' and 'marginal-2020-04.csv' into 'data' folder;
3. Run 'data_example1_analysis.m' and get results for the next steps; 
4. Run 'data_example1_sparse_CCA.R' to conduct data analysis based on the result in the Step 3, where we use R package 'PMA' to implement sparse CCA analysis;
5. Run 'plot_data_example1.m' to reproduce Figure 6 and Table 5. 

<h3>To reproduce data example 2a results in Section 6.2.1:</h3>

1. Preparation: obtain data in https://www.kaggle.com/datasets/group16/covid19-literature-knowledge-graph, unzip it and place it as 'kg.nt.original' in 'data' folder and download 'metadata.csv' from https://www.kaggle.com/datasets/allen-institute-for-ai/CORD-19-research-challenge
2. Run 'data_example2_kaggle_preprocessing.py' to preprocess data and save them as 'kg_Table.txt' and 'kg_in_cord19.txt' in 'data' folder;
3. Run 'data_example2_kaggle_beta_esti.m' to reproduce left plots 1 & 2 in Figure 7 and get results for the next steps;
4. Run 'plot_data_example2_kaggle.m' to reproduce Figure 8 and Table 6. 

<h3>To reproduce data example 2b results in Section 6.2.2:</h3>

1. Preparation: from https://dj2taa9i652rf.cloudfront.net/ download data in 'covid_knowledge_graph/csv/nodes' and 'covid_knowledge_graph/csv/edges'; save them to local folder paths 'data/AWS-csv/nodes' and 'data/AWS-csv/edges' respectively;
2. Run 'data_example2_aws_preprocessing.py' to preprocess data; it will produce a 'deg_vec.txt' file in the 'data' folder;
3. Run 'data_example2_aws_beta_esti.m' to get results for the next steps; (We used gradient method in this step -- please run it for sufficient number of iterations to ensure convergence. We suggest running this file on a computing server.)
4. Run 'plot_data_example2_aws.m' to reproduce the right panel plots 1 & 2 in Figure 7;
5. Run 'data_example2_aws_concept_table.py' and 'data_example2_aws_concept_table_print.m' to reproduce Table 7. 

<h3>To reproduce results in Section 7:</h3>

1. Run 'generate_tracy_widom_variables.R' to generate random variable from the Tracy-Widom distribution with index 1 using R package 'RMTstat'. The results will be saved as 'tracy-widom-distribution.txt';
2. Run 'goodness_of_fit.m' and 'plot_goodness_of_fit_test.m' to reproduce Figure 9. 



