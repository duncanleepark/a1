(** Converts typed picture data into SVG text *)

(** [color_to_string color] returns the hexadecimal SVG color for [color]. *)
let color_to_string (c : Picture.color) =
  match c with
  | Black -> "#111111"
  | White -> "#ffffff"
  | Gray -> "#808080"
  | Red -> "#c1121f"
  | Orange -> "#f77f00"
  | Yellow -> "#fcbf49"
  | Green -> "#2a9d8f"
  | Blue -> "#277da1"
  | Purple -> "#7b2cbf"
  | Pink -> "#e76f91"
  | Brown -> "#8d6e63"
  | Navy -> "#091226"
  | Teal -> "#008080"
  | Gold -> "#d9a441"
  | Cream -> "#fff1b0"

(** [escape_xml_text contents] escapes XML markup characters in text-node
    contents so generated SVG remains well-formed. *)
let escape_xml_text contents =
  let escaped = Buffer.create (String.length contents) in
  String.iter
    (function
      | '&' -> Buffer.add_string escaped "&amp;"
      | '<' -> Buffer.add_string escaped "&lt;"
      | '>' -> Buffer.add_string escaped "&gt;"
      | '"' -> Buffer.add_string escaped "&quot;"
      | '\'' -> Buffer.add_string escaped "&apos;"
      | character -> Buffer.add_char escaped character)
    contents;
  Buffer.contents escaped

(** [transform_to_string transform] formats a picture transformation as an SVG
    transform attribute value. *)
let transform_to_string (transform : Picture.transform) : string =
  match transform with
  | Translate { dx; dy } -> Printf.sprintf "translate(%f %f)" dx dy
  | Rotate { degrees } -> Printf.sprintf "rotate(%f)" degrees
  | Scale { factor } -> Printf.sprintf "scale(%f)" factor

(** [render_shape shape] renders one primitive or compound picture element to
    SVG markup. Compound elements recursively include their children. *)
let rec render_shape (s : Picture.shape) : string =
  (* [render_group transform elements] wraps rendered children in an SVG group
     with the given transform attribute value. *)
  let render_group transform elements =
    Printf.sprintf "  <g transform=\"%s\">\n%s  </g>\n" transform
      (List.map render_shape elements |> String.concat "")
  in
  match s with
  | Circle { x; y; radius; color } ->
      Printf.sprintf "  <circle cx=\"%f\" cy=\"%f\" r=\"%f\" fill=\"%s\" />\n" x
        y radius (color_to_string color)
  | Rectangle { x; y; width; height; color } ->
      Printf.sprintf
        "  <rect x=\"%f\" y=\"%f\" width=\"%f\" height=\"%f\" fill=\"%s\" />\n"
        x y width height (color_to_string color)
  | Line { x1; y1; x2; y2; color; width } ->
      Printf.sprintf
        "  <line x1=\"%f\" y1=\"%f\" x2=\"%f\" y2=\"%f\" stroke=\"%s\" \
         stroke-width=\"%f\" />\n"
        x1 y1 x2 y2 (color_to_string color) width
  | Text { x; y; size; color; contents } ->
      Printf.sprintf
        "  <text x=\"%f\" y=\"%f\" font-size=\"%f\" fill=\"%s\" \
         text-anchor=\"middle\">%s</text>\n"
        x y size (color_to_string color) (escape_xml_text contents)
  | Transform { transform; elements } ->
      render_group (transform_to_string transform) elements
  | Repeat { count; transform; elements } ->
      let render_copy index =
        let copy_index = float_of_int index in
        let copy_transform : Picture.transform =
          if index = 0 then
            match transform with
            | Translate _ -> Picture.Translate { dx = 0.0; dy = 0.0 }
            | Rotate _ -> Picture.Rotate { degrees = 0.0 }
            | Scale _ -> Picture.Scale { factor = 1.0 }
          else
            match transform with
            | Translate { dx; dy } ->
                Picture.Translate
                  { dx = copy_index *. dx; dy = copy_index *. dy }
            | Rotate { degrees } ->
                Picture.Rotate { degrees = copy_index *. degrees }
            | Scale { factor } ->
                Picture.Scale { factor = factor ** copy_index }
        in
        render_group (transform_to_string copy_transform) elements
      in
      List.init count render_copy |> String.concat ""

(** [render picture] serializes a complete typed picture as an SVG document,
    including a background rectangle when the picture has a background color. *)
let render (pic : Picture.picture) : string =
  let bg_rect =
    match pic.background with
    | None -> ""
    | Some c ->
        Printf.sprintf "  <rect width=\"%.2f\" height=\"%.2f\" fill=\"%s\" />\n"
          pic.width pic.height (color_to_string c)
  in
  let shapes_svg = List.map render_shape pic.elements |> String.concat "" in
  Printf.sprintf
    "<svg width=\"%f\" height=\"%f\" viewBox=\"0 0 %f %f\" \
     xmlns=\"http://www.w3.org/2000/svg\">\n\
     %s%s</svg>\n"
    pic.width pic.height pic.width pic.height bg_rect shapes_svg
