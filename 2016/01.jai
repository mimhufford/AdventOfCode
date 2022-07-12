day1 :: (data: string) -> string, string
{
    dir :: ([2]int).[.[0,1],.[1,0],.[0,-1],.[-1,0]];

    seen : Table(s64, u8);
    x, y, d, first_dup := 0;

    while data.count
    {
        if data[0] == #char "L"  { d += 3; d %= 4; }
        else                     { d += 1; d %= 4; }

        advance(*data, 1);
        
        dist := 0;
        
        while data[0] >= #char "0" && data[0] <= #char "9"
        {
            dist *= 10;
            dist += data[0] - #char "0";
            advance(*data, 1);
        }
        
        for 1..dist
        {
            x += dir[d][0];
            y += dir[d][1];

            hash := (10000+x)<<32 | (10000+y); // offset to avoid dealing with shifting the negative bit
            if !first_dup && table_find_pointer(*seen, hash) first_dup = x + y;
            else table_add(*seen, hash, 0);
        }

        if data.count advance(*data, 1);
        if data.count advance(*data, 1);
    }

    return tprint("%", x + y), tprint("%", first_dup);
}