/client/proc/clean()
	set category = "Special Verbs"
	set name = "Clean"


	var/d = 0
	var/g = 0
	var/t = d+g
	for(var/obj/Obj in world)
		if(istype(Obj,/obj/effect/decal/cleanable))
			d++
	for(var/obj/Obj in world)
		if(istype(Obj,/obj/item/weapon/cigbutt))
			d++
	for(var/obj/Obj in world)
		if(istype(Obj,/obj/item/weapon/material/shard))
			g++

	if(!d)
		usr << "No objects of this type exist"
		return
	if(alert("There are [d] cleanable decals in the world and [g] cleanable glass shards. [t] Total objects. Do you still want to delete?",,"Yes", "No") == "Yes")
		world << "<br><br><font color = red size = 2><b>Admin [usr.client.holder.fakekey ? "Administrator" : usr.key] is cleaning the station.<br>Expect some lag</b></font><br>"
		sleep 15
		for(var/obj/Obj in world)
			if(istype(Obj,/obj/effect/decal/cleanable))
				qdel(Obj)
		for(var/obj/Obj in world)
			if(istype(Obj,/obj/item/weapon/material/shard))
				qdel(Obj)
		for(var/obj/Obj in world)
			if(istype(Obj,/obj/item/weapon/cigbutt))
				qdel(Obj)
		log_admin("[key_name_admin(usr)] cleaned the world ([d] decals, [g] glass shards, [t] total objects deleted) ")
		message_admins("\blue [key_name_admin(usr)] cleaned the world ([t] objects deleted) ")