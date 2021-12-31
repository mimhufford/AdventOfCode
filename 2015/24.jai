day24 :: (data: string) -> string, string
{
    weights : [..]u64;
    while data.count array_add(*weights, next_u64(*data));
    total : u64 = 0; for weights total += it;
    goal_3, goal_4 := total/3, total/4;
    best_3, best_4 := U64_MAX;

    for combinations(weights)
    {
        weight_footwell : u64 = 0;
        quantum_entanglement : u64 = 1;

        for weight: it
        {
            weight_footwell += weight;
            quantum_entanglement *= weight;

            if weight_footwell > goal_3 break;
            if weight_footwell == goal_4 && quantum_entanglement < best_4 { best_4 = quantum_entanglement;        }
            if weight_footwell == goal_3 && quantum_entanglement < best_3 { best_3 = quantum_entanglement; break; }
        }
    }

    return tprint("%", best_3), tprint("%", best_4);
}

#scope_file

combinations :: (n: []u64) -> Combination_For
{
    cf: Combination_For;
    cf.n = n;
    return cf;
}

Combination_For :: struct
{
    n: []u64;
}

for_expansion :: (cf: *Combination_For, body: Code, flags: For_Flags) #expand
{
    `it : [..]u64;
    `it_index := 0;

    for binary: 1..1<<cf.n.count-1
    {
        if popcount(binary) > 6 continue;

        `it.count = 0;

        for bit: 0..cf.n.count-1
        {
            if 1<<bit & binary
            {
                array_add(*`it, cf.n[bit]);
            }
        }

        `it_index = binary;
        #insert body;
    }
}