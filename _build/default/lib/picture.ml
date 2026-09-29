(** Typed representation of Picture This pictures. *)

type color =
  | Black
  | White
  | Gray
  | Red
  | Orange
  | Yellow
  | Green
  | Blue
  | Purple
  | Pink
  | Brown
  | Navy
  | Teal
  | Gold
  | Cream

type transform =
  | Translate of {
      dx : float;
      dy : float;
    }
  | Rotate of { degrees : float }
  | Scale of { factor : float }

type shape =
  | Circle of {
      x : float;
      y : float;
      radius : float;
      color : color;
    }
  | Rectangle of {
      x : float;
      y : float;
      width : float;
      height : float;
      color : color;
    }
  | Line of {
      x1 : float;
      y1 : float;
      x2 : float;
      y2 : float;
      color : color;
      width : float;
    }
  | Text of {
      x : float;
      y : float;
      size : float;
      color : color;
      contents : string;
    }
  | Transform of {
      transform : transform;
      elements : shape list;
    }
  | Repeat of {
      count : int;
      transform : transform;
      elements : shape list;
    }

type picture = {
  width : float;
  height : float;
  background : color option;
  elements : shape list;
}
