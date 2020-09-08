# using StaticArrays

abstract type Pulse end

abstract type BasicPulse <: Pulse end
abstract type PulseSequence end


"""
IdlePulse is a pulse where the amplitude and phase are zero
"""
struct IdlePulse{T} <: BasicPulse
    Ω::T
    ϕ::T
    T::T
    dt::T
    IdlePulse(T, dt) = new{Float64}(0.0, 0.0, T, dt)
end

"""
A πPulse is a pulse where the duration is chosen to produce a pi rotation
"""
struct PiPulse{T} <: BasicPulse
    Ω::T
    ϕ::T
    T::T
    dt::T
    PiPulse(Ω, ϕ, dt) = new{Float64}(Ω, ϕ, π/Ω, dt)
end

"""
A πHalfPulse is a pulse where the duration is chosen to produce a pi/2 rotation
"""
struct PiHalfPulse{T} <: BasicPulse
    Ω::T
    ϕ::T
    T::T
    dt::T
    PiHalfPulse(Ω, ϕ, dt) = new{Float64}(Ω, ϕ, π/Ω/2, dt)
end

"""
An ArbitraryPulse is a pulse where you control everything
"""
struct ArbitraryPulse{T} <: BasicPulse
    Ω::T
    ϕ::T
    T::T
    dt::T
    ArbitraryPulse(Ω, ϕ, T, dt) = new{Float64}(Ω, ϕ, T, dt)
end

"""
Piecewise constant pulse constructed from arrays of amplitude and phase
"""
struct PWPulse{T} <: Pulse
    Ω::Array{T,1}
    ϕ::Array{T,1}
    T::T
    TArray::Array{T,1}
    N::Integer
    dt::T
    # TODO we need to think about the internal time array here, step = dt instead of length?
    PWPulse(Ω, ϕ, T, N, dt) = new{Float64}(Ω, ϕ, T, collect(range(0, T, length = N)), N, dt)
end

function _pulse_t(p::BasicPulse, t)::Tuple{Float64,Float64}
    (p.Ω, p.ϕ)
    # p.Ω * exp(1im * p.ϕ)
end

function _pulse_t(p::PWPulse, t)::Tuple{Float64,Float64}
    idx = searchsortedlast(p.TArray, t)

    if idx == 0
        idx = 1
    end
    @inbounds (p.Ω[idx], p.ϕ[idx])
    # @inbounds p.Ω[idx] * exp(1im * p.ϕ[idx])
end


function get_length(p::BasicPulse)::Int64
    Int(floor(p.T/p.dt))
end

function get_length(p::PWPulse)::Int64
    p.N
end

function get_dt(p::Pulse)::Array{Float64,1}
    N = get_length(p)
    ones(N) .* p.dt
end

(c::BasicPulse)(t::Float64) = _pulse_t(c, t)
(c::PWPulse)(t::Float64) = _pulse_t(c, t)



"""
Sequence holds a list of pulses and other useful information to define a pulse sequence!
It's also possible to call (sequence(t)) to get back the value of the drive at that time
which makes visualising and simulation sequences much easier!
"""
struct Sequence
    pulses
    T_Array
    cum_T_Array
    duration
    function Sequence(pulseList)
        N = length(pulseList)
        TArray = zeros(N)
        for i=1:N
            TArray[i] = pulseList[i].T
        end
        cs = cumsum(TArray)
        prepend!(cs, 0.0)
        new(pulseList, TArray, cs ,sum(TArray))
    end
end

function _seq_t(c, t)::Tuple{Float64,Float64}
    ind = searchsortedlast(c.cum_T_Array, t)
    N = length(c.cum_T_Array)
    if ind >= N
        return (0.0, 0.0)
    elseif ind >= 2
        t = t - c.T_Array[ind - 1]
    end
    c.pulses[ind](t)
end

(c::Sequence)(t::Float64) = _seq_t(c, t)

