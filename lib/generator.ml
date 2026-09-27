(** Coordinates the workflow by reading .pic files, parsing, generating SVG, and writing .svg files. *)

(* Opens input_filename and reads all the lines, then converts into list of pairs*)
let read_numbered_lines input_filename : ((int * string) list, string) result =
  try
    let lines = In_channel.with_open_text input_filename In_channel.input_lines in
    Ok (List.mapi (fun index line -> (index + 1, line)) lines)
  with
  | Sys_error error ->
      Error ("Error reading input file '" ^ input_filename ^ "': " ^ error)

(* parse reads the file, and returns error or passes numbered lines to the parser*)
let parse input_filename : (Picture.picture, string) result =
  match read_numbered_lines input_filename with
  | Error err -> Error err
  | Ok numbered_lines -> Parser.parse numbered_lines

(* Parses the input file into typed picture value, renders to SVG text, tries to write text to the output file*)
let generate (input_filename : string) (output_filename : string) : (unit, string) result =
  match parse input_filename with
  | Error err -> Error err
  | Ok picture ->
      let svg_text = Svg.render picture in
      try
        Out_channel.with_open_text output_filename (fun channel ->
          output_string channel svg_text);
        Ok ()
      with
      | Sys_error error ->
          Error ("Error writing output file '" ^ output_filename ^ "': " ^ error)
