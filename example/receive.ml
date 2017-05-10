

let trace   = Common.get_by_id "trace"
let name    = Common.get_by_id "name"
let (bus, _) = 
  BroadcastChannel.create_with "say_hello" (Js.string "message")


let callback ev _ = 
  let d = ev##.data in 
  let _ = Common.text_in name (Js.to_string d)  in
  let _ = Common.write_in trace ("Received from [index.html]: " ^(Js.to_string ev##.data)) in
  Lwt.return_unit

let _ = 
  Lwt_js_events.async_loop
    BroadcastChannel.lwt_js_message
    bus
    callback
