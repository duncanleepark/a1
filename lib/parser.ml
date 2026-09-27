(** Converts numbered source lines into typed picture data. *)

exception ParseError of (int option * string)

(* Maps text words to typed color enumeration*)
let parse_color line_number color_text : Picture.color option =
  match color_text with
  | "none" -> None
  | "black" -> Some Picture.Black
  | "white" -> Some Picture.White
  | "gray" -> Some Picture.Gray
  | "red" -> Some Picture.Red
  | "orange" -> Some Picture.Orange
  | "yellow" -> Some Picture.Yellow
  | "green" -> Some Picture.Green
  | "blue" -> Some Picture.Blue
  | "purple" -> Some Picture.Purple
  | "pink" -> Some Picture.Pink
  | "brown" -> Some Picture.Brown
  | "navy" -> Some Picture.Navy
  | "teal" -> Some Picture.Teal
  | "gold" -> Some Picture.Gold
  | "cream" -> Some Picture.Cream
  | _ -> raise (ParseError (Some line_number, "unknown color '" ^ color_text ^ "'"))

  let parse_canvas (numbered_lines : (int * string) list) : Picture.picture =
  let trimmed_lines =
    List.filter_map
      (fun (line_number, line) ->
        let trimmed = String.trim line in
        if trimmed = "" then None else Some (line_number, trimmed))
      numbered_lines
  in
  match trimmed_lines with
  | [] -> raise (ParseError (None, "No nonblank lines found in the input."))
  | (line_number, line) :: _ ->
      let words =
        String.split_on_char ' ' line
        |> List.filter (fun word -> word <> "")
      in
      match words with
      | ["canvas"; width_text; height_text; background_text] ->
          let width =
            match float_of_string_opt width_text with
            | Some value when value > 0.0 -> value
            | _ -> raise (ParseError (Some line_number, "canvas width must be a positive number"))
          in
          let height =
            match float_of_string_opt height_text with
            | Some value when value > 0.0 -> value
            | _ -> raise (ParseError (Some line_number, "canvas height must be a positive number"))
          in
          {
            Picture.width;
            height;
            background = parse_color line_number background_text;
          }
      | _ -> raise (ParseError (Some line_number, "canvas declaration must be of the form: canvas width height background"))

(* Public boundary of parser; converts result to user-friendly response. *)
let parse (numbered_lines : (int * string) list) : (Picture.picture, string) result =
  try
    Ok (parse_canvas numbered_lines)
  with
  | ParseError (Some line_number, message) ->
      Error (Printf.sprintf "Line %d: %s" line_number message)
  | ParseError (None, message) ->
      Error message
