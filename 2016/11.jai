day11 :: (data: string) -> string, string
{
    state : State;

    // todo: parse input
    array_add(*index_to_item, "ag"); add(*state, 0, 0);
    array_add(*index_to_item, "ac"); add(*state, 0, 1);
    array_add(*index_to_item, "bg"); add(*state, 1, 2);
    array_add(*index_to_item, "cg"); add(*state, 1, 3);
    array_add(*index_to_item, "dg"); add(*state, 1, 4);
    array_add(*index_to_item, "eg"); add(*state, 1, 5);
    array_add(*index_to_item, "bc"); add(*state, 2, 6);
    array_add(*index_to_item, "cc"); add(*state, 2, 7);
    array_add(*index_to_item, "dc"); add(*state, 2, 8);
    array_add(*index_to_item, "ec"); add(*state, 2, 9);

    best := U64_MAX;

    solve(state, *best);

    return tprint("%", best), tprint("%", "");

    solve :: (s: State, best: *u64, current_floor: u8 = 0, moves: u64 = 0)
    {
        // if floor 4 has all the items, maybe update best, and stop
        if s.floor[0] == 0 && s.floor[1] == 0 && s.floor[2] == 0
        {
            if <<best > moves
            {
                <<best = moves;
            }
            return;
        } 

        compressed_state, is_valid := generate_seen_state(s, current_floor);

        if !is_valid return;

        prev := table_find_pointer(seen, compressed_state);

        // if seen this state before and we're at more moves, stop
        if prev && <<prev <= moves return;

        // update seen states with new info
        if prev { <<prev = moves; }
        else table_add(*seen, compressed_state, moves);

        // calculate all possible combos of moving 2 or 1 items up and recurse
        if current_floor < 3
        {
            for i: 0..index_to_item.count-1 for j: i+1..index_to_item.count-1
            {
                if s.floor[current_floor] & (1 << i) && s.floor[current_floor] & (1 << j)
                {
                    ns := s;
                    mov(*ns, current_floor, current_floor + 1, xx i);
                    mov(*ns, current_floor, current_floor + 1, xx j);
                    solve(ns, best, current_floor + 1, moves + 1);
                }
            }

            for i: 0..index_to_item.count-1
            {
                if s.floor[current_floor] & (1 << i)    
                {
                    ns := s;
                    mov(*ns, current_floor, current_floor + 1, xx i);
                    solve(ns, best, current_floor + 1, moves + 1);
                }
            } 
        }

        // calculate all possible combos of taking 1 item down and recurse
        if current_floor > 0
        {
            for i: 0..index_to_item.count-1
            {
                if s.floor[current_floor] & (1 << i)
                {
                    ns := s;
                    mov(*ns, current_floor, current_floor - 1, xx i);
                    solve(ns, best, current_floor - 1, moves + 1);
                }
            }
        }
    }
}

index_to_item : [..]string;
seen : Table(u64, u64); // state -> fewest moves

// u64 seen state stores: the current floor, the number of pairs on each floor,
//                        the number of lone generators on each floor,
//                        and the number of lone chips on each floor
//
//                           |cf|f3p|f3g|f3c|f2p|f2g|f2c|f1p|f1g|f1c|f0p|f0g|f0c
// 66665555555555444444444433|33|333|333|222|222|222|211|111|111|110|000|000|000
// 32109876543210987654321098|76|543|210|987|654|321|098|765|432|109|876|543|210

rem :: (s: *State, f: u64, item: u64) { s.floor[f] &= ~cast(u16)1 << item; }
add :: (s: *State, f: u64, item: u64) { s.floor[f] |=  cast(u16)1 << item; }
mov :: (s: *State, f_src: u64, f_dst: u64, item: u64) { rem(s, f_src, item); add(s, f_dst, item); }

State :: struct
{
    floor: [4]u16;
}

generate_seen_state :: (s: State, current_floor: u8) -> u64, bool
{
    valid := true;
    state : u64;
    state |= (cast(u64)current_floor) << 36;

    for f: 0..3
    {
        pairs: u64;

        // todo: this but without allocating arrays
        chips: [..]string;
        generators: [..]string;
        defer array_free(generators);
        defer array_free(chips);

        for i: 0..index_to_item.count-1
        {
            if s.floor[f] & (1 << i)
            {
                item := index_to_item[i];
                if item[1] == #char "g" array_add(*generators, item);
                else                    array_add(*chips, item);
            }
        }

        for c: chips
        {
            for g: generators
            {
                if c[0] == g[0]
                {
                    pairs += 1;
                    remove c;
                    remove g;
                    continue c;
                }
            }
        }

        if chips.count && (generators.count || pairs)
        {
            valid = false;
        }

        state |=                       pairs << (6+f*9);
        state |= (cast(u64)generators.count) << (3+f*9);
        state |=      (cast(u64)chips.count) << (0+f*9);
    }

    return state, valid;
}

print :: (s: State)
{
    for < 3..0 print("% %\n", it, formatInt(s.floor[it], base=2, minimum_digits=index_to_item.count));
    print("\n");
}