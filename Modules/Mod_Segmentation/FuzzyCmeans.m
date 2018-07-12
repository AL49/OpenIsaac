function varargout = FuzzyCmeans(varargin)
% Segmentation fuzzy c-mean nD
% Initialisation aléatoire, distance euclidienne
%
% INPUT:
% - image PxQ
% - matrice des paramètres :
%   + nombre de classes
%   + couleurs affichées pour les classes
%	    1 : centre des clusters
%	    2 : palette hsv
%	
% OUTPUT:
%	- image 3x8 de segmentation
%	- matrice (nc,3) des couleurs pour les nc classes
%
% Plugin for OpenIsaac
% version 1
% © 2011-2018 Alain Clément - Université d'Angers

%---------------------------------------------------------------------------------------------------

% Copyright 2007 - 2018 Université d'Angers - Author: Alain Clément
%
% This program is free software; you can redistribute it and/or modify it under the terms of the GNU
% General Public License as published by the Free Software Foundation; either version 3 of the
% License, or any later version. This program is distributed in the hope that it will be useful, but
% WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A
% PARTICULAR PURPOSE. See the GNU General Public License for more details. You should have received
% a copy of the GNU General Public License along with this program; if not, write to the Free
% Software Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.

%---------------------------------------------------------------------------------------------------

% PLUGIN PARAMETERS
if (nargin == 1) && strcmp(varargin{1},'-f')
    % input
	varargout{1} = {'IMG','image source', ...
					'DATA' ,'matrice des paramètres'};
    % output
	varargout{2} = {'IMG','image couleur segmentation', ...
					'DATA' ,'couleurs des classes'};
	return
end	

% INPUT
ObjIMG = varargin{1};
DataVal = IsaacDATA_get(varargin{2},'Val');
nbclusters = DataVal(1);
affiche = DataVal(2);
        
%---------------------------------------------------------------------------------------------------

img1 = IsaacIMG_img2mat(ObjIMG,'double');
nrows = size(img1,1);
ncols = size(img1,2);
nplans = size(img1,3);
ab = reshape(img1,nrows*ncols,nplans);
% fuzzy c-means
[cluster_center,U,~] = fcm(ab,nbclusters);
maxU = max(U);
nbpix = size(U,2);
cluster_idx = zeros(nbpix,1);
for i = 1:nbpix
	cluster_idx(i) = find((U(:,i) == maxU(i)),1,'first'); % 'first' par sécurité en cas d'exaeco
end
fprintf('\nSegmentation Fuzzy C-means : plan(s)= %d nbclasses= %d\n',nplans,nbclusters);
% image couleur 8 bits résultat segmentation
pixel_labels = reshape(cluster_idx,nrows,ncols);
if affiche == 1
	if (nplans < 3)
		map = repmat(cluster_center(:,1),3);
	else
		map = cluster_center(:,1:3);
	end
else
	% couleurs automatiques
	map = colormap(hsv(nbclusters));
end
classescolors = zeros(nbclusters,3);
for i = 1:nbclusters
	classescolors(i,:) = round(255*map(i,:));
	fprintf('[%3d %3d %3d]\n',classescolors(i,1),classescolors(i,2),classescolors(i,3)); 
end
img2 = label2rgb(pixel_labels,map);
% forcer le changement de nbbits
ObjIMG = IsaacIMG_mat2img(ObjIMG,img2,'ChangeBits');

%---------------------------------------------------------------------------------------------------

% OUTPUT
varargout{1} = ObjIMG;
varargout{2} = IsaacDATA('TABN',classescolors,'classes FuzzyCmeans');
