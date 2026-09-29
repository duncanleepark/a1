(** Converts numbered source lines into typed picture data. *)

exception ParseError of (int option * string)

(** [ParseError (line, message)] is an internal parse failure. [line] is absent
    in errors that are not associated with a source line. The public [parse]
    function converts this exception to an [Error] result. *)

(** [parse_color line color] converts a source color name to its typed color.
    ["none"] maps to [None]; unknown names raise [ParseError] at [line]. *)
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
  | _ ->
      raise
        (ParseError (Some line_number, "unknown color '" ^ color_text ^ "'"))

(** Parses a finite floating-point number from source text. *)
let parse_number line_number description text : float =
  match float_of_string_opt text with
  | Some value when Float.is_finite value -> value
  | _ ->
      raise (ParseError (Some line_number, description ^ " must be a number"))

(** Parses a positive finite floating-point number from source text. *)
let parse_positive_number line_number description text : float =
  let value = parse_number line_number description text in
  if value > 0.0 then value
  else
    raise
      (ParseError (Some line_number, description ^ " must be a positive number"))

(** [parse_shape line words] parses one primitive declaration into the picture
    model. Invalid syntax or values raise [ParseError] associated with [line].
*)
let parse_shape line_number words : Picture.shape =
  match words with
  | [ "circle"; x_str; y_str; radius_str; color_str ] ->
      let x = parse_number line_number "circle x" x_str in
      let y = parse_number line_number "circle y" y_str in
      let radius =
        parse_positive_number line_number "circle radius" radius_str
      in
      let color =
        match parse_color line_number color_str with
        | Some c -> c
        | None ->
            raise
              (ParseError
                 (Some line_number, "shape cannot have 'none' fill color"))
      in
      Picture.Circle { x; y; radius; color }
  | [ "rectangle"; x_str; y_str; width_str; height_str; color_str ] ->
      let x = parse_number line_number "rectangle x" x_str in
      let y = parse_number line_number "rectangle y" y_str in
      let width =
        parse_positive_number line_number "rectangle width" width_str
      in
      let height =
        parse_positive_number line_number "rectangle height" height_str
      in
      let color =
        match parse_color line_number color_str with
        | Some c -> c
        | None ->
            raise
              (ParseError
                 (Some line_number, "shape cannot have 'none' fill color"))
      in
      Picture.Rectangle { x; y; width; height; color }
  | [ "line"; x1_str; y1_str; x2_str; y2_str; color_str; width_str ] ->
      let x1 = parse_number line_number "line x1" x1_str in
      let y1 = parse_number line_number "line y1" y1_str in
      let x2 = parse_number line_number "line x2" x2_str in
      let y2 = parse_number line_number "line y2" y2_str in
      let color =
        match parse_color line_number color_str with
        | Some c -> c
        | None ->
            raise
              (ParseError
                 (Some line_number, "shape cannot have 'none' fill color"))
      in
      let width = parse_positive_number line_number "line width" width_str in
      Picture.Line { x1; y1; x2; y2; color; width }
  | "text" :: x_str :: y_str :: size_str :: color_str :: rest when rest <> [] ->
      let x = parse_number line_number "text x" x_str in
      let y = parse_number line_number "text y" y_str in
      let size = parse_positive_number line_number "text size" size_str in
      let color =
        match parse_color line_number color_str with
        | Some c -> c
        | None ->
            raise
              (ParseError
                 (Some line_number, "shape cannot have 'none' fill color"))
      in
      let contents = String.concat " " rest in
      Picture.Text { x; y; size; color; contents }
  | "text" :: _ ->
      raise
        (ParseError (Some line_number, "text must include nonempty contents"))
  | _ ->
      raise
        (ParseError
           ( Some line_number,
             "unknown shape type or incorrect number of parameters" ))

(** [split_words line] splits a source line on spaces and tabs; omits empty
    words. *)
let split_words (line : string) : string list =
  String.map (fun c -> if c = '\t' then ' ' else c) line
  |> String.split_on_char ' '
  |> List.filter (fun word -> word <> "")

(** [parse_transformation line args] parses the transformation arguments used by
    both [transform] and [repeat] headers. Invalid arguments raise [ParseError]
    at [line]. *)
let parse_transformation line_number (args : string list) : Picture.transform =
  match args with
  | [ "translate"; dx_str; dy_str ] ->
      let dx = parse_number line_number "translate dx" dx_str in
      let dy = parse_number line_number "translate dy" dy_str in
      Picture.Translate { dx; dy }
  | [ "rotate"; degrees_str ] ->
      let degrees = parse_number line_number "rotate degrees" degrees_str in
      Picture.Rotate { degrees }
  | [ "scale"; factor_str ] ->
      let factor = parse_number line_number "scale factor" factor_str in
      if factor > 0.0 then Picture.Scale { factor }
      else
        raise
          (ParseError
             (Some line_number, "scale factor must be a positive number"))
  | (("translate" | "rotate" | "scale") as kind) :: _ ->
      raise
        (ParseError
           ( Some line_number,
             "wrong number of parameters for '" ^ kind ^ "' transformation" ))
  | kind :: _ ->
      raise
        (ParseError
           ( Some line_number,
             "unknown transformation '" ^ kind
             ^ "'; expected translate, rotate, or scale" ))
  | [] ->
      raise
        (ParseError
           ( Some line_number,
             "transform must be followed by translate, rotate, or scale" ))

(** [parse_repeat_header line args] parses a nonnegative integer repeat count
    and its transformation. Invalid counts or transformations raise [ParseError]
    at [line]. *)
let parse_repeat_header line_number (args : string list) :
    int * Picture.transform =
  match args with
  | [] ->
      raise
        (ParseError
           ( Some line_number,
             "repeat must be followed by a count and a transformation" ))
  | [ _ ] ->
      raise
        (ParseError
           (Some line_number, "repeat requires a transformation after the count"))
  | count_str :: transformation_args ->
      let count =
        match int_of_string_opt count_str with
        | Some n when n >= 0 -> n
        | Some _ ->
            raise
              (ParseError (Some line_number, "repeat count must not be negative"))
        | None ->
            raise
              (ParseError (Some line_number, "repeat count must be an integer"))
      in
      (count, parse_transformation line_number transformation_args)

(** [parse_elements opener lines] parses elements until the matching [end] or
    end of input. It returns the parsed elements and unconsumed lines; malformed
    blocks raise [ParseError]. *)
let rec parse_elements (opener : (int * string) option)
    (lines : (int * string list) list) :
    Picture.shape list * (int * string list) list =
  match lines with
  | [] -> (
      match opener with
      | None -> ([], [])
      | Some (opener_line, kind) ->
          raise
            (ParseError
               ( Some opener_line,
                 kind ^ " block is never closed; expected a matching 'end'" )))
  | (line_number, [ "end" ]) :: rest -> (
      match opener with
      | None ->
          raise
            (ParseError (Some line_number, "unexpected 'end' outside of a block"))
      | Some _ -> ([], rest))
  | (line_number, "end" :: _) :: _ ->
      raise (ParseError (Some line_number, "'end' takes no parameters"))
  | (line_number, "transform" :: args) :: rest ->
      let transformation = parse_transformation line_number args in
      let body, after_block =
        parse_elements (Some (line_number, "transform")) rest
      in
      let following, remaining = parse_elements opener after_block in
      ( Picture.Transform { transform = transformation; elements = body }
        :: following,
        remaining )
  | (line_number, "repeat" :: args) :: rest ->
      let count, transformation = parse_repeat_header line_number args in
      let body, after_block =
        parse_elements (Some (line_number, "repeat")) rest
      in
      let following, remaining = parse_elements opener after_block in
      ( Picture.Repeat { count; transform = transformation; elements = body }
        :: following,
        remaining )
  | (line_number, words) :: rest ->
      let shape = parse_shape line_number words in
      let following, remaining = parse_elements opener rest in
      (shape :: following, remaining)

(** [parse_picture numbered_lines] parses a complete picture, including its
    canvas declaration. Parse failures raise [ParseError]. *)
let parse_picture (numbered_lines : (int * string) list) : Picture.picture =
  let word_lines =
    List.filter_map
      (fun (line_number, line) ->
        match split_words (String.trim line) with
        | [] -> None
        | words -> Some (line_number, words))
      numbered_lines
  in
  match word_lines with
  | [] -> raise (ParseError (None, "No nonblank lines found in the input."))
  | (canvas_line_number, canvas_words) :: rest_lines ->
      let width, height, background =
        match canvas_words with
        | [ "canvas"; width_text; height_text; background_text ] ->
            let w =
              parse_positive_number canvas_line_number "canvas width" width_text
            in
            let h =
              parse_positive_number canvas_line_number "canvas height"
                height_text
            in
            (w, h, parse_color canvas_line_number background_text)
        | _ ->
            raise
              (ParseError
                 ( Some canvas_line_number,
                   "canvas declaration must be of the form: canvas width \
                    height background" ))
      in
      let elements, _ = parse_elements None rest_lines in
      { Picture.width; height; background; elements }

(** [parse numbered_lines] parses numbered source lines into a picture. Returns
    [Ok picture] on success or [Error message] with a user-facing diagnostic on
    invalid input. *)
let parse (numbered_lines : (int * string) list) :
    (Picture.picture, string) result =
  try Ok (parse_picture numbered_lines) with
  | ParseError (Some line_number, message) ->
      Error (Printf.sprintf "Line %d: %s" line_number message)
  | ParseError (None, message) -> Error message
