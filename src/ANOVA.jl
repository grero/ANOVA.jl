module ANOVA
import Base.show

using Distributions
type TwoWayANOVA
	SS_1::Float64
	SS_2::Float64
	SS_12::Float64
	SS_error::Float64
	df_1::Int64
	df_2::Int64
	df_12::Int64
	df_error::Int64
	F_1::Float64
	F_2::Float64
	F_12::Float64
	pv_1::Float64
	pv_2::Float64
	pv_12::Float64
end

function show(ii::IO, X::TwoWayANOVA)
	println(ii, "\tSS\tdf\tMS\tF\tp-value")
	println(ii,"Var 1\t$(round(X.SS_1,2))\t$(X.df_1)\t$(round(X.SS_1/X.df_1,2))\t$(round(X.F_1,2))\t$(round(X.pv_1,3))") 
	println(ii,"Var 2\t$(round(X.SS_2,2))\t$(X.df_2)\t$(round(X.SS_2/X.df_2,2))\t$(round(X.F_2,2))\t$(round(X.pv_2,3))") 
	println(ii,"Var 1&2\t$(round(X.SS_12,2))\t$(X.df_12)\t$(round(X.SS_12/X.df_12,2))\t$(round(X.F_12,2))\t$(round(X.pv_12,3))") 
	println(ii,"Error\t$(round(X.SS_error,2))\t$(X.df_error)\t$(round(X.SS_error/X.df_error,2))\t\t")
end


type RepeatedMeasuresANOVA
	SS_b::Float64
	SS_error::Float64
	MS_b::Float64
	MS_error::Float64
	df_b::Int64
	df_error::Int64
	F::Float64
	pvalue::Float64
end

"""
Run a two way ANOVA using `Y` as the dependent variable and `label1` and `label2` as the independent variables.

	function anova{T<:Real}(Y::Array{T,1}, label1::Array, label2::Array)
"""
function anova{T<:Real}(Y::Array{T,1}, label1::Array, label2::Array)
	μ = mean(Y)
	ulabel1 = unique(label1)
	sort!(ulabel1)
	n1 = length(ulabel1)
	ulabel2 = unique(label2)
	sort!(ulabel2)
	n2 = length(ulabel2)

	μ_1 = [mean(Y[label1.==g]) for g in ulabel1]
	μ_2 = [mean(Y[label2.==g]) for g in ulabel2]
	n_12 =[sum((label1.==r)&(label2.==g)) for r in ulabel1, g in ulabel2]
	μ_12 =[mean(Y[(label1.==r)&(label2.==g)]) for r in ulabel1, g in ulabel2]
	SS_1 = first(sum(n_12,2)'*((μ_1 - μ).^2))
	SS_2 = first(sum(n_12,1)*((μ_2 - μ).^2))
	SS_12 = first(sum(n_12.*((μ_12 .- μ_2').^2 +(μ_12 .- μ_1).^2 - (μ_12 - μ).^2)))
	SS_error = first(sum([sum((Y[(label1.==r)&(label2.==g)]-μ_12[ri,gi]).^2) for (ri,r) in enumerate(ulabel1), (gi,g) in enumerate(ulabel2)]))

	df_1 = n1-1
	df_2 = n2-1
	df_12 = df_1*df_2
	df_error = sum(n_12-1)
	MS_1 = SS_1/df_1
	MS_2 = SS_2/df_2
	MS_12 = SS_12/df_12
	MS_error = SS_error/df_error
	F_1 = MS_1/MS_error
	F_2 = MS_2/MS_error
	F_12 = MS_12/MS_error
	pv_1 = 1-cdf(FDist(df_1,df_error), F_1)
	pv_2 = 1-cdf(FDist(df_2,df_error), F_2)
	pv_12 = 1-cdf(FDist(df_12,df_error), F_12)
	TwoWayANOVA(SS_1, SS_2, SS_12, SS_error, df_1, df_2, df_12, df_error, F_1, F_2, F_12, pv_1, pv_2, pv_12)
end
"""
Perform a repeated ANOVA on the data in `X`,where each 'subject` is treated with each `condition`. Thus, `condition` is repeatedly measured for each `subject`.
"""
function ranova(X::Array{Float64,1}, condition::Array{Int64,1}, subject::Array{Int64,1},args...)
	μ = mean(X) #overall mean
	uconditions = unique(condition)
	sort!(uconditions)
	nsubjects = length(unique(subject))
	nconditions = length(uconditions)
	μ_conditions = zeros(nconditions)
	nn_conditions = zeros(Int64,nconditions) 
	μ_subjects = zeros(nsubjects)
	nn_subjects = zeros(Int64, nsubjects)
	for i in 1:length(X)
		c = condition[i]	
		s = subject[i]
		μ_conditions[c] += X[i]
		nn_conditions[c] += 1 
		μ_subjects[s] += X[i]
		nn_subjects[s] += 1
	end
	μ_conditions ./= nn_conditions
	μ_subjects ./= nn_subjects
	SSb = sum(x->x[1]*(x[2]-μ)^2, zip(nn_conditions, μ_conditions))
	SSw = 0.0
	for i in 1:length(X)
		c = condition[i]
		_x = X[i] - μ_conditions[c]
		SSw += _x*_x
	end
	SS_subject = sum(x->x[1]*(x[2]-μ)^2, zip(nn_subjects, μ_subjects))
	SS_error = SSw - SS_subject
	df_b = nconditions-1
	df_error = (nsubjects-1)*(nconditions-1)
	MS_b = SSb/df_b
	MS_error = SS_error/df_error
	F = MS_b/MS_error
	pvalue = 1-cdf(FDist(df_b, df_error), F)
	return RepeatedMeasuresANOVA(SSb, SS_error, MS_b, MS_error, df_b, df_error, F, pvalue)
end

end#module
