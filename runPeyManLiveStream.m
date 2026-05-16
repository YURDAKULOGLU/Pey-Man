function lastResult = runPeyManLiveStream(options)
%RUNPEYMANLIVESTREAM Launch live MATLAB Mobile streaming into Pey-Man.

if nargin < 1
    options = struct();
end

projectRoot = fileparts(mfilename("fullpath"));
addpath(fullfile(projectRoot, "source", "pey_man"));

lastResult = peyManLiveStream(options);
end
