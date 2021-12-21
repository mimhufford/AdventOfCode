day21 :: (data : string) -> string, string
{
    p1_pos : u64 = data[28] - #char "0";
    p2_pos : u64 = data[58] - #char "0";
    p1_score : u64;
    p2_score : u64;
    die : u64 = 0;

    while p1_score < 1000 && p2_score < 1000
    {
        die += 3;

        total_roll := ((die + 0) * (die + 1) / 2) - ((die - 3) * (die - 2) / 2);

        p1_move : u64 = xx (((die-1) / 3) % 2 == 0);
        p2_move : u64 = xx (((die-1) / 3) % 2 != 0);

        p1_pos += p1_move * total_roll; p1_pos -= 1; p1_pos %= 10; p1_pos += 1;
        p2_pos += p2_move * total_roll; p2_pos -= 1; p2_pos %= 10; p2_pos += 1;

        p1_score += p1_pos * p1_move;
        p2_score += p2_pos * p2_move;
    }

    part_1 := min(p1_score, p2_score) * die;

    start_state : State;
    init(*seen, 32_000);
    start_state.p1_pos = data[28] - #char "0";
    start_state.p2_pos = data[58] - #char "0";

    part_2 := count_wins(start_state);

    return tprint("%", part_1), tprint("%", max(part_2[0], part_2[1]));
}

seen : Table(u32, [2]u64);

State :: struct
{
    p1_pos   : u8;
    p2_pos   : u8;
    p1_score : u8;
    p2_score : u8;

    #place p1_pos;
    hash : u32;
}

count_wins :: (_s: State) -> [2]u64
{
    if _s.p1_score >= 21 return .[1, 0];
    if _s.p2_score >= 21 return .[0, 1];

    result, found := table_find(seen, _s.hash);
    if found return result;

    wins : [2]u64;

    for d1: 1..cast(u8)3 for d2: 1..cast(u8)3 for d3: 1..cast(u8)3
    {
        s := _s;
        s.p1_pos += d1 + d2 + d3;
        s.p1_pos -= 1; s.p1_pos %= 10; s.p1_pos += 1;
        s.p1_score += s.p1_pos;
        s.p1_pos, s.p2_pos = swap(s.p1_pos, s.p2_pos);
        s.p1_score, s.p2_score = swap(s.p1_score, s.p2_score);
        sub_wins := count_wins(s);
        wins[0] += sub_wins[1];
        wins[1] += sub_wins[0];
    }
    
    table_add(*seen, _s.hash, wins);
    return wins;
}