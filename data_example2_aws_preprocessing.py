# data availability: https://dj2taa9i652rf.cloudfront.net/
# covid_knowledge_graph/csv

import sys
import os
import time
import csv

import numpy as np
from numpy import linalg as LA

import pandas as pd

node_list_df = pd.read_csv('data/AWS-csv/nodes/paper_nodes.csv')
edge_list_df = pd.read_csv('data/AWS-csv/edges/paper_to_reference.csv')

node_name_list = node_list_df['~id']
paper_dict = dict.fromkeys(node_name_list,0)
for iii in range(len(paper_dict)):
    paper_dict[node_name_list[iii]] = iii

from_list = edge_list_df['~from']
to_list   = edge_list_df['~to']

deg_dict = dict.fromkeys(node_name_list,0)
for iii in range(len(from_list)):
    deg_dict[from_list[iii]] += 1
    deg_dict[to_list[iii]]   += 1

deg_vec = list(deg_dict.values())

N = len(deg_vec)
with open('data/deg_vec.txt','w') as wt:
    for ii in range(N):
        _ = wt.write('%d\n'%(deg_vec[ii]));
