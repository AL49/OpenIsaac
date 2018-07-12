function varargout = Kmeans(varargin)
% Segmentation K-means nD, initialisation aléatoire ou liste de pixels
%
% INPUT:
% - image PxQ
% - cellaray des paramètres :
%   + initialisation : 'random' | 'LPIX' 
%   + valeur numérique nombre de classes ('random') ou objet @IsaacLPIX ('LPIX')
%   + mesure de distance
%	    'sqE'  : sqEuclidean
%	    'city' : cityblock
%   + couleurs affichées pour les classes
%	    1 : centre des clusters
%	    2 : palette hsv
%	
% OUTPUT:
%	- image 3x8 de segmentation
%	- matrice (nc,3) des couleurs pour les nc classes ou [] si échec
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
					'DATA' ,'cellarray des paramètres'};
    % output
	varargout{2} = {'IMG','image couleur segmentation', ...
					'DATA','succès (true|false)'};
	return
end	

% INPUT
ObjIMG = varargin{1};
DataVal = IsaacDATA_get(varargin{2},'Val');
initmode = DataVal{1};
initparam = DataVal{2};
dist = DataVal{3};
affiche = DataVal{4};
        
%---------------------------------------------------------------------------------------------------

img1 = IsaacIMG_img2mat(ObjIMG,'double');
nrows = size(img1,1);
ncols = size(img1,2);
nplans = size(img1,3);
ab = reshape(img1,nrows*ncols,nplans);
% kmeans
OK = true;
switch initmode
	case('random')
		if ~isnumeric(initparam)
			error('initialisation invalide')
		end
		nColors = initparam;
		try
			[cluster_idx, cluster_center] = kmeans(ab,nColors,'distance',dist,'start','sample');
		catch
			OK = false;
		end	
	case('LPIX')
		if ~isa(initparam,'IsaacLPIX')
			error('initialisation invalide')
		end
		ObjLPIX = initparam;
		imaref = IsaacLPIX_get(ObjLPIX,'ImaRef');
		if (imaref.dimx > ncols) || (imaref.dimy > nrows) || (imaref.dimz ~= nplans)
			error ('image et liste de pixels incompatibles')
		end	
		nColors = IsaacLPIX_get(ObjLPIX,'PixNb');
		listepix = IsaacLPIX_get(ObjLPIX,'PixVal');
		try
			[cluster_idx, cluster_center] = kmeans(ab,nColors,'distance',dist,'start',listepix);
		catch	
			OK = false;
		end
otherwise
	error('initialisation invalide')
end
fprintf(['\nSegmentation K-means : plan(s)= %d nbclasses= %d distance= ''%s''', ...
	' initialisation= ''%s''\n'], nplans,nColors,dist,initmode);
% image couleur 8 bits résultat segmentation
if ~OK
	fprintf('Echec cluster vide\n');
	classescolors = [];
	img2 = uint8(zeros(nrows,ncols,3));
else
	pixel_labels = reshape(cluster_idx,nrows,ncols);
	if affiche == 1
		if (nplans < 3)
			map = repmat(cluster_center(:,1),3);
		else
			map = cluster_center(:,1:3);
		end
	else
		% couleurs automatiques
		map = colormap(hsv(nColors));
	end			
	classescolors = zeros(nColors,3);
	for i = 1:nColors
		classescolors(i,:) = round(255*map(i,:));
		fprintf('[%3d %3d %3d]\n',classescolors(i,1),classescolors(i,2),classescolors(i,3)); 
	end
	img2 = label2rgb(pixel_labels,map);
end	
% forcer le changement de nbbits
ObjIMG = IsaacIMG_mat2img(ObjIMG,img2,'ChangeBits');

%---------------------------------------------------------------------------------------------------

% OUTPUT
varargout{1} = ObjIMG;
varargout{2} = IsaacDATA('TABN',classescolors,'classes Kmeans');
