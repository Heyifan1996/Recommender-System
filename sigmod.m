function [ z ] = sigmod( x,y )
z=1/(1+exp(y-x));
end

