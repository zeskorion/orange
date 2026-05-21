/client/proc/spawn_player(var/client/C in GLOB.clients)
	set name = "Spawn Player"
	set desc = "Spawn a character as a specified job, with their currently loaded char slot"
	set category = "-Admin-"
	if(!holder)
		return
	//Setup and option selections
	if(!istype(C.mob, /mob/dead))
		if(alert(usr, "Target is still alive, are you sure you want to delete and respawn them?", "Target Still Alive!", "Yes", "No") == "No")
			return
	var/list/job_list = sortList(build_loadout_job_list())
	var/selected_title = tgui_input_list(usr, "Select a job to spawn [C.key] as:", "Job Selection", job_list)
	var/selected_job_path = job_list[selected_title]
	if(!selected_job_path)
		to_chat(usr, span_warning("No Job Selected!"))
		return
	var/selected_advclass_path = null
	var/is_migrant = ispath(selected_job_path, /datum/migrant_role)
	if(is_migrant)
		var/datum/migrant_role/migrant_datum = new selected_job_path()
		if(migrant_datum.advclass_cat_rolls && length(migrant_datum.advclass_cat_rolls))
		
			// Get advclasses from the role class handler
			var/list/advclass_choices = list()
			for(var/category in migrant_datum.advclass_cat_rolls)
				for(var/datum/advclass/advclass_instance in SSrole_class_handler.sorted_class_categories[category])
					advclass_choices[advclass_instance.name] = advclass_instance.type
			
			qdel(migrant_datum)
			
			if(length(advclass_choices))
				var/selected = tgui_input_list(usr, "Select advclass:", "Advclass Selection", sortList(advclass_choices))
				to_chat(usr, span_notice("Advclass selected: [selected]"))
				selected_advclass_path = advclass_choices[selected]
	else
		// Regular job
		var/datum/job/selected_job
		for(var/datum/job/J in SSjob.occupations)
			if(J.type == selected_job_path)
				selected_job = J
				break
		
		if(selected_job && selected_job.job_subclasses && length(selected_job.job_subclasses))
			var/list/advclass_choices = list()
			for(var/advclass_path in selected_job.job_subclasses)
				var/datum/advclass/AC = advclass_path
				advclass_choices[initial(AC.name)] = advclass_path
			
			var/selected = tgui_input_list(usr, "Select advclass:", "Advclass Selection", sortList(advclass_choices))
			to_chat(usr, span_notice("Advclass selected: [selected]"))
			selected_advclass_path = advclass_choices[selected]
	var/turf/location = usr.loc //Fallback to self if the location doesn't exist
	switch(alert(usr,"Where should [C.prefs.real_name] be spawned?", "Where to spawn?", "Here", "Offset", "Coordinates"))
		if("Offset")
			var/x = input(usr, "Set X offset", "X Offset", 0) as num
			var/y = input(usr, "Set Y offset", "Y Offset", 0) as num
			var/z = input(usr, "Set Z offset", "Z Offset", 0) as num
			location = locate(usr.loc.x + x, usr.loc.y + y, usr.loc.z + z)
		if("Coordinates")
			var/x = input(usr, "Set X position", "X Position", 0) as num
			var/y = input(usr, "Set Y position", "Y Position", 0) as num
			var/z = input(usr, "Set Z position", "Z Position", 0) as num
			location = locate(0 + x, 0 + y, 0 + z)
	if(alert(usr, "You are spawning [C.prefs.real_name]/([C.ckey]) as [selected_title] at ([location.x],[location.y],[location.z]), is this correct?", "Confirmation", "Yes", "Cancel") == "Cancel")
		return
	//Actual Spawning stuff
	var/mob/living/carbon/human/new_character = new
	GLOB.loadout_selected_jobs[REF(new_character)] = selected_job_path
	if(selected_advclass_path)
		GLOB.loadout_selected_advclasses[REF(new_character)] = selected_advclass_path
	C.prefs.copy_to(new_character)
	new_character.dna.update_dna_identity()
	location.JoinPlayerHere(new_character, FALSE)
	if(C.mob) //Delete whatever they are
		qdel(C.mob)
	new_character.key = C.key
	new_character.roll_stats(null)
	apply_full_job_loadout(new_character, selected_job_path)
	apply_prefs_sizecat(new_character, C)
	apply_character_post_equipment(new_character,C)
	message_admins("[key_name_admin(usr)] has spawned [ADMIN_LOOKUPFLW(new_character)] as [selected_title].")
	log_admin("[key_name(usr)] has spawned [key_name(new_character)] as [selected_title].")
	

	
