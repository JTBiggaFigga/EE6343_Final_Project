function h_hat_k = NPML_chan_est(x, y, h_hat_kmin1, sigma, num_subs)

sum1 = 0;
sum2 = 0;
sum3 = 0;

for i=1:num_subs
	for j=1:num_subs
		sum1 = sum1 + parzen_func( sigma, est_error(i, x, y, h_hat_kmin1, num_subs) - est_error(j, x, y, h_hat_kmin1, num_subs)); 
		num = diff(parzen_func( sigma, est_error(i, x, y, h_hat_kmin1, num_subs) - est_error(j, x, y, h_hat_kmin1, num_subs))); 
		denom = diff(h_hat_kmin1);
		size(num);
		size(denom);
		if size(num) == 0
		    num = 0;
		end
		sum2 = sum2 + (num ./ denom); % Approximate derivitave (respect to h)
	end
	size(sum1);
	size(sum2);
	sum3 = sum3 + ([sum2 0] ./ sum1);
end

h_hat_k = sum3;
