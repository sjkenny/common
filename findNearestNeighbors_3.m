% Find nearest neighbors with boundary condition
% -This function returns the indices of nearest neighbors to each molecule,
% for further processing.  Example given is Z averaging over all neighbors
% within search radius.
% Uses binary search on sorted indices implemented in findInSorted
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Parameters
%
dist_thresh = 1;    %radius for nearest neighbor search (in pixels)
%  
%%
%for dependencies
addpath ..

[r,filehead]=OpenMolList;
outfile = sprintf('%s-zNearestNeighbor.bin',filehead)

x=r.xc;
y=r.yc;
z = r.zc;
z_out = z.*0;
x_out = x.*0;
z_out_final = z.*0;
count = 0;
neighbor_count = x.*0;
num_mols_calculated = 0;
percent = 0;
percent_now = 0;

bin_length = dist_thresh;
xbins = min(x):bin_length:max(x);
ybins = min(y):bin_length:max(y);
[num_out edges mid loc] = histcn([y x],ybins,xbins);
ind_out_size = size(num_out);
nrows = ind_out_size(1);
ind_out_vec = nrows*(loc(:,2)-1)+loc(:,1);
[ind_out_vec_sort sorted_ind] = sort(ind_out_vec);
%avoid counting empty bins
u = unique(ind_out_vec);
ind_to_find = [];
fprintf('Calculating...\n')
for k=1:numel(u)
    ind_use = [];
    ind_use_mol = [];
    %find bin indices of 3x3 box
    ind_to_find = [u(k) u(k)+1 u(k)-1 ...
                   u(k)-nrows u(k)-nrows+1 u(k)-nrows-1 ...
                   u(k)+nrows u(k)+nrows+1 u(k)+nrows-1 ...
                   ];
    [b,c] = findInSorted(ind_out_vec_sort,u(k));
    ind_use_mol = sorted_ind(b:c);           
    for j=1:9
        [b,c] = findInSorted(ind_out_vec_sort,ind_to_find(j));
        ind_use_now = sorted_ind(b:c);
        %indices of molecules in 3x3 box
        ind_use = cat(1,ind_use,ind_use_now);
    end

    
    xlist = x(ind_use);
    ylist = y(ind_use);
    %indices of molecules in center bin
    xlist_mol = x(ind_use_mol);
    ylist_mol = y(ind_use_mol);
    for m=1:numel(ind_use_mol)
        x_use = xlist_mol(m);
        y_use = ylist_mol(m);
        dist = sqrt(((bsxfun(@minus,xlist,x_use)).^2+ ...
        (bsxfun(@minus,ylist,y_use)).^2));
    
        %nearest neighbor indices
        ind_out = find(dist<dist_thresh);
        
        %do calculations here
        z_out(ind_use_mol(m)) = mean(z(ind_use(ind_out)));
%         x_out(ind_use_mol(m)) = mean(x(ind_use(ind_out)));
        neighbor_count(ind_use(m)) = numel(ind_out);
        percent = percent_now;
    end
    %progress bar
    num_mols_calculated = num_mols_calculated+numel(ind_use_mol);
    percent_now = round(100*num_mols_calculated/r.N);
    if ~isequal(percent,percent_now)
        fprintf('%d%% complete\n',percent_now)
    end
end

r.zc = z_out;
% r.xc = x_out;
r.xc = x;
WriteMolBinNXcYcZc(r,outfile);

                