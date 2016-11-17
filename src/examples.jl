function example1()
	X2 = [9.8, 9.9,11.3, 10.1, 9.5, 10.7, 9.8, 10.0, 10.7, 9.2, 9.1, 10.3, 8.6, 9.1, 10.7, 9.2, 9.4, 10.2, 8.4, 8.6, 9.8, 7.9, 8.0, 10.1, 8.0, 8.0, 10.1]
	treatment = repmat(["A", "B", "C"],9,1)
	subject = repmat([1,2,3], 1,9)'[:]
	PP = ANOVA.anova(X2, subject, treatment)
end
