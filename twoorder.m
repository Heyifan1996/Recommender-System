function [answer] = twoorder( x,y,z,r )
score=x*y';
answer=sigmod(z,r)*sigmod(score,r)*(1-sigmod(score,r))*x-sigmod(score,r)^2*(1-sigmod(score,r))*x;
end

