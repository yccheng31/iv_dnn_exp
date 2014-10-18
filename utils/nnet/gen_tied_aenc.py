#!/usr/bin/python -u

# ./gen_tied_aenc.py
# script generateing NN initialization for training with TNet
#     
# author: Chao Weng 
#

# To fit current version at 6/26/2014, I made some modifications
# You-Chi Cheng


import math, random
import sys
import numpy as np


if (len(sys.argv) != 3):
  print >> sys.stderr, 'Usage....\n' 
  sys.exit(1) 

#recur_layer = int(sys.argv[2])
nnet_in = open(sys.argv[1], 'r')
nnet_out = open(sys.argv[2], 'w')
cur_layer = 0 
in_dims = []
out_dims = []
weights_list = []
learnratecoef = []
biaslearnratecoef = []

while 1:
  line = nnet_in.readline();
  line_list = line.split();
  if (len(line_list) == 0):
    break
  #affine
  if (line_list[0] == '<AffineTransform>'):
    out_dims.append(int(line_list[1])) 
    in_dims.append(int(line_list[2]))        
    #cur_layer = cur_layer + 1
    nnet_out.write('<AffineTransformTied>'+ ' ' + line_list[1] + ' ' + line_list[2] + '\n')
    line_cnt = 0
    #print out_dims[cur_layer]
    # current version has one more line, so also add it
    line = nnet_in.readline()
    line_list = line.split()
    if(line_list[0] == '<LearnRateCoef>'):
      learnratecoef.append(float(line_list[1]))
      biaslearnratecoef.append(float(line_list[3]))
      nnet_out.write('<LearnRateCoef>'+ ' ' + str(float(line_list[1])) + ' ' + '<BiasLearnRateCoef>' + ' ' + str(float(line_list[3])) + '  [\n')
    #nnet_out.write(line)
    while line_cnt < out_dims[cur_layer]:
      line = nnet_in.readline() 
      nnet_out.write(line)
      if (not line):
        sys.stderr.write('wrong format: not enough rows for affine transform\n')
        sys.exit(0) 
      line_list = line.split()
      if (len(line_list) == 1):
        continue
      if (len(line_list) == in_dims[cur_layer]):
        weights_list.extend(line_list)
      if (len(line_list) > in_dims[cur_layer]):
        #print line_list[0:in_dims[cur_layer]]
        weights_list.extend(line_list[0:in_dims[cur_layer]])
        #print weights_list 
      line_cnt = line_cnt + 1
    line = nnet_in.readline()
    line_list = line.split()
    #print line_list
    if (len(line_list) != out_dims[cur_layer] + 2):
      sys.stderr.write('wrong dims for bias: len(line_list) = %d != out_dims[cur_layer] + 2 = %d\n' % (len(line_list), out_dims[cur_layer] + 2))
      sys.exit(0) 
    nnet_out.write(line)
    cur_layer = cur_layer + 1
#Sigmoid
  if (line_list[0] == '<Sigmoid>'):
    nnet_out.write(line) 


#now begin write tied decoder layers
for i in range(len(in_dims)-1, -1, -1):
  nnet_out.write('<AffineTransformTied>'+ ' ' + str(in_dims[i]) + ' ' + str(out_dims[i]) + '\n'  )
  cur_weights = weights_list[-out_dims[i]*in_dims[i]:]
  del weights_list[-out_dims[i]*in_dims[i]:]
  weights_array = np.array(cur_weights)
  weights_array1 = weights_array.reshape(out_dims[i], in_dims[i]).T
  weight_tied = weights_array1.tolist()
  #print weight_tied
  nnet_out.write('<LearnRateCoef>'+ ' ' + str(learnratecoef[i]) + ' ' + '<BiasLearnRateCoef>' + ' ' + str(biaslearnratecoef[i]) + ' ') 
  nnet_out.write('[\n')
  for rows in range(0,in_dims[i]):
    for cols in range(0, out_dims[i]):
      nnet_out.write(weight_tied[rows][cols] + ' ')
    if rows == in_dims[i] - 1:
      nnet_out.write(']\n')
    else: 
      nnet_out.write('\n')
  #bias
  nnet_out.write('[ ')
  for cols in range(0, in_dims[i]):
    nnet_out.write(str(random.random()/5.0-4.1)) 
    nnet_out.write(' ') 
  nnet_out.write(']\n')
  if i != 0: 
    nnet_out.write('<Sigmoid>' + ' ' + str(in_dims[i]) + ' ' + str(in_dims[i]) + '\n')
  









