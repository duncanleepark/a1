(** Typed representation of Picture This pictures. *)

type color =
  | Black | White | Gray | Red | Orange | Yellow | Green | Blue
  | Purple | Pink | Brown | Navy | Teal | Gold | Cream

type picture = {
  width : float;
  height : float;
  background : color option;
}

