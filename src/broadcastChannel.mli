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

(** [jsoo_broadcastchannel] provides a wrapper around the BroadcastChannel API 
    in JavaScript. 
    The BroadcastChannel interface represents a named channel that any browsing context 
    of a given origin can subscribe to. It allows communication between different documents 
    (in different windows, tabs, frames or iframes) of the same origin. Messages are 
    broadcasted via a message event fired at all BroadcastChannel objects listening 
    to the channel.

    You can have more details here : https://developer.mozilla.org/en-US/docs/Web/API/BroadcastChannel
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

val is_supported : unit -> bool
val create: string -> 'message t
val create_with: string -> 'a -> ('a t * 'a message Dom.Event.typ)
val close:  'message t -> unit
val name:   'message t -> string
val post:   'message t -> 'message -> unit
val on:     'message t -> ('message message -> bool Js.t) -> unit

val addEventListener : 
  'a t
  -> 'a message Dom.Event.typ
  -> ('a t, 'a message) Dom.event_listener
  -> bool Js.t 
  -> Dom.event_listener_id

val message : 'a t -> 'a message Dom.Event.typ

val lwt_js_message: 
  ?use_capture:bool 
  -> 'a t 
  -> ('a messageEvent) Js.t Lwt.t