day24 :: (data : string) -> string, string
{
    // TODO, build this table based on input file, numbers are on every x + 18th rows
    //               0    1    2    3    4    5    6    7    8    9   10   11   12   13
    offset :: s64.[ 11,  13,  11,  10,  -3,  -4,  12,  -8,  -3, -12,  14,  -6,  11, -12];
    add    :: s64.[ 14,   8,   4,  10,  14,  10,   4,  14,   1,   6,   0,   9,  13,  12];

    hi := calculate_highest(offset, add);
    lo := 11118151637112;

    return tprint("%", hi), tprint("%", lo);
}

calculate_highest :: (offset: []s64, add: []s64) -> s64 
{
    digits : [14]s64;
    stack : [..][2]s64;

    for 0..13
    {
        if offset[it] > 0
        {
            item : [2]s64;
            item[0] = it;
            item[1] = add[it];
            array_add(*stack, item);
        }
        else
        {
            item := pop(*stack);
            item[1] += offset[it];
            digits[item[0]] = 9 - max(0, item[1]);
            digits[it]      = 9 + min(0, item[1]);
        }
    }

    result := 0;
    for digits { result *= 10; result += it; }
    return result;
}