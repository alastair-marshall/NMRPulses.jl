module NMRPulses

export Pulse,
    BasicPulse,
    IdlePulse,
    Sequence,
    PiPulse,
    PiHalfPulse,
    ArbitraryPulse,
    PWPulse,
    prepare_sequence



include("pulses.jl")
include("tools.jl")

end
