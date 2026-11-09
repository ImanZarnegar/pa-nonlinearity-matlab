% STARTUP  Add project folders to the MATLAB path (relative to this file).
root_dir = fileparts(mfilename('fullpath'));
addpath(fullfile(root_dir, 'src'), fullfile(root_dir, 'scripts'));
clear root_dir
