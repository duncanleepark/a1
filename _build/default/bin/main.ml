(** Command-line entry point: validates the two file arguments, delegates
    generation to the library, and reports errors to standard error. Success is
    silent. *)

let () =
  if Array.length Sys.argv <> 3 then begin
    Printf.eprintf "Usage: %s <input.pic> <output.svg>\n" Sys.argv.(0);
    exit 1
  end;

  let input_filename = Sys.argv.(1) in
  let output_filename = Sys.argv.(2) in

  match A1.Generator.generate input_filename output_filename with
  | Ok () -> ()
  | Error message ->
      Printf.eprintf "%s\n" message;
      exit 1
