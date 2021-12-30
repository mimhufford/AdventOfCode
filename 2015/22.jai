day22 :: (data: string) -> string, string
{
    advance(*data, 12);
    boss_health := next_u8(*data);
    boss_damage := next_s16(*data);

    initial_state : State;
    initial_state.health = 50;
    initial_state.mana = 500;
    initial_state.boss = xx boss_health;

    play_game(initial_state, boss_damage);

    // 1507 too low

    return tprint("%", best), tprint("%", "");
}

best := S64_MAX;

play_game :: (s: State, boss_damage: s16, spent: s64 = 0)
{
    armour : s16 = 0;

    ns := s;

    if ns.e1 { armour = 7;      ns.e1 -= 1; }
    if ns.e2 { ns.boss -= 3;    ns.e2 -= 1; }
    if ns.e3 { ns.mana += 101;  ns.e3 -= 1; }

    if ns.boss <= 0
    {
        if spent < best
        {
            print("%\n", spent);
            best = spent;
        } 
    }
    if ns.health <= 0  return;

    if ns.mana >= 53
    {
        nns := ns;
        nns.boss -= 4;
        nns.mana -= 53;
        if nns.e1 { armour = 7;       nns.e1 -= 1; }
        if nns.e2 { nns.boss -= 3;    nns.e2 -= 1; }
        if nns.e3 { nns.mana += 101;  nns.e3 -= 1; }
        nns.health -= boss_damage - armour;
        play_game(nns, boss_damage, 53 + spent);
    }
    if ns.mana >= 73
    {
        nns := ns;
        nns.boss -= 2;
        nns.mana -= 73;
        nns.health += 2;
        if nns.e1 { armour = 7;       nns.e1 -= 1; }
        if nns.e2 { nns.boss -= 3;    nns.e2 -= 1; }
        if nns.e3 { nns.mana += 101;  nns.e3 -= 1; }
        nns.health -= boss_damage - armour;
        play_game(nns, boss_damage, 73 + spent);
    }
    if ns.mana >= 113 && ns.e1 == 0
    {
        nns := ns;
        nns.mana -= 113;
        nns.e1 = 6;
        if nns.e1 { armour = 7;       nns.e1 -= 1; }
        if nns.e2 { nns.boss -= 3;    nns.e2 -= 1; }
        if nns.e3 { nns.mana += 101;  nns.e3 -= 1; }
        nns.health -= boss_damage - 7;
        play_game(nns, boss_damage, 113 + spent);
    }
    if ns.mana >= 173 && ns.e2 == 0
    {
        nns := ns;
        nns.mana -= 173;
        nns.e2 = 6;
        if nns.e1 { armour = 7;       nns.e1 -= 1; }
        if nns.e2 { nns.boss -= 3;    nns.e2 -= 1; }
        if nns.e3 { nns.mana += 101;  nns.e3 -= 1; }
        nns.health -= boss_damage - armour;
        play_game(nns, boss_damage, 173 + spent);
    }
    if ns.mana >= 229 && ns.e3 == 0
    {
        nns := ns;
        nns.mana -= 229;
        nns.e3 = 5;
        if nns.e1 { armour = 7;       nns.e1 -= 1; }
        if nns.e2 { nns.boss -= 3;    nns.e2 -= 1; }
        if nns.e3 { nns.mana += 101;  nns.e3 -= 1; }
        nns.health -= boss_damage - armour;
        play_game(nns, boss_damage, 229 + spent);
    }
}

State :: struct
{
    health : s16;
    mana : s16;
    boss : s8;
    e1 : u8;
    e2 : u8;
    e3 : u8;
    
    #place health;
    hash : u64;
}