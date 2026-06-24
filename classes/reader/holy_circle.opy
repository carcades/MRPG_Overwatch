#!mainFile "../../main.opy"

def create_reader_holy_circle():
    @Name "Reader: create a holy circle"
    
    eventPlayer.readerHolyCircleIter = 0
    while eventPlayer.readerHolyCircleIter < 10:
        eventPlayer.readerHolyCircleIterPlus = eventPlayer.readerHolyCircleIter + 1
        if eventPlayer.readerHolyCircleIter < 9:
            createBeam(getAllPlayers(), Beam.MERCY_BOOST, reader_holy_circle_vectors[evalOnce(eventPlayer.readerHolyCircleIter)] + (vect(eventPlayer.getEyePosition().x, eventPlayer.getEyePosition().y + 3, eventPlayer.getEyePosition().z)), reader_holy_circle_vectors[evalOnce(eventPlayer.readerHolyCircleIter) + 1] + (vect(eventPlayer.getEyePosition().x, eventPlayer.getEyePosition().y + 3, eventPlayer.getEyePosition().z)), Color.TEAM_1, EffectReeval.POSITION_AND_RADIUS)
        else:
            createBeam(getAllPlayers(), Beam.MERCY_BOOST, reader_holy_circle_vectors[evalOnce(eventPlayer.readerHolyCircleIter)] + (vect(eventPlayer.getEyePosition().x, eventPlayer.getEyePosition().y + 3, eventPlayer.getEyePosition().z)), reader_holy_circle_vectors[0] + (vect(eventPlayer.getEyePosition().x, eventPlayer.getEyePosition().y + 3, eventPlayer.getEyePosition().z)), Color.TEAM_1, EffectReeval.POSITION_AND_RADIUS)
        eventPlayer.reader_holy_circle_effects.append(getLastCreatedEntity())
        wait(0.03)
        eventPlayer.readerHolyCircleIter++


def destroy_reader_holy_circle():
    @Name "Reader: destroy a holy circle"
    
    eventPlayer.readerHolyCircleIter = 0
    while eventPlayer.readerHolyCircleIter < len(reader_holy_circle_vectors):
        destroyEffect(eventPlayer.reader_holy_circle_effects[eventPlayer.readerHolyCircleIter + 1])
        wait(0.03)
        eventPlayer.readerHolyCircleIter++
    eventPlayer.reader_holy_circle_effects = [null]
