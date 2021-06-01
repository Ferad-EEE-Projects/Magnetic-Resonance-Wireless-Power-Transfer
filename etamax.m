function [ max_eff ] = etamax( k,Q1,Q2 )
%ETAMAX Summary of this function goes here
%   Detailed explanation goes here
max_eff = (k.^2*Q1.*Q2)./((1+sqrt(1+k.^2*Q1.*Q2)).^2);
end

