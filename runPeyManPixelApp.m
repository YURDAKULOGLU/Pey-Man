function runPeyManPixelApp
% RUNPEYMANPIXELAPP Launch the Pey-Man pixel-art fitness tracker UI.

projectRoot = fileparts(mfilename("fullpath"));
addpath(fullfile(projectRoot, "source", "pey_man"));

peyManPixelApp;
end
