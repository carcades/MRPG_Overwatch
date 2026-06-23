#!mainFile "../../main.opy"

def create_reader_holy_circle():
    @Name "Reader: create a holy circle"
    
    for eventPlayer.reader_holy_circle_iter in range(10):
        eventPlayer.reader_holy_circle_iter_plus = eventPlayer.reader_holy_circle_iter + 1
        if eventPlayer.reader_holy_circle_iter < 9:
            createBeam(getAllPlayers(), Beam.MERCY_BOOST, reader_holy_circle_vectors[evalOnce(eventPlayer.reader_holy_circle_iter)] + (vect(eventPlayer.getEyePosition().x, eventPlayer.getEyePosition().y + 3, eventPlayer.getEyePosition().z)), reader_holy_circle_vectors[evalOnce(eventPlayer.reader_holy_circle_iter) + 1] + (vect(eventPlayer.getEyePosition().x, eventPlayer.getEyePosition().y + 3, eventPlayer.getEyePosition().z)), Color.TEAM_1, EffectReeval.POSITION_AND_RADIUS)
        else:
            createBeam(getAllPlayers(), Beam.MERCY_BOOST, reader_holy_circle_vectors[evalOnce(eventPlayer.reader_holy_circle_iter)] + (vect(eventPlayer.getEyePosition().x, eventPlayer.getEyePosition().y + 3, eventPlayer.getEyePosition().z)), reader_holy_circle_vectors[0] + (vect(eventPlayer.getEyePosition().x, eventPlayer.getEyePosition().y + 3, eventPlayer.getEyePosition().z)), Color.TEAM_1, EffectReeval.POSITION_AND_RADIUS)
        eventPlayer.reader_holy_circle_effects.append(getLastCreatedEntity())
        wait(0.03)


def destroy_reader_holy_circle():
    @Name "Reader: destroy a holy circle"
    
    for eventPlayer.reader_holy_circle_iter in range(len(reader_holy_circle_vectors)):
        destroyEffect(eventPlayer.reader_holy_circle_effects[eventPlayer.reader_holy_circle_iter + 1])
        wait(0.03)
    eventPlayer.reader_holy_circle_effects = [null]
