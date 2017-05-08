let a = BroadcastChannel.create "test"

let () = Firebug.console##log(a)
let () = Firebug.console##log(Js.string (BroadcastChannel.name a))

let () = BroadcastChannel.close(a)
