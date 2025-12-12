day12 :: (input: string) -> string, string
{
    part1 : s64;
    shapes : [6]s64;

    for * shapes {
        advance(*input, 3);
        
        while input[0] != "\n" {
            if input[0] == "#" then it.* += 1;
            advance(*input);
            if input[0] == "\n" advance(*input);
        }

        advance(*input);
    }

    while input {
        w := read_s64(*read_up_to(*input, "x"));
        advance(*input);
        h := read_s64(*read_up_to(*input, ":"));
        advance(*input, 2);

        required := 0;
        for shapes required += it * read_s64(*input);
        if required > w*h continue;
        part1 += 1;
    }

    return tprint("%", part1), ":)";
}