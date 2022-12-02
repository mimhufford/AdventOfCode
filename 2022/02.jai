day2 :: (input: string) -> string, string
{
    score_p1 := 0;
    score_p2 := 0;
    win_lut  :: u8.[0, 3, 1, 2];
    lose_lut :: u8.[0, 2, 3, 1];

    while input.count
    {
        op := read_word(*input)[0] - #char "A" + 1;
        me := read_word(*input)[0] - #char "X" + 1;

        score_p1 += me;

        if      me == op           score_p1 += 3;
        else if win_lut[me] == op  score_p1 += 6;

        if      me == 2  score_p2 += op + 3;
        else if me == 1  score_p2 += win_lut[op];
        else if me == 3  score_p2 += lose_lut[op] + 6;
    }

    return tprint("%", score_p1), tprint("%", score_p2);
}