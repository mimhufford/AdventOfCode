day22 :: (data: string) -> string, string
{
    advance(*data, 12);
    boss_health := next_u8(*data);
    boss_damage := next_s16(*data);

    initial_state : State;
    initial_state.health = 50;
    initial_state.mana = 500;
    initial_state.boss = xx boss_health;

    easy := S64_MAX;
    hard := S64_MAX;
    play_game(initial_state, boss_damage, false, *easy);
    play_game(initial_state, boss_damage, true,  *hard);

    return tprint("%", easy), tprint("%", hard);
}

play_game :: (prev_state: State, boss_damage: s16, hard: bool, best: *s64, spent: s64 = 0)
{
    s := prev_state;

    if hard s.health -= 1;

    if s.boss <= 0
    {
        if spent < <<best
        {
            <<best = spent;
        } 
    }

    if s.health <= 0 return;

    if s.mana >= 53
    {
        ns := s;
        do_effects(*ns);
        ns.mana -= 53;
        ns.boss -= 4;
        do_boss_turn(*ns);
        play_game(ns, boss_damage, hard, best, 53 + spent);
    }
    if s.mana >= 73
    {
        ns := s;
        do_effects(*ns);
        ns.mana -= 73;
        ns.boss -= 2;
        ns.health += 2;
        do_boss_turn(*ns);
        play_game(ns, boss_damage, hard, best, 73 + spent);
    }
    if s.mana >= 113 && s.e1 == 1
    {
        ns := s;
        do_effects(*ns);
        ns.mana -= 113;
        ns.e1 = 6;
        do_boss_turn(*ns);
        play_game(ns, boss_damage, hard, best, 113 + spent);
    }
    if s.mana >= 173 && s.e2 == 1
    {
        ns := s;
        do_effects(*ns);
        ns.mana -= 173;
        ns.e2 = 6;
        do_boss_turn(*ns);
        play_game(ns, boss_damage, hard, best, 173 + spent);
    }
    if s.mana >= 229 && s.e3 == 1
    {
        ns := s;
        do_effects(*ns);
        ns.mana -= 229;
        ns.e3 = 5;
        do_boss_turn(*ns);
        play_game(ns, boss_damage, hard, best, 229 + spent);
    }

    do_effects :: (s: *State)
    {
        if s.e1 {                s.e1 -= 1; }
        if s.e2 { s.boss -= 3;   s.e2 -= 1; }
        if s.e3 { s.mana += 101; s.e3 -= 1; }
    }

    do_boss_turn :: (s: *State) #expand
    {
        armour : s16 = xx ifx s.e1 then 7 else 0;
        do_effects(s);
        s.health -= `boss_damage - armour;
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