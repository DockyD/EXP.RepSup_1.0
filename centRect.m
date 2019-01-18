function dstRect = centRect(srcRect, refRect)

srcRect = srcRect(:)';
refRect = refRect(:)';

srcRect = srcRect - [srcRect(1), srcRect(2), srcRect(1), srcRect(2)];
srcRect = srcRect - [srcRect(3), srcRect(4), srcRect(3), srcRect(4)]/2;

refRect = [(refRect(1) + refRect(3))/2, (refRect(2) + refRect(4))/2];

dstRect = round(srcRect + repmat(refRect, [1 2]));

end

