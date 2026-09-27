(** Handles command-line arguments, terminal communication, and exit status. *)

let () =
  if Array.length Sys.argv <> 3 then begin
    Printf.eprintf "Usage: %s <input.pic> <output.svg>\n" Sys.argv.(0);
    exit 1
  end;

  let input_filename = Sys.argv.(1) in
  let output_filename = Sys.argv.(2) in

  Printf.printf "Input file: %s\n" input_filename;
  Printf.printf "Output file: %s\n" output_filename;

  match A1.Generator.read_numbered_lines input_filename with
  | Ok numbered_lines ->
      List.iter (fun (line_number, line) -> Printf.printf "%d: %s\n" line_number line) numbered_lines
  | Error message ->
      Printf.eprintf "%s\n" message;
      exit 1

