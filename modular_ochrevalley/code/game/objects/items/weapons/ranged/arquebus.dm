// OV File

/datum/intent/shoot/arquebus
    chargetime = 1 // Fallback value if something that isn't a mob/living aims this.
    chargedrain = 0

/datum/intent/shoot/prewarning()
	if(masteritem && mastermob)
		mastermob.visible_message(span_warning("[mastermob] aims [masteritem]!"))
		playsound(mastermob, pick('sound/foley/equip/rummaging-01.ogg'), 100, FALSE)

/datum/intent/shoot/arquebus/get_chargetime()
	if(mastermob) // chargetime isn't used here. Returning chargetime if it's falsy doesn't make any sense either.
		var/newtime = 40
		newtime -= mastermob.get_skill_level(/datum/skill/combat/firearms) * 4.6 // skill block
		newtime -= mastermob.STAPER // per block
		return max(newtime, 1) // Master skill and 16 PER will hit the aim time floor.
	return chargetime

/datum/intent/arc/arquebus
	chargetime = 1
	chargedrain = 0

/datum/intent/arc/arquebus/prewarning()
	if(masteritem && mastermob)
		mastermob.visible_message(span_warning("[mastermob] aims [masteritem] for a precise shot!"))
		playsound(mastermob, pick('sound/foley/equip/rummaging-01.ogg'), 100, FALSE)

/datum/intent/arc/arquebus/get_chargetime()
	if(mastermob)
		var/newtime = 40
		newtime -= mastermob.get_skill_level(/datum/skill/combat/firearms) * 4.6
		newtime -= mastermob.STAPER
		return max(newtime, 12) // Raise the aim time floor like bow arc, instead of raising the floor and making it much faster to reach it like crossbow arc.
	return chargetime

/obj/item/gun/ballistic/arquebus/attackby(obj/item/A, mob/living/carbon/user, params) // Reloading code for rifle
	if (gunchannel) // If you send null, you're going to stop all sound channels!
		user.stop_sound_channel(gunchannel)
	var/firearm_skill = (user?.mind ? user.get_skill_level(/datum/skill/combat/firearms) : 1)
	var/load_time_skill = load_time - (load_time * firearm_skill / 10) // 10% faster for each skill level
	gunchannel = SSsounds.random_available_channel()

	if(istype(A, /obj/item/ammo_box) || istype(A, /obj/item/ammo_casing))
		if(user.get_inactive_held_item() != src) // You have to hold it to load it.
			return
		if(chambered)
			to_chat(user, "<span class='warning'>There is already [chambered] in [src]!</span>")
			return
		if(!gunpowder)
			to_chat(user, "<span class='warning'>You must fill [src] with gunpowder first!</span>")
			return
		if(!istype(A, /obj/item/ammo_casing/caseless/rogue/bullet))
			to_chat(user, "<span class='warning'>[A] cannot be fired from [src].</span>")
			return
		playsound(src, 'modular_causticcove/sound/arquebus/musketload.ogg',  100)
		user.visible_message("<span class='notice'>[user] forces [A] down the barrel of [src].</span>")
		..()

	if(istype(A, /obj/item/powderflask))
		if(user.get_inactive_held_item() != src) // You have to hold it to load it.
			return
		if(gunpowder)
			user.visible_message("<span class='warning'>[src] is already filled with gunpowder!</span>")
			return
		playsound(src, 'modular_causticcove/sound/arquebus/pour_powder.ogg',  100)
		if(do_after(user, load_time_skill, src))
			user.visible_message("<span class='notice'>[user] fills [src] with gunpowder.</span>")
			gunpowder = TRUE
		return
	if(istype(A, /obj/item/ramrod))
		var/obj/item/ramrod/R=A
		if(!reloaded && chambered)
			if(user.get_inactive_held_item() != src) // You have to hold it to load it.
				return
			user.visible_message("<span class='notice'>[user] begins ramming the [R] down the barrel of [src].</span>")
			playsound(src, 'modular_causticcove/sound/arquebus/ramrod.ogg',  100)
			if(do_after(user, load_time_skill, src))
				user.visible_message("<span class='notice'>[user] has finished reloading [src].</span>")
				reloaded = TRUE
			return
		if(reloaded && !myrod)
			user.transferItemToLoc(R, src)
			myrod = R
			playsound(src, 'modular_causticcove/sound/sheath_sounds/put_back_dagger.ogg',  100)
			user.visible_message("<span class='notice'>[user] stows [R] under the barrel of [src].</span>")
		if(!chambered && !myrod)
			user.transferItemToLoc(R, src)
			myrod = R
			playsound(src, 'modular_causticcove/sound/sheath_sounds/put_back_dagger.ogg',  100)
			user.visible_message("<span class='notice'>[user] stows [R] under the barrel of [src] without chambering it.</span>")
		if(!myrod == null)
			to_chat(user, span_warning("There's already a [R] inside of [src]."))
			return
	user.stop_sound_channel(gunchannel)

/datum/intent/shoot/arquebus/pistol
    chargetime = 1
    chargedrain = 0

/datum/intent/shoot/arquebus/pistol/can_charge()
    return TRUE

/datum/intent/arc/arquebus/pistol
    chargetime = 12
    chargedrain = 0

/datum/intent/arc/arquebus/pistol/can_charge()
	return TRUE

/obj/item/gun/ballistic/arquebus/pistol
    name = "arquebus pistol"
    icon = 'icons/roguetown/weapons/32.dmi'
    icon_state = "pistol"
    item_state = "pistol"
    force_wielded = null
    possible_item_intents = list(/datum/intent/shoot/arquebus/pistol, /datum/intent/arc/arquebus/pistol, /datum/intent/mace/strike/wood)
    gripped_intents = null
    pixel_y = 0
    pixel_x = 0
    bigboy = FALSE
    gripsprite = FALSE
    wlength = WLENGTH_SHORT
    w_class = WEIGHT_CLASS_SMALL
    equip_delay_self = 1.5 SECONDS
    unequip_delay_self = 1.5 SECONDS
    inv_storage_delay = 2 SECONDS
    walking_stick = FALSE
    smeltresult = /obj/item/ash
    slot_flags = ITEM_SLOT_HIP
    range = 10
    var/can_spin = TRUE
    var/last_spunned
    var/spin_cooldown = 3 SECONDS

/obj/item/gun/ballistic/arquebus/pistol/getonmobprop(tag)
    . = ..()
    if(tag)
        switch(tag)
            if("gen")
                return list("shrink" = 0.4,"sx" = -10,"sy" = -8,"nx" = 13,"ny" = -8,"wx" = -8,"wy" = -7,"ex" = 7,"ey" = -8,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0,"nturn" = 30,"sturn" = -30,"wturn" = -30,"eturn" = 30,"nflip" = 0,"sflip" = 8,"wflip" = 8,"eflip" = 0)
            if("onbelt")
                return list("shrink" = 0.3,"sx" = -2,"sy" = -5,"nx" = 4,"ny" = -5,"wx" = 0,"wy" = -5,"ex" = 2,"ey" = -5,"nturn" = 0,"sturn" = 0,"wturn" = 0,"eturn" = 0,"nflip" = 0,"sflip" = 0,"wflip" = 0,"eflip" = 0,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0)

/obj/item/gun/ballistic/arquebus/pistol/attack_self(mob/living/user)
	var/string = "smoothly"
	var/list/strings_noob = list("unsurely", "nervously", "anxiously", "timidly", "shakily", "clumsily", "fumblingly", "awkwardly")
	var/list/strings_moderate = list("smoothly", "confidently", "determinately", "calmly", "skillfully", "decisively")
	var/list/strings_pro = list("masterfully", "expertly", "flawlessly", "elegantly", "artfully", "impeccably")
	var/firearm_skill = (user?.mind ? user.get_skill_level(/datum/skill/combat/firearms) : 1)
	var/noob_spin_sound = 'sound/combat/weaponr1.ogg'
	var/pro_spin_sound = 'modular_causticcove/sound/arquebus/gunspin.ogg'
	var/spin_sound
	if(firearm_skill <= 2)
		string = pick(strings_noob)
		spin_sound = noob_spin_sound
	if((firearm_skill > 2) && (firearm_skill <= 4))
		string = pick(strings_moderate)
		spin_sound = pro_spin_sound
	if((firearm_skill > 4) && (firearm_skill <= 6))
		string = pick(strings_pro)
		spin_sound = pro_spin_sound
	if(world.time > last_spunned + spin_cooldown)
		can_spin = TRUE
	if(can_spin)
		user.play_overhead_indicator('icons/effects/effects.dmi', "emote", 10, OBJ_LAYER)
		user.visible_message("<span class='emote'>[user] spins [src] around their fingers [string]!</span>")
		playsound(src, spin_sound, 100, FALSE, ignore_walls = FALSE)
		last_spunned = world.time
		/*if(firearm_skill <= 2)
			if(prob(35))
				shoot_live_shot(message = 0)
				user.visible_message("<span class='danger'>[user] accidentally discharges [src]!</span>")*/ // This is supposed to make the gun go off but someone forgot what they were doing while writing it I guess.
		if(firearm_skill <= 3)
			if(prob(50))
				user.visible_message("<span class='danger'>[user] accidentally drops [src]!</span>")
				user.dropItemToGround(src)
		can_spin = FALSE
