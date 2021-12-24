day24 :: (data : string) -> string, string
{
    a : [..]s64;
    b : [..]s64;

    lines := split(data, "\n");
    for lines
    {
        if it_index % 18 ==  5 { advance(*it, 6); array_add(*a, string_to_int(it)); } 
        if it_index % 18 == 15 { advance(*it, 6); array_add(*b, string_to_int(it)); } 
    }

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