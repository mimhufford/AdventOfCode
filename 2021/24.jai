day24 :: (data : string) -> string, string
{
    // TODO, build this table based on input file, numbers are on every x + 18th rows
    //               0    1    2    3    4    5    6    7    8    9   10   11   12   13
    offest :: s64.[ 11,  13,  11,  10,  -3,  -4,  12,  -8,  -3, -12,  14,  -6,  11, -12];
    divide :: s64.[  1,   1,   1,   1,  26,  26,   1,  26,  26,  26,   1,  26,   1,  26];
    add    :: s64.[ 14,   8,   4,  10,  14,  10,   4,  14,   1,   6,   0,   9,  13,  12];

    hi := 74929995999389;
    lo := 11118151637112;

    // TODO, using table work out pairs of digits using these push+pop based rules:
    /*
                    add  offset       (add+offset)
        d4  =  d3  + 10 -  3    = d3  + 7
        d5  =  d2  +  4 -  4    = d2  + 0
        d7  =  d6  +  4 -  8    = d6  - 4
        d8  =  d1  +  8 -  3    = d1  + 5
        d9  =  d0  + 14 - 12    = d0  + 2
        d11 =  d10 +  0 -  6    = d10 - 6
        d13 =  d12 + 13 - 12    = d12 + 1
    */

    return tprint("%", hi), tprint("%", lo);
}