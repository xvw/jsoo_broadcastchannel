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

  val message :  message messageEvent Js.t Dom.Event.typ

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

  val create: string -> t
  val close: t -> unit
  val name: t-> string
  val post: t -> message -> unit
  val onmessage: t -> (message messageEvent Js.t -> bool Js.t) -> unit
  

end

module Make (B : REQUIRED) : 
  BROADCASTER with type message = B.message = 
struct 

  type message = B.message

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

  let message = Dom.Event.make "message"

  let onmessage obj f =
    obj##.onmessage := (Dom.handler f)
end



