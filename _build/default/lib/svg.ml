(** Converts typed picture data into SVG text *)

let color_to_string (c : Picture.color) =
  match c with
  | Black -> "black"
  | White -> "white"
  | Gray -> "gray"
  | Red -> "red"
  | Orange -> "orange"
  | Yellow -> "yellow"
  | Green -> "green"
  | Blue -> "blue"
  | Purple -> "purple"
  | Pink -> "pink"
  | Brown -> "brown"
  | Navy -> "navy"
  | Teal -> "teal"
  | Gold -> "gold"
  | Cream -> "cream"

(* Creates SVG and adds rectangle if necessary. *)
let render (pic : Picture.picture) : string =
  let bg_rect =
    match pic.background with
    | None -> ""
    | Some c ->
      Printf.sprintf "<rect width=\"%.2f\" height=\"%.2f\" fill=\"%s\" />\n"
        pic.width pic.height (color_to_string c)
  in
  Printf.sprintf
    "<svg width=\"%f\" height=\"%f\" viewBox=\"0 0 %f %f\" xmlns=\"http://www.w3.org/2000/svg\">\n%s</svg>\n"
    pic.width pic.height pic.width pic.height bg_rect

