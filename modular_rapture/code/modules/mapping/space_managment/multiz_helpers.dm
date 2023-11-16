// for jukeboxSS
/proc/get_multiz_accessible_levels(center_z)
	. = list(center_z)
	var/other_z = center_z
	var/offset
	while((offset = SSmapping.level_trait(other_z, ZTRAIT_DOWN)))
		other_z += offset
		if(other_z in .)
			break	// no infinite loops
		. += other_z
	other_z = center_z
	while((offset = SSmapping.level_trait(other_z, ZTRAIT_UP)))
		other_z += offset
		if(other_z in .)
			break	// no infinite loops
		. += other_z
