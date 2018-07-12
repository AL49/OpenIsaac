function varargout = NivGrisCooccurrence (varargin)% Calcul de la matrice de cooccurrence d'une image en niveaux de gris%% INPUT: % - image 1xQ, Q>=8% - nombre de bits de requantification (1 � 8) pour 2 � 256 niveaux de gris% - matrice num�rique :%   [0 D]   : angle 0�,   distance D%   [-D D]  : angle 45�,  distance D%   [-D 0]  : angle 90�,  distance D%   [-D -D] : angle 135�, distance D%% OUTPUT: % - matrice num�rique : matrice de cooccurrence%% Plugin for OpenIsaac% version 1% � 2017-2018 Arthur Berger / Alain Cl�ment - Universit� d'Angers%---------------------------------------------------------------------------------------------------% PLUGIN PARAMETERSif (nargin == 1) && strcmp(varargin{1},'-f')    % input	varargout{1} = {'IMG','image', ...                  'DATA','nombre de bits de quantification', ...                  'DATA','matrice offset'};    % output            	varargout{2} = {'DATA','matrice de cooccurrence'};	returnend	% INPUTObjIMG = varargin{1};nbb = IsaacDATA_get(varargin{2},'Val');DataVal = IsaacDATA_get(varargin{3},'Val');%---------------------------------------------------------------------------------------------------if (IsaacIMG_get(ObjIMG,'BitClass') < 8) || (IsaacIMG_get(ObjIMG,'DimZ') ~= 1)	error('image incompatible')end% requantification image sur nbb bits (valeurs entre 0 et (2^nbb)-1)if (nbb ~= IsaacIMG_get(ObjIMG,'NbBits'))	ObjIMG = IsaacIMG_changebits(ObjIMG,nbb);end	img = IsaacIMG_img2mat(ObjIMG);% en 2^nbb niveaux de gris du min au maxglcm = graycomatrix(img,'NumLevels',2^nbb,'GrayLimits',[],'Offset',DataVal);%---------------------------------------------------------------------------------------------------% OUTPUTvarargout{1} = IsaacDATA('TABN',glcm,'matrice de cooccurrence');