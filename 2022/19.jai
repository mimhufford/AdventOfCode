day19 :: (input: string) -> string, string
{
    blueprints := parse_blueprints(input);

    quality_total := 0;

    for * b: blueprints
    {
        state : State;

        // find out max costs, we don't need to make more robots for this type if we already collect this amount per minute
        b.max_ore_cost      = max(b.ore, b.clay, b.obsidian[0], b.geode[0]);
        b.max_clay_cost     = b.obsidian[1];
        b.max_obsidian_cost = b.geode[1];

        most_geodes := simulate(24, b, state);
        quality_total += most_geodes * (it_index + 1);

        print("%/% = %\n", it_index+1, blueprints.count, most_geodes);
    }

    return tprint("%", quality_total), tprint("%", "");
}

#scope_file

State :: struct
{
    minute         : u8;

    ore_count      : u8;
    clay_count     : u8;
    obsidian_count : u8;
    geode_count    : u8;

    // bot count for 24 minutes never exceeds 20
    // for 32 minutes it can only ever reach ~28
    // can compress these to only use 5 bits each
    // then the whole state can fit in a u64
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

simulate :: (limit: u8, b: *Blueprint, _state: State) -> u8
{
    using state := _state;

    // sanity check using u8s ===================
    if ore_count > 200 print("%\n", state);
    if clay_count > 200 print("%\n", state);
    if obsidian_count > 200 print("%\n", state);
    if geode_count > 200 print("%\n", state);
    // ==========================================

    if minute == limit return geode_count;

    minute += 1;

    // collect resources
    ore_count += ore_bots;
    clay_count += clay_bots;
    obsidian_count += obsidian_bots;
    geode_count += geode_bots;

    // simulate all possible buying paths / waiting a minute from here
    best_child := geode_count;

    // we're supposed to build using the resources at the start of the minute
    // so we have to subtract the current number of bots to negate the above addition
    if ore_bots < b.max_ore_cost && ore_count - ore_bots >= b.ore
    {
        next := state;
        next.ore_count -= b.ore;
        next.ore_bots += 1;
        best_child = max(best_child, simulate(limit, b, next));
    }

    if clay_bots < b.max_clay_cost && ore_count - ore_bots >= b.clay
    {
        next := state;
        next.ore_count -= b.clay;
        next.clay_bots += 1;
        best_child = max(best_child, simulate(limit, b, next));
    }

    if obsidian_bots < b.max_obsidian_cost && ore_count - ore_bots >= b.obsidian[0] && clay_count - clay_bots >= b.obsidian[1]
    {
        next := state;
        next.ore_count -= b.obsidian[0];
        next.clay_count -= b.obsidian[1];
        next.obsidian_bots += 1;
        best_child = max(best_child, simulate(limit, b, next));
    }

    if ore_count - ore_bots >= b.geode[0] && obsidian_count - obsidian_bots >= b.geode[1]
    {
        next := state;
        next.ore_count -= b.geode[0];
        next.obsidian_count -= b.geode[1];
        next.geode_bots += 1;
        best_child = max(best_child, simulate(limit, b, next));
    }

    return max(best_child, simulate(limit, b, state));
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