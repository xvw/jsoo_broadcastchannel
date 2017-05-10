

let trace   = Common.get_by_id "trace"
let name    = Common.get_by_id "name"
let (bus, message) = 
  BroadcastChannel.create_with "say_hello" (Js.string "message")


let callback ev = 
  let d = ev##.data in 
  let _ = Common.text_in name (Js.to_string d)  in
  let _ = Common.write_in trace ("Received from [index.html]: " ^(Js.to_string ev##.data)) in
  Js._true

let _ = 
  BroadcastChannel.addEventListener
    bus
    (BroadcastChannel.message bus)
    (Dom.handler callback)
    Js._true
