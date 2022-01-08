day1 :: (data: string) -> string, string
{
    part_1, part_2 := 0;

    for 0..data.count-2
    {
        if data[it] == data[(it+1)            % (data.count-1)] part_1 += data[it] - #char "0";
        if data[it] == data[(it+data.count/2) % (data.count-1)] part_2 += data[it] - #char "0";
    }

    return tprint("%", part_1), tprint("%", part_2);
}