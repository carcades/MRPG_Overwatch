#!mainFile "../main.opy"

rule "Ability Vampire":
    @Event playerDealtDamage
    @Condition eventPlayer.passive_vampire == true
    @Condition victim != attacker
    
    heal(attacker, attacker, eventDamage * eventPlayer.vampire_size)


rule "Ability Bleeding":
    @Event playerDealtDamage
    @Condition eventPlayer.bleeding_passive == true
    @Condition victim != attacker
    @Condition eventPlayer.bleeding_cd == false
    
    eventPlayer.bleeding_chance = random.randint(1, 10)
    if eventPlayer.bleeding_chance <= eventPlayer.bleeding_chance_player:
        victim.startDamageOverTime(eventPlayer, eventPlayer.bleeding_duration, eventPlayer.stat_damage / 3 * eventPlayer.bleeding_power)
        eventPlayer.bleeding_cd = true
        wait(eventPlayer.bleeding_duration)
        eventPlayer.bleeding_cd = false
