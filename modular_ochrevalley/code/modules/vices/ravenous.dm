/mob
	var/maxnutrition = NUTRITION_LEVEL_FULL

/datum/charflaw/ravenous
	name = "Ravenous"
	desc = "No matter how much I eat, I still feel empty..."
	var/last_check = 0

/datum/charflaw/ravenous/flaw_on_life(mob/user)
	. = ..()
	if(world.time < last_check + 10 SECONDS)
		return
	if(!user)
		return
	if(user.stat == DEAD)
		return
	last_check = world.time
	
	user.maxnutrition += user.maxnutrition + 2.500
	if(user.maxnutrition * 0.8 > user.nutrition)
		user.add_stress(/datum/stressevent/hungy)
	else
		user.remove_stress(/datum/stressevent/hungy)

/datum/stressevent/hungy
	timer = 10 MINUTES
	stressadd = 5
	desc = span_red("I feel painfully empty, I need to eat more! More!!")
