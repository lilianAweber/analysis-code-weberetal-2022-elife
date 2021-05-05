function [ clrs ] = dprst_define_colors( studyArm )
%DPRST_DEFINE_COLORS Defines all colors needed for plotting results in the
%DPRST ERP paper
%   IN:     studyArm    - string 'anta' or 'agon' to determine drug colors
%   OUT:    -

% for backward compatibility
if nargin < 1
    studyArm = 'anta';
end

clrs.purple     = [128 0 128]/255;
clrs.medpurple  = [147 112 219]/255;
clrs.medblue    = [30 144 255]/255;

clrs.violet     = [106 27 154]/255;

clrs.darkred    = [0.545 0 0];  % epsi3 and deviants (volatile)
clrs.lightred   = [1 0 0];      % epsi2 and deviants (stable)

clrs.turquoise  = [0 0.4 0.4];  % mu3
clrs.darkgreen  = [0 0.4 0];    % mu2
clrs.lightgreen = [0 0.7 0];    % mu1

clrs.yellow     = [255 215 0]/255;	% input u
clrs.lightgray  = [169 174 176]/255;% parameters
%clrs.medgray    = [84 87 88]/255;   % standards (stable)
clrs.medgray    = [135 137 138]/255;% standards (stable) 
clrs.darkgray   = [58 60 61]/255;   % standards (volatile)

clrs.lightblue  = [0.5294 0.8078 0.9804];

switch studyArm
    case 'anta'
        clrs.placebo = [40 40 40]/255; % gray 
        clrs.dopamine = [142 44 75]/255; % dark pink 
        clrs.acetylcholine = [1 150 200]/255; % turquoise 

        %clrs.placebo = [40 40 40]/255; % gray % #3C3C3C
        %clrs.dopamine = [226 84 5]/255; % orange % F5780F
        %clrs.acetylcholine = [1 113 150]/255; % turquoise % #0196c8

        %clrs.placebo = [60 60 60]/255; % gray % #3C3C3C
        %clrs.dopamine = [160 20 110]/255; % violet % #A0146E
        %clrs.acetylcholine = [250 180 10]/255; % orange-yellow % FAB40A
        
        %clrs.placebo = [80 80 80]/255; % gray % #505050
        %clrs.dopamine = [175 1 1]/255; % dark red % #AF0101
        %clrs.acetylcholine = [1 150 200]/255; % turquoise % #0196c8
        
        %clrs.dopamine = [150 10 100]/255; % violet
        %clrs.acetylcholine = [250 150 10]/255; % orange
        %clrs.acetylcholine = [250 180 10]/255; % orange-yellow
    case 'agon'
        clrs.placebo = [150 150 150]/255; % gray % #969696
        clrs.dopamine = [180 59 100]/255; % light pink
        clrs.acetylcholine = [1 113 150]/255; % dark turquoise
        %clrs.placebo = [150 150 150]/255; % gray % #969696
        %clrs.dopamine = [169 90 161]/255; % light violet % #A95AA1
        %clrs.acetylcholine = [245 120 15]/255; % orange % F5780F
        %clrs.placebo = [130 130 130]/255; % gray % #828282
        %clrs.dopamine = [225 20 20]/255; % red % #e11414
        %clrs.acetylcholine = [1 100 150]/255; % dark blue/turquoise % #016496
        %clrs.dopamine = [169 90 161]/255; % violet
        %clrs.acetylcholine = [245 121 58]/255; % orange
        %clrs.acetylcholine = [245 120 15]/255; % orange
        %clrs.acetylcholine = [200 60 0]/255; % orange
end



%clrs.placebo = [10/255 147/255 176/255]; % blue
%clrs.dopamine = [176/255 39/255 10/255]; % red
%clrs.acetylcholine = [64/255 176/255 10/255]; % green

%clrs.placebo = [133 192 249]/255; % blue
%clrs.dopamine = [169 90 161]/255; % violet
%clrs.acetylcholine = [245 121 58]/255; % orange

%clrs.placebo = [10 150 250]/255; % blue (fig4)
%clrs.dopamine = [150 10 100]/255; % violet
%clrs.acetylcholine = [250 150 10]/255; % orange

%clrs.placebo = [99 172 190]/255; % blue
%clrs.dopamine = [90 26 74]/255; % dark violet
%clrs.acetylcholine = [238 68 47]/255; % red



end

