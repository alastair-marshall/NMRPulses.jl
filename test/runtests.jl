using NMRPulses
using Test

id = IdlePulse(1, 1e-3)
Ω = 2*pi
pi_2 = PiHalfPulse(Ω, 0, 1e-3)
pi_pulse = PiPulse(Ω, 0, 1e-3)

s = Sequence([pi_2, id, pi_pulse, id, pi_2])

a, b, c = prepare_sequence(s)


@testset "NMRPulses.jl" begin
    # Write your tests here.
    @test s(0.0)[1] == a[1]
    @test pi_2(0.0)[1] == a[1]

    
end