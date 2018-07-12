function varargout = RGB2Lum(varargin)% Conversion en luminance% Pour image couleur RGB% % INPUT:% - image 3xQ% - valeur texte op�ration : 'Y601' | 'Yp601' | 'Y709' | 'L*'%% OUTPUT:% - image 1xQ%% INFOS:% - Y601  = 0.299 * R + 0.587 * G + 0.114 * B% - Yp601 = 0.299 * R^0.45 + 0.587 * G^0.45 + 0.114 * B^0.45 (correction gamma = 1/2.2)% - Y709  = 0.213 * R + 0.715 * G + 0.072 * B% - L*    = (116 * Y709^(1/3) - 16) / 255 ou (903.3 * Y709) / 255%% Plugin for OpenIsaac% version 1% � 2011-2018 Alain Cl�ment - Universit� d'Angers%---------------------------------------------------------------------------------------------------% Copyright 2007 - 2018 Universit� d'Angers - Author: Alain Cl�ment%% This program is free software; you can redistribute it and/or modify it under the terms of the GNU% General Public License as published by the Free Software Foundation; either version 3 of the% License, or any later version. This program is distributed in the hope that it will be useful, but% WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A% PARTICULAR PURPOSE. See the GNU General Public License for more details. You should have received% a copy of the GNU General Public License along with this program; if not, write to the Free% Software Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.%---------------------------------------------------------------------------------------------------% PLUGIN PARAMETERSif (nargin == 1) && strcmp(varargin{1},'-f')    % input	varargout{1} = {'IMG','image couleur RGB', ...					'DATA','op�ration'};    % output	varargout{2} = {'IMG','image de luminance'};	returnend	% INPUTObjIMG = varargin{1};oper = IsaacDATA_get(varargin{2},'Val');%---------------------------------------------------------------------------------------------------if (IsaacIMG_get(ObjIMG,'DimZ') ~= 3)	error('image incompatible')endif ~strcmp(IsaacIMG_get(ObjIMG,'ColorSpaceName') ,'SRGB')	IsaacMessageWarning('l''image doit �tre cod�e en RGB')endimg1 = IsaacIMG_img2mat(ObjIMG,'double');switch opercase 'Y601'	img2 = 0.299 * img1(:,:,1) + 0.587 * img1(:,:,2) + 0.114 * img1(:,:,3);case 'Yp601'	img2 = 0.299*(img1(:,:,1).^0.45)+0.587*(img1(:,:,2).^0.45)+0.114*(img1(:,:,3).^0.45);case 'Y709'	img2 = 0.213 * img1(:,:,1) + 0.715 * img1(:,:,2) + 0.072 * img1(:,:,3);case 'L*'	img2 = 0.213 * img1(:,:,1) + 0.715 * img1(:,:,2) + 0.072 * img1(:,:,3);	mask = (img2 > 0.008856);	img2(mask) = 116 * (img2(mask).^(1/3)) - 16;	img2(~mask) = 903.3 * img2(~mask);	img2 = img2/255;otherwise	error('op�ration invalide')end% suppression de l'espace colorim�trique si il existeif IsaacIMG_get(ObjIMG,'IsColorSpace')	ObjIMG = IsaacIMG_set(ObjIMG,'ColorSpace',[]);end	ObjIMG = IsaacIMG_mat2img(ObjIMG,img2);%---------------------------------------------------------------------------------------------------% OUTPUTvarargout{1} = ObjIMG;	