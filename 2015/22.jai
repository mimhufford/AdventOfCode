day22 :: (data: string) -> string, string
{
    advance(*data, 12);
    boss_health := next_u8(*data);
    boss_damage := next_s16(*data);

    initial_state : State;
    initial_state.health = 50;
    initial_state.mana = 500;
    initial_state.boss = xx boss_health;
    
    least_mana := play_game(initial_state, boss_damage);

    return tprint("%", least_mana), tprint("%", "");
}

play_game :: (s: State, boss_damage: s16) -> s64
{
    spent := S64_MAX;

    armour : s16 = 0;

    ns := s;

    if ns.e1 armour = 7;      ns.e1 = xx max(0, ns.e1 - 1);
    if ns.e2 ns.boss -= 3;    ns.e2 = xx max(0, ns.e2 - 1);
    if ns.e3 ns.mana += 101;  ns.e3 = xx max(0, ns.e3 - 1);

    if   ns.boss <= 0  return 0;
    if ns.health <= 0  return spent;

    if ns.mana >= 53
    {
        nns := ns;
        nns.boss -= 4;
        nns.mana -= 53;
        nns.health -= boss_damage + armour;
        spent = min(spent, play_game(nns, boss_damage));
    }
    if ns.mana >= 73
    {
        nns := ns;
        nns.boss -= 2;
        nns.mana -= 73;
        nns.health += 2;
        nns.health -= boss_damage + armour;
        spent = min(spent, play_game(nns, boss_damage));
    }
    if ns.mana >= 113 && ns.e1 == 0
    {
        nns := ns;
        nns.mana -= 113;
        nns.e1 = 6;
        nns.health -= boss_damage + armour;
        spent = min(spent, play_game(nns, boss_damage));
    }
    if ns.mana >= 173 && ns.e2 == 0
    {
        nns := ns;
        nns.mana -= 173;
        nns.e2 = 6;
        nns.health -= boss_damage + armour;
        spent = min(spent, play_game(nns, boss_damage));
    }
    if ns.mana >= 229 && ns.e3 == 0
    {
        nns := ns;
        nns.mana -= 229;
        nns.e3 = 5;
        nns.health -= boss_damage + armour;
        spent = min(spent, play_game(nns, boss_damage));
    }

    return spent;
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