function val=intSinCosPow(u,n,m)
%%INTSINCOSPOWER Evaluate the integral of sin(u)^n*cos(u)^m du.  A definite
%             integral can be evaluated, or an indefinite integral (with a
%             particular additive constant).
%
%INPUTS: u A 2XN (for definite integral) or a 1XN (for indefinite
%          integrals) set of N points. For definite integrals, u(1,:) are
%          the real lower bounds and u(2,:) are the real upper bounds. For
%          indefinite integrals, the integral is evaluated at the points in
%          u. The values in u should be real.
%        n The positive integer exponent of the sine term.
%        m The positive integer exponent of the cosine term.
%
%OUTPUTS: val The 1XN set of values of the integral of sin(u)^n*cos(u)^m.
%
%This function simply implements the recursion that arises from integration
%by parts from basic calculus, as are given in the tables in the back of
%[1].
%
%REFERENCES:
%[1] J. Stewart, Calculus, 7th ed. Belmont, CA: Brooks/Cole, 2012.
%
%October 2016 David F. Crouse, Naval Research Laboratory, Washington D.C.
%(UNCLASSIFIED) DISTRIBUTION STATEMENT A. Approved for public release.

numDim=size(u,1);

if(isempty(u))
   val=[];
   return;
end

if(numDim==1)%An indefinite integral
    val=indefIntSinCosPow(u,n,m);
else%A definite integral
    val=indefIntSinCosPow(u(2,:),n,m)-indefIntSinCosPow(u(1,:),n,m);
end
end

function val=indefIntSinCosPow(u,n,m)
    %Special cases come first
    if(n==0)
        val=intCosPow(u,m);
        return
    elseif(m==0)
        val=intSinPow(u,n);
        return
    elseif(n==1)
        val=-(cos(u).^(1+m)./(1+m));
        return
    elseif(m==1)
        val=sin(u).^(1+n)./(1+n);
        return;
    end

    %If here, n>=1 and m>=1
    sinVal=sin(u);
    cosVal=cos(u);

    %The integration by parts is taken across the value with fewer terms.
    if(m>n)
        val=0;
        if(mod(n,2)==0)%If n is even
            endVal=2;
        else
            endVal=3;
        end

        coeffProd=1;
        for k=n:-2:endVal
            val=val-coeffProd*(1/(k+m))*sinVal.^(k-1).*cosVal.^(m+1);
            coeffProd=coeffProd*(k-1)/(k+m);
        end

        if(endVal==2)
            %The final integral is over sin^0*cos^m
            val=val+coeffProd*intCosPow(u,m);
        else%The final value is over sin^1*cos^m
            val=val-coeffProd*(cos(u).^(1+m)./(1+m));
        end
    else%m<=n
        val=0;
        if(mod(m,2)==0)%If n is even
            endVal=2;
        else
            endVal=3;
        end 

        coeffProd=1;
        for k=m:-2:endVal
            val=val+coeffProd*(1/(k+n))*sinVal.^(n+1).*cosVal.^(k-1);
            coeffProd=coeffProd*(k-1)./(k+n);
        end

        if(endVal==2)
            %The final integral is over sin^n*cos^0
            val=val+coeffProd*intSinPow(u,n);
        else%The final value is over sin^n*cos^1
            val=val+coeffProd*(sin(u).^(1+n)./(1+n));
        end
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
