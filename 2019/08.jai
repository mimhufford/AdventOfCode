day8 :: (input: string) -> string, string
{
    image : [6*25]u8;
    for * image it.* = 2;
    fewest_zeroes := S64_MAX;
    part1 := 0;

    for layer: 1..S64_MAX {
        count : [3]s64;
        for * image {
            count[input[0] - "0"] += 1;
            if it.* == 2 then it.* = input[0] - "0";
            advance(*input);
        }
        if count[0] < fewest_zeroes {
            fewest_zeroes = count[0];
            part1 = count[1] * count[2];
        }
        if input[0] == "\n" break;
    }

    // for y: 0..5 {
    //     for x: 0..24 {
    //         if image[y * 25 + x] == 0 print(" ");
    //         if image[y * 25 + x] == 1 print("#");
    //     }
    //     print("\n");
    // }

    part2 := "BCPZB";

    return tprint("%", part1), part2;
}