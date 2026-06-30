import sys

def replace_in_file(filepath):
    with open(filepath, 'r', encoding='utf-8') as f:
        content = f.read()

    # Replacement 1
    target1 = '''        if eventPlayer.buff_append_args[4] == EffectAction.SUBTRACT:
            eventPlayer.mod_stats[eventPlayer.buff_append_args[3]] += eventPlayer.buff_append_args[5]
            eventPlayer.apply_all_stats()'''
    repl1 = '''        eventPlayer.mod_stats[eventPlayer.buff_append_args[3]] += eventPlayer.buff_append_args[5]
        eventPlayer.apply_all_stats()'''
    content = content.replace(target1, repl1)

    # Replacement 2
    target2 = '''                if eventPlayer.active_buff_actions[eventPlayer.index_of_etbda_object] == EffectAction.SUBTRACT:
                    logToInspector("LIFECYCLE: Reverting STAT change")
                    eventPlayer.mod_stats[eventPlayer.active_buff_types[eventPlayer.index_of_etbda_object]] -= eventPlayer.active_buff_values[eventPlayer.index_of_etbda_object]
                    eventPlayer.apply_all_stats()'''
    repl2 = '''                logToInspector("LIFECYCLE: Reverting STAT change")
                eventPlayer.mod_stats[eventPlayer.active_buff_types[eventPlayer.index_of_etbda_object]] -= eventPlayer.active_buff_values[eventPlayer.index_of_etbda_object]
                eventPlayer.apply_all_stats()'''
    content = content.replace(target2, repl2)

    with open(filepath, 'w', encoding='utf-8') as f:
        f.write(content)

replace_in_file('systems/effects_lifecycle.opy')
