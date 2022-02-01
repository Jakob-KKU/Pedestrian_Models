obs_bin(a::agent, b::agent, l, m) = (b.x[m]-a.x[l]-0.3)/(b.v_x[m] - a.v_x[l])
;
