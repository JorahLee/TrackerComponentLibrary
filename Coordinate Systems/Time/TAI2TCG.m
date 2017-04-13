function [Jul1,Jul2]=TAI2TCG(Jul1,Jul2)
%%TAI2TCG Convert from international atomic time (TAI) given as a two-part
%         Julian date to geocentric coordinate time (TCG), represented as a
%         two-part Julian date.
%
%INPUTS: Jul1, Jul2 Two parts of a Julian date given in TAI. The units of
%                   the date are days. The full date is the sum of both
%                   terms. The date is broken into two parts to provide
%                   more bits of precision. It does not matter how the date
%                   is split.
%
%OUTPUTS: Jul1, Jul2 The time as a Julian date in TCG.
%
%This just calls a number of intermediate conversion functions out of the
%International Astronomical Union's (IAU) Standard's of Fundamental
%Astronomy library.
%
%Many temporal coordinate systems standards are compared in [1].
%
%REFERENCES:
%[1] D. F. Crouse, "An overview of major terrestrial, celestial, and
%    temporal coordinate systems for target tracking", Report, U. S. Naval
%    Research Laboratory, to appear, 2016.
%
%October 2013 David F. Crouse, Naval Research Laboratory, Washington D.C.
%(UNCLASSIFIED) DISTRIBUTION STATEMENT A. Approved for public release.

[Jul1,Jul2]=TAI2TT(Jul1,Jul2);
[Jul1,Jul2]=TT2TCG(Jul1,Jul2);
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
