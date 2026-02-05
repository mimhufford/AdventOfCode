day2 :: (data: string) -> string, string
{
    valid_passwords_rule_1 := 0;
    valid_passwords_rule_2 := 0;

    for i : 0..data.count-1
    {
        min := 0;
        while #char "0" <= data[i] && data[i] <= #char "9"
        {
            min = min * 10 + data[i] - #char "0";
            i += 1;
        } 

        i += 1; // skip the -

        max := 0;
        while #char "0" <= data[i] && data[i] <= #char "9"
        {
            max = max * 10 + data[i] - #char "0";
            i += 1;
        } 

        i += 1; // skip the space

        chr := data[i];

        i += 3; // skip the chr:space

        if (data[i+min-1] == chr) ^ (data[i+max-1] == chr)
        {
            valid_passwords_rule_2 += 1;
        } 

        count := 0;

        while i < data.count && data[i] != #char "\n"
        {
            if data[i] == chr
            {
                count += 1;
            } 

            i += 1;
        }

        if min <= count && count <= max
        {
            valid_passwords_rule_1 += 1;
        }
    }

    return tprint("%", valid_passwords_rule_1), tprint("%", valid_passwords_rule_2);
}