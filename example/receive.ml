let trace   = Common.get_by_id "trace"
let name    = Common.get_by_id "name"
let bus     = Common.StringBus.create "say_hello"

let _ = 
  Lwt_js_events.(
    async_loop
      Common.StringBus.Event.lwt_js_message
      bus
      (fun ev _ ->
        let _ = Common.text_in name (Js.to_string ev##.data)  in
        let _ = Common.write_in trace ("Received from [index.html]: " ^(Js.to_string ev##.data)) in
        Lwt.return_unit
      )
  )
