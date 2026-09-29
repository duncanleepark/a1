(** [read_numbered_lines input_filename] reads a text file and numbers its lines
    starting at 1. Returns a user-facing [Error] if the file cannot be read. *)
let read_numbered_lines input_filename : ((int * string) list, string) result =
  try
    let lines =
      In_channel.with_open_text input_filename In_channel.input_lines
    in
    Ok (List.mapi (fun index line -> (index + 1, line)) lines)
  with Sys_error error ->
    Error ("Error reading input file '" ^ input_filename ^ "': " ^ error)

(** [parse input_filename] reads and parses a Picture This source file. Returns
    the typed picture or a diagnostic describing an I/O or syntax error. *)
let parse input_filename : (Picture.picture, string) result =
  match read_numbered_lines input_filename with
  | Error err -> Error err
  | Ok numbered_lines -> Parser.parse numbered_lines

(** [generate input_filename output_filename] parses the input, renders it as
    SVG, and writes the result to the output file. Returns [Ok ()] on success;
    returns [Error message] for input, parse, or output errors. Does not print
    to standard output. *)
let generate (input_filename : string) (output_filename : string) :
    (unit, string) result =
  match parse input_filename with
  | Error err -> Error err
  | Ok picture -> (
      let svg_text = Svg.render picture in
      try
        Out_channel.with_open_text output_filename (fun channel ->
            output_string channel svg_text);
        Ok ()
      with Sys_error error ->
        Error ("Error writing output file '" ^ output_filename ^ "': " ^ error))
