day21 :: (data: string) -> string, string
{
    advance(*data, 12);
    hp := next_s64(*data);
    damage := next_s64(*data);
    armour := next_s64(*data);

    return tprint("%", ""), tprint("%", "");
}