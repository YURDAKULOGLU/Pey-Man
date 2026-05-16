function fig = runPeyManPixelApp(metricsSource, uiOptions)
% RUNPEYMANPIXELAPP Launch the Pey-Man pixel-art fitness tracker UI.

if nargin < 1
    metricsSource = "";
end
if nargin < 2
    uiOptions = struct();
end

projectRoot = fileparts(mfilename("fullpath"));
addpath(fullfile(projectRoot, "source", "pey_man"));

fig = peyManPixelApp(metricsSource, uiOptions);
end
