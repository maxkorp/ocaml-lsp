let () =
  Printexc.record_backtrace true;
  let version = ref false in
  let use_merlin_files = ref false in
  Arg.parse
    [ ("--version", Arg.Set version, "print version")
    ; ( "--use-merlin-files"
      , Arg.Set use_merlin_files
      , "enables use of .merlin files" )
    ]
    (fun _ -> raise (Arg.Bad "anonymous arguments are not accepted"))
    "ocamllsp";
  let version = !version in
  let use_merlin_files = !use_merlin_files in
  if version then
    let version = Ocaml_lsp_server.Version.get () in
    print_endline version
  else
    let module Exn_with_backtrace = Stdune.Exn_with_backtrace in
    match
      Exn_with_backtrace.try_with (fun () ->
          Ocaml_lsp_server.run use_merlin_files)
    with
    | Ok () -> ()
    | Error exn ->
      Format.eprintf "%a@." Exn_with_backtrace.pp_uncaught exn;
      exit 1
