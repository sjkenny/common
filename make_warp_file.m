%select moving then fixed - 3D then 2D

r = OpenMolList;
l = OpenMolList;
%%
idx_moving = find(r.cat==1);
idx_fixed = find(l.cat==1);
moving = double([r.xc(idx_moving) r.yc(idx_moving)]);
fixed = double([l.xc(idx_fixed) l.yc(idx_fixed)]);

tform = cp2tform(fixed,moving,'projective');

moving_warp = tforminv(tform,moving);
%%
clf
plot(moving(:,1),moving(:,2),'k.')
hold on
axis equal
plot(fixed(:,1),fixed(:,2),'m.')

%%
clf
plot(moving_warp(:,1),moving_warp(:,2),'k.')
hold on
axis equal
plot(fixed(:,1),fixed(:,2),'m.')
%%
xdist = bsxfun(@minus,moving(:,1),fixed(:,1));
ydist = bsxfun(@minus,moving(:,2),fixed(:,2));