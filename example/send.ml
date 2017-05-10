let message = Common.get_input "message"
let btn     = Common.get_by_id "send"
let trace   = Common.get_by_id "trace"
let bus     = BroadcastChannel.create "say_hello"

let _ = 
  Lwt_js_events.(
    async_loop
      click
      btn
      (fun _ _ ->
        let value = message##.value in
        let _ = Common.write_in trace ("Send to [receive.html]: " ^(Js.to_string value)) in
        let _ = BroadcastChannel.post bus value in
        Lwt.return_unit
      )
  )
