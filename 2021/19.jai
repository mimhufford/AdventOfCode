day19 :: (data : string) -> string, string
{
    scanners: [..]Scanner;

    while data.count array_add(*scanners, read_scanner(*data));
    
    return tprint("%", ""), tprint("%", "");
}

Scanner :: struct
{
    id  : int;
    pos : Vector3;
    dir : Vector3;
    up  : Vector3;
    beacons : [..]Vector3;
}

read_scanner :: (s: *string) -> Scanner
{
    scanner : Scanner;

    while s.data[0] != #char "\n" advance(s, 1);
    advance(s, 1);

    while s.count && s.data[0] != #char "\n"
    {
        array_add(*scanner.beacons, make_vector3(read_num(), read_num(), read_num()));
    }

    if s.count advance(s, 1);

    return scanner;

    read_num :: () -> float #expand
    {
        num : float;
        neg := false;
        
        if s.data[0] == #char "-"
        {
            neg = true;
            advance(s, 1);
        }

        while s.data[0] >= #char "0" && s.data[0] <= #char "9"
        {
            num *= 10;
            num += s.data[0] - #char "0";
            advance(s, 1);
        }

        advance(s, 1);

        return ifx neg then -num else num;
    }
}