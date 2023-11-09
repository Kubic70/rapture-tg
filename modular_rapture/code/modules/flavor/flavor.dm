/datum/preference/text/flavor_text
	category = PREFERENCE_CATEGORY_FLAVORS_DATA
	savefile_identifier = PREFERENCE_CHARACTER
	savefile_key = "flavor_text"
	maximum_value_length = MAX_FLAVOR_LEN

/datum/preference/text/flavor_text/apply_to_human(mob/living/carbon/human/target, value, datum/preferences/preferences)
	target.dna.features["flavor_text"] = value

/datum/preference/text/silicon_flavor_text
	category = PREFERENCE_CATEGORY_FLAVORS_DATA
	savefile_identifier = PREFERENCE_CHARACTER
	savefile_key = "silicon_flavor_text"
	maximum_value_length = MAX_FLAVOR_LEN
	// This does not get a apply_to_human proc, this is read directly in silicon/robot/examine.dm

/datum/preference/text/silicon_flavor_text/apply_to_human(mob/living/carbon/human/target, value, datum/preferences/preferences)
	return FALSE // To prevent the not-implemented runtime

/datum/preference/text/ooc_notes
	category = PREFERENCE_CATEGORY_FLAVORS_DATA
	savefile_identifier = PREFERENCE_CHARACTER
	savefile_key = "ooc_notes"
	maximum_value_length = MAX_FLAVOR_LEN

/datum/preference/text/ooc_notes/apply_to_human(mob/living/carbon/human/target, value, datum/preferences/preferences)
	target.dna.features["ooc_notes"] = value

// RP RECORDS REJUVINATION - All of these are handled in datacore, so we dont apply it to the human.
/datum/preference/text/general
	category = PREFERENCE_CATEGORY_FLAVORS_DATA
	savefile_identifier = PREFERENCE_CHARACTER
	savefile_key = "general_record"
	maximum_value_length = MAX_FLAVOR_LEN

/datum/preference/text/general/apply_to_human(mob/living/carbon/human/target, value, datum/preferences/preferences)
	return FALSE

/datum/preference/text/medical
	category = PREFERENCE_CATEGORY_FLAVORS_DATA
	savefile_identifier = PREFERENCE_CHARACTER
	savefile_key = "medical_record"
	maximum_value_length = MAX_FLAVOR_LEN

/datum/preference/text/medical/apply_to_human(mob/living/carbon/human/target, value, datum/preferences/preferences)
	return FALSE

/datum/preference/text/security
	category = PREFERENCE_CATEGORY_FLAVORS_DATA
	savefile_identifier = PREFERENCE_CHARACTER
	savefile_key = "security_record"
	maximum_value_length = MAX_FLAVOR_LEN

/datum/preference/text/security/apply_to_human(mob/living/carbon/human/target, value, datum/preferences/preferences)
	return FALSE



/////////Barking///////////

/datum/preference/toggle/sound_bark
	category = PREFERENCE_CATEGORY_GAME_PREFERENCES
	savefile_key = "sound_bark"
	savefile_identifier = PREFERENCE_PLAYER

/datum/preference/choiced/bark_id
	category = PREFERENCE_CATEGORY_BARKS_DATA
	savefile_identifier = PREFERENCE_CHARACTER
	savefile_key = "bark_id"

/datum/preference/choiced/bark_id/init_possible_values()
	var/list/values = list()
	for(var/name in GLOB.bark_list)
		values[name] = GLOB.bark_list[name]
	return values

/datum/preference/choiced/bark_id/create_default_value()
	return pick(GLOB.bark_random_list)

/datum/preference/choiced/bark_id/compile_constant_data()
	var/list/data = ..()
	data["voices"] = GLOB.bark_list

	return data

/datum/preference/choiced/bark_id/apply_to_human(mob/living/carbon/human/target, value, datum/preferences/preferences)
	target.vocal_bark_id = value



/*
/datum/preference/numeric/bark_speed
	category = PREFERENCE_CATEGORY_BARKS_DATA
	savefile_identifier = PREFERENCE_CHARACTER
	savefile_key = "bark_speed"

/datum/preference/text/bark_speed/create_default_value()
	return rand(BARK_DEFAULT_MINSPEED,BARK_DEFAULT_MAXSPEED)

/datum/preference/text/bark_speed/apply_to_human(mob/living/carbon/human/target, value, datum/preferences/preferences)
	target.vocal_speed = value
*/


/datum/preference/numeric/bark_speed
	category = PREFERENCE_CATEGORY_BARKS_DATA
	savefile_identifier = PREFERENCE_CHARACTER
	savefile_key = "bark_speed"
	minimum = BARK_DEFAULT_MINSPEED
	maximum = BARK_DEFAULT_MAXSPEED
	step = 0.1

/datum/preference/numeric/bark_speed/create_default_value()
	return rand(BARK_DEFAULT_MINSPEED,BARK_DEFAULT_MAXSPEED)

/datum/preference/numeric/bark_speed/apply_to_human(mob/living/carbon/human/target, value)
	target.vocal_speed = value


/datum/preference/numeric/bark_pitch
	category = PREFERENCE_CATEGORY_BARKS_DATA
	savefile_identifier = PREFERENCE_CHARACTER
	savefile_key = "bark_pitch"
	minimum = BARK_DEFAULT_MINPITCH
	maximum = BARK_DEFAULT_MAXPITCH
	step = 0.1

/datum/preference/numeric/bark_pitch/create_default_value()
	return BARK_PITCH_RAND(PLURAL)

/datum/preference/numeric/bark_pitch/apply_to_human(mob/living/carbon/human/target, value)
	target.vocal_pitch = value


/datum/preference/numeric/bark_variance
	category = PREFERENCE_CATEGORY_BARKS_DATA
	savefile_identifier = PREFERENCE_CHARACTER
	savefile_key = "bark_variance"
	minimum = BARK_DEFAULT_MINVARY
	maximum = BARK_DEFAULT_MAXVARY
	step = 0.1

/datum/preference/numeric/bark_variance/create_default_value()
	return BARK_VARIANCE_RAND

/datum/preference/numeric/bark_variance/apply_to_human(mob/living/carbon/human/target, value)
	target.vocal_pitch_range = value
