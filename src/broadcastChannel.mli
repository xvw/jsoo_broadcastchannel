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
 *)


(** {1 Types and classes} *)

(** This class represent a broacasterChannel, it is a wrapper around the 
    JavaScript implementation.
 *)
class type broadcaster = object 
  inherit Dom_html.eventTarget
  method name  : (Js.js_string Js.t) Js.readonly_prop
  method close : unit -> unit Js.meth
end

(** This type is the JavaScript part of a BroadcasterChannel. *)
type t = broadcaster Js.t

(** {1 API} *)

(** Checks if the BroadcastChannel is available for the client *)
val is_supported : unit -> bool

(** Creates  a new BroadcastChannel (with a name). This function 
    returns a [BroadcastChannel.t].
 *)
val create: string -> t

(** Close a BroadcastChannel. *)
val close: t -> unit

(** Returns the name of a BroadcastChannel. *)
val name: t-> string