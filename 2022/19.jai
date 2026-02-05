day19 :: (input: string) -> string, string
{
    blueprints := parse_blueprints(input);

    first_3       := 1;
    quality_total := 0;

    for * b: blueprints
    {
        state : State;

        for * highest_geode_count_so_far { it.* = 0; }

        // find out max costs, we don't need to make more robots for this type if we already collect this amount per minute
        b.max_ore_cost      = max(b.ore, b.clay, b.obsidian[0], b.geode[0]);
        b.max_clay_cost     = b.obsidian[1];
        b.max_obsidian_cost = b.geode[1];

        most_geodes := simulate(24, b, state);
        quality_total += most_geodes * (it_index + 1);

        if it_index < 3 first_3 *= simulate(32, b, state);
    }

    return tprint("%", quality_total), tprint("%", first_3);
}

#scope_file

State :: struct
{
    ore_count      : u8;
    clay_count     : u8;
    obsidian_count : u8;
    geode_count    : u8;

    ore_bots       : u8 = 1;
    clay_bots      : u8;
    obsidian_bots  : u8;
    geode_bots     : u8;
}

Blueprint :: struct
{
    ore       : u8;
    clay      : u8;
    obsidian  : [2]u8;
    geode     : [2]u8;

    max_ore_cost      : u8;
    max_clay_cost     : u8;
    max_obsidian_cost : u8;
}

highest_geode_count_so_far : [32]u8;

tick :: (using s: *State)
{
    ore_count += ore_bots;
    clay_count += clay_bots;
    obsidian_count += obsidian_bots;
    geode_count += geode_bots;
}

simulate :: (t: u8, b: *Blueprint, s: State) -> u8
{
    if t == 0 return s.geode_count;

    // prune any branches where we have a lower geode count (with +1 tolerance)
    if s.geode_count + 1 < highest_geode_count_so_far[t-1] return s.geode_count;
    highest_geode_count_so_far[t-1] = max(highest_geode_count_so_far[t-1], s.geode_count);

    // prune any branches that couldn't possibly beat the best we've seen so far
    most : u8 = cast(u8)min(cast(u64)255, cast(u64)s.geode_count + cast(u64)s.geode_bots*cast(u64)t + (cast(u64)t * (cast(u64)t+1) / 2));
    if most <= highest_geode_count_so_far[0] return s.geode_count;

    // simulate all possible buying paths from current state
    best_child := s.geode_count;

    if s.obsidian_bots
    {
        using ns := s;
        nt := t;

        while nt > 0
        {
            nt -= 1;
            if ore_count >= b.geode[0] && obsidian_count >= b.geode[1]
            {
                tick(*ns);
                ore_count -= b.geode[0];
                obsidian_count -= b.geode[1];
                geode_bots += 1;
                best_child = max(best_child, simulate(nt, b, ns));
                break;
            }
            tick(*ns);
        }
    }

    if s.obsidian_bots < b.max_obsidian_cost && s.clay_bots
    {
        using ns := s;
        nt := t;

        while nt > 0
        {
            nt -= 1;
            if ore_count >= b.obsidian[0] && clay_count >= b.obsidian[1]
            {
                tick(*ns);
                ore_count -= b.obsidian[0];
                clay_count -= b.obsidian[1];
                obsidian_bots += 1;
                best_child = max(best_child, simulate(nt, b, ns));
                break;
            }
            tick(*ns);
        }
    }

    if s.clay_bots < b.max_clay_cost
    {
        using ns := s;
        nt := t;

        while nt > 0
        {
            nt -= 1;
            if ore_count >= b.clay
            {
                tick(*ns);
                ore_count -= b.clay;
                clay_bots += 1;
                best_child = max(best_child, simulate(nt, b, ns));
                break;
            }
            tick(*ns);
        }
    }

    if s.ore_bots < b.max_ore_cost
    {
        using ns := s;
        nt := t;

        while nt > 0
        {
            nt -= 1;
            if ore_count >= b.ore
            {
                tick(*ns);
                ore_count -= b.ore;
                ore_bots += 1;
                best_child = max(best_child, simulate(nt, b, ns));
                break;
            }
            tick(*ns);
        }
    }

    return best_child;
}

parse_blueprints :: (input: string) -> []Blueprint
{
    blueprints : [..]Blueprint;

    while input
    {
        b := array_add(*blueprints);
        for 1..6 read_word(*input);
        b.ore = read_u8(*input);
        for 1..5 read_word(*input);
        b.clay = read_u8(*input);
        for 1..5 read_word(*input);
        b.obsidian[0] = read_u8(*input);
        for 1..2 read_word(*input);
        b.obsidian[1] = read_u8(*input);
        for 1..5 read_word(*input);
        b.geode[0] = read_u8(*input);
        for 1..2 read_word(*input);
        b.geode[1] = read_u8(*input);
        skip_to_next_line(*input);
    }

    return blueprints;
}