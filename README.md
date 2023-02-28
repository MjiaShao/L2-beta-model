# L2-beta-model

Each simulation/data example has its own main file.  See details below.

<h2>Reference:</h2>

* L-2 regularized maximum likelihood for \beta-model in large and sparse networks<br />
<i>Yu Zhang, Qiuping Wang, Meijia Shao, Yuan Zhang, Ting Yan& Jing Luo</i><br>


<h2>Contents:</h2>
This README file contains step-by-step instructions on how to reproduce the simulation results in Main Paper.


<h2>Remarks:</h2>
<ul>
  <li>
</ul>


<h2>Subroutine list</h2>

1. 'generate_A.m'
2. 'graphon.m'
3. 'graphon_mean.m'
4. 'Motif.m'  (publically available routine, https://github.com/yzhanghf/NetworkEdgeworthExpansion)
5. 'Our_method_NetHashing.m'
6. 'Our_method_FastTest.m'
7. 'sort_nodes.m'
8. 'sort_nodes_with_clusters.m'
9. 'NeighborhoodSmoothing.m'  (publically available routine, https://github.com/yzhanghf/NeighborhoodSmoothing)
10. 'shadedErrorBar.m'  (publically available routine, https://github.com/raacampbell/shadedErrorBar)



<h2>Instructions for result reproduction</h2>

<h3>Preparation:</h3>

Before running our code, please:

1. Place all coding files in main working folder, and create two subfolders named 'result' and 'ROC_result';
2. Place the data files in a subfolder named 'data'.

<h3>To reproduce simulations 1 & 2 results in Sections 5.1 and 5.2:</h3>



<h3>To reproduce simulation 3 results in Section 5.3:</h3>

1. Run 'Roc_simulation.m', results will output to subfolder 'ROC_result';
   (This step takes some time, please be patient.  It's recommended to run this step on a computing server.)
2. Run 'plot_Roc_all.m' to reproduce Row 1 of Figure 3;
3. Run 'Roc_simulation2.m' and 'Roc_simulation3.m', results will output to subfolder 'ROC_result';
   (This step takes some time, please be patient.  It's recommended to run this step on a computing server.)
4. Run 'plot_ROC_comparison_hist.m'  to reproduce Row 2 of Figure 3.


<h3>To reproduce data example 1 results in Section 5.4:</h3>

1. Preparation: download data from http://snap.stanford.edu/data/ego-Gplus.html (official website for this publically available data set) and unzip, place individual data files unzipped from 'gplus.tar.gz' under subfolder 'data/gplus', place 'gplus_combined.txt' under subfolder 'data'.
2. Run 'data_preposessing_ego.m' for prepossessing data and it will automatically construct 'data_pre' and 'hash_edge' subfolders;
3. Run 'similarity_matrix_ego.m', it will load the data in 'hash_edge' automatically; 
4. Run 'plot_ego_similarity_matrix.m' to reproduce Figure 4.



<h3>To reproduce data example 2 results in Section 5.5:</h3>

0. You need to obtain data from the data owner.  The data is not publically available.  See "Data_permission.txt" for more details.
1. Preparation: place data at path: 'data/TwoSampleNetwork/Final_data.mat'
2. Run 'similarity_matrix_sz.m';
3. Run 'plot_sz_similarity_matrix.m' to reproduce Figure 5.







