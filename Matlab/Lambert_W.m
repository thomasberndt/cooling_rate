function W = Lambert_W(x)
%
% Generate initial guess.
%

sz = size(x); 
x = x(:); 

mask = (x<0.7385);
%
x1 = x(mask);
W = NaN * zeros(size(x)); 
W(mask) = x1.*(1.0 + 1.33333333333333*x1) ./ ...
    (1.0 + x1.*(2.33333333333333 + 0.83333333333333*x1));
%
mask2 = ~mask;
x2 = x(mask2);
xlog = log(x2);
W(mask2) = xlog - 24.0*( xlog.*(xlog + 2.0) - 3.0) ./ ...
    (127.0 + xlog .* ( 7.0*xlog + 58.0 ) );
%
% Iterate until relative error is below something small for all values of x:
%
relerr = 2.0 * eps;
en = ones(1,length(x));
nits = 0;
while (max(en) > relerr)
    z = log(x./W) - W;
    temp1 = 1.0 + W + 0.66666666666667*z;
    en = z .* temp1 ./ ( (1.0+W) .* temp1 - 0.5*z );
    W = W .* (1.0+en);
    nits = nits + 1;
    if (nits > 100)
        disp('Too many iterations!');
        break
    end
end

W = reshape(W, sz);