day2 :: (data: string) -> string, string
{
    horizontal, depth1, depth2, aim : u32;

    while data
    {
        dir, amt := next_instruction(*data);
        
        if dir == {
            case #char "u"; depth1 -= amt; aim -= amt;
            case #char "d"; depth1 += amt; aim += amt;
            case #char "f"; horizontal += amt; depth2 += aim * amt;
        }
    }

    return tprint("%", horizontal * depth1), tprint("%", horizontal * depth2);
}

next_instruction :: (s: *string) -> dir: u8, amt: u8
{
    dir := s.data[0];

    if dir == {
        case #char "u"; advance(s, 3);
        case #char "d"; advance(s, 5);
        case #char "f"; advance(s, 8);
    }

    amt := s.data[0] - #char "0";

    advance(s, 1);

    return dir, amt;
}