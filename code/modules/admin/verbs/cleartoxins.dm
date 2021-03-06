/client/proc/cleartox()
	set category = "Special Verbs"
	set name = "Clear Toxin/Fire in Zone"
	if(!holder)
		src << "Only mentors and above may use this command."
		return
	var/datum/gas_mixture/environment = usr.loc.return_air()
	environment.gas["sleeping_agent_archived"] = null
	environment.gas["sleeping_agent"] = 0
	environment.gas["phoron_archived"] = null
	environment.gas["phoron"] = 0
	environment.gas["carbon_dioxide"] = 0
	environment.gas["carbon_dioxide_archived"] = null
	environment.gas["oxygen"] = 21.8366
	environment.gas["oxygen_archived"] = null
	environment.gas["nitrogen"] = 82.1472
	environment.gas["nitrogen_archived"] = null
	environment.gas["temperature_archived"] = null
	environment.temperature = 293.15
	environment.update_values()
	var/turf/simulated/location = get_turf(usr)
	if(location.zone)
		for(var/turf/T in location.zone.contents)
			for(var/obj/fire/F in T.contents)
				qdel(F)
			T.overlays = null
		for(var/obj/fire/FF in world)
			qdel(FF)
