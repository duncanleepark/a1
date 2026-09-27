(** Coordinates the workflow by reading .pic files, parsing, generating SVG, and writing .svg files. *)

let read_numbered_lines input_filename : ((int * string) list, string) result =
  try
    let lines = In_channel.with_open_text input_filename In_channel.input_lines in
    Ok (List.mapi (fun index line -> (index + 1, line)) lines)
  with
  | Sys_error error ->
      Error ("Error reading input file '" ^ input_filename ^ "': " ^ error)
