let trace   = Common.get_by_id "trace"
let name    = Common.get_by_id "name"
let bus : Js.js_string Js.t BroadcastChannel.t = 
  BroadcastChannel.create "say_hello"

let _ = 
  BroadcastChannel.on
    bus
    (fun ev ->
      let d = ev##.data in 
      let _ = Common.text_in name (Js.to_string d)  in
      let _ = Common.write_in trace ("Received from [index.html]: " ^(Js.to_string ev##.data)) in
      Js._true
    )
