open AST

exception Error of exn * (int * int * string)

module Lexer = Wlexer
module Parser = Wparser

let print_const (c:const) :string =
  match c with
    | C_prin _
    | C_prins _ -> "some_prin(s)"
    | C_unit -> "()"
    | C_nat n -> string_of_int n
    | C_bool b -> string_of_bool b

let print_pat (p:pat) :string =
  match p with
    | P_const c -> print_const c

let rec print_exp (e:exp) :string =
  match e with
    | Exp (e, _) -> print_exp' e

and print_exp' (e:exp') :string =
  match e with
    | E_aspar (e1, e2) -> "as_par (" ^ print_exp e1 ^ ") (" ^ print_exp e2 ^ ")"
    | E_assec (e1, e2) -> "as_sec (" ^ print_exp e1 ^ ") (" ^ print_exp e2 ^ ")"
    | E_unbox e -> "unbox (" ^ print_exp e ^ ")"
    | E_mkwire (e1, e2) -> "mkwire (" ^ print_exp e1 ^ ") (" ^ print_exp e2 ^ ")"
    | E_projwire (e1, e2) -> "projwire (" ^ print_exp e1 ^ ") (" ^ print_exp e2 ^ ")"
    | E_concatwire (e1, e2) -> "concatwire (" ^ print_exp e1 ^ ") (" ^ print_exp e2 ^ ")"
    | E_const c -> print_const c
    | E_var v -> v
    | E_let (x, e1, e2) -> "let " ^ x ^ " = " ^ print_exp e1 ^ " in\n" ^ print_exp e2
    | E_abs (x, e) -> "fun " ^ x ^ ". " ^ print_exp e
    | E_fix (f, x, e) -> "fix " ^ f ^ ". " ^ x ^ ". " ^ print_exp e
    | E_empabs (x, e) -> "fun " ^ x ^ ". " ^ print_exp e
    | E_app (e1, e2) -> "apply (" ^ print_exp e1 ^ ") (" ^ print_exp e2 ^ ")"
    | E_ffi (s, l) ->
      "ffi " ^ s ^ " [ " ^ (List.fold_left (fun s e -> s ^ print_exp e ^ "; ") "" l) ^ " ]"
    | E_match (e, l) ->
      "match " ^ print_exp e ^ " with\n" ^ (List.fold_left (fun s b -> s ^ print_match_branch b) "" l) ^ "\n"

and print_match_branch ((p, e): pat * exp) :string = "| " ^ (print_pat p) ^ " -> " ^ print_exp e ^ "\n"

let parse_channel :string -> in_channel -> exp =
  fun f i ->
  let lexbuf = Lexing.from_channel i in
  Parser.exp Lexer.token lexbuf

let init_mode =
  let s = Sys.argv.(1) in
  let s = String.sub s 1 (String.length s - 2) in    (* cut out brackets *)
  let ps_list = Str.split (Str.regexp ";") s in
  let ps = List.fold_left (fun ps p -> OrdSet.union () ps (OrdSet.singleton () (int_of_string p))) (OrdSet.empty ()) ps_list in
  Mode (Par, ps)

let init_env =
  let meta = Meta (OrdSet.empty (), Can_b, OrdSet.empty (), Can_w) in
  fun x ->
    if x = "alice" then Some (D_v (meta, V_const (C_prin 0)))
    else if x = "bob" then Some (D_v (meta, V_const (C_prin 1)))
    else if x = "charlie" then Some (D_v (meta, V_const (C_prin 2)))
    else if x = "empty" then Some (D_v (meta, V_const (C_prins (OrdSet.empty ()))))
    else None

let is_terminal (c:config) :bool = match c with
  | Conf (_, _, s, _, t) ->
    s = [] &&
      match t with
        | T_val _ -> true
        | _       -> false

let rec run (c:config) :unit =
  if is_terminal c then print_string "\nTerminal\n"
  else
    let c' = SourceInterpreter.step c in
    match c' with
      | None    -> print_string "Error in interpreter\n"
      | Some c' -> run c'

let _ =
  let f = "SMC.wy" in
  let i = open_in f in
  let e = parse_channel f i in
  print_string ((print_exp e) ^ "\n\n");
  let init_config = Conf (Source, init_mode, [], init_env, T_exp e) in
  run init_config
  (* let c_opt = SourceInterpreter.step_star init_config in
  match c_opt with
    | None -> print_string "Error in interpreter\n"
    | Some c -> () *)
