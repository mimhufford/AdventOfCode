day19 :: (input: string) -> string, string
{
    blueprints := parse_blueprints(input);

    quality_total := 0;

    for blueprint: blueprints
    {
        state : State;
        
        // find out max costs, we don't need to make more robots for this type if we already collect this amount per minute
        state.max_ore_cost      = max(blueprint.ore, blueprint.clay, blueprint.obsidian[0], blueprint.geode[0]);
        state.max_clay_cost     = blueprint.obsidian[1];
        state.max_obsidian_cost = blueprint.geode[1];

        most_geodes := simulate(24, blueprint, state);
        quality_total += most_geodes * (it_index + 1);

        print("%/%\n", it_index+1, blueprints.count);
    }

    return tprint("%", quality_total), tprint("%", "");
}

#scope_file

State :: struct
{
    minute         : u8 = 1;

    ore_count      : s64;
    clay_count     : s64;
    obsidian_count : s64;
    geode_count    : s64;

    ore_bots       : u8 = 1;
    clay_bots      : u8;
    obsidian_bots  : u8;
    geode_bots     : u8;

    max_ore_cost      : u8;
    max_clay_cost     : u8;
    max_obsidian_cost : u8;
}

Blueprint :: struct
{
    ore       : u8;
    clay      : u8;
    obsidian  : [2]u8;
    geode     : [2]u8;
}

simulate :: (limit: u8, blueprint: Blueprint, _state: State) -> s64
{
    using state := _state;

    if minute == limit + 1 return geode_count;

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
    if ore_bots < max_ore_cost && ore_count - ore_bots >= blueprint.ore
    {
        next := state;
        next.ore_count -= blueprint.ore;
        next.ore_bots += 1;
        best_child = max(best_child, simulate(limit, blueprint, next));
    }

    if clay_bots < max_clay_cost && ore_count - ore_bots >= blueprint.clay
    {
        next := state;
        next.ore_count -= blueprint.clay;
        next.clay_bots += 1;
        best_child = max(best_child, simulate(limit, blueprint, next));
    }

    if obsidian_bots < max_obsidian_cost && ore_count - ore_bots >= blueprint.obsidian[0] && clay_count - clay_bots >= blueprint.obsidian[1]
    {
        next := state;
        next.ore_count -= blueprint.obsidian[0];
        next.clay_count -= blueprint.obsidian[1];
        next.obsidian_bots += 1;
        best_child = max(best_child, simulate(limit, blueprint, next));
    }

    if ore_count - ore_bots >= blueprint.geode[0] && obsidian_count - obsidian_bots >= blueprint.geode[1]
    {
        next := state;
        next.ore_count -= blueprint.geode[0];
        next.obsidian_count -= blueprint.geode[1];
        next.geode_bots += 1;
        best_child = max(best_child, simulate(limit, blueprint, next));
    }

    return max(best_child, simulate(limit, blueprint, state));
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