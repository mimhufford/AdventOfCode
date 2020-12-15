day15 :: (input: string) -> string, string
{
    memory: [2020]u16;
    count : [2020]u16;
    index: u16;

    while input.count
    {
        num := read_number(*input);
        memory[index] = num;
        count[num] += 1;
        index += 1;
    }

    while index < 2020
    {
        last := memory[index-1];
        if count[last] == 1
        {
            memory[index] = 0;
            count[0] += 1;
        } 
        else
        {
            gap : u16 = 2;
            while memory[index - gap] != last gap += 1;
            gap -= 1;
            memory[index] = gap;
            count[gap] += 1;
        } 
        index += 1;
    }

    return tprint("%", memory[2020-1]), "";
}

#scope_file

read_number :: (s: *string) -> u16
{
    num: u16;

    while s.count && s.data[0] >= #char "0" && s.data[0] <= #char "9"
    {
        num *= 10;
        num += s.data[0] - #char "0";
        advance(s);
    }

    if s.count advance(s);

    return num;
}