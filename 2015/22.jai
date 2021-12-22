day22 :: (data: string) -> string, string
{
    advance(*data, 12);
    bh := next_s8(*data);
    bd := next_s16(*data);

    initial_state : State;
    initial_state.ph = 50;
    initial_state.pm = 500;
    initial_state.bh = bh;
    
    play_game(initial_state, bd);

    return tprint("%", ""), tprint("%", "");
}

play_game :: (s: State, bd: s16) -> bool
{
    // must do a spell every turn
    // not enough mana = lose
    return false;
}

State :: struct
{
    ph : s16;
    pm : s16;
    bh : s8;
    e1 : u8;
    e2 : u8;
    e3 : u8;
    
    #place ph;
    hash : u64;
}

Spell  :: struct { cost: s16; damage: s16; heal: s16; ticks: s16; armour: s16; tick_damage: s16; tick_mana: s16; }
spells :: Spell.[ .{ 53, 4, 0, 0, 0, 0, 0}, .{ 73, 2, 2, 0, 0, 0, 0}, .{ 113,0, 0, 6, 7, 0, 0}, .{ 173,0, 0, 6, 0, 3, 0}, .{ 229,0, 0, 5, 0, 0, 101} ];