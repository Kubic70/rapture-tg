/obj/machinery/jukebox
	name = "jukebox"
	desc = "A classic music player."
	icon = 'icons/obj/machines/music.dmi'
	icon_state = "jukebox"
	verb_say = "states"
	density = TRUE
	payment_department = ACCOUNT_SRV
	//var/volume = 70
	var/queuecost = 40 //PRICE_CHEAP //Set to -1 to make this jukebox require access for queueing
	var/datum/track/playing = null
	var/datum/track/selectedtrack = null
	var/list/queuedplaylist = list()
	var/selectedStyle = null
	var/queuecooldown //This var exists solely to prevent accidental repeats of John Mulaney's 'What's New Pussycat?' incident. Intentional, however......

/obj/machinery/jukebox/Destroy()
	dance_over()
	return ..()

/obj/machinery/jukebox/emag_act(mob/user)
	. = ..()
	if(obj_flags & EMAGGED)
		return
	log_admin("[key_name(usr)] emagged [src] at [AREACOORD(src)]")
	obj_flags |= EMAGGED
	queuecost = 0//PRICE_FREE
	req_one_access = null
	to_chat(user, "<span class='notice'>You've bypassed [src]'s audio volume limiter, and enabled free play.</span>")
	return TRUE

/obj/machinery/jukebox/ui_status(mob/user)
	if(!anchored)
		to_chat(user,"<span class='warning'>This device must be anchored by a wrench!</span>")
		return UI_CLOSE
	if((queuecost < 0 && !allowed(user)) && !isobserver(user))
		to_chat(user,"<span class='warning'>Error: Access Denied.</span>")
		user.playsound_local(src, 'sound/misc/compiler-failure.ogg', 25, TRUE)
		return UI_CLOSE
	if(!SSjukeboxes.songs.len && !isobserver(user))
		to_chat(user,"<span class='warning'>Error: No music tracks have been authorized for your station. Petition Central Command to resolve this issue.</span>")
		playsound(src, 'sound/misc/compiler-failure.ogg', 25, TRUE)
		return UI_CLOSE
	return ..()

/obj/machinery/jukebox/ui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "Jukebox_r", name)
		ui.open()


/obj/machinery/jukebox/ui_data(mob/user)
	var/list/data = list()
	data["active"] = active
	data["songs"] = list()
	for(var/datum/track/S in SSjukeboxes.songs)
		var/list/track_data = list(name = S.song_name)
		data["songs"] += list(track_data)
	data["styles"] = SSjukeboxes.styles
	data["queued_tracks"] = list()
	for(var/datum/track/S in queuedplaylist)
		var/list/track_data = list(name = S.song_name)
		data["queued_tracks"] += list(track_data)
	data["track_selected"] = null
	data["track_length"] = null
	if(playing)
		data["track_selected"] = playing.song_name
		data["track_length"] = DisplayTimeText(playing.song_length)
	data["volume"] = volume
	data["is_emagged"] = (obj_flags & EMAGGED)
	data["cost_for_play"] = queuecost
	data["has_access"] = allowed(user)
	return data

/obj/machinery/jukebox/ui_act(action, list/params)
	. = ..()
	if(.)
		return

	switch(action)
		if("toggle")
			if(QDELETED(src))
				return
			if(!allowed(usr))
				return
			if(!active && !playing)
				activate_music()
			else
				stop = 0
			return TRUE
		if("add_to_queue")
			var/list/available = list()
			for(var/datum/track/S in SSjukeboxes.songs)
				available[S.song_name] = S
			var/selected = params["track"]
			if(QDELETED(src) || !selected || !istype(available[selected], /datum/track))
				return
			selectedtrack = available[selected]
			if(world.time < queuecooldown)
				return
			if(!istype(selectedtrack, /datum/track))
				return
			if(!allowed(usr) && queuecost)
				var/obj/item/card/id/C
				if(isliving(usr))
					var/mob/living/L = usr
					C = L.get_idcard(TRUE)
				/*if(!can_transact(C))
					queuecooldown = world.time + (1 SECONDS)
					playsound(src, 'sound/misc/compiler-failure.ogg', 25, TRUE)
					return
				if(!attempt_transact(C, queuecost))
					say("Insufficient funds.")
					queuecooldown = world.time + (1 SECONDS)
					playsound(src, 'sound/misc/compiler-failure.ogg', 25, TRUE)
					return*/
				to_chat(usr, "<span class='notice'>You spend [queuecost] credits to queue [selectedtrack.song_name].</span>")
				log_econ("[queuecost] credits were inserted into [src] by [key_name(usr)] (ID: [C.registered_name]) to queue [selectedtrack.song_name].")
			queuedplaylist += selectedtrack
			if(active)
				say("[selectedtrack.song_name] has been added to the queue.")
			else if(!playing)
				activate_music()
			playsound(src, 'sound/machines/ping.ogg', 50, TRUE)
			queuecooldown = world.time + (3 SECONDS)
			return TRUE
		if("select_track")
			var/list/available = list()
			for(var/datum/track/S in SSjukeboxes.songs)
				available[S.song_name] = S
			var/selected = params["track"]
			if(QDELETED(src) || !selected || !istype(available[selected], /datum/track))
				return
			selectedtrack = available[selected]
			return TRUE
		if("set_volume")
			if(!allowed(usr))
				return
			var/new_volume = params["volume"]
			if(new_volume  == "reset")
				volume = initial(volume)
			else if(new_volume == "min")
				volume = 0
			else if(new_volume == "max")
				volume = ((obj_flags & EMAGGED) ? 1000 : 100)
			else if(text2num(new_volume) != null)
				volume = clamp(0, text2num(new_volume), ((obj_flags & EMAGGED) ? 1000 : 100))
			var/wherejuke = SSjukeboxes.findjukeboxindex(src)
			if(wherejuke)
				SSjukeboxes.updatejukebox(wherejuke, jukefalloff = volume/35)
			return TRUE

/obj/machinery/jukebox/proc/activate_radio()
	if(playing || selectedStyle == null)
		return FALSE
	var/radioList = list()
	var/datum/track/T
	for(T in songs)
		if(T.song_style == selectedStyle)
			radioList |= T
	if(length(radioList) == 0)
		return FALSE
	playing = pick(radioList)
	var/jukeboxslottotake = SSjukeboxes.addjukebox(src, playing, volume/35)
	if(jukeboxslottotake)
		active = TRUE
		update_icon()
		START_PROCESSING(SSobj, src)
		stop = world.time + playing.song_length
		say("Сейчас играет: [playing.song_name]")
		playsound(src, 'sound/machines/terminal_insert_disc.ogg', 50, TRUE)
		return TRUE
	else
		return FALSE

/obj/machinery/jukebox/activate_music()
	if(playing || !queuedplaylist.len)
		return FALSE
	playing = queuedplaylist[1]
	var/jukeboxslottotake = SSjukeboxes.addjukebox(src, playing, volume/35)
	if(jukeboxslottotake)
		active = TRUE
		update_icon()
		update_use_power(ACTIVE_POWER_USE)
		START_PROCESSING(SSobj, src)
		stop = world.time + playing.song_length
		queuedplaylist.Cut(1, 2)
		say("Сейчас играет: [playing.song_name]")
		playsound(src, 'sound/machines/terminal_insert_disc.ogg', 50, TRUE)
		return TRUE
	else
		return FALSE

/obj/machinery/jukebox/disco/activate_music()
	. = ..()
	if(!.)
		return
	dance_setup()
	lights_spin()

/obj/machinery/jukebox/disco/activate_radio()
	. = ..()
	if(!.)
		return
	dance_setup()
	lights_spin()

/obj/machinery/jukebox/dance_over()
	var/position = SSjukeboxes.findjukeboxindex(src)
	if(!position)
		return
	SSjukeboxes.removejukebox(position)
	update_use_power(IDLE_POWER_USE)
	STOP_PROCESSING(SSobj, src)
	playing = null
	rangers = list()

/*
/obj/machinery/jukebox/process()
	if(active)
		if(world.time >= stop)
			active = FALSE
			dance_over()
			if(stop && queuedplaylist.len)
				activate_music()
			else
				playsound(src,'sound/machines/terminal_off.ogg',50,1)
				update_icon()
				playing = null
				stop = 0
//		else if(volume > 750) // BOOM BOOM BOOM BOOM
//			for(var/mob/living/carbon/C in hearers(round(volume/35), src)) // I WANT YOU IN MY ROOM
//				if(istype(C)) // LETS SPEND THE NIGHT TOGETHER
//					C.adjustEarDamage(max((((volume/100) - sqrt(get_dist(C, src) * 2)) - C.get_ear_protection())*0.1, 0)) // FROM NOW UNTIL FOREVER
*/

/*
/obj/machinery/jukebox/disco/process()
	. = ..()
	if(active)
		//for(var/mob/living/M in rangers)
		for(var/mob/living/M in hearers(2, src))
			if(prob(5+(allowed(M)*4)) && CHECK_MOBILITY(M, MOBILITY_MOVE) && (!M.client || !(M.client.prefs.cit_toggles & NO_DISCO_DANCE)))
				dance(M)
*/
