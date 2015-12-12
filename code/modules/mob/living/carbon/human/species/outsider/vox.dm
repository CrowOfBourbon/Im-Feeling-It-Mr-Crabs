/datum/species/vox
	name = "Vox"
	name_plural = "Vox"
	icobase = 'icons/mob/human_races/r_vox.dmi'
	deform = 'icons/mob/human_races/r_def_vox.dmi'
	default_language = "Vox-pidgin"
	language = "Galactic Common"
	unarmed_types = list(/datum/unarmed_attack/stomp, /datum/unarmed_attack/kick,  /datum/unarmed_attack/claws/strong, /datum/unarmed_attack/bite/strong)
	rarity_value = 4
	blurb = "The Vox are the broken remnants of a once-proud race, now reduced to little more than \
	scavenging vermin who prey on isolated stations, ships or planets to keep their own ancient arkships \
	alive. They are four to five feet tall, reptillian, beaked, tailed and quilled; human crews often \
	refer to them as 'shitbirds' for their violent and offensive nature, as well as their horrible \
	smell.<br/><br/>Most humans will never meet a Vox raider, instead learning of this insular species through \
	dealing with their traders and merchants; those that do rarely enjoy the experience."

	speech_sounds = list('sound/voice/shriek1.ogg')
	speech_chance = 20

	warning_low_pressure = 50
	hazard_low_pressure = 0

	cold_level_1 = 80
	cold_level_2 = 50
	cold_level_3 = 0

	eyes = "vox_eyes_s"

	breath_type = "nitrogen"
	poison_type = "oxygen"
	siemens_coefficient = 0.2

	flags = CAN_JOIN| IS_WHITELISTED | NO_SCAN | HAS_EYE_COLOR

	blood_color = "#2299FC"
	flesh_color = "#808D11"

	reagent_tag = IS_VOX

	inherent_verbs = list(
		/mob/living/carbon/human/proc/leap
		)

	has_organ = list(
		"heart" =    /obj/item/organ/heart,
		"lungs" =    /obj/item/organ/lungs,
		"liver" =    /obj/item/organ/liver,
		"kidneys" =  /obj/item/organ/kidneys,
		"brain" =    /obj/item/organ/brain,
		"eyes" =     /obj/item/organ/eyes,
		"stack" =    /obj/item/organ/stack/vox
		)

/datum/species/vox/get_random_name(var/gender)
	var/datum/language/species_language = all_languages[default_language]
	return species_language.get_random_name(gender)

/datum/species/vox/equip_survival_gear(var/mob/living/carbon/human/H)
	H.equip_to_slot_or_del(new /obj/item/clothing/mask/breath(H), slot_wear_mask)
	H.equip_to_slot_or_del(new /obj/item/weapon/tank/nitrogen(H), slot_r_hand)
	H.equip_to_slot_or_del(new /obj/item/weapon/storage/box/vox(H), slot_in_backpack)
	H.internals.icon_state = "internal1"

// Joining as a station vox will give you this template, hence IS_RESTRICTED flag.
/datum/species/vox/pariah
	name = "Vox Pariah"
	rarity_value = 0.1
	speech_chance = 60        // No volume control.
	siemens_coefficient = 0.5 // Ragged scaleless patches.

	warning_low_pressure = (WARNING_LOW_PRESSURE-20)
	hazard_low_pressure =  (HAZARD_LOW_PRESSURE-10)
	total_health = 80

	cold_level_1 = 999
	cold_level_2 = 999
	cold_level_3 = 999

	unarmed_types = list(/datum/unarmed_attack/stomp, /datum/unarmed_attack/kick,  /datum/unarmed_attack/claws, /datum/unarmed_attack/bite)

	// Pariahs have no stack.
	has_organ = list(
		"heart" =    /obj/item/organ/heart,
		"lungs" =    /obj/item/organ/lungs,
		"liver" =    /obj/item/organ/liver,
		"kidneys" =  /obj/item/organ/kidneys,
		"brain" =    /obj/item/organ/pariah_brain,
		"eyes" =     /obj/item/organ/eyes
		)
	flags = IS_RESTRICTED | NO_SCAN | HAS_EYE_COLOR

// No combat skills for you.
/datum/species/vox/pariah/can_shred(var/mob/living/carbon/human/H, var/ignore_intent)
	return 0

/datum/species/vox/pariah/get_bodytype()
	return "Vox"
