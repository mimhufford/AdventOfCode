day2 :: (input: string) -> string, string
{
    score_p1 := 0;
    score_p2 := 0;

    while input.count
    {
        op := read_word(*input)[0] - #char "A" + 1;
        me := read_word(*input)[0] - #char "X" + 1;

        score_p1 += me;

        if      me == op           score_p1 += 3;
        else if me == 1 && op == 3 score_p1 += 6;
        else if me == 2 && op == 1 score_p1 += 6;
        else if me == 3 && op == 2 score_p1 += 6;

        if      me == 2            score_p2 += op + 3;
        else if me == 1 && op == 1 score_p2 += 3;
        else if me == 1 && op == 2 score_p2 += 1;
        else if me == 1 && op == 3 score_p2 += 2;
        else if me == 3 && op == 1 score_p2 += 2 + 6;
        else if me == 3 && op == 2 score_p2 += 3 + 6;
        else if me == 3 && op == 3 score_p2 += 1 + 6;
    }

    return tprint("%", score_p1), tprint("%", score_p2);
}