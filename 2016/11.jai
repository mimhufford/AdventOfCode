day11 :: (data: string) -> string, string
{
    state : u64;

    // todo: parse input
    table_add(*items, "ag", 0);  add(*state, 1, 0);
    table_add(*items, "ac", 1);  add(*state, 1, 1);
    table_add(*items, "bg", 2);  add(*state, 2, 2);
    table_add(*items, "cg", 3);  add(*state, 2, 3);
    table_add(*items, "dg", 4);  add(*state, 2, 4);
    table_add(*items, "eg", 5);  add(*state, 2, 5);
    table_add(*items, "bc", 6);  add(*state, 3, 6);
    table_add(*items, "cc", 7);  add(*state, 3, 7);
    table_add(*items, "dc", 8);  add(*state, 3, 8);
    table_add(*items, "ec", 9);  add(*state, 3, 9);
    floor(*state, 1);

    best := U64_MAX;

    solve(state, *best);

    return tprint("%", best), tprint("%", "");

    solve :: (s: u64, best: *u64, floor: u8 = 1, moves: u64 = 0)
    {
        if s >> 30 & 0b1111111111 == 0b1111111111 { if moves < <<best { <<best = moves; } return; }

        prev := table_find_pointer(seen, s);
        if prev && moves >= <<prev return;
        if prev { <<prev = moves; }
        else table_add(*seen, s, moves);
    }
}

items : Table(string, u8);
seen  : Table(u64, u64); // state -> fewest moves

print :: (s: u64)
{
    current_floor := s >> 40;
    floor_4 := s >> 30 & 0b1111111111;
    floor_3 := s >> 20 & 0b1111111111;
    floor_2 := s >> 10 & 0b1111111111;
    floor_1 := s >> 00 & 0b1111111111;
    print("4) % %\n", ifx current_floor == 4 then "=>" else "  ", formatInt(floor_4, base=2, minimum_digits=10));
    print("3) % %\n", ifx current_floor == 3 then "=>" else "  ", formatInt(floor_3, base=2, minimum_digits=10));
    print("2) % %\n", ifx current_floor == 2 then "=>" else "  ", formatInt(floor_2, base=2, minimum_digits=10));
    print("1) % %\n", ifx current_floor == 1 then "=>" else "  ", formatInt(floor_1, base=2, minimum_digits=10));
    print("\n");
}

floor :: (s: *u64, f: u64) { <<s &= 0b1111111111_1111111111_1111111111_1111111111; <<s |= f << 40; }
rem :: (s: *u64, f: u64, item: u64) { <<s &= (~cast(u64)1 << (item + 10*(f-1))); }
add :: (s: *u64, f: u64, item: u64) { <<s |=   cast(u64)1 << (item + 10*(f-1));  }
rem :: (s: *u64, f: u64, item: string) { rem(s, f, <<table_find_pointer(items, item)); }
add :: (s: *u64, f: u64, item: string) { add(s, f, <<table_find_pointer(items, item)); }
move :: (s: *u64, f_src: u64, f_dst: u64, item: string)
{
    index := table_find_pointer(items, item);
    rem(s, f_src, <<index);
    add(s, f_dst, <<index);
}

// state is a u64 containing the current floor and items for each floor
// |  cf  | | floor4 | | floor3 | | floor2 | | floor1 |
// 44444444 3333333333 2222222222 1111111111 0000000000
// 76543210 9876543210 9876543210 9876543210 9876543210