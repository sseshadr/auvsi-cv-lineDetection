function fNoOrange  = blockOrangeCones(frame)
% Copyright 2015-2016 The MathWorks, Inc.    
    % Find orange cones
    BWO = createOrangeMask(frame);

    % Apply a close morphology to make continuous lines
    BMO = imclose(BWO,strel('disk',25));

    % Detect blobs
    bd = vision.BlobAnalysis('MinimumBlobArea',500);

    [~,~,bbox] = step(bd,BMO);

%     fshape = insertShape(frame,'rectangle',bbox,...
%         'LineWidth',4);
    fNoOrange = frame;
    
    if (~isempty(bbox))
        for bidx = 1:size(bbox,1)
            x = bbox(bidx,1);
            y = bbox(bidx,2);
            w = bbox(bidx,3);
            h = bbox(bidx,4);
            cLoc = x:x+w;
            rLoc = y:y+h;
            fNoOrange(rLoc,cLoc,:) = 0;
        end        
    end
%     imshow(fNoOrange)
end