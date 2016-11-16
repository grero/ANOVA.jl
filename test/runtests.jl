using ANOVA
using Base.Test


function test_ranova()
	#data taken from https://statistics.laerd.com/statistical-guides/repeated-measures-anova-statistical-guide.php
	X = [45.0, 42.0, 36.0, 39.0, 51.0, 44.0, 50.0, 42.0, 41.0, 35.0, 55.0, 49.0, 55.0, 45.0, 43.0, 40.0, 59.0, 56.0]
	conditions = repmat(1:3',1,6)'[:]
	subjects = repmat(1:6,1,3)[:]
	rr = ANOVA.ranova(X, conditions, subjects)
	@test_approx_eq rr.SS_b 143.44444444444423
	@test_approx_eq rr.SS_error 57.222222222222285
	@test_approx_eq rr.F 12.53398058252424
	@test_approx_eq rr.pvalue 0.0018855906470255368
end

function test_anova()
	#data taken from https://people.richland.edu/james/ictcm/2004/twoway.html
	Y = [54, 49, 59, 39, 55, 25, 29, 47, 26, 28,53, 72, 43, 56, 52,46, 51, 33, 47, 41,33, 30, 26, 25, 29,18, 21, 34, 40, 24]
	race = repmat(repmat(["Caucasian", "African-American", "Hispanic"], 1,5)'[:]',2,1)[:]
	gender = repmat(repmat(["Male","Female"], 1,5)'[:],3,1)
	P = ANOVA.anova(Y, race, gender)
	@test_approx_eq P.SS_1 2328.2
	@test_approx_eq P.SS_2 907.5
	@test_approx_eq P.SS_12 452.5999999999999
	@test_approx_eq P.SS_error 1589.2
	@test_approx_eq P.df_error 24
	@test_approx_eq P.df_1  2
	@test_approx_eq P.df_2  1
	@test_approx_eq P.df_12  2
end

test_anova()
test_ranova()




