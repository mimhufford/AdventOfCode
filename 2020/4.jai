day4 :: () -> string, string
{
    //byr (Birth Year)
    //iyr (Issue Year)
    //eyr (Expiration Year)
    //hgt (Height)
    //hcl (Hair Color)
    //ecl (Eye Color)
    //pid (Passport ID)
    //cid (Country ID)

    data := input(4);
    part1 := 0;

    for i: 0..data.count-1
    {
        keys := 0;

        while true
        {
            key : string = ---;
            key.data = *data[i];
            key.count = 3;

            if key == 
            {
                case "byr"; keys |= 1<<7;
                case "iyr"; keys |= 1<<6;
                case "eyr"; keys |= 1<<5;
                case "hgt"; keys |= 1<<4;
                case "hcl"; keys |= 1<<3;
                case "ecl"; keys |= 1<<2;
                case "pid"; keys |= 1<<1;
                case "cid"; keys |= 1<<0;
            }

            i += 3; // jump over key
            while i < data.count && data[i] != #char " " && data[i] != #char "\n" i += 1;
            i += 1; // jump over the separator we're currently on

            if (i >= data.count || data[i] == #char "\n") // end of passport
            {
                if keys >= 254 part1 += 1;
                break;
            }
        }
    }

    return tprint("%", part1), "";
}