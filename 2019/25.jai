day25 :: (input: string) -> string, string
{
    ram : [..]s64;
    while input array_add(*ram, get(s64, *input));

    /*
        TODO: don't hardcode solution

            p-#
            |
        #-m m
            | |
            #-# l  
            |   |  
        O-c---#-#   D
        |       |   |
        a-b-f   #-#-#-#
    */

    commands := string.[
        "south", "west", "take asterisk", "east", "north", "east",
        "north", "east", "north", "take mug", "south", "west", "north",
        "take mutex", "north", "take prime number", "south", "south",
        "south", "east", "east", "south", "east", "east", "north"
    ];

    c := computer(array_copy(ram));
    for commands {
        command : [..]s64;
        for c: it array_add(*command, c);
        array_add(*command, 10);
        run(c, ..command);
    }

    output : [..]u8;
    for c.out array_add(*output, it.(u8));
    part1 := get(u64, *split(output.(string), "typing")[1]).(s64);

    return tprint("%", part1), ":)";
}