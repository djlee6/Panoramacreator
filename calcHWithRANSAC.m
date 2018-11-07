function H = calcHWithRANSAC(p1, p2)
% Returns the homography that maps p2 to p1 under RANSAC.
% Pre-conditions:
%     Both p1 and p2 are nx2 matrices where each row is a feature point.
%     p1(i, :) corresponds to p2(i, :) for i = 1, 2, ..., n
%     n >= 4
% Post-conditions:
%     Returns H, a 3 x 3 homography matrix
    
    assert(all(size(p1) == size(p2)));  % input matrices are of equal size
    assert(size(p1, 2) == 2);  % input matrices each have two columns
    assert(size(p1, 1) >= 4);  % input matrices each have at least 4 rows

    %------------- YOUR CODE STARTS HERE -----------------
    % 
    % The following code computes a homography matrix using all feature points
    % of p1 and p2. Modify it to compute a homography matrix using the inliers
    % of p1 and p2 as determined by RANSAC.
    %
    % Your implementation should use the helper function calcH in two
    % places - 1) finding the homography between four point-pairs within
    % the RANSAC loop, and 2) finding the homography between the inliers
    % after the RANSAC loop.
    
    numIter = 100;
    maxDist = 3;
    maxInliers = 0;
    bestH = zeros(3,3);
    
    for i = 1:numIter %loops numIter = 100 times
        inds = randperm(size(p1, 1), 4); %inds is a vector of 4 random unique integers in [1, n]
        H1 = calcH(p1(inds,:),p2(inds,:)); %calculate homography with 4 inds
        inliers = 0;
        for j = 1:size(p1,1)
            A = H1 * [p2(j,:),1]'; %A is 3xn matrix and H is a 3x3 matrix
            dist = sqrt(sum((A-[p1(j,:),1]').^2)); %A is nx3 matrices and dist is a 1xn matrix
            if(dist < maxDist)
                inliers = inliers + 1;
            end
        end
        if(inliers > maxInliers)
            bestH = H1;
            maxInliers = inliers;
        end
    end
    
    inlierpts = zeros(maxInliers,1);
    k = 1;
    
    for l = 1:size(p1,1)
        C = bestH * [p2(l,:),1]';
        dist = sqrt(sum((C-[p1(l,:),1]').^2));
        if(dist < maxDist)
            inlierpts(k) = l;
            k = k + 1;
        end
    end
    
    H = calcH(p1(inlierpts,:),p2(inlierpts,:));

    %------------- YOUR CODE ENDS HERE -----------------
end

% The following function has been implemented for you.
% DO NOT MODIFY THE FOLLOWING FUNCTION
function H = calcH(p1, p2)
% Returns the homography that maps p2 to p1 in the least squares sense
% Pre-conditions:
%     Both p1 and p2 are nx2 matrices where each row is a feature point.
%     p1(i, :) corresponds to p2(i, :) for i = 1, 2, ..., n
%     n >= 4
% Post-conditions:
%     Returns H, a 3 x 3 homography matrix
    
    assert(all(size(p1) == size(p2)));
    assert(size(p1, 2) == 2);
    
    n = size(p1, 1);
    if n < 4
        error('Not enough points');
    end
    H = zeros(3, 3);  % Homography matrix to be returned

    A = zeros(n*3,9);
    b = zeros(n*3,1);
    for i=1:n
        A(3*(i-1)+1,1:3) = [p2(i,:),1];
        A(3*(i-1)+2,4:6) = [p2(i,:),1];
        A(3*(i-1)+3,7:9) = [p2(i,:),1];
        b(3*(i-1)+1:3*(i-1)+3) = [p1(i,:),1];
    end
    x = (A\b)';
    H = [x(1:3); x(4:6); x(7:9)];

end
