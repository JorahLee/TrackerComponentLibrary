function val=calcMERF(zTrue,zMeas,zEst,type)
%%CALCMERF Compute the measurement error reduction factor (MERF). This is a
%          measure of how well a filter does at reducting the error of
%          measurements. If ther MERF is greater than 1, then it is
%          generally better to not use the filter at all and just "connect
%          the dots" with the measurements. This function can also be used
%          to compute an estimation error reduction factor (EERF) by
%          changing the inputs, as described below.
%
%INPUTS: zTrue These are zDimXN set of noiseless values of the measurements
%              (or for an EERF, true target state components) If the truth
%              is the same for all samples of the estimate, then this is a
%              zDimX1 vector.
%        zMeas The zDimXN set of measurements (or measurements converted to
%              the state domain if an EERF is desired).
%         zEst The zDimXN set of estimated in the measurement domain (for
%              the MERF and in the state domain for the EERF).
%         type An optional parameter specifying the type of MERF/EERF to
%              compute.  Possible values are
%              0 (The default if omitted or an empty matrix is passed)
%                Compute the MERF using the AEE as in Equation 14 in [1].
%              1 Compute the MERF using the RMSE as after Equation 15 in
%                [1].
%              2 Compute the MERF using a type of geometric average as
%                after Equation 16 in [1].
%
%OUTPUTS: val The scalar value of the MERF (or EERF).
%
%The MERF and the EERF are discussed in detail in [1].
%
%EXAMPLE:
%Here, we consider the MERF when looking at the estimate of a Kalman filter
%after a number of steps when dealing with a simple Gaussian model and
%Gaussian measurements. 
% H=[1,0,0,0;
%    0,1,0,0];
% zDim=size(H,1);
% xDim=size(H,2);
% T=1;
% F=FPolyKal(T,zeros(4,1),1);
% q0=1e-3;
% Q=QPolyKal(T,zeros(4,1),1,q0);
% SQ=chol(Q,'lower');
% R=eye(2);
% SR=chol(R,'lower');
% numRuns=100;
% numSteps=20;
% xInit=[1000;100;20;50];
% sigmaV=200;%Standard deviation for single-point initializtion.
% zTrue=zeros(zDim,numRuns);
% zMeas=zeros(zDim,numRuns);
% zEst=zeros(zDim,numRuns);
% 
% for curRun=1:numRuns
%     %Create the true track
%     xTrue=xInit;
%     z=H*xTrue+SR*randn(zDim,1);
%     [xEst,PEst]=onePointCartInit(z,SR,sigmaV);
%     SEst=chol(PEst,'lower');
%
%     for curStep=1:numSteps
%         [xEst,SEst]=sqrtDiscKalPred(xEst,SEst,F,SQ);
%         
%         xTrue=F*xTrue+SQ*randn(xDim,1);
%         zTrueCur=H*xTrue;
%         z=zTrueCur+SR*randn(zDim,1);
%         [xEst,SEst]=sqrtKalmanUpdate(xEst,SEst,z,SR,H);
%     end
%     zTrue(:,curRun)=zTrueCur;
%     zMeas(:,curRun)=z;
%     zEst(:,curRun)=H*xEst;
% end
% calcMERF(zTrue,zMeas,zEst,0)
% calcMERF(zTrue,zMeas,zEst,1)
% calcMERF(zTrue,zMeas,zEst,2)
% %One will see that the error is reduced usually to less than 0.5 for all
% %estimators. As a sanity check, one will see that for all estimators, if
% %the measurement is used as the estimate, then the estimators return 1
% calcMERF(zTrue,zMeas,zMeas,0)
% calcMERF(zTrue,zMeas,zMeas,1)
% calcMERF(zTrue,zMeas,zMeas,2)
%
%REFERENCES:
%[1] X. R. Li and Z. Zhao, "Measures of performance for evaluation of
%    estimators and filters," in Proceedings of SPIE: Conference on Signal
%    and Data processing of Small Targets, vol. 4473, San Diego, CA, 29
%    Jul. 2001, pp. 530-541.
%
%February 2017 David F. Crouse, Naval Research Laboratory, Washington D.C.
%(UNCLASSIFIED) DISTRIBUTION STATEMENT A. Approved for public release.

if(nargin<4||isempty(type))
    type=0; 
end

numEst=size(zMeas,2);
if(size(zTrue,2)==1)
    zTrue=repmat(zTrue,[1,numEst]);
end

switch(type)
    case 0%AEE
        val=calcAEE(zTrue,zEst)/calcAEE(zTrue,zMeas);
    case 1%RMSE
        val=calcRMSE(zTrue,zEst)/calcRMSE(zTrue,zMeas);
    case 2%A type of GAE
        val=exp((1/(2*numEst))*sum(log(sum((zTrue-zEst).^2,1)./sum((zTrue-zMeas).^2,1))));
    otherwise
        error('Unknown type specified')
end
end

%LICENSE:
%
%The source code is in the public domain and not licensed or under
%copyright. The information and software may be used freely by the public.
%As required by 17 U.S.C. 403, third parties producing copyrighted works
%consisting predominantly of the material produced by U.S. government
%agencies must provide notice with such work(s) identifying the U.S.
%Government material incorporated and stating that such material is not
%subject to copyright protection.
%
%Derived works shall not identify themselves in a manner that implies an
%endorsement by or an affiliation with the Naval Research Laboratory.
%
%RECIPIENT BEARS ALL RISK RELATING TO QUALITY AND PERFORMANCE OF THE
%SOFTWARE AND ANY RELATED MATERIALS, AND AGREES TO INDEMNIFY THE NAVAL
%RESEARCH LABORATORY FOR ALL THIRD-PARTY CLAIMS RESULTING FROM THE ACTIONS
%OF RECIPIENT IN THE USE OF THE SOFTWARE.
