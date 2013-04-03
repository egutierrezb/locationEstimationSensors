function y = squareform (x, method)

  if nargin < 1
    print_usage ();
  elseif nargin < 2
    if isscalar (x) || isvector (x)
      method = "tomatrix";
    elseif issquare (x)
      method = "tovector";
    else
      error ("squareform: cannot deal with a nonsquare, nonvector input");
    endif
  endif
  method = lower (method);

  if ! strcmp ({"tovector" "tomatrix"}, method)
    error ("squareform: method must be either \"tovector\" or \"tomatrix\"");
  endif

  if strcmp ("tovector", method)
    if ! issquare (x)
      error ("squareform: x is not a square matrix");
    endif

    sx = size (x, 1);
    y = zeros ((sx-1)*sx/2, 1);
    idx = 1;
    for i = 2:sx
      newidx = idx + sx - i;
      y(idx:newidx) = x(i:sx,i-1);
      idx = newidx + 1;
    endfor
  else
    ## we're converting to a matrix

    ## make sure that x is a column
    x = x(:);

    ## the dimensions of y are the solution to the quadratic formula for:
    ## length(x) = (sy-1)*(sy/2)
    sy = (1 + sqrt (1+ 8*length (x)))/2;
    y = zeros (sy);
    for i = 1:sy-1
      step = sy - i;
      y((sy-step+1):sy,i) = x(1:step);
      x(1:step) = [];
    endfor
    y = y + y';
  endif

endfunction

