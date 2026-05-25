function fig = peyManPixelApp(metricsSource, uiOptions)
%PEYMANPIXELAPP Backwards-compatible entrypoint for the Pey-Man fitness app.
%
% This function instantiates the Object-Oriented PeyManPixelApp class
% and returns the figure handle directly to prevent breaking existing code.

if nargin < 1
    metricsSource = "";
end
if nargin < 2
    uiOptions = struct();
end

% Instantiate the Object-Oriented Pey-Man App
app = PeyManPixelAppClass(metricsSource, uiOptions);
fig = app.Figure;
end
