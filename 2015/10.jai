day10 :: (data: string) -> string, string
{
    seq : [..]u16;

    while data.count && data[0] != #char "\n"
    {
        array_add(*seq, data[0] - #char "0");
        advance(*data, 1);
    }

    for 1..40 evolve(); part_1 := seq.count;
    for 1..10 evolve(); part_2 := seq.count;

    return tprint("%", part_1), tprint("%", part_2);
}

evolve :: () #expand
{
    new_seq : [..]u16;
    
    while `seq.count
    {
        num := `seq[0];
        count : u16 = 1;
        `seq.data += 1;
        `seq.count -= 1;
        while `seq.count && `seq[0] == num
        {
            count += 1;
            `seq.data += 1;
            `seq.count -= 1;
        }
        array_add(*new_seq, count);
        array_add(*new_seq, num);
    }

    `seq = new_seq;
}