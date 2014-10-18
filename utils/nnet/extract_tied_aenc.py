#!/usr/bin/python -u

# ./gen_tied_aenc.py
# script generateing NN initialization for training with TNet
#     
# author: Chao Weng 
#

import math, random
import sys
import numpy as np


if (len(sys.argv) != 4):
  print >> sys.stderr, 'Usage....\n' 
  sys.exit(1) 

nnet_in = open(sys.argv[1], 'r')
num_layers=int(sys.argv[2])
nnet_out = open(sys.argv[3], 'w')
cur_layer = 0 
in_dims = []
out_dims = []
weights_list = []

while num_layers > 0:
  line = nnet_in.readline();
  line_list = line.split();
  if (len(line_list) == 0):
    break
  #affine transform tied
  if (line_list[0] == '<affinetransformtied>'):
    out_dims.append(int(line_list[1])) 
    in_dims.append(int(line_list[2]))        
    #cur_layer = cur_layer + 1
    nnet_out.write(line)
    line_cnt = 0
    while line_cnt < out_dims[cur_layer]:
      line = nnet_in.readline() 
      nnet_out.write(line)
      if (not line):
        sys.stderr.write('wrong format: not enough rows for affine transform\n')
        sys.exit(0) 
      line_list = line.split()
      if (len(line_list) == 1):
        continue
      #if (len(line_list) == in_dims[cur_layer]):
      #  weights_list.extend(line_list)
      if (len(line_list) < in_dims[cur_layer]):
        sys.stderr.write('wrong format: not enough cols for affine transform\n')
        sys.exit(0)
      line_cnt = line_cnt + 1
    line = nnet_in.readline()
    line_list = line.split()
    if (len(line_list) != out_dims[cur_layer] + 2):
      sys.stderr.write('wrong dims for bias\n')
      sys.exit(0) 
    nnet_out.write(line)
    cur_layer = cur_layer + 1
    num_layers = num_layers - 1 
  #sigmoid
  if (line_list[0] == '<sigmoid>'):
    nnet_out.write(line) 
    num_layers = num_layers - 1

