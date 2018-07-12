function varargout = IndicesHaralick(varargin)
% Calcul des principaux indices d'Haralick d'une matrice de cooccurrence
% 
% INPUT:
% - matrice numérique de cooccurrence
% - valeur texte : indice d'Haralick
%   'Energie' | 'Contraste' | 'Correlation' | 'Homogeneite' | 'Entropie'
%
% OUTPUT:
% - valeur numérique : indice d'Haralick 
%
% Plugin for OpenIsaac
% version 1
% © 2017-2018 Arthur Berger / Alain Clément - Université d'Angers

%---------------------------------------------------------------------------------------------------

% PLUGIN PARAMETERS
if (nargin == 1) && strcmp(varargin{1},'-f')
    % input
	varargout{1} = {'DATA','matrice de cooccurrence', ...
					'DATA','nom de l''indice'};
    % output
	varargout{2} = {'DATA', 'indice calculé'};
	return
end	

% INPUT
MatCoo = IsaacDATA_get(varargin{1},'Val');
indice = IsaacDATA_get(varargin{2},'Val');

%---------------------------------------------------------------------------------------------------

switch indice
	case 'Energie' 
      stats = graycoprops(MatCoo,'Energy');
      resultat = stats.Energy;
	case 'Contraste'
      stats = graycoprops(MatCoo,'Contrast');
      resultat = stats.Contrast;
	case 'Correlation' 
      stats = graycoprops(MatCoo,'Correlation');
      resultat = stats.Correlation;
	case 'Homogeneite'
      stats = graycoprops(MatCoo,'Homogeneity');
      resultat = stats.Homogeneity;
	case 'Entropie'
      % normalisation de MatCoo inutile car entropie invariante
      resultat = entropy(MatCoo); 
   otherwise
      error('indice invalide')
end

%---------------------------------------------------------------------------------------------------

% OUTPUT
varargout{1} = IsaacDATA('VALN',resultat,'');