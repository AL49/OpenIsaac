function varargout = Entropie(varargin)% Calcul de l'entropie d'une image% % INPUT:% - image PxQ%% OUTPUT:% - valeur num�rique : entropie%% Plugin for OpenIsaac% version 1% � 2011-2018 Si� Ouattara / Alain Cl�ment - Universit� d'Angers%---------------------------------------------------------------------------------------------------% Copyright 2007 - 2018 Universit� d'Angers - Author: Alain Cl�ment%% This program is free software; you can redistribute it and/or modify it under the terms of the GNU% General Public License as published by the Free Software Foundation; either version 3 of the% License, or any later version. This program is distributed in the hope that it will be useful, but% WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A% PARTICULAR PURPOSE. See the GNU General Public License for more details. You should have received% a copy of the GNU General Public License along with this program; if not, write to the Free% Software Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.%---------------------------------------------------------------------------------------------------% PLUGIN PARAMETERSif (nargin == 1) && strcmp(varargin{1},'-f')    % input	varargout{1} = {'IMG','image'};    % sortie            	varargout{2} = {'DATA','entropie'};	returnend	% INPUTObjIMG = varargin{1};%---------------------------------------------------------------------------------------------------[~,counts] = IsaacModule('IsaacHistN',double(IsaacIMG_img2mat(ObjIMG)));p = counts/sum(counts);entrop = -p'*log2(p); % attention op�ration matricielle : ordre imp�ratif%---------------------------------------------------------------------------------------------------% OUTPUTvarargout{1} = IsaacDATA('VALN',entrop,'entropie');