# L2-beta-model

Each simulation/data example has its own main file.  See details below.

<h2>Reference:</h2>

* L-2 regularized maximum likelihood for $\beta$-model in large and sparse networks<br />
<i>Meijia Shao, Yu Zhang, Qiuping Wang, Yuan Zhang, Jing Luo and Ting Yan</i><br>


<h2>Contents:</h2>
This README file contains step-by-step instructions on how to reproduce the simulation results in Main Paper.


<h2>Remarks:</h2>
<ul>
  <li> The original coding files for implementing <i>Chen et al. (2021)</i> and <i>Stein and Leng (2020)</i> in 'simulation_2_chen.R' and 'simulation_2_stein.R' are not provided in the following coding. 
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

1. Place all coding files in main working folder, and create two subfolders named 'results','plots','data' and 'parameters';
2. Place the data files in a subfolder named 'data'.

<h3>To reproduce simulations 1 results in Section 5.1:</h3>

1. Run 'simulation_1_part1a.m' to reproduce Row 1 of Figure 1;
2. Run 'simulation_1_part1b.m' to reproduce Row 2 & 3 of Figure 1;
2. Run 'simulation_1_part2.m' to reproduce Figure 2 & 3.

<h3>To reproduce simulations 2 results in Section 5.2:</h3>

1. Run 'parameters.m' to prepare network setting for all methods;
2. Run 'simulation_2_our_method.m' to reproduce simulation results by our method;
3. Run 'simulation_2_stein.R' to reproduce simulation results by Stein and Leng(2020)'s method;
4. Run 'simulation_2_chen.R' to reproduce simulation results by Chen et al.(2021)'s method;
5. Run 'plot_simulation2_part1.R' to reproduce Row 1 of Figure 4;
6. Run 'plot_simulation2_part2.R' to reproduce Row 2 of Figure 4.

<h3>To reproduce simulations 3 results in Section 5.3:</h3>

1. Run 'simulation_3.m' to reproduce Row 1 of Figure 5.

<h3>To reproduce data example 1 results in Section 6.1:</h3>

1. Preparation: download data 'anon_data.RData' from https://osf.io/muknv/ (official website for this publically available data set), place files under 'data' folder;
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

1. Preparation: search https://dj2taa9i652rf.cloudfront.net/ and save data in 'covid_knowledge_graph/csv/nodes' and 'covid_knowledge_graph/csv/edges' into local 'data/AWS-csv/nodes' and 'data/AWS-csv/edges' respectively;
2. Run 'data_example2_aws_preprocessing.py' to preprocess data and save them as 'deg_vec.txt' in 'data' folder;
3. Run 'data_example2_aws_beta_esti.m' and get results for the next steps;(We use gradient method in this step and it might run for a long time to ensure convergence of estimation. We suggest to run this file in the computing server.)
4. Run 'plot_data_example2_aws.m' to reproduce right plots 1 & 2 in Figure 7;
5. Run 'data_example2_aws_concept_table.py' and 'data_example2_aws_concept_table_print.m' to reproduce Table 7. 

<h3>To reproduce results in Section 7:</h3>

1. Run 'generate_tracy_widom_variables.R' to generate random variable from Tracy-Widom distribution with index 1 using R package 'RMTstat'. The results will saved as 'tracy-widom-distribution.txt';
2. Run 'goodness_of_fit.m' and 'plot_goodness_of_fit_test.m' to reproduce Figure 9. 



