
open Weaver
open Consts

       		     
module OrdAnim=struct
  type t=string
  let compare:string->string->int = compare
end

	
		    
module AnimData = Map.Make (OrdAnim)
let ( +> ) database animation= let open Timeline in
			       AnimData.add animation.name animation database
			   
let animator = AnimData.empty
	       +> Atmospheric.animation
	       +> Atmospheric_half.animation
	       +> Convergence.animation
	       +> Markov2d.animation
	       +> Markov3d.animation
	       +> Asep.animation
		    
		   
let null_animation =
  let nothing status element = () in
  Timeline.{name = "nothing"; run=nothing; step =nothing; suspend = nothing }

	     		
let animator s =  try AnimData.find s animator with
		  |Not_found -> null_animation
		     

let slides = Slides.getRaws document
let frame_info = let n_slides = slides##length in
		 Engine.{n_slides; current=0}
		   
let events = ref Engine.no_events
let font_size = ref 200
				  
	
let () = 
  let slides = Engine.slide_prepare slides in
  let () = Slides.(  Utils.node_iter slides add_title ) in
  let () = Utils.seq_ document Decorations.[ center; css_width ] in 
  let _ = Lwt_js_events.keydowns window @@ Engine.keyboard_action font_size animator events frame_info in
  ignore @@ Engine.pick_frame animator events 0
