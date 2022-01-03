day10 :: (data: string) -> string, string
{
    bots : [256][..]int;
    outputs : [32]int;
    moves : [..][5]int; // src_bot_id, lo_bot_id, hi_bot_id, lo_output_id, hi_output_id

    lines := split(data, "\n");
    lines.count -= 1;

    for line: lines
    {
        if line[0] == #char "b"
        {
            move := int.[-1, -1, -1, -1, -1];

            advance(*line, 4);
            move[0] = read_num(*line);
            advance(*line, 14);

            if line[0] == #char "b"
            {
                advance(*line, 4);
                move[1] = read_num(*line);
            }
            else // output
            {
                advance(*line, 7);
                move[3] = read_num(*line);
            }
            advance(*line, 13);

            if line[0] == #char "b"
            {
                advance(*line, 4);
                move[2] = read_num(*line);
            }
            else // output
            {
                advance(*line, 7);
                move[4] = read_num(*line);
            }

            array_add(*moves, move);
        }
        else // value to bot
        {
            advance(*line, 6);
            value := read_num(*line);
            advance(*line, 13);
            bot_id := read_num(*line);
            array_add(*bots[bot_id], value);
        }
    }

    part_1 := 0;

    while moves.count
    {
        for move: moves
        {
            if bots[move[0]].count == 2
            {
                lo, hi := bots[move[0]][0], bots[move[0]][1];
                if lo > hi Swap(*lo, *hi);
                if lo == 17 && hi == 61 part_1 = move[0];
                if move[1] >= 0 array_add(*bots[move[1]], lo); else outputs[move[3]] = lo;
                if move[2] >= 0 array_add(*bots[move[2]], hi); else outputs[move[4]] = hi;
                bots[move[0]].count = 0;
                remove move;
            }
        }
    }

    return tprint("%", part_1), tprint("%", outputs[0]*outputs[1]*outputs[2]);

    read_num :: (s: *string) -> int
    {
        num := 0;

        while s.data[0] >= #char "0" && s.data[0] <= #char "9"
        {
            num *= 10;
            num += s.data[0] - #char "0";
            advance(s, 1);
        }

        return num;
    }
}