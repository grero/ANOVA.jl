using ANOVA
using Test

function test_ranova()
	#data taken from https://statistics.laerd.com/statistical-guides/repeated-measures-anova-statistical-guide.php
	X = [45.0, 42.0, 36.0, 39.0, 51.0, 44.0, 50.0, 42.0, 41.0, 35.0, 55.0, 49.0, 55.0, 45.0, 43.0, 40.0, 59.0, 56.0]
	conditions = repeat(1:3',1,6)'[:]
	subjects = repeat(1:6,1,3)[:]
	rr = ANOVA.ranova(X, conditions, subjects)
	@test rr.SS_b ≈ 143.44444444444423
	@test rr.SS_error ≈ 57.222222222222285
	@test rr.F ≈ 12.53398058252424
	@test rr.pvalue ≈ 0.0018855906470255368
end

function test_anova()
	#data taken from https://people.richland.edu/james/ictcm/2004/twoway.html
    Y = [54, 49, 59, 39, 55, 25, 29, 47, 26, 28,53, 72, 43, 56, 52,46, 51, 33, 47, 41,33, 30, 26, 25, 29,18, 21, 34, 40, 24]
    _race = ["Caucasian", "African-American", "Hispanic"]
    race = [r for i in 1:10, r in _race][:]
    G = ["Male", "Female"]
    gender = [g for i = 1:5, g in G,j in 1:3][:]
	P = ANOVA.anova(Y, race, gender)
    @test P.SS_1 ≈ 2328.2
    @test P.SS_2 ≈ 907.5
    @test P.SS_12 ≈ 452.5999999999999
    @test P.SS_error ≈ 1589.2
    @test P.df_error == 24
    @test P.df_1 == 2
    @test P.df_2 == 1
    @test P.df_12 == 2
end

@testset "ANOVA" begin
    test_anova()
end
@testset "rANOVA" begin
    test_ranova()
end
