
/proc/init_bark_lists()
	for(var/path in subtypesof(/datum/bark))
		var/datum/bark/B = new path()
		GLOB.bark_list[B.id] = path
		if(B.allow_random)
			GLOB.bark_random_list[B.id] = path

