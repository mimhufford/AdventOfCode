day4 :: () -> string, string
{
    data := input(4);
    part1, part2 := 0, 0;

    for i: 0..data.count-1
    {
        keys, values := 0, 0;

        while true
        {
            key : string = ---;
            key.data = *data[i];
            key.count = 3;

            if key == 
            {
                case "byr";
                    keys |= 1<<7;
                    value := 0;
                    i += 4;
                    for 1..4
                    {
                        value *= 10;
                        value += data[i] - #char "0";
                        i += 1;
                    }
                    if 1920 <= value && value <= 2002 values |= 1<<7;
                case "iyr";
                    keys |= 1<<6;
                    value := 0;
                    i += 4;
                    for 1..4
                    {
                        value *= 10;
                        value += data[i] - #char "0";
                        i += 1;
                    }
                    if 2010 <= value && value <= 2020 values |= 1<<6;
                case "eyr";
                    keys |= 1<<5;
                    value := 0;
                    i += 4;
                    for 1..4
                    {
                        value *= 10;
                        value += data[i] - #char "0";
                        i += 1;
                    }
                    if 2020 <= value && value <= 2030 values |= 1<<5;
                case "hgt";
                    keys |= 1<<4;
                    value := 0;
                    unit : string;
                    i += 4;
                    while #char "0" <= data[i] && data[i] <= #char "9"
                    {
                        value *= 10;
                        value += data[i] - #char "0";
                        i += 1;
                    }
                    if data[i] == #char "c" && 150 <= value && value <= 193 values |= 1<<4;
                    if data[i] == #char "i" && 59 <= value && value <= 76 values |= 1<<4;
                    while i < data.count && data[i] != #char " " && data[i] != #char "\n" i += 1;
                case "hcl";
                    keys |= 1<<3;
                    i += 4;
                    if data[i] == #char "#"
                    {
                        i += 1;
                        problem := false;

                        for 1..6
                        {
                            if !(#char "0" <= data[i] && data[i] <= #char "9" ||
                                 #char "a" <= data[i] && data[i] <= #char "f")
                                problem = true;
                            i += 1;
                        }

                        if !problem values |= 1<<3;
                    }
                    while i < data.count && data[i] != #char " " && data[i] != #char "\n" i += 1;
                case "ecl";
                    keys |= 1<<2;
                    i += 4;
                    value : string = ---;
                    value.count = 3;
                    value.data = *data[i];
                    i += 3;
                    if value ==
                    {
                        case "amb"; #through;
                        case "blu"; #through;
                        case "brn"; #through;
                        case "gry"; #through;
                        case "grn"; #through;
                        case "hzl"; #through;
                        case "oth"; values |= 1<<2;
                    }
                    while i < data.count && data[i] != #char " " && data[i] != #char "\n" i += 1;
                case "pid";
                    keys |= 1<<1;
                    i += 4;
                    value: string = ---;
                    value.count = 9;
                    value.data = *data[i];
                    problem := false;
                    for 0..8 if #char "0" > value[it] || value[it] > #char "9" problem = true;
                    if !problem values |= 1<<1;
                    while i < data.count && data[i] != #char " " && data[i] != #char "\n" i += 1;
                case "cid"; 
                    i += 4;
                    while i < data.count && data[i] != #char " " && data[i] != #char "\n" i += 1;
            }

            i += 1; // jump over the separator we're currently on

            if (i >= data.count || data[i] == #char "\n") // end of passport
            {
                if keys >= 254 part1 += 1;
                // TODO: part2 too high
                if values >= 254 part2 += 1;
                break;
            }
        }
    }

    return tprint("%", part1), tprint("%", part2);
}