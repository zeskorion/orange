// OV File

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

/datum/intent/shoot/arquebus/pistol
    chargetime = 1 SECONDS
    chargedrain = 0

/datum/intent/shoot/arquebus/pistol/can_charge()
    return TRUE

/datum/intent/arc/arquebus/pistol
    chargetime = 1 SECONDS
    chargedrain = 0

/datum/intent/arc/arquebus/pistol/can_charge()
	return TRUE

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
