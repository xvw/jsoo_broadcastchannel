let a = BroadcastChannel.create "testLDKZLMKD"

let () = Firebug.console##log(a)
let () = Firebug.console##log(BroadcastChannel.name a)

let () = BroadcastChannel.close(a)
