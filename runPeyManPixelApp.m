function fig = runPeyManPixelApp(metricsSource)
% RUNPEYMANPIXELAPP Launch the Pey-Man pixel-art fitness tracker UI.

if nargin < 1
    metricsSource = "";
end

projectRoot = fileparts(mfilename("fullpath"));
addpath(fullfile(projectRoot, "source", "pey_man"));

fig = peyManPixelApp(metricsSource);
end
