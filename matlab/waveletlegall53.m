function X = waveletlegall53(X, Level) 
%WAVELETLEGALL53  Le Gall 5/3 (Spline 2.2) wavelet transform. 
%   Y = WAVELETLEGALL53(X, L) decomposes X with L stages of the 
%   Le Gall 5/3 wavelet.  For the inverse transform,  
%   WAVELETLEGALL53(X, -L) inverts L stages.  Filter boundary 
%   handling is half-sample symmetric. 
% 
%   X may be of any size; it need not have size divisible by 2^L. 
%   For example, if X has length 9, one stage of decomposition 
%   produces a lowpass subband of length 5 and a highpass subband 
%   of length 4.  Transforms of any length have perfect 
%   reconstruction (exact inversion). 
% 
%   If X is a matrix, WAVELETLEGALL53 performs a (tensor) 2D 
%   wavelet transform.  If X has three dimensions, the 2D 
%   transform is applied along the first two dimensions. 
% 
%   Example: 
%   Y = waveletlegall53(X, 5);    % Transform image X using 5 stages 
%   R = waveletlegall53(Y, -5);   % Reconstruct from Y 
 
% Pascal Getreuer 2004-2006 
 
if nargin < 2, error('Not enough input arguments.'); end 
if ndims(X) > 3, error('Input must be a 2D or 3D array.'); end 
if any(size(Level) ~= 1), error('Invalid transform level.'); end 
 
N1 = size(X,1); 
N2 = size(X,2); 
 
% Lifting scheme filter coefficients for Le Gall 5/3 
LiftFilter = [-1/2,1/4]; 
ScaleFactor = sqrt(2); 
 
LiftFilter = LiftFilter([1,1],:); 
 
if Level >= 0   % Forward transform 
   for k = 1:Level 
      M1 = ceil(N1/2); 
      M2 = ceil(N2/2); 
       
      %%% Transform along columns %%% 
      if N1 > 1          
         RightShift = [2:M1,M1]; 
         X0 = X(1:2:N1,1:N2,:); 
 
         % Apply lifting stages 
         if rem(N1,2) 
            X1 = [X(2:2:N1,1:N2,:);X0(M1,:,:)]... 
               + filter(LiftFilter(:,1),1,X0(RightShift,:,:),... 
               X0(1,:,:)*LiftFilter(1,1),1); 
         else 
            X1 = X(2:2:N1,1:N2,:) ... 
               + filter(LiftFilter(:,1),1,X0(RightShift,:,:),... 
               X0(1,:,:)*LiftFilter(1,1),1); 
         end 
 
         X0 = X0 + filter(LiftFilter(:,2),1,... 
            X1,X1(1,:,:)*LiftFilter(1,2),1); 
 
         if rem(N1,2) 
            X1(M1,:,:) = []; 
         end 
 
         X(1:N1,1:N2,:) = [X0*ScaleFactor;X1/ScaleFactor]; 
      end 
 
      %%% Transform along rows %%% 
      if N2 > 1 
         RightShift = [2:M2,M2]; 
         X0 = permute(X(1:N1,1:2:N2,:),[2,1,3]); 
 
         % Apply lifting stages 
         if rem(N2,2) 
            X1 = permute([X(1:N1,2:2:N2,:),X(1:N1,N2,:)],[2,1,3])... 
               + filter(LiftFilter(:,1),1,X0(RightShift,:,:),... 
               X0(1,:,:)*LiftFilter(1,1),1); 
         else 
            X1 = permute(X(1:N1,2:2:N2,:),[2,1,3]) ... 
               + filter(LiftFilter(:,1),1,X0(RightShift,:,:),... 
               X0(1,:,:)*LiftFilter(1,1),1); 
         end 
 
         X0 = X0 + filter(LiftFilter(:,2),1,... 
            X1,X1(1,:,:)*LiftFilter(1,2),1); 
 
         if rem(N2,2) 
            X1(M2,:,:) = []; 
         end 
 
         X(1:N1,1:N2,:) = permute([X0*ScaleFactor;X1/ScaleFactor],[2,1,3]); 
      end 
 
      N1 = M1; 
      N2 = M2; 
   end 
else           % Inverse transform 
   for k = 1+Level:0 
      M1 = ceil(N1*pow2(k)); 
      M2 = ceil(N2*pow2(k)); 
 
      %%% Inverse transform along rows %%% 
      if M2 > 1 
         Q = ceil(M2/2); 
         RightShift = [2:Q,Q]; 
         X1 = permute(X(1:M1,Q+1:M2,:)*ScaleFactor,[2,1,3]); 
 
         if rem(M2,2) 
            X1(Q,1,1) = 0; 
         end 
 
         % Undo lifting stages 
         X0 = permute(X(1:M1,1:Q,:)/ScaleFactor,[2,1,3]) ... 
            - filter(LiftFilter(:,2),1,X1,X1(1,:,:)*LiftFilter(1,2),1); 
         X1 = X1 - filter(LiftFilter(:,1),1,X0(RightShift,:,:),... 
            X0(1,:,:)*LiftFilter(1,1),1); 
 
         if rem(M2,2) 
            X1(Q,:,:) = []; 
         end 
 
         X(1:M1,[1:2:M2,2:2:M2],:) = permute([X0;X1],[2,1,3]); 
      end 
 
      %%% Inverse transform along columns %%% 
      if M1 > 1 
         Q = ceil(M1/2); 
         RightShift = [2:Q,Q]; 
         X1 = X(Q+1:M1,1:M2,:)*ScaleFactor; 
 
         if rem(M1,2) 
            X1(Q,1,1) = 0; 
         end 
 
         % Undo lifting stages 
         X0 = X(1:Q,1:M2,:)/ScaleFactor ... 
            - filter(LiftFilter(:,2),1,X1,X1(1,:,:)*LiftFilter(1,2),1); 
         X1 = X1 - filter(LiftFilter(:,1),1,X0(RightShift,:,:),... 
            X0(1,:,:)*LiftFilter(1,1),1); 
 
         if rem(M1,2) 
            X1(Q,:,:) = []; 
         end 
 
         X([1:2:M1,2:2:M1],1:M2,:) = [X0;X1]; 
      end 
   end 
end