function prepare_sequence(sequence)
    N_list = [1]
    append!(N_list, [get_length(i) for i in sequence.pulses])
    totN = Int(sum(N_list) - 1)
    N_list = cumsum(N_list)
    ΩArr = zeros(totN)
    ϕArr = zeros(totN)
    dtArr = zeros(totN)

    for (i, p) in enumerate(sequence.pulses)
        pulse_t = range(0, p.T - p.dt, step=p.dt)
        N = get_length(p)
        D = p.(pulse_t)

        @views ΩArr[N_list[i]:N_list[i + 1] - 1] = [D[i][1] for i = 1:N]
        @views ϕArr[N_list[i]:N_list[i + 1] - 1] = [D[i][2] for i = 1:N]
        @views dtArr[N_list[i]:N_list[i + 1] - 1] = repeat([p.dt], N)
    end
    (ΩArr, ϕArr, dtArr)
end


