day11 :: (data: string) -> string, string
{
    state : u64;

    // todo: parse input
    table_add(*item_to_index, "ag", 0); array_add(*index_to_item, "ag"); add(*state, 1, 0);
    table_add(*item_to_index, "ac", 1); array_add(*index_to_item, "ac"); add(*state, 1, 1);
    table_add(*item_to_index, "bg", 2); array_add(*index_to_item, "bg"); add(*state, 2, 2);
    table_add(*item_to_index, "cg", 3); array_add(*index_to_item, "cg"); add(*state, 2, 3);
    table_add(*item_to_index, "dg", 4); array_add(*index_to_item, "dg"); add(*state, 2, 4);
    table_add(*item_to_index, "eg", 5); array_add(*index_to_item, "eg"); add(*state, 2, 5);
    table_add(*item_to_index, "bc", 6); array_add(*index_to_item, "bc"); add(*state, 3, 6);
    table_add(*item_to_index, "cc", 7); array_add(*index_to_item, "cc"); add(*state, 3, 7);
    table_add(*item_to_index, "dc", 8); array_add(*index_to_item, "dc"); add(*state, 3, 8);
    table_add(*item_to_index, "ec", 9); array_add(*index_to_item, "ec"); add(*state, 3, 9);
    floor(*state, 1);

    best := U64_MAX;

    solve(state, *best);

    return tprint("%", best), tprint("%", "");

    solve :: (s: u64, best: *u64, moves: u64 = 0)
    {
        if s >> 30 & 0b1111111111 == 0b1111111111 { print(s); if moves < <<best { <<best = moves; } return; }

        prev := table_find_pointer(seen, s);
        if prev && moves >= <<prev return;
        if prev { <<prev = moves; }
        else table_add(*seen, s, moves);

        current_floor : u64 = s >> 40;
        current_items : u64 = s >> ((current_floor-1)*10) & 0b1111111111;
        items : [..]string; // todo: memory shite
        for 0..9 if current_items & (cast(u64)1 << it) array_add(*items, index_to_item[it]);

        // take individual items to different floors
        for items
        {
            if current_floor < 4
            {
                ns := s;
                move(*ns, current_floor, current_floor + 1, it);
                floor(*ns, current_floor + 1);
                solve(ns, best, moves + 1);
            }
            if current_floor > 1
            {
                ns := s;
                move(*ns, current_floor, current_floor - 1, it);
                floor(*ns, current_floor - 1);
                solve(ns, best, moves + 1);
            }
        }

        // todo: take pairs of items to different floors
    }
}

item_to_index : Table(string, u8);
index_to_item : [..]string;
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
rem :: (s: *u64, f: u64, item: string) { rem(s, f, <<table_find_pointer(item_to_index, item)); }
add :: (s: *u64, f: u64, item: string) { add(s, f, <<table_find_pointer(item_to_index, item)); }
move :: (s: *u64, f_src: u64, f_dst: u64, item: string)
{
    index := table_find_pointer(item_to_index, item);
    rem(s, f_src, <<index);
    add(s, f_dst, <<index);
}

// state is a u64 containing the current floor and items for each floor
// |  08  | |   10   | |   10   | |   10   | |   10   |
// |  cf  | | floor4 | | floor3 | | floor2 | | floor1 |
// 44444444 3333333333 2222222222 1111111111 0000000000
// 76543210 9876543210 9876543210 9876543210 9876543210