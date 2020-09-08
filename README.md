# NMRPulses

Few definitions and convenience functions to make life easier when dealing with NMR pulse sequences. Exports several common pulse definitions plus a sequence definition which makes it easier to write, use and visualise pulse sequences.

Has few dependencies.

```julia
using NMRPulses
using Plots

id = IdlePulse(1, 1e-3)
Ω = 2*pi
pi_2 = PiHalfPulse(Ω, 0, 1e-3)
pi_pulse = PiPulse(Ω, 0, 1e-3)

s = Sequence([pi_2, id, pi_pulse, id, pi_2])

a, b, c = prepare_sequence(s)
plot(cumsum(c), a, xlabel = "Time (us)", ylabel = "Rabi Frequency")

```
![Plot of pulse sequence](https://github.com/alastair-marshall/NMRPulses.jl/blob/master/assets/echo.png?raw=true "Pulse sequence")
