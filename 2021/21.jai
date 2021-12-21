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

    return tprint("%", part_1), "";
}