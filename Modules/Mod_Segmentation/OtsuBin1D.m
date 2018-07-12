function varargout = OtsuBin1D(varargin)
% Binarisation par l'algorithme d'Otsu 1D (minimisation de la variance intraclasse)
% Traitement marginal des images à P plans
%
% INPUT:
% - image PxQ
%	
% OUTPUT: 
% - image Px1
% - matrice (1,P) des valeurs de seuil
%
% Plugin for OpenIsaac
% version 1
% © 2011-2018 Bertrand Vigouroux /Alain Clément - Université d'Angers

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
	varargout{1} = {'IMG','image source'};
    % output            
	varargout{2} = {'IMG','image binaire résultat', ...
					'DATA','valeurs de seuil'};
	return
end	

% INPUT
ObjIMG = varargin{1};

%---------------------------------------------------------------------------------------------------

% nombre de plans
nbp = IsaacIMG_get(ObjIMG,'DimZ');
% classe de bits de l'image
bitclass = IsaacIMG_get(ObjIMG,'BitClass');
% valeur max en fonction du nombre exact de bits
valmax = IsaacIMG_get(ObjIMG,'ValMax');
% img1 = image en double entre 0 et 1
img1 = IsaacIMG_img2mat(ObjIMG,'double');
img2 = false(size(img1));
result = zeros(1,nbp);
for k = 1:nbp
	v = graythresh(img1(:,:,k));
   if verLessThan('matlab', '9.0') 
      % code pour MATLAB 2015b et antérieur
      img2(:,:,k) = im2bw(img1(:,:,k),v);                                                       %#ok
   else
      % code pour MATLAB 2016a (9.0) et postérieur
       img2(:,:,k) = imbinarize(img1(:,:,k),v); 
   end
	if ismember(bitclass,[1,32,64])
		result(k) = v;
	else
		result(k) = round(v*valmax);
	end	
end
% suppression de l'espace colorimétrique si il existe
if IsaacIMG_get(ObjIMG,'IsColorSpace')
	ObjIMG = IsaacIMG_set(ObjIMG,'ColorSpace',[]);
end	
% forcer le changement de nbbits
ObjIMG = IsaacIMG_mat2img(ObjIMG,img2,'ChangeBits');

%---------------------------------------------------------------------------------------------------

% OUTPUT
varargout{1} = ObjIMG;
varargout{2} = IsaacDATA('TABN',result,'seuils Otsu');
