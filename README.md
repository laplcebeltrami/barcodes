## Brain structural covariate network data for maltreated children

The datset is published in

Chung, M.K., Hanson, J.L., Ye, J., Davidson, R.J. Pollak, S.D. 2015 Persistent homology in sparse regression and its application to brain morphometry. IEEE Transactions on Medical Imaging, 34:1928-1939, https://pages.stat.wisc.edu/~mchung/papers/chung.2015.TMI.pdf

Chung, M.K., Hanson, J.L., Lee, H., Adluru, N., Alexander1, A.L., Davidson, A.L., Pollak, S.D. 2013. Persistent homological sparse network approach to detecting white matter abnormality in maltreated children: MRI and DTI multimodal study, MICCAI: 8149:300-307, https://pages.stat.wisc.edu/~mchung/papers/chung.2013.MICCAI.pdf

1) Run script SCRIPT-jacobian.m to import data and visualize the network data. It starts with the correlation matrices. Correlation is a similarity measure so similar objects have bigger correlations. While topology is usually built on top of distances such that larger distance objects are less similar. So we converted the correlation to distance as dist = 1- correlation. Note this is not metric. To make it metric, we need to use sqrt(1-correlation). The issue is explained in page 677 of
https://pages.stat.wisc.edu/~mchung/papers/chung.2019.NN
 
2) The code does uniform subsampling to reduce the size of networks. The data reduction technique like diffusion map should not be used. It may be difficult to trace back and identify the regions of brain that might be responsible for topological differences. The results need to be biologically interpretable forward and backward.
 
3) The between-group and within-group showing the group differnce is visualized as shown below.

![alt text](https://github.com/laplcebeltrami/barcodes/blob/main/jackknifebar.jpg?raw=true)

The quantification and infernce of the above plot is done in 

Songdechakraiwut, T. Chung, M.K. 2022 Topological learning for brain networks, arXiv: 2012.00675 Accepted in Annals of Applied Statistics:
https://arxiv.org/pdf/2012.00675
The ratio statitic code in conjunction with the transposition test is given in
https://pages.stat.wisc.edu/~mchung/dynamicTDA

(C) 2022 Moo K. Chung
University of Wisconsin-Madison 
