function [ wrapped ] = MDWrap( in )
%MY_WRAP Summary of this function goes here
%   Detailed explanation goes here

wrapped=mod(in+pi,2*pi)-pi;

end

