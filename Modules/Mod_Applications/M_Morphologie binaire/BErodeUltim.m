function varargout = BErodeUltim(varargin)% Erosion ultime% Pour image binaire � 1 plan%% INPUT:% - image 1x1% - valeur num�rique : connexit� (4 ou 8)%% OUTPUT:% - image 1x1%% Plugin for OpenIsaac% version 1% � 2011-2018 Julio Rojas / Alain Cl�ment - Universit� d'Angers%---------------------------------------------------------------------------------------------------% Copyright 2007 - 2018 Universit� d'Angers - Author: Alain Cl�ment%% This program is free software; you can redistribute it and/or modify it under the terms of the GNU% General Public License as published by the Free Software Foundation; either version 3 of the% License, or any later version. This program is distributed in the hope that it will be useful, but% WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A% PARTICULAR PURPOSE. See the GNU General Public License for more details. You should have received% a copy of the GNU General Public License along with this program; if not, write to the Free% Software Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.%---------------------------------------------------------------------------------------------------% PLUGIN PARAMETERSif (nargin == 1) && strcmp(varargin{1},'-f')    % input	varargout{1} = {'IMG','image binaire source', ...					'DATA','connexit�'};    % output	varargout{2} = {'IMG','image binaire r�sultat'};	returnend	% INPUTObjIMG = varargin{1};cnt = IsaacDATA_get(varargin{2},'Val');%---------------------------------------------------------------------------------------------------if (IsaacIMG_get(ObjIMG,'BitClass') ~= 1) || (IsaacIMG_get(ObjIMG,'DimZ') ~= 1)	error('image incompatible')endif ~ismember(cnt,[4,8])	error('connexit� incorrecte')end	ObjIMG = IsaacIMG_mat2img(ObjIMG,bwulterode(IsaacIMG_img2mat(ObjIMG),'euclidean',cnt));%---------------------------------------------------------------------------------------------------% OUTPUTvarargout{1} = ObjIMG;