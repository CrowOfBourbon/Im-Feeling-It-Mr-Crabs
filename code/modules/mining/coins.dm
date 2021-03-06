/*****************************Coin********************************/

/obj/item/weapon/coin
	icon = 'icons/obj/items.dmi'
	name = "Coin"
	icon_state = "coin"
	flags = CONDUCT
	force = 1.0
	throwforce = 2.0
	w_class = 1.0
	slot_flags = SLOT_EARS
	var/string_attached
	var/sides = 2
	var/list/sideslist = list("heads","tails")
	var/cmineral = null
	var/cooldown = 0
	var/value = 10

/obj/item/weapon/coin/New()
	pixel_x = rand(0,16)-8
	pixel_y = rand(0,8)-8

	if(cmineral)
		name = "[cmineral] coin"

/obj/item/weapon/coin/gold
	name = "gold coin"
	cmineral = "gold"
	icon_state = "coin_gold"
	value = 250

/obj/item/weapon/coin/silver
	name = "silver coin"
	cmineral = "silver"
	icon_state = "coin_silver"
	value = 140

/obj/item/weapon/coin/diamond
	name = "diamond coin"
	cmineral = "diamond"
	icon_state = "coin_diamond"
	value = 200

/obj/item/weapon/coin/iron
	name = "iron coin"
	cmineral = "iron"
	icon_state = "coin_iron"
	value = 80

/obj/item/weapon/coin/phoron
	name = "solid phoron coin"
	cmineral = "phoron"
	icon_state = "coin_phoron"
	value = 240

/obj/item/weapon/coin/uranium
	name = "uranium coin"
	cmineral = "uranium"
	icon_state = "coin_uranium"
	value = 120

/obj/item/weapon/coin/platinum
	name = "platinum coin"
	cmineral = "adamantine"
	icon_state = "coin_adamantine"
	value = 120

/obj/item/weapon/coin/attackby(obj/item/weapon/W as obj, mob/user as mob)
	if(istype(W,/obj/item/stack/cable_coil))
		var/obj/item/stack/cable_coil/CC = W
		if(string_attached)
			user << "<span class='notice'>There already is a string attached to this coin.</span>"
			return
		if (CC.use(1))
			overlays += image('icons/obj/items.dmi',"coin_string_overlay")
			string_attached = 1
			user << "<span class='notice'>You attach a string to the coin.</span>"
		else
			user << "<span class='notice'>This cable coil appears to be empty.</span>"
		return
	else if(istype(W,/obj/item/weapon/wirecutters))
		if(!string_attached)
			..()
			return

		var/obj/item/stack/cable_coil/CC = new/obj/item/stack/cable_coil(user.loc)
		CC.amount = 1
		CC.update_icon()
		overlays = list()
		string_attached = null
		user << "\blue You detach the string from the coin."
	else ..()

/obj/item/weapon/coin/attack_self(mob/user as mob)
	var/result = rand(1, sides)
	var/comment = ""
	if(result == 1)
		comment = "tails"
	else if(result == 2)
		comment = "heads"
	user.visible_message("<span class='notice'>[user] has thrown \the [src]. It lands on [comment]! </span>", \
						 "<span class='notice'>You throw \the [src]. It lands on [comment]! </span>")
