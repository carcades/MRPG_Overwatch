#!mainFile "../main.opy"

rule "Rt effects":
    wait(3)
    #rt_enter_ring
    createEffect(getAllPlayers(), Effect.RING, Color.YELLOW, rt_enter_pos, 1, EffectReeval.NONE)
    #rt_exit_ring
    createEffect(getAllPlayers(), Effect.RING, Color.YELLOW, rt_exit_pos, 1, EffectReeval.NONE)
    #shop effects
    createEffect(getAllPlayers(), Effect.RING, Color.YELLOW, vect(rt_left_1_pos.x, -1 + rt_left_1_pos.y, rt_left_1_pos.z), 1, EffectReeval.NONE)
    createEffect(getAllPlayers(), Effect.RING, Color.YELLOW, vect(rt_left_2_pos.x, -1 + rt_left_2_pos.y, rt_left_2_pos.z), 1, EffectReeval.NONE)
    createEffect(getAllPlayers(), Effect.RING, Color.YELLOW, vect(rt_right_1_pos.x, -1 + rt_right_1_pos.y, rt_right_1_pos.z), 1, EffectReeval.NONE)
    createEffect(getAllPlayers(), Effect.RING, Color.YELLOW, vect(rt_right_2_pos.x, -1 + rt_right_2_pos.y, rt_right_2_pos.z), 1, EffectReeval.NONE)


rule "Rt text":
    wait(3)
    #enter text
    createInWorldText(getAllPlayers(), "The Treasury Of Relics", vect(rt_enter_pos.x, 2 + rt_enter_pos.y, rt_enter_pos.z), 1.6, Clip.SURFACES, WorldTextReeval.COLOR, color_yellow_gold)
    #vial of expirence
    createInWorldText(getAllPlayers(), "buy a vial of expirence\nfor {1} gold".format(null, cost_vial_exp), vect(rt_left_1_pos.x, rt_left_1_pos.y - 0, rt_left_1_pos.z), 1.3, Clip.SURFACES, WorldTextReeval.STRING)
