# data_availability: https://www.kaggle.com/datasets/group16/covid19-literature-knowledge-graph

import sys
import os
import time
import csv

import numpy as np
from numpy import linalg as LA

import pandas as pd


# ROUND 1

paper_dict = dict()
author_dict = dict()
institution_dict = dict()
relation_dict = dict()

line = 123;count = 0
fp = open('./data/kg.nt.original', 'r', encoding='utf-8')
while line:
    
    if count % 100000 == 0:
        print(count, end=' ', flush=True);
    
    line = fp.readline()
    x = line.split('> <')
    if len(x)<=2:
        continue
    x[0] = x[0]+'>'
    x[1] = '<'+x[1]+'>'
    x[2] = '<'+x[2][:-3]
    
    if 'dx.doi.org' in x[0]:
        if x[0] not in paper_dict:
            paper_dict[x[0]] = len(paper_dict)
    if 'dx.doi.org' in x[2]:
        if x[2] not in paper_dict:
            paper_dict[x[2]] = len(paper_dict)
    
    
    if 'orcid.org' in x[0]:
        if x[0] not in author_dict:
            author_dict[x[0]] = len(author_dict)
    if 'orcid.org' in x[2]:
        if x[2] not in author_dict:
            author_dict[x[2]] = len(author_dict)
    
    if 'idlab.github.io' in x[0] and 'covid19#>' not in x[0]:
        if x[0] not in institution_dict:
            institution_dict[x[0]] = len(institution_dict)
    if 'idlab.github.io' in x[2] and 'covid19#>' not in x[2]:
        if x[2] not in institution_dict:
            institution_dict[x[2]] = len(institution_dict)
    
    if x[1] not in relation_dict:
        relation_dict[x[1]] = len(relation_dict)
    
    count += 1


fp.close()



# ROUND 2

paper_author_dict = dict.fromkeys(paper_dict.keys())
for key_idx in paper_author_dict.keys():
    paper_author_dict[key_idx] = list()

author_institution_dict = dict.fromkeys(author_dict.keys())
for key_idx in author_institution_dict.keys():
    author_institution_dict[key_idx] = list()

institution_nation_dict = dict.fromkeys(institution_dict.keys())
for key_idx in institution_nation_dict.keys():
    institution_nation_dict[key_idx] = list()

N = len(paper_dict)
deg_vec = np.zeros([N,1],dtype=int)

for iii in relation_dict: print(iii,end='  ');print(relation_dict[iii]) 


line = 123;count = 0
fp = open('data/kg.nt.original', 'r', encoding='utf-8')
while line:
    
    if count % 100000 == 0:
        print(count, end=' ', flush=True);
    
    line = fp.readline()
    x = line.split('> <')
    if len(x)<=2:
        continue
    x[0] = x[0]+'>'
    x[1] = '<'+x[1]+'>'
    x[2] = '<'+x[2][:-3]
    
    if relation_dict[x[1]]==1:
        deg_vec[paper_dict[x[0]]] += 1
        deg_vec[paper_dict[x[2]]] += 1
    
    if relation_dict[x[1]]==2:
        paper_author_dict[x[0]].append(x[2])
    
    if relation_dict[x[1]]==5 and 'covid19#>' not in x[0]:
        author_institution_dict[x[0]].append(x[2])
    
    if relation_dict[x[1]]==4 and 'covid19#>' not in x[0]:
        institution_nation_dict[x[0]].append(x[2])
    
    count += 1


fp.close()


# need to clean up inconsistencies in institution 
for uuu in list(institution_nation_dict.keys()):
    nation_vec = institution_nation_dict[uuu]
    nation_count = np.zeros([1,7], dtype=int)[0]
    for country_name in nation_vec:
        is_others = 1
        if 'China' in country_name:
            is_others = 0; nation_count[1] += 1
        if 'U' in country_name and 'S' in country_name:
            is_others = 0; nation_count[2] += 1
        if 'U' in country_name and 'K' in country_name:
            is_others = 0; nation_count[3] += 1
        if 'Germany' in country_name or 'France' in country_name or 'Italy' in country_name or 'Spain' in country_name or 'Switzerland' in country_name or 'Netherlands' in country_name:
            is_others = 0; nation_count[4] += 1
        if 'Japan' in country_name or 'Korea' in country_name:
            is_others = 0; nation_count[5] += 1
        if 'India' in country_name:
            is_others = 0; nation_count[6] += 1
        nation_count[0] += is_others
    
    nation_count = nation_count.tolist()
    ncmax = max(nation_count)
    ncidx = nation_count.index(ncmax)
    institution_nation_dict[uuu] = ['Other', 'China', 'USA', 'UK', 'EU', 'JpKr', 'India'][ncidx]





paper_nation_tab = np.zeros([N,7], dtype=int)
paper_list = list(paper_dict.keys())

for iii in range(N):
    paper_nation_tab[iii, 0] = 1
    author_vec = paper_author_dict[paper_list[iii]]
    if len(author_vec)>0:
        for author_name in author_vec:
            institution_vec = author_institution_dict[author_name]
            if len(institution_vec)>0:
                for institution_name in institution_vec:
                    if 'covid19#>' not in institution_name:
                        country_vec = institution_nation_dict[institution_name]
                        if len(country_vec)>0:
       
                            country_name = country_vec
                            if 'China' in country_name:
                                paper_nation_tab[iii, 0] = 0; paper_nation_tab[iii, 1] = 1
                            if 'U' in country_name and 'S' in country_name:
                                paper_nation_tab[iii, 0] = 0; paper_nation_tab[iii, 2] = 1
                            if 'U' in country_name and 'K' in country_name:
                                paper_nation_tab[iii, 0] = 0; paper_nation_tab[iii, 3] = 1
                            if 'Germany' in country_name or 'France' in country_name or 'Italy' in country_name or 'Spain' in country_name or 'Switzerland' in country_name or 'Netherlands' in country_name or 'EU' in country_name:
                                paper_nation_tab[iii, 0] = 0; paper_nation_tab[iii, 4] = 1
                            if 'Japan' in country_name or 'Korea' in country_name or 'JpKr' in country_name:
                                paper_nation_tab[iii, 0] = 0; paper_nation_tab[iii, 5] = 1
                            if 'India' in country_name:
                                paper_nation_tab[iii, 0] = 0; paper_nation_tab[iii, 6] = 1



np.savetxt('./data/kg_degs.txt', deg_vec, delimiter=",")

All_Nodes = pd.DataFrame(columns = ['DOI','degree','type','Other','China','USA','UK','EU','JpKr','India'])
All_Nodes.DOI = paper_dict.keys()
All_Nodes.degree = deg_vec
All_Nodes['type'] = '';

All_Nodes.Other = paper_nation_tab[:,0]
All_Nodes.China = paper_nation_tab[:,1]
All_Nodes.USA   = paper_nation_tab[:,2]
All_Nodes.UK    = paper_nation_tab[:,3]
All_Nodes.EU    = paper_nation_tab[:,4]
All_Nodes.JpKr  = paper_nation_tab[:,5]
All_Nodes.India = paper_nation_tab[:,6]


All_Nodes.to_csv('./data/kg_Table.txt')

#####################################
#####################################
#####################################


paper_in_cord19_dict = dict.fromkeys(paper_dict.keys(), 0)
line = 456;
count = 0
fp = pd.read_csv('./data/metadata.csv')
cord_list = fp['doi']

for i in range(len(cord_list)):
    doi_entry = '<http://dx.doi.org/' + str(cord_list[i]) + '>'

    if doi_entry in paper_in_cord19_dict:
        paper_in_cord19_dict[doi_entry] = 1

in_cord19 = np.array(list(paper_in_cord19_dict.values()), dtype=int)
np.savetxt('./data/kg_in_cord19.txt', in_cord19, fmt='%d', delimiter=",")









