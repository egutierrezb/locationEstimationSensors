function y = pdist2(x, distfun, varargin)

  if (nargin < 1)
    print_usage ();
  endif
  ##elseif (nargin > 1) && ...
  ##      ! (ischar (distfun) || ...
  ##         strcmp (class(distfun), "function_handle"))
  ##  error ("pdist: the distance function must be either a string or a function handle.");
  ##endif

  if (nargin < 2)
    distfun = "euclidean";
  endif

  if (isempty (x))
    error ("pdist: x cannot be empty");
  elseif (length (size (x)) > 2)
    error ("pdist: x must be 1 or 2 dimensional");
  endif

  sx1 = size (x, 1);
  y = [];
  ## compute the distance
  for i = 1:sx1
    tmpd = feval (distfun, x(i,:), x(i+1:sx1,:), varargin{:});
    y = [y;tmpd(:)];
  endfor

endfunction

## the different standardized distance functions

function d = euclidean(u, v)
  d = sqrt (sum ((repmat (u, size (v,1), 1) - v).^2, 2));
endfunction

function d = seuclidean(u, v)
  ## FIXME
  error("Not implemented")
endfunction

function d = mahalanobis(u, v, p)
  repu = repmat (u, size (v,1), 1);
  d = (repu - v)' * inv (cov (repu, v)) * (repu - v);
  d = d.^(0.5);
endfunction

function d = cityblock(u, v)
  d = sum (abs (repmat (u, size(v,1), 1) - v), 2);
endfunction

function d = minkowski
  if (nargin < 3)
    p = 2;
  endif

  d = (sum (abs (repmat (u, size(v,1), 1) - v).^p, 2)).^(1/p);
endfunction

function d = cosine(u, v)
  repu = repmat (u, size (v,1), 1);
  d = dot (repu, v, 2) ./ (dot(repu, repu).*dot(v, v));
endfunction

function d = correlation(u, v)
  repu = repmat (u, size (v,1), 1);
  d = cor(repu, v);
endfunction

function d = spearman(u, v)
  repu = repmat (u, size (v,1), 1);
  d = spearman (repu, v);
endfunction

function d = hamming(u, v)
  ## Hamming distance, the percentage of coordinates that differ
  sv2 = size(v, 2);
  for i = 1:sv2\
    v(:,i) = (v(:,i) == u(i));
  endfor
  d = sum (v,2)./sv2;
endfunction

function d = jaccard(u, v)
  ## Jaccard distance, one minus the percentage of non-zero coordinates
  ## that differ
  sv2 = size(v, 2);
  for i = 1:sv2
    v(:,i) = (v(:,i) == u(i)) && (u(i) || v(:,i));
  endfor
  d = 1 - sum (v,2)./sv2;
endfunction

function d = chebychev(u, v)
  repu = repmat (u, size (v,1), 1);
  d = max (abs (repu - v), [], 2);
endfunction
