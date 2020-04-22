hash_v2 :: (v2 : Vector2) -> u32 {
    return xx (v2.x * 10000 + v2.y);
}

compare_v2 :: (a: Vector2, b: Vector2) -> bool {
    return a.x == b.x && a.y == b.y;
}

Day3 :: () {
    input := read_entire_file("input/3.txt");

    houses : Table(Vector2, int, hash_v2, compare_v2);

    pos : Vector2;

    table_add(*houses, pos, 1);

    for 0..input.count-1 {
        if      input[it] == #char "^"  pos.y += 1;
        else if input[it] == #char "<"  pos.x -= 1;
        else if input[it] == #char ">"  pos.x += 1;
        else                            pos.y -= 1;

        visits := table_find_pointer(houses, pos);
        if visits table_set(*houses, pos, <<visits + 1);
        else      table_add(*houses, pos, 1);
    }

    print("Day 03: Part 1: %\n", houses.count);
}