using Test

int_re = r"^[-+]?\d+$"

@testset "Matching Integers" begin
  @test occursin(int_re, "1234")
  @test occursin(int_re, "-1234")
  @test occursin(int_re, "+1234")
  @test occursin(int_re, "0123")
  @test occursin(int_re, "-999")
  @test occursin(int_re, "+9")
end

@testset "Non-integers" begin
  @test !occursin(int_re, "12.34")
  @test !occursin(int_re, "-12.34")
  @test !occursin(int_re, "0.1234")
  @test !occursin(int_re, "+12.34")
end

run_dec_test = true

@testset "Matching Decimals" begin
  @test occursin(dec_re, "12.34") skip = !run_dec_test
  @test occursin(dec_re, "-12.34") skip = !run_dec_test
  @test occursin(dec_re, "0.1234") skip = !run_dec_test
  @test occursin(dec_re, "-0.1234") skip = !run_dec_test
  @test occursin(dec_re, ".1234") skip = !run_dec_test
  @test occursin(dec_re, "-.1234") skip = !run_dec_test
  @test occursin(dec_re, "12.0") skip = !run_dec_test
  @test occursin(dec_re, "12.") skip = !run_dec_test
  @test occursin(dec_re, "-12.0") skip = !run_dec_test
  @test occursin(dec_re, "-12.") skip = !run_dec_test
end

@testset "Non decimals" begin
  @test !occursin(dec_re, "1234") skip = !run_dec_test
  @test !occursin(dec_re, "-1234") skip = !run_dec_test
  @test !occursin(dec_re, ".") skip = !run_dec_test
end

run_parse_test = true

@testset "Parse integers" begin
  @test parseIntOrDec("1234") == 1234 skip = !run_parse_test
  @test parseIntOrDec("-1234") == -1234 skip = !run_parse_test
  @test parseIntOrDec("+1234") == 1234 skip = !run_parse_test
  @test parseIntOrDec("0123") == 123 skip = !run_parse_test
  @test parseIntOrDec("-999") == -999 skip = !run_parse_test
  @test parseIntOrDec("+9") == 9 skip = !run_parse_test
end

@testset "Parse Decimals" begin
  @test parseIntOrDec("12.34") == 12.34 skip = !run_parse_test
  @test parseIntOrDec("-12.34") ==  -12.34 skip = !run_parse_test
  @test parseIntOrDec("0.1234") == 0.1234 skip = !run_parse_test
  @test parseIntOrDec("-0.1234") == -0.1234 skip = !run_parse_test
  @test parseIntOrDec(".1234") == 0.1234 skip = !run_parse_test
  @test parseIntOrDec("-.1234") == -0.1234 skip = !run_parse_test
  @test parseIntOrDec("12.0") == 12.0 skip = !run_parse_test
  @test parseIntOrDec("12.")  == 12.0 skip = !run_parse_test
  @test parseIntOrDec("-12.0") == -12.0 skip = !run_parse_test
  @test parseIntOrDec("-12.") == -12.0 skip = !run_parse_test
end