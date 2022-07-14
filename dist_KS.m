function dist = dist_KS(x, y)
% function dist = dist_KS(x, y) 
%
% Compute the Kolmogorov Smirnov (KS) distace between vectorized networks x
% and y. THe distance is introduced in
%
%Chung, M.K., Lee, H., Solo, V., Davidson, R.J., Pollak, S.D. 2017  
%Topological distances between brain networks, International Workshop 
%on Connectomics in NeuroImaging, Lecture Notes in Computer Science 
%10511:161-170
%https://pages.stat.wisc.edu/~mchung/papers/chung.2017.CNI.pdf
%
% Songdechakraiwut, T., Shen, L., Chung, M.K. 2021 Topological learning 
% and its application to multimodal brain network integration, Medical 
% Image Computing and Computer Assisted Intervention (MICCAI), 
% LNCS 12902:166-176 


% INPUT
% x: a matrix of size # of subjects x # of features 
% y: a matrix of size # of subjects x # of features 
% The number of features has to be identical
%
% OUTPUT:
% dist: the distance between the networks in the groups
%
% (C) 2022 Moo K. Chung
%          University of Wisconsin-Madison
%
% Contact mkchung@wisc.edu 
% for any inquary about the code. 
% The code is downloaded from
% https://github.com/laplcebeltrami/barcodes


KSdist = @(xi,yi)(max(abs(xi-yi)))
