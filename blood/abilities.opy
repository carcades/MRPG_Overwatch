#!mainFile "../main.opy"

rule "Ability Vampire":
    @Event playerDealtDamage
    @Condition eventPlayer.passiveVampire == true
    @Condition eventDamage > 0
    
    heal(attacker, attacker, eventDamage * eventPlayer.vampireSize)


rule "Ability Bleeding":
    @Event playerDealtDamage
    @Condition eventPlayer.bleedingPassive == true
    @Condition eventDamage > 0
    @Condition eventPlayer.bleedingCd == false
    
    eventPlayer.bleedingChance = random.randint(1, 10)
    if eventPlayer.bleedingChance <= eventPlayer.bleedingChancePlayer:
        victim.startDamageOverTime(eventPlayer, eventPlayer.bleedingDuration, eventPlayer.stat_damage / 3 * eventPlayer.bleedingPower)
        eventPlayer.bleedingCd = true
        wait(eventPlayer.bleedingDuration)
        eventPlayer.bleedingCd = false
