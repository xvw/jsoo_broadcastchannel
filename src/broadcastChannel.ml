(* MIT License
 * 
 * Copyright (c) 2017 Xavier Van de Woestyne
 * 
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 * 
 * The above copyright notice and this permission notice shall be included in all
 * copies or substantial portions of the Software.
 * 
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
 * SOFTWARE.
 *)

exception Not_supported of string

type ('a, 'b) listener = 
  ('a, 'b) Dom_html.event_listener

class type ['message] messageEvent =
object 
  inherit ['message] EventSource.messageEvent
end

type 'a message = 'a messageEvent Js.t

class type ['message] broadcaster = 
object ('self)
  inherit Dom_html.eventTarget
  method name  : (Js.js_string Js.t) Js.readonly_prop
  method close : unit -> unit Js.meth
  method postMessage :  'message -> unit Js.meth
  method onmessage: 
    ('self Js.t, 'message message) listener Js.writeonly_prop
end

type 'a t = 'a broadcaster Js.t

let constr = Js.Unsafe.global##._BroadcastChannel
let is_supported () = Js.Optdef.test constr

let create name = 
  if is_supported () 
  then new%js constr (Js.string name)
  else raise (Not_supported "BroadcastChannel")

let close bus = 
  ignore (bus ## close())

let name bus = 
  Js.to_string (bus##.name)

let post bus message = 
  ignore (bus##postMessage(message))

let on bus f = 
  bus##.onmessage := (Dom.handler f)

let addEventListener = 
  Dom.addEventListener

let message _ = 
  Dom.Event.make "message"

let create_with name _ =
  let bus = create name in 
  (bus, message bus)


module Old =
struct

  class type ['a] messageEvent =
    object 
      inherit ['a] EventSource.messageEvent
    end

  let constr = Js.Unsafe.global##._BroadcastChannel
  let is_supported () = Js.Optdef.test constr

  module type REQUIRED = 
  sig 
    type message
  end


  module type BROADCASTER = 
  sig

    include REQUIRED
    
    class type broadcaster = 
    object ('self)
      inherit Dom_html.eventTarget
      method name  : (Js.js_string Js.t) Js.readonly_prop
      method close : unit -> unit Js.meth
      method postMessage :  message -> unit Js.meth
      method onmessage: 
        ('self Js.t, message messageEvent Js.t) Dom_html.event_listener Js.writeonly_prop
    end

    type t = broadcaster Js.t

    module Event : 
    sig 
      val message :  (message messageEvent) Js.t Dom.Event.typ
      val lwt_js_message: 
        ?use_capture:bool
        -> t 
        -> (message messageEvent) Js.t Lwt.t
    end

    val create: string -> t
    val close: t -> unit
    val name: t-> string
    val post: t -> message -> unit
    val onmessage: t -> (message messageEvent Js.t -> bool Js.t) -> unit

    val addEventListener : 
      t
      -> message messageEvent Js.t Dom.Event.typ
      -> (t, message messageEvent Js.t) Dom.event_listener
      -> bool Js.t 
      -> Dom.event_listener_id
    

  end

  module Make (B : REQUIRED) : 
    BROADCASTER with type message = B.message = 
  struct 

    type message = B.message

    module Event = 
    struct 
      let message = Dom.Event.make "message"
      let lwt_js_message ?(use_capture = false) target = 
        let el = ref Js.null in
        let t, w = Lwt.task () in
        let cancel () = Js.Opt.iter !el Dom.removeEventListener in
        Lwt.on_cancel t cancel;
        el := Js.some
          (Dom.addEventListener
            target message
            (Dom.handler (fun ev -> cancel (); Lwt.wakeup w ev; Js.bool true))
            (Js.bool use_capture)
          );
        t
    end
    

    class type broadcaster = 
    object ('self)
      inherit Dom_html.eventTarget
      method name  : (Js.js_string Js.t) Js.readonly_prop
      method close : unit -> unit Js.meth
      method postMessage :  message -> unit Js.meth
      method onmessage: 
        ('self Js.t, message messageEvent Js.t) Dom.event_listener Js.writeonly_prop
    end


    type t = broadcaster Js.t

    let create name = new%js constr (Js.string name)
    let close obj = ignore (obj ## close())
    let name obj = Js.to_string (obj##.name)
    let post obj message = ignore (obj##postMessage(message))
    let onmessage obj f = obj##.onmessage := (Dom.handler f)
    let addEventListener = Dom.addEventListener

  end

end


