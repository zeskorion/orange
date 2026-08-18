/datum/advclass/wretch/madtinkerer //The wretch evolution of a tinkerer who goes a bit too far. Similar to munitioneer- but with gadgets instead of a riddle of steel, and magic instead of miracles
	name = "Mad Tinkerer"
	tutorial = "Your craft has fascinated you beyond what most would consider reasonable limits. No lawful guild would fund your machinations. No matter. Your work will continue, at any cost."
	outfit = /datum/outfit/job/roguetown/wretch/madtinkerer
	cmode_music = 'sound/music/combat_dwarf.ogg'
	class_select_category = CLASS_CAT_ROGUE
	category_tags = list(CTAG_WRETCH)
	traits_applied = list(TRAIT_TRAINED_SMITH, TRAIT_INTELLECTUAL, TRAIT_ARCYNE, TRAIT_SMITHING_EXPERT, TRAIT_ALCHEMY_EXPERT)
	subclass_stats = list(
		STATKEY_INT = 3,
		STATKEY_PER = 2,
		STATKEY_SPD = 1,
	)

subclass_skills = list(
		/datum/skill/combat/wrestling = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/unarmed = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/knives = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/crossbows = SKILL_LEVEL_APPRENTICE, //crossbows, firearms, and a big wrench
		/datum/skill/combat/firearms = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/maces = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/athletics = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/climbing = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/sneaking = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/swimming = SKILL_LEVEL_NOVICE,
		/datum/skill/misc/reading = SKILL_LEVEL_MASTER,
		/datum/skill/misc/lockpicking = SKILL_LEVEL_EXPERT,
		/datum/skill/craft/traps = SKILL_LEVEL_EXPERT,
		/datum/skill/craft/weaponsmithing = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/craft/armorsmithing = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/craft/blacksmithing = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/craft/engineering = SKILL_LEVEL_MASTER,
		/datum/skill/labor/mining = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/craft/smelting = SKILL_LEVEL_JOURNEYMAN, //similar skill list to munitioneer, but their skills start a touch lower, with the exception of Engineering
		/datum/skill/craft/crafting = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/craft/sewing = SKILL_LEVEL_APPRENTICE,
		/datum/skill/craft/tanning = SKILL_LEVEL_APPRENTICE,
		/datum/skill/craft/carpentry = SKILL_LEVEL_APPRENTICE,
		/datum/skill/craft/alchemy = SKILL_LEVEL_APPRENTICE,
		/datum/skill/magic/arcane = SKILL_LEVEL_JOURNEYMAN
	)

/datum/outfit/job/roguetown/wretch/madtinkerer/pre_equip(mob/living/carbon/human/H)
	to_chat(H, span_warning("Combat is not ideal, but you're no pushover. Your prowess would be called madness, to the close-minded folks of 'proper society'. They might even say your ambition will lead to ruin. You know better."))
	has_loadout = TRUE
	head = /obj/item/clothing/mask/rogue/facemask/steel/confessor/tinkerer
	shoes = /obj/item/clothing/shoes/roguetown/boots/leather/reinforced/labboots
	pants = /obj/item/clothing/under/roguetown/heavy_leather_pants
	wrists = /obj/item/clothing/wrists/roguetown/bracers/leather
	shirt = /obj/item/clothing/suit/roguetown/armor/gambeson/heavy
	armor = /obj/item/clothing/suit/roguetown/armor/leather/heavy/coat/labcoat
	gloves = /obj/item/clothing/gloves/roguetown/angle/labgloves
	cloak = /obj/item/clothing/suit/roguetown/shirt/robe/black
	belt = /obj/item/storage/belt/rogue/leather/black
	neck = /obj/item/clothing/neck/roguetown/leather
	backl = /obj/item/storage/backpack/rogue/backpack
	backr = /obj/item/rogueweapon/contraption/linker/mace/big/steel/precharged
	backpack_contents = list(
		/obj/item/rogueweapon/tongs/bronze = 1,
		/obj/item/chalk = 1,
		/obj/item/reagent_containers/glass/bottle/alchemical/healthpot = 1,
		/obj/item/rogueweapon/huntingknife = 1,
		/obj/item/rogueweapon/scabbard/sheath = 1,
		/obj/item/storage/belt/rogue/pouch/coins/mid = 1,
		/obj/item/rogueweapon/hammer/bronze = 1
		/obj/item/flashlight/flare/torch/lantern = 1
		/obj/item/clothing/mask/rogue/spectacles/golden = 1
		)
	if(H.mind)
		H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/engineeranalyze)
		var/weapons = list("Pistol", "Slurbow", "Arcyne Silver Dagger")
		var/weapon_choice = input(H, "Choose your sidearm.", "A COMPELLING ARGUMENT") as anything in weapons
		switch(weapon_choice)
			if("Pistol")
				H.adjust_skillrank_up_to(/datum/skill/combat/firearms, SKILL_LEVEL_EXPERT, TRUE)
				H.put_in_hands(new /obj/item/gun/ballistic/revolver/grenadelauncher/arquebus/pistol)
				beltl = /obj/item/quiver/bulletpouch/iron
				beltr = /obj/item/powderflask
			if("Slurbow")
				H.adjust_skillrank_up_to(/datum/skill/combat/crossbows, SKILL_LEVEL_EXPERT, TRUE)
				beltl = /obj/item/quiver/bolt/light
				beltr = /obj/item/gun/ballistic/revolver/grenadelauncher/crossbow/slurbow
			if("Arcyne Silver Dagger")
				H.adjust_skillrank_up_to(/datum/skill/combat/knives, SKILL_LEVEL_EXPERT, TRUE)
				H.put_in_hands(new /obj/item/rogueweapon/huntingknife/idagger/silver/arcyne)
				beltl = /obj/item/rogueweapon/scabbard/sheath
		var/fixations = list("Arcyne Secrets", "Transcend Humen Limitations", "Whimsy")
		var/fixation_choice = input(H, "What is your pursuit?", "THEY CALLED ME MAD!") as anything in fixations
		var/mage = FALSE
		switch(fixation_choice)
			if("Arcyne Secrets")
				H.mind.setup_mage_aspects(list("mastery" = FALSE, "major" = 1, "minor" = 3, "utilities" = 4, "allowed_majors" = list(/datum/magic_aspect/pyromancy, /datum/magic_aspect/ferramancy, /datum/magic_aspect/cryomancy, /datum/magic_aspect/kinesis, /datum/magic_aspect/battlewardry), "locked_aspects" = list(/datum/magic_aspect/artifice) "ward" = TRUE))
				mage = TRUE
			if("Transcend Humen Limitations")

			if("Whimsy")
		if(!mage)
			H.mind.setup_mage_aspects(list("mastery" = FALSE, "major" = 0, "minor" = 2, "utilities" = 4, "locked_aspects" = list(/datum/magic_aspect/artifice) "ward" = TRUE))
		wretch_select_bounty(H)

/obj/item/clothing/mask/rogue/facemask/steel/confessor/tinkerer
	name = "strange mask"
	desc = "A product of strange artifice, protecting the wearer from noxious fumes and shrapnel to the eyes. You can taste copper whenever you draw breath."
	icon_state = "tinkerermask"
	icon = 'modular_ochrevalley/icons/roguetown/clothing/masks.dmi'
	mob_overlay_icon = 'modular_ochrevalley/icons/roguetown/clothing/onmob/masks.dmi'
	max_integrity = ARMOR_INT_MASK_BRONZE
	resistance_flags = FIRE_PROOF | UNACIDABLE | ACID_PROOF
	armor = ARMOR_LABWEAR
	smeltresult = /obj/item/ingot/bronze
	block2add = null //similar to the malpractitioner's mask, you get full vision for the sake of drip. You do not, however, gain the full integrity of the confessor's mask

/obj/item/clothing/mask/rogue/facemask/steel/confessor/tinkerer/attackby(obj/item/I, mob/user, params)
	if(istype(I, /obj/item/clothing/mask/rogue/spectacles/inq))
		to_chat(user, span_info("The lenses won't fit your mask."))
	else
		return(..())

/obj/item/clothing/suit/roguetown/armor/leather/heavy/coat/labcoat
	name = "treated leather coat"
	desc = "A heavy coat of hide, reinforced with copper threads and bleached white by a potent alchemical treatment. Capable of withstanding extreme heat, and protecting the wearer, somewhat, from lightning."
	armor = ARMOR_LABWEAR
	resistance_flags = FIRE_PROOF | UNACIDABLE | ACID_PROOF
	max_integrity = ARMOR_INT_CHEST_LIGHT_MEDIUM
	color = "#acaaa8"

/obj/item/clothing/suit/roguetown/armor/leather/heavy/coat/labcoat/equipped(mob/user, slot)
	..()
	if(slot == SLOT_ARMOR)
		ADD_TRAIT(user, TRAIT_SHOCKIMMUNE, "labcoat") //not a terribly relevant trait here, but it'll come up at times
		return

/obj/item/clothing/suit/roguetown/armor/leather/heavy/coat/labcoat/dropped(mob/user, slot)
	..()
	if(slot != SLOT_ARMOR)
		REMOVE_TRAIT(user, TRAIT_SHOCKIMMUNE, "labcoat")
		return

/obj/item/clothing/gloves/roguetown/angle/labgloves
	name = "treated leather gloves"
	desc = "A pair of heavy leather gloves, treated for extreme resistance to heat and foul liquid alike."
	armor = ARMOR_LABWEAR
	resistance_flags = FIRE_PROOF | UNACIDABLE | ACID_PROOF
	color = "#131314"

/obj/item/clothing/shoes/roguetown/boots/leather/reinforced/labboots
	name = "treated leather boots"
	desc = "A pair of heavy leather boots, alchemically treated to resist both flame and acid."
	armor = ARMOR_LABWEAR
	resistance_flags = FIRE_PROOF | UNACIDABLE | ACID_PROOF
