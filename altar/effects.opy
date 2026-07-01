#!mainFile "../main.opy"

rule "Altar Of Rebirth effects":
    wait(5)
    #exit altar ring
    createEffect(getAllPlayers(), Effect.RING, Color.TURQUOISE, vect(exit_altar_point.x, exit_altar_point.y - 2, exit_altar_point.z), 1.3, EffectReeval.VISIBILITY_POSITION_AND_RADIUS)
    createEffect(getAllPlayers(), Effect.RING, localPlayer.altarLeft1RingColor, altar_left_1_point if localPlayer.altarLeft1RingVisible == true else vect(0, -999, 0), 1, EffectReeval.VISIBILITY_POSITION_RADIUS_AND_COLOR)
    createEffect(getAllPlayers(), Effect.RING, localPlayer.altarRight1RingColor, altar_right_1_point if localPlayer.altarRight1RingVisible == true else vect(0, -999, 0), 1, EffectReeval.VISIBILITY_POSITION_RADIUS_AND_COLOR)
    #1-6 effects
    #createEffect(getAllPlayers(), Effect.RING, Color.WHITE, altar_left_1_point, 1, EffectReeval.VISIBILITY_POSITION_AND_RADIUS)
    #createEffect(getAllPlayers(), Effect.RING, Color.WHITE, altar_left_2_point, 1, EffectReeval.VISIBILITY_POSITION_AND_RADIUS)
    #createEffect(getAllPlayers(), Effect.RING, Color.WHITE, altar_left_3_point, 1, EffectReeval.VISIBILITY_POSITION_AND_RADIUS)
    #createEffect(getAllPlayers(), Effect.RING, Color.WHITE, altar_right_1_point, 1, EffectReeval.VISIBILITY_POSITION_AND_RADIUS)
    #createEffect(getAllPlayers(), Effect.RING, Color.WHITE, altar_right_2_point, 1, EffectReeval.VISIBILITY_POSITION_AND_RADIUS)
    #createEffect(getAllPlayers(), Effect.RING, Color.WHITE, altar_right_3_point, 1, EffectReeval.VISIBILITY_POSITION_AND_RADIUS)


rule "Altar Of Rebirth text (eng)":
    wait(5)
    #exit text
    createInWorldText(getAllPlayers(), "exit", vect(exit_altar_point.x, exit_altar_point.y + 0.8, exit_altar_point.z), 1.6, Clip.SURFACES, WorldTextReeval.STRING_AND_COLOR, color_altar_text, SpecVisibility.DEFAULT)
    #description 
    createInWorldText(getAllPlayers(), localPlayer.altar_description_text[localPlayer.descriptionVisibility], vect(altar_description_point.x, altar_description_point.y + 2, altar_description_point.z), 2, Clip.SURFACES, WorldTextReeval.STRING)
    #1-6 points text
    createInWorldText(getAllPlayers(), localPlayer.altar_left_1_text[AltarRaceText.TITLE if localPlayer.descriptionVisibility == AltarDescVisibility.TITLE else AltarRaceText.DESCRIPTION], vect(altar_left_1_point.x, altar_left_1_point.y + 0.6, altar_left_1_point.z), 1.6, Clip.NONE, WorldTextReeval.STRING_AND_COLOR, localPlayer.altar_left_1_text[AltarRaceText.TITLE_COLOR if localPlayer.descriptionVisibility == AltarDescVisibility.TITLE else AltarRaceText.DESC_COLOR])
    createInWorldText(getAllPlayers(), localPlayer.altar_right_1_text[AltarRaceText.TITLE if localPlayer.descriptionVisibility == AltarDescVisibility.TITLE else AltarRaceText.DESCRIPTION], vect(altar_right_1_point.x, altar_right_1_point.y + 0.6, altar_right_1_point.z), 1.6, Clip.NONE, WorldTextReeval.STRING_AND_COLOR, localPlayer.altar_right_1_text[AltarRaceText.TITLE_COLOR if localPlayer.descriptionVisibility == AltarDescVisibility.TITLE else AltarRaceText.DESC_COLOR])
