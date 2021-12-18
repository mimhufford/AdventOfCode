day20 :: (data: string) -> string, string
{
    min_presents :: 36000000;

    house_num := 1;

    while true
    {
        presents := 0;

        for i: 1..cast(int)(sqrt(cast(float)house_num))
        {
            if house_num % i != 0 continue;
            presents += i*10;
            if house_num / i != i presents += (house_num/i*10);
            if presents >= min_presents break;
        }
        
        if presents >= min_presents break;

        house_num += 1;
    }

    return tprint("%", house_num), tprint("%", "");
}