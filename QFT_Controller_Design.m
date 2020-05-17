s = tf('s');
P = s*zeros(1,1,6);
A = [25.34 28.7 19.26 29.96 4.353 7.76];
T = [10.4 9.6 1.9 1.65 0.09 0.14];
Ay = A(1);
Tau = T(1);

tfs = s*zeros(1,1,6);
Gf = tf([1.2 6.3], 1);
G2 = (s/8.66+1)*1.2/s;
% Generate set of first order velocity plants Pv
for i = (1:1:6)
    P(1,1,i) = tf(A(i),[1 T(i)]);
    tfs(1,1,i) = ((G2*P(1,1,i)))/(1+G2*P(1,1,i))*1/s*1/30;
end
tf2 = tfs(1,1,3);
% Choose discrete values at which to consider sensitivity
W = [0.2, 0.5, 1, 5, 10, 20, 50, 100];

% Generate frequency response
Pw = freqresp(P,W);

% alpha = 8.66 rad/s
% T = 0.07053 s

% Plot template and bounds
% plottmpl(W,P,6);
b1=sisobnds(2,W(1),10^(-23/20),P); % |1/(1+L)| <=-23dB, w=0.2rad/s
b2=sisobnds(2,W,10^(5/20),P); %|1/(1+L)| <= 5dB, \forall w
bnd=grpbnds(b1,b2); % group the bounds for use in lpshape
ubnd = sectbnds(bnd);
% plotbnds(bnd);
G = tf(1,1); %G(w)
Gout = 90*(s/2.8+1);
% *(1-s*0.07053/2)
lpshape(W,ubnd,tfs(1,1,1),G) % CAD tool for loop-shaping
