day24 :: (data : string) -> string, string
{
    // TODO, build this table based on input file, numbers are on every x + 18th rows
    a :: s64.[ 11,  13,  11,  10,  -3,  -4,  12,  -8,  -3, -12,  14,  -6,  11, -12];
    b :: s64.[ 14,   8,   4,  10,  14,  10,   4,  14,   1,   6,   0,   9,  13,  12];

    hi := calculate_highest(a, b);
    lo := calculate_lowest (a, b);

    return tprint("%", hi), tprint("%", lo);
}

calculate_highest :: (a, b) => calculate(a, b, false);
calculate_lowest  :: (a, b) => calculate(a, b, true);

calculate :: (a: []s64, b: []s64, minimise: bool) -> s64 
{
    digits : [14]s64;
    stack : [..][2]s64;

    for 0..13
    {
        if a[it] > 0
        {
            item : [2]s64;
            item[0] = it;
            item[1] = b[it];
            array_add(*stack, item);
        }
        else
        {
            item := pop(*stack);
            item[1] += a[it];

            if minimise
            {
                digits[item[0]] = 1 - min(0, item[1]);
                digits[it]      = 1 + max(0, item[1]);
            }
            else
            {
                digits[item[0]] = 9 - max(0, item[1]);
                digits[it]      = 9 + min(0, item[1]);
            }
        }
    }

    result := 0;
    for digits { result *= 10; result += it; }
    return result;
}