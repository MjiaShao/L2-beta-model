import sys
import os
import time
import csv

import numpy as np
from numpy import linalg as LA

import pandas as pd

node_list_df = pd.read_csv('./data/AWS-csv/nodes/paper_nodes.csv')
node_deg_df = pd.read_csv('./data/AWS-csv/deg_vec.txt', header=None)
beta_est_df = pd.read_csv('./results/aws_beta_est.txt', header=None)
deg_vec = node_deg_df.values
node_name_list = node_list_df['~id']
node_name_list = node_name_list.loc[deg_vec>0]
node_name_list = node_name_list.tolist()
deg_vec = deg_vec[deg_vec>0]
paper_dict = dict.fromkeys(node_name_list, 0)
for iii in range(len(paper_dict)):
    paper_dict[node_name_list[iii]] = iii

paper_score = np.zeros([len(deg_vec), 1])

beta_est_vec = beta_est_df.values
beta_est_dict = dict.fromkeys(node_name_list)
for iii in node_name_list:
    beta_est_dict[iii] = beta_est_vec[paper_dict[iii]]

concept_df = pd.read_csv('./data/AWS-csv/nodes/concept_nodes.csv')
concept_list = concept_df['~id']
concept_dict = dict.fromkeys(concept_list, 0.0)  # total score
concept_dict2 = dict.fromkeys(concept_list, 0)  # paper count
concept_dict3 = dict.fromkeys(concept_list, 0)  # total paper degree

line = 456;
count = 0
fp = open('./data/AWS-csv/edges/paper_to_concept.csv', 'r')
next(fp)
while line:
    if count % 100000 == 0:
        print(count, end=' ', flush=True);

    line = fp.readline()
    x = line.split(',')

    if len(x) <= 2: continue

    score = float(x[4][:-2])

    if x[3] not in concept_dict or x[2] not in node_name_list :
        continue
    else:
        concept_dict[x[3]] += np.exp(beta_est_dict[x[2]]) * score
        concept_dict2[x[3]] += 1
        concept_dict3[x[3]] += deg_vec[paper_dict[x[2]]]

    count += 1

fp.close()

rank_scores = np.fromiter(concept_dict.values(), dtype=float)

concept_table = pd.DataFrame()
concept_table['id'] = concept_list
concept_table['entity:String'] = concept_df['entity:String']
concept_table['concept:String'] = concept_df['concept:String']

xx1 = np.array(list(concept_dict3.values()))
xx2 = np.array(list(concept_dict2.values()))
xx3 = np.array(list(concept_dict.values()))
xx0 = np.zeros([len(xx1), 1])
xx4 = np.zeros([len(xx1), 1])
for jjj in range(len(xx1)):
    if xx2[jjj] != 0:
        xx0[jjj] = xx1[jjj] / xx2[jjj]
    else:
        xx0[jjj] = 0

concept_table['paper:number'] = xx2
concept_table['paper:avg:deg'] = xx0
concept_table['score'] = rank_scores

concept_table = concept_table.sort_values(by='score', ascending=False)
concept_table.to_csv('./results/AWS_concept_rank.csv')



