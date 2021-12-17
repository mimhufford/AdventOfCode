day14 :: (data: string) -> string, string
{
    while data.count
    {
        print("%", read_reindeer(*data));
    }

    return tprint("%", ""), tprint("%", "");
}

Reindeer :: struct
{
    name: string;
    speed: u64;
    time: u64;
    rest: u64;
}

read_reindeer :: (s: *string) -> Reindeer
{
    result: Reindeer;

    result.name.data = s.data;
    while s.data[0] != #char " "
    {  
        result.name.count += 1;
        advance(s, 1);
    }

    advance(s, 9);

    while s.data[0] >= #char "0" && s.data[0] <= #char "9"
    {
        result.speed *= 10;
        result.speed += s.data[0] - #char "0";
        advance(s, 1);
    }

    advance(s, 10);

    while s.data[0] >= #char "0" && s.data[0] <= #char "9"
    {
        result.time *= 10;
        result.time += s.data[0] - #char "0";
        advance(s, 1);
    }

    advance(s, 33);

    while s.data[0] >= #char "0" && s.data[0] <= #char "9"
    {
        result.rest *= 10;
        result.rest += s.data[0] - #char "0";
        advance(s, 1);
    }

    advance(s, 10);

    return result;
}