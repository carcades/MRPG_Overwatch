#!mainFile "../main.opy"

rule "Altar Of Rebirth effects":
    wait(5)
    #exit altar ring
    createEffect(getAllPlayers(), Effect.RING, Color.TURQUOISE, vect(exit_altar_point.x, exit_altar_point.y - 2, exit_altar_point.z), 1.3, EffectReeval.VISIBILITY_POSITION_AND_RADIUS)
    createEffect(getAllPlayers().filter(lambda _: localPlayer.altar_left_1_ring[1] == true), Effect.RING, localPlayer.altar_left_1_ring[0], altar_left_1_point, 1, EffectReeval.VISIBILITY_AND_COLOR)
    createEffect(getAllPlayers().filter(lambda _: localPlayer.altar_right_1_ring[1] == true), Effect.RING, localPlayer.altar_right_1_ring[0], altar_right_1_point, 1, EffectReeval.VISIBILITY_AND_COLOR)
    #1-6 effects
    #createEffect(getAllPlayers(), Effect.RING, Color.WHITE, altar_left_1_point, 1, EffectReeval.VISIBILITY_POSITION_AND_RADIUS)
    #createEffect(getAllPlayers(), Effect.RING, Color.WHITE, altar_left_2_point, 1, EffectReeval.VISIBILITY_POSITION_AND_RADIUS)
    #createEffect(getAllPlayers(), Effect.RING, Color.WHITE, altar_left_3_point, 1, EffectReeval.VISIBILITY_POSITION_AND_RADIUS)
    #createEffect(getAllPlayers(), Effect.RING, Color.WHITE, altar_right_1_point, 1, EffectReeval.VISIBILITY_POSITION_AND_RADIUS)
    #createEffect(getAllPlayers(), Effect.RING, Color.WHITE, altar_right_2_point, 1, EffectReeval.VISIBILITY_POSITION_AND_RADIUS)
    #createEffect(getAllPlayers(), Effect.RING, Color.WHITE, altar_right_3_point, 1, EffectReeval.VISIBILITY_POSITION_AND_RADIUS)


rule "Altar Of Rebirth text (eng)":
    wait(5)
    #description 
    createInWorldText(getAllPlayers(), localPlayer.altar_description_text[localPlayer.description_visibility_status], vect(altar_description_point.x, altar_description_point.y + 2, altar_description_point.z), 2, Clip.SURFACES, WorldTextReeval.STRING)
    #1-6 points text
    createInWorldText(getAllPlayers(), localPlayer.altar_left_1_text[localPlayer.description_visibility_status], vect(altar_left_1_point.x, altar_left_1_point.y + 0.6, altar_left_1_point.z), 1.6, Clip.NONE, WorldTextReeval.STRING_AND_COLOR, localPlayer.altar_left_1_text[localPlayer.description_visibility_status + 2])
    createInWorldText(getAllPlayers(), localPlayer.altar_right_1_text[localPlayer.description_visibility_status], vect(altar_right_1_point.x, altar_right_1_point.y + 0.6, altar_right_1_point.z), 1.6, Clip.NONE, WorldTextReeval.STRING_AND_COLOR, localPlayer.altar_right_1_text[localPlayer.description_visibility_status + 2])
