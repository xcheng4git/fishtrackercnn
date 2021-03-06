function net = cnn_fish_init(opts)
%opts = vl_argparse(opts, varargin) ;
f=1/100 ;
opts.useBnorm = true ;
net.layers = {} ;
net.layers{end+1} = struct('type', 'conv', ...
                           'filters', f*randn(5,5,1,25, 'single'), ...
                           'biases', zeros(1, 25, 'single'), ...
                           'stride', 1, ...
                           'pad', 0) ;
net.layers{end+1} = struct('type', 'pool', ...
                           'method', 'max', ...
                           'pool', [2 2], ...
                           'stride', 2, ...
                           'pad', 0) ;
net.layers{end+1} = struct('type', 'conv', ...
                            'filters', f*randn(5,5,25,50, 'single'), ...
                           'biases', zeros(1, 50, 'single'), ...
                           'stride', 1, ...
                           'pad', 0) ;
net.layers{end+1} = struct('type', 'pool', ...
                           'method', 'max', ...
                           'pool', [3 3], ...
                           'stride', 2, ...
                           'pad', 0) ;
net.layers{end+1} = struct('type', 'conv', ...
                           'filters', f*randn(6,6,50,500, 'single'), ...
                           'biases', zeros(1, 500, 'single'), ...
                           'stride', 1, ...
                           'pad', 0) ;
net.layers{end+1} = struct('type', 'pool', ...
                           'method', 'max', ...
                           'pool', [3 3], ...
                           'stride', 2, ...
                           'pad', 0) ;
net.layers{end+1} = struct('type', 'relu') ;
net.layers{end+1} = struct('type', 'conv', ...
                           'filters', f*randn(2,2,500,14, 'single'), ...
                           'biases', zeros(1, 14, 'single'), ...
                           'stride', 1, ...
                           'pad', 0) ;

net.layers{end+1} = struct('type', 'softmaxloss') ;
if opts.useBnorm
  net = insertBnorm(net, 1) ;
  net = insertBnorm(net, 4) ;
  net = insertBnorm(net, 7) ;
  %net = insertBnorm(net, 10) ;
end

% --------------------------------------------------------------------
function net = insertBnorm(net, l)
% --------------------------------------------------------------------
assert(isfield(net.layers{l}, 'filters'));
ndim = size(net.layers{l}.filters, 4);
layer = struct('type', 'bnorm', ...
               'filters', ones(ndim, 1, 'single'), ...
               'biases',zeros(ndim, 1, 'single'), ...
               'learningRate', [1 1], ...
               'weightDecay', [0 0]) ;
net.layers{l}.biases = [] ;
net.layers = horzcat(net.layers(1:l), layer, net.layers(l+1:end)) ;
                       