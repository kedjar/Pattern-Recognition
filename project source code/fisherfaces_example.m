%% SYS800 - Reconnaissance de formes et inspection
% M'Hand Kedjar - December 2016
% Course Project on Age and Gender Classification

% Copyright (c) Philipp Wagner. All rights reserved.
% Licensed under the BSD license. See LICENSE file in the project root for full license information.

% load function files from subfolders aswell
addpath (genpath ('.'));

% load data
path_to_images = 'datasets/orl';
[X y width height names] = read_images(path_to_images);

% compute a model
fisherface = fisherfaces(X,y);

% plot fisherfaces
figure; hold on;
for i=1:min(16, size(fisherface.W,2))
  subplot(4,4,i);
  comp = cvtGray(fisherface.W(:,i), width, height);
  imshow(comp);
  colormap(jet(256));
  title(sprintf('Fisherface #%i', i));
end

%% 2D plot of projection (first three classes)
figure; hold on;
for i = findclasses(fisherface.y, [1,2,3])
  text(fisherface.P(1,i), fisherface.P(2,i), num2str(fisherface.y(i)));
end

%% 3D plot of projection (first three classes)
if(size((fisherface.P),2) >= 3)
  figure; hold on;
  for i = findclasses(fisherface.y, [1,2,3])
    % LineSpec: red dots 'r.'
    plot3(fisherface.P(1,i), fisherface.P(2,i), fisherface.P(3,i), 'r.'), view(45,-45);
    text(fisherface.P(1,i), fisherface.P(2,i), fisherface.P(3,i), num2str(fisherface.y(i)));
  end
end

pause;
