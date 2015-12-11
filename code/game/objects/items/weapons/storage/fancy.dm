/*
 * The 'fancy' path is for objects like donut boxes that show how many items are in the storage item on the sprite itself
 * .. Sorry for the shitty path name, I couldnt think of a better one.
 *
 * WARNING: var/icon_type is used for both examine text and sprite name. Please look at the procs below and adjust your sprite names accordingly
 *		TODO: Cigarette boxes should be ported to this standard
 *
 * Contains:
 *		Donut Box
 *		Egg Box
 *		Candle Box
 *		Crayon Box
 *		Cigarette Box
 */

/obj/item/weapon/storage/fancy/
	icon = 'icons/obj/food.dmi'
	icon_state = "donutbox6"
	name = "donut box"
	var/icon_type = "donut"

/obj/item/weapon/storage/fancy/update_icon(var/itemremoved = 0)
	var/total_contents = src.contents.len - itemremoved
	src.icon_state = "[src.icon_type]box[total_contents]"
	return

/obj/item/weapon/storage/fancy/examine(mob/user)
	if(!..(user, 1))
		return

	if(contents.len <= 0)
		user << "There are no [src.icon_type]s left in the box."
	else if(contents.len == 1)
		user << "There is one [src.icon_type] left in the box."
	else
		user << "There are [src.contents.len] [src.icon_type]s in the box."

	return

/*
 * Egg Box
 */

/obj/item/weapon/storage/fancy/egg_box
	icon = 'icons/obj/food.dmi'
	icon_state = "eggbox"
	icon_type = "egg"
	name = "egg box"
	storage_slots = 12
	can_hold = list(
		/obj/item/weapon/reagent_containers/food/snacks/egg,
		/obj/item/weapon/reagent_containers/food/snacks/boiledegg
		)

/obj/item/weapon/storage/fancy/egg_box/New()
	..()
	for(var/i=1; i <= storage_slots; i++)
		new /obj/item/weapon/reagent_containers/food/snacks/egg(src)
	return

/*
 * Candle Box
 */

/obj/item/weapon/storage/fancy/candle_box
	name = "candle pack"
	desc = "A pack of red candles."
	icon = 'icons/obj/candle.dmi'
	icon_state = "candlebox5"
	icon_type = "candle"
	item_state = "candlebox5"
	storage_slots = 5
	throwforce = 2
	slot_flags = SLOT_BELT


/obj/item/weapon/storage/fancy/candle_box/New()
	..()
	for(var/i=1; i <= storage_slots; i++)
		new /obj/item/weapon/flame/candle(src)
	return

/*
 * Crayon Box
 */

/obj/item/weapon/storage/fancy/crayons
	name = "box of crayons"
	desc = "A box of crayons for all your rune drawing needs."
	icon = 'icons/obj/crayons.dmi'
	icon_state = "crayonbox"
	w_class = 2.0
	storage_slots = 6
	icon_type = "crayon"
	can_hold = list(
		/obj/item/weapon/pen/crayon
	)

/obj/item/weapon/storage/fancy/crayons/New()
	..()
	new /obj/item/weapon/pen/crayon/red(src)
	new /obj/item/weapon/pen/crayon/orange(src)
	new /obj/item/weapon/pen/crayon/yellow(src)
	new /obj/item/weapon/pen/crayon/green(src)
	new /obj/item/weapon/pen/crayon/blue(src)
	new /obj/item/weapon/pen/crayon/purple(src)
	update_icon()

/obj/item/weapon/storage/fancy/crayons/update_icon()
	overlays = list() //resets list
	overlays += image('icons/obj/crayons.dmi',"crayonbox")
	for(var/obj/item/weapon/pen/crayon/crayon in contents)
		overlays += image('icons/obj/crayons.dmi',crayon.colourName)

/obj/item/weapon/storage/fancy/crayons/attackby(obj/item/W as obj, mob/user as mob)
	if(istype(W,/obj/item/weapon/pen/crayon))
		switch(W:colourName)
			if("mime")
				usr << "This crayon is too sad to be contained in this box."
				return
			if("rainbow")
				usr << "This crayon is too powerful to be contained in this box."
				return
	..()

////////////
//CIG PACK//
////////////

/obj/item/weapon/storage/fancy/cigarettes
	name = "cigarette packet"
	desc = "The most popular brand of Space Cigarettes, sponsors of the Space Olympics."
	icon = 'icons/obj/cigarettes.dmi'
	icon_state = "cigpacket"
	item_state = "cigpacket"
	w_class = 1
	throwforce = 2
	slot_flags = SLOT_BELT
	storage_slots = 6
	can_hold = list("/obj/item/clothing/mask/cigarette")
	cant_hold = list("/obj/item/clothing/mask/cigarette/cigar",
		"/obj/item/clothing/mask/cigarette/pipe")
	icon_type = "cigarette"
	var/list/unlaced_cigarettes = list() // Cigarettes that haven't received reagents yet
	var/default_reagents = list("nicotine" = 15) // List of reagents to pre-generate for each cigarette

/obj/item/weapon/storage/fancy/cigarettes/New()
	..()
	flags |= NOREACT
	create_reagents(30 * storage_slots)//so people can inject cigarettes without opening a packet, now with being able to inject the whole one
	for(var/i = 1 to storage_slots)
		var/obj/item/clothing/mask/cigarette/C = new /obj/item/clothing/mask/cigarette(src)
		unlaced_cigarettes += C
		for(var/R in default_reagents)
			reagents.add_reagent(R, default_reagents[R])


/obj/item/weapon/storage/fancy/cigarettes/Destroy()
	qdel(reagents)
	return ..()


/obj/item/weapon/storage/fancy/cigarettes/update_icon()
	icon_state = "[initial(icon_state)][contents.len]"
	desc = "There are [contents.len] cig\s left!"
	return

/obj/item/weapon/storage/fancy/cigarettes/proc/lace_cigarette(var/obj/item/clothing/mask/cigarette/C as obj)
	if(istype(C) && (C in unlaced_cigarettes)) // Only transfer reagents to each cigarette once
		reagents.trans_to(C, (reagents.total_volume/unlaced_cigarettes.len))
		unlaced_cigarettes -= C
		reagents.maximum_volume = 30 * unlaced_cigarettes.len

/obj/item/weapon/storage/fancy/cigarettes/remove_from_storage(obj/item/W as obj, atom/new_location)
	lace_cigarette(W)
	..()

/obj/item/weapon/storage/fancy/cigarettes/attack(mob/living/carbon/M as mob, mob/living/carbon/user as mob)
	if(!istype(M, /mob))
		return

	if(istype(M) && M == user && user.zone_sel.selecting == "mouth" && contents.len > 0 && !user.wear_mask)
		var/obj/item/clothing/mask/cigarette/C = contents[contents.len]
		if(!istype(C)) return
		lace_cigarette(C)
		user.equip_to_slot_if_possible(C, slot_wear_mask)
		user << "<span class='notice'>You take a cigarette out of the pack.</span>"
		update_icon()
	else
		..()

/obj/item/weapon/storage/fancy/cigarettes/dromedaryco
	name = "\improper DromedaryCo packet"
	desc = "A packet of six imported DromedaryCo cancer sticks. A label on the packaging reads, \"Wouldn't a slow death make a change?\""
	icon_state = "Dpacket"
	item_state = "cigpacket"
	default_reagents = list("nicotine" = 15)

/obj/item/weapon/storage/fancy/cigarettes/syndicate
	name = "\improper Syndicate Cigarettes"
	desc = "A packet of six evil-looking cigarettes, A label on the packaging reads, \"Donk Co\""
	icon_state = "robustpacket"
	item_state = "cigpacket"
	default_reagents = list("nicotine" = 25, "toxin" = 2)

/obj/item/weapon/storage/fancy/cigarettes/syndicate/New()
	..()
	var/new_name = pick("evil", "suspicious", "ominous", "donk-flavored", "robust", "sneaky")
	name = "[new_name] cigarette packet"

/obj/item/weapon/storage/fancy/cigarettes/cigpack_syndicate
	name = "cigarette packet"
	desc = "An obscure brand of cigarettes."
	icon_state = "syndiepacket"
	item_state = "cigpacket"
	default_reagents = list("nicotine" = 15, "inaprovaline" = 10)

/obj/item/weapon/storage/fancy/cigarettes/cigpack_uplift
	name = "\improper Uplift Smooth packet"
	desc = "Your favorite brand, now menthol flavored."
	icon_state = "upliftpacket"
	item_state = "cigpacket"
	default_reagents = list("nicotine" = 15, "inaprovaline" = 5)

/obj/item/weapon/storage/fancy/cigarettes/cigpack_robust
	name = "\improper Robust packet"
	desc = "Smoked by the robust."
	icon_state = "robustpacket"
	item_state = "cigpacket"

/obj/item/weapon/storage/fancy/cigarettes/cigpack_robustgold
	name = "\improper Robust Gold packet"
	desc = "Smoked by the truly robust."
	icon_state = "robustgpacket"
	item_state = "cigpacket"
	default_reagents = list("nicotine" = 15, "gold" = 5)

/obj/item/weapon/storage/fancy/cigarettes/cigpack_carp
	name = "\improper Carp Classic packet"
	desc = "Since 2313."
	icon_state = "carppacket"
	item_state = "cigpacket"
	default_reagents = list("nicotine" = 25)

/obj/item/weapon/storage/fancy/cigarettes/cigpack_midori
	name = "\improper Midori Tabako packet"
	desc = "You can't understand the runes, but the packet smells funny."
	icon_state = "midoripacket"
	item_state = "cigpacket"
	default_reagents = list("nicotine" = 20)

/obj/item/weapon/storage/fancy/cigarettes/cigpack_shadyjims
	name ="\improper Shady Jim's Super Slims"
	desc = "Is your weight slowing you down? Having trouble running away from gravitational singularities? Can't stop stuffing your mouth? Smoke Shady Jim's Super Slims and watch all that fat burn away. Guaranteed results!"
	icon_state = "shadyjimpacket"
	item_state = "cigpacket"
	default_reagents = list("nicotine" = 20)

/obj/item/weapon/storage/fancy/cigarettes/kanser_sticks
	name ="\improper Kanser Sticks"
	desc = "Kanser Sticks provide a smooth Kanser taste! Smoke your life away today!"
	icon_state = "kancersticks"
	item_state = "cigpacket"
	default_reagents = list("nicotine" = 30)

/obj/item/weapon/storage/fancy/cigarettes/holy_smokes
	name ="\improper Holy Smokes"
	desc = "Holy smokes! Guaranteed 100% heresy free! Say goodbye to heretical lung cancer!"
	icon_state = "holypacket"
	item_state = "cigpacket"
	default_reagents = list("nicotine" = 25, "holywater" = 5)

/obj/item/weapon/storage/fancy/cigarettes/lho_sticks
	name ="\improper Lho Sticks"
	desc = "Smooth Lho taste! The best in premium space cigarettes since 2401! Now with 25% more nicotine!"
	icon_state = "lhosticks"
	item_state = "cigpacket"
	default_reagents = list("nicotine" = 25, "hyperzine" = 5)

/obj/item/weapon/storage/fancy/cigarettes/admum_stikz
	name ="\improper AdmunStikz"
	desc = "'s Little sticks of fun! I wouldnt trust these at all."
	icon_state = "admun"
	item_state = "cigpacket"
	default_reagents = list("capsaicin" = 10, "condensedcapsaicin" = 0.5)

/////////
//Cigar//
////////

/obj/item/weapon/storage/fancy/cigar
	name = "Premium Cigar Case"
	desc = "A case for holding your cigars when you are not smoking them."
	icon_state = "cigarcase"
	item_state = "cigarcase"
	icon = 'icons/obj/cigarettes.dmi'
	w_class = 1
	throwforce = 2
	slot_flags = SLOT_BELT
	storage_slots = 7
	can_hold = list(/obj/item/clothing/mask/smokable/cigarette/cigar)
	icon_type = "cigar"
	var/default_reagents = list("nicotine" = 25)

/obj/item/weapon/storage/fancy/cigar/New()
	..()
	flags |= NOREACT
	for(var/i = 1 to storage_slots)
		new /obj/item/clothing/mask/smokable/cigarette/cigar(src)
	create_reagents(15 * storage_slots)

/obj/item/weapon/storage/fancy/cigar/Del()
	del(reagents)
	..()

/obj/item/weapon/storage/fancy/cigar/update_icon()
	icon_state = "[initial(icon_state)][contents.len]"
	return

/obj/item/weapon/storage/fancy/cigar/remove_from_storage(obj/item/W as obj, atom/new_location)
		var/obj/item/clothing/mask/smokable/cigarette/cigar/C = W
		if(!istype(C)) return
		reagents.trans_to(C, (reagents.total_volume/contents.len))
		..()

/obj/item/weapon/storage/fancy/cigar/attack(mob/living/carbon/M as mob, mob/living/carbon/user as mob)
	if(!istype(M, /mob))
		return

	if(M == user && user.zone_sel.selecting == "mouth" && contents.len > 0 && !user.wear_mask)
		var/obj/item/clothing/mask/smokable/cigarette/cigar/W = new /obj/item/clothing/mask/smokable/cigarette/cigar(user)
		reagents.trans_to(W, (reagents.total_volume/contents.len))
		user.equip_to_slot_if_possible(W, slot_wear_mask)
		reagents.maximum_volume = 15 * contents.len
		contents.len--
		user << "<span class='notice'>You take a cigar out of the case.</span>"
		update_icon()
	else
		..()

/obj/item/weapon/storage/fancy/cigar/cohiba
	name = "Premium Cohiba Cigar Case"
	desc = "A case for holding your cigars when you are not smoking them."
	icon_state = "cigarcase"
	item_state = "cigarcase"
	icon = 'icons/obj/cigarettes.dmi'
	can_hold = list(/obj/item/clothing/mask/cigarette/cigar/cohiba)
	icon_type = "cigar2off"
	default_reagents = list("nicotine" = 30)

/obj/item/weapon/storage/fancy/cigar/havana
	name = "Premium Hohiba Cigar Case"
	desc = "A case for holding your cigars when you are not smoking them."
	icon_state = "cigarcase"
	item_state = "cigarcase"
	icon = 'icons/obj/cigarettes.dmi'
	can_hold = list(/obj/item/clothing/mask/cigarette/cigar/havana)
	icon_type = "cigar2off"
	default_reagents = list("nicotine" = 30)


/*
 * Vial Box
 */

/obj/item/weapon/storage/fancy/vials
	icon = 'icons/obj/vialbox.dmi'
	icon_state = "vialbox6"
	icon_type = "vial"
	name = "vial storage box"
	storage_slots = 6
	can_hold = list(/obj/item/weapon/reagent_containers/glass/beaker/vial)


/obj/item/weapon/storage/fancy/vials/New()
	..()
	for(var/i=1; i <= storage_slots; i++)
		new /obj/item/weapon/reagent_containers/glass/beaker/vial(src)
	return

/obj/item/weapon/storage/lockbox/vials
	name = "secure vial storage box"
	desc = "A locked box for keeping things away from children."
	icon = 'icons/obj/vialbox.dmi'
	icon_state = "vialbox0"
	item_state = "syringe_kit"
	max_w_class = 2
	can_hold = list(/obj/item/weapon/reagent_containers/glass/beaker/vial)
	max_storage_space = 12 //The sum of the w_classes of all the items in this storage item.
	storage_slots = 6
	req_access = list(access_virology)

/obj/item/weapon/storage/lockbox/vials/New()
	..()
	update_icon()

/obj/item/weapon/storage/lockbox/vials/update_icon(var/itemremoved = 0)
	var/total_contents = src.contents.len - itemremoved
	src.icon_state = "vialbox[total_contents]"
	src.overlays.Cut()
	if (!broken)
		overlays += image(icon, src, "led[locked]")
		if(locked)
			overlays += image(icon, src, "cover")
	else
		overlays += image(icon, src, "ledb")
	return

/obj/item/weapon/storage/lockbox/vials/attackby(obj/item/weapon/W as obj, mob/user as mob)
	..()
	update_icon()
