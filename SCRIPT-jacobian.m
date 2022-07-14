%% MAIN SCRIPT for brain struactural covariate network analysis
%
%The following processed dataset and MATLAB codes are used in studies [1], [2] and [3]. 
% Using the maltreated children's MRI and DTI data, we will show how to 
% construct the Betti-0 curves from weighted brain graphs. The Betti curves are the 
% basic data visualization and quantification technique in persistent homology but 
% statistical inference procedure has been lacking in the field. The Jackknife based 
% resampling technique is used to compute the p-values.
%
%The matlab script codes below is given in SCRIPT-jacobian.m. Simply run through the 
% codes line by line. MRI data is given in jacobian.mat. The whole package 
% (codes, references, data) is zippped as jacobian-v3.zip. If you use the codes or 
% data in this page, please reference [1] or  [2]. The old version is zipped as 
% jacobian-v1.zip and jocobian-v2.zip

%[1] Chung, M.K., Hanson, J.L., Ye, J., Davidson, R.J. Pollak, S.D. 2015 
%Persistent homology in sparse regression and its application to brain morphometry. 
%IEEE Transactions on Medical Imaging, 34:1928-1939
%https://pages.stat.wisc.edu/~mchung/papers/chung.2015.TMI.pdf
%
%[2] Chung, M.K., Hanson, J.L., Lee, H., Adluru, N., Alexander1, A.L., 
%Davidson, A.L., Pollak, S.D. 2013. Persistent homological sparse network 
%approach to detecting white matter abnormality in maltreated children: 
%MRI and DTI multimodal study, MICCAI: 8149:300-307 
%https://pages.stat.wisc.edu/~mchung/papers/chung.2013.MICCAI.pdf
%
%[3] Chung, M.K., Lee, H., Arnold, A. 2012. Persistent homological structures 
%in compressed sensing and sparse likelihood, NIPS Workshop on Algebraic 
%Topology and Machine Learning.
%https://pages.stat.wisc.edu/~mchung/papers/chung.2012.NIPS.pdf
%
% The files are downloaded from 
% (1) https://github.com/laplcebeltrami/barcodes and
% (2) http://brainimaging.waisman.wisc.edu/~chung/barcodes
% 
% (C) 2013- Moo K. Chung 
% mkchung@wisc.edu
% Universtiy of Wisconsin-Madison
% 
% Update histroy: 2013 script created by Chung
%                 2022 July 13 script updated

%==============================
% 1. BRAIN STRUCTURAL COVARIATE NETWORK DATA
%The data that was used to publish Chung, M.K., Hanson, J.L., Ye, J., 
%Davidson, R.J. Pollak, S.D. 2015 Persistent homology in sparse regression 
%and its application to brain morphometry. 
%IEEE Transactions on Medical Imaging, 34:1928-1939 is stored in jacobian.mat


load jacobian.mat

% jacobian.mat file contains the following variables

% jacobian  :Jacobian determinant of deforming a template to 54 individual 
%            surfaces. It is sampled at 18881 mesh vertices along the white matter
%            surface.
% surf      :White matter surface template saved as a structured array of
%            size
%                   faces: [37910×3 double]
%                vertices: [18881×3 double].
% nodes:    :548 node uniformly subsampled from 18881 mesh vertices. This
%            is used for smaller networks.
% nodes1856 :1856 node positions uniformly subsampled from 18881 mesh vertices
% group     :control 0, post instutitualized (PI) 1
% gender    :female 0, male 1
% FA        :54 (subjects) x 548 (nodes) matrix containing Fractional Anisotropy (FA)

% Data subsampling
% 18881 node data are too large to handle for computation intensive resampling
% techniques. Thus, we subsample the Jacobian determiannt to 548 nodes
% using mesh_commonvertex.m
% For the results on 1856 nodes, replace "nodes" with "nodes1856".

ind=mesh_commonvertex(surf, nodes); 
surfJJ= jacobian(:,ind);
% surfJJ is 54 (subjects) x 548 (nodes) matrix containing Jacobian determinant. 

%Strcutural covariate brain network data
X=surfJJ(find(group),:); %X is size 23x548
corr_pi= corrcoef(X);
% corr_pi : The correlation matrix of PI (post-institutized) group. It's maltreated children

X=surfJJ(find(~group),:);
corr_co= corrcoef(X);
% corr_co: The correlation matrix of control group

%================================
% 2. BRAIN NETWORK DISPLAY
%The code was used to publish 3D nework visualizaion in Chung, M.K., Hanson, J.L., Ye, J., Davidson, 
%R.J. Pollak, S.D. 2015 Persistent homology in sparse regression and its application to brain morphometry. 
%IEEE Transactions on Medical Imaging, 34:1928-1939 and many other
%subsequent publicataions. 

% display surface template
figure;
figure_patch(surf, [0.6 0.6 0.6],0.2); 

%display nodes. 
coord = nodes.vertices;
nodevalue = sum(corr_co,1); % we wil simply put sum of correlation values at each node as an illustration
landmarks_nodelabel(coord, 3, nodevalue,[])
view([90 90]); camlight;

% display network edges
landmarks_tubes(corr_co, coord, 0.7); colorbar
view([90 90]); camlight;


%===============================
% 3. BETTI-0 CURVES
%
%The Betti-0 curve plots are introduced in Chung, M.K., Hanson, J.L., Ye, J., Davidson, R.J. Pollak, 
%S.D. 2015 Persistent homology in sparse regression and its application to brain morphometry. 
%IEEE Transactions on Medical Imaging, 34:1928-1939
% The Betti-0 curve displays the change of connected components over filtration values

% Constructing network filtration on 1-correlation. 
% number of nodes
p=size(nodes.vertices,1)

figure;
dco=PHbarcode(1-corr_co);
plot([1; 1-dco'],  [p:-1:1], '-k');

dpi=PHbarcode(1-corr_pi);
hold on; plot([1; 1-dpi'],  [p:-1:1], '--r');

legend('Controls', 'PI')

%==========================
% 4. JACKKNIFE RESAMPLING ON BARCODES
%The Jackknife resampling was introduced in Chung, M.K., Hanson, J.L., Ye, J., Davidson, R.J. Pollak, 
%S.D. 2015 Persistent homology in sparse regression and its application to brain morphometry. 
%IEEE Transactions on Medical Imaging, 34:1928-1939

%n_subject=54

n1=  23;  
n2= 31; 

MSTpi=zeros(547,n1);
MSTco=zeros(547,n2);

%Displays the collection of barcodes

X=surfJJ(find(group),:);
for i=1:n1
    Xi= X; 
    Xi(i,:)=[]; %i-th subject removed
    corr_pi= corrcoef(Xi);
    MSTpi(:,i) = PHbarcode(1-abs(corr_pi));
end;

Y=surfJJ(find(~group),:);
for i=1:n2
    Yi= Y; 
    Yi(i,:)=[]; %i-th subject removed
    corr_co= corrcoef(Yi);
    MSTco(:,i) = PHbarcode(1-abs(corr_co));
end;

%==========================
% 5. UNIFORM RESAMPLING ON BARCODES VIA LINEAR INTERPOLATION
%The technique is useful if we want to sample at the uniform filtration
%values across subjects. 

% Example showing single barcode
dco=PHbarcode(1-corr_co);
x=[1 1-dco]'; 
Y=[548:-1:1]';
figure; plot(x,Y, '.k');

xgrid=[0:0.005:1]'; 
ygrid = interp1(x,Y,xgrid, 'nearest'); 
hold on; plot(xgrid, ygrid, '+r')
legend('barcode', 'interpolation')

% uniform resampling on whole dataset
figure
INTpi=[]
INTco=[]
xgrid=[0:0.005:1]';
Y=[548:-1:1]';

for i=1:n1
    dco=MSTpi(:,i)';
    x=[1 1-dco];
    INTpi(:,i) = interp1(x,Y,xgrid, 'nearest');
    hold on; plot(xgrid, INTpi(:,i) ,'--r')
end

for i=1:n2
    dco=MSTco(:,i)';
    x=[1 1-dco];
    INTco(:,i) = interp1(x,Y,xgrid, 'nearest');
    hold on; plot(xgrid, INTco(:,i),'k')
end

figure_bg('w'); box on; 

%========================
% 6. Kolmogorov Smirnov (KS) distace
% The KS-distance is explained in 
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

%Input data 
% INTpi   201 features x 23 subjects
% INTco   201 features x 31 subjects
% 

%between-group distance
d=[];
for i=1:n1
    for j=1:n2
        Mpi=INTpi(:,i);
        Mco=INTco(:,j);
        diff=max(abs(Mpi-Mco));
        d=[d diff];
    end
end;

% Within-group distance
e=[];
for i=1:n1
    for j=1:n1
        Mpi1=INTpi(:,i);
        Mpi2=INTpi(:,j);
        
        diff=max(abs(Mpi1-Mpi2));
        if i~=j
            e=[e diff];
        end;
    end
end;

for i=1:n2
    for j=1:n2
        Mco1=INTco(:,i);
        Mco2=INTco(:,j);
        
        diff=max(abs(Mco1-Mco2));
        if i~=j
            e=[e diff];
        end;
    end
end;
%% Comment by Chung: This part of codes should be optimized using pdist.m function.
%% Let me know if you optimized and reduced the double loop.

figure; histogram(e,30, 'FaceColor', 'y')
hold on; histogram(d, 30, 'FaceColor', 'r')
legend('Witin-group','Between-group')

figure_bg('w'); %make background white
figure_bigger(20) %20point font size
print_pdf('jackknife_bar') 
%It produces the 300dpi publication quality figure as PDF

%For perfomring the statistical inference on the KS-distances,the
%ratio-statistics of within-distance over between-disatnce:
%
% Songdechakraiwut, T., Shen, L., Chung, M.K. 2021 Topological learning 
% and its application to multimodal brain network integration, Medical 
% Image Computing and Computer Assisted Intervention (MICCAI), 
% LNCS 12902:166-176. The code is implmented in 
%https://pages.stat.wisc.edu/~mchung/dynamicTDA



