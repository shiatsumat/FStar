open AST

open FFI

let const_meta = AST.Meta ([], AST.Can_b, [], AST.Can_w)

let program = mk_let "alice_s" (mk_ffi 1 "FFI.singleton" (FFI.singleton) [  (mk_var "alice"); ] (fun x -> D_v (const_meta, V_eprins x))) (mk_let "bob_s" (mk_ffi 1 "FFI.singleton" (FFI.singleton) [  (mk_var "bob"); ] (fun x -> D_v (const_meta, V_eprins x))) (mk_let "ab" (mk_ffi 2 "FFI.union" (FFI.union) [  (mk_var "alice_s"); (mk_var "bob_s"); ] (fun x -> D_v (const_meta, V_eprins x))) (mk_let "to_s2" (mk_abs "p1" (mk_abs "p2" (mk_ffi 2 "FFI.union" (FFI.union) [  (mk_ffi 1 "FFI.singleton" (FFI.singleton) [  (mk_var "p1"); ] (fun x -> D_v (const_meta, V_eprins x))); (mk_ffi 1 "FFI.singleton" (FFI.singleton) [  (mk_var "p2"); ] (fun x -> D_v (const_meta, V_eprins x))); ] (fun x -> D_v (const_meta, V_eprins x))))) (mk_let "read_fn" (mk_abs "_15_17" (mk_abs "_15_19" (mk_ffi 1 "FFI.read_int_list" FFI.read_int_list [ E_const (C_unit ()) ] (fun x -> mk_v_opaque x (slice_list slice_id) (compose_lists compose_ids) (slice_list_sps slice_id_sps))))) (mk_let "nth" (mk_fix "nth" "n" (mk_abs "l" (mk_cond (mk_ffi 2 "Prims.op_Equality" (Prims.op_Equality) [  (mk_var "n"); (mk_const (C_opaque ((), Obj.magic 0))); ] (fun x -> D_v (const_meta, V_bool x))) (mk_ffi 1 "FFI.hd_of_cons" (FFI.hd_of_cons) [  (mk_var "l"); ] (fun x -> mk_v_opaque x slice_id compose_ids slice_id_sps)) (mk_app (mk_app (mk_var "nth") (mk_ffi 2 "Prims.(-)" (Prims.(-)) [  (mk_var "n"); (mk_const (C_opaque ((), Obj.magic 1))); ] (fun x -> mk_v_opaque x slice_id compose_ids slice_id_sps))) (mk_ffi 1 "FFI.tl_of_cons" (FFI.tl_of_cons) [  (mk_var "l"); ] (fun x -> mk_v_opaque x (slice_list slice_id) (compose_lists compose_ids) (slice_list_sps slice_id_sps))))))) (mk_let "mem_begin" (mk_fix "mem_begin" "x" (mk_abs "n" (mk_abs "l" (mk_const (C_unit ()))))) (mk_let "mem" (mk_fix "mem" "x" (mk_abs "l" (mk_abs "len" (mk_abs "n" (mk_cond (mk_ffi 2 "Prims.op_Equality" (Prims.op_Equality) [  (mk_var "n"); (mk_var "len"); ] (fun x -> D_v (const_meta, V_bool x))) (mk_ffi 2 "FFI.mk_tuple" (FFI.mk_tuple) [  (mk_const (C_bool false)); (mk_const (C_opaque ((), Obj.magic 0))); ] (fun x -> mk_v_opaque x ((slice_tuple slice_id) slice_id) ((compose_tuples compose_ids) compose_ids) ((slice_tuple_sps slice_id_sps) slice_id_sps))) (mk_let "g" (mk_abs "_15_49" (mk_let "_33_56" (mk_unbox (mk_var "l")) (mk_app (mk_app (mk_var "nth") (mk_var "n")) (mk_var "_33_56")))) (mk_let "y" (mk_aspar (mk_var "bob_s") (mk_var "g")) (mk_let "_15_58" (mk_const (C_unit ())) (mk_let "cmp" (mk_abs "_15_60" (mk_cond (mk_ffi 2 "Prims.op_Equality" (Prims.op_Equality) [  (mk_unbox (mk_var "x")); (mk_unbox (mk_var "y")); ] (fun x -> D_v (const_meta, V_bool x))) (mk_let "_33_72" (mk_unbox (mk_var "x")) (mk_ffi 2 "FFI.mk_tuple" (FFI.mk_tuple) [  (mk_const (C_bool true)); (mk_var "_33_72"); ] (fun x -> mk_v_opaque x ((slice_tuple slice_id) slice_id) ((compose_tuples compose_ids) compose_ids) ((slice_tuple_sps slice_id_sps) slice_id_sps)))) (mk_ffi 2 "FFI.mk_tuple" (FFI.mk_tuple) [  (mk_const (C_bool false)); (mk_const (C_opaque ((), Obj.magic 0))); ] (fun x -> mk_v_opaque x ((slice_tuple slice_id) slice_id) ((compose_tuples compose_ids) compose_ids) ((slice_tuple_sps slice_id_sps) slice_id_sps))))) (mk_let "p" (mk_assec (mk_var "ab") (mk_var "cmp")) (mk_cond (mk_ffi 1 "Prims.fst" (Prims.fst) [  (mk_var "p"); ] (fun x -> D_v (const_meta, V_bool x))) (mk_var "p") (mk_app (mk_app (mk_app (mk_app (mk_var "mem") (mk_var "x")) (mk_var "l")) (mk_var "len")) (mk_ffi 2 "Prims.(+)" (Prims.(+)) [  (mk_var "n"); (mk_const (C_opaque ((), Obj.magic 1))); ] (fun x -> mk_v_opaque x slice_id compose_ids slice_id_sps)))))))))))))) (mk_let "lmem" (mk_abs "x" (mk_abs "l" (mk_const (C_unit ())))) (mk_let "psi" (mk_fix "psi" "l1" (mk_abs "l2" (mk_abs "len1" (mk_abs "len2" (mk_abs "n1" (mk_let "_15_93" (mk_const (C_unit ())) (mk_cond (mk_ffi 2 "Prims.op_Equality" (Prims.op_Equality) [  (mk_var "n1"); (mk_var "len1"); ] (fun x -> D_v (const_meta, V_bool x))) (mk_ffi 1 "FFI.mk_nil" (FFI.mk_nil) [  (mk_const (C_unit ())); ] (fun x -> mk_v_opaque x (slice_list slice_id) (compose_lists compose_ids) (slice_list_sps slice_id_sps))) (mk_let "g" (mk_abs "_15_95" (mk_let "_33_127" (mk_unbox (mk_var "l1")) (mk_app (mk_app (mk_var "nth") (mk_var "n1")) (mk_var "_33_127")))) (mk_let "x" (mk_aspar (mk_var "alice_s") (mk_var "g")) (mk_let "p" (mk_app (mk_app (mk_app (mk_app (mk_var "mem") (mk_var "x")) (mk_var "l2")) (mk_var "len2")) (mk_const (C_opaque ((), Obj.magic 0)))) (mk_let "l" (mk_app (mk_app (mk_app (mk_app (mk_app (mk_var "psi") (mk_var "l1")) (mk_var "l2")) (mk_var "len1")) (mk_var "len2")) (mk_ffi 2 "Prims.(+)" (Prims.(+)) [  (mk_var "n1"); (mk_const (C_opaque ((), Obj.magic 1))); ] (fun x -> mk_v_opaque x slice_id compose_ids slice_id_sps))) (mk_cond (mk_ffi 1 "Prims.fst" (Prims.fst) [  (mk_var "p"); ] (fun x -> D_v (const_meta, V_bool x))) (mk_ffi 2 "FFI.mk_cons" (FFI.mk_cons) [  (mk_ffi 1 "Prims.snd" (Prims.snd) [  (mk_var "p"); ] (fun x -> mk_v_opaque x slice_id compose_ids slice_id_sps)); (mk_var "l"); ] (fun x -> mk_v_opaque x (slice_list slice_id) (compose_lists compose_ids) (slice_list_sps slice_id_sps))) (mk_var "l"))))))))))))) (mk_let "psi_m" (mk_abs "_15_106" (mk_let "l1" (mk_aspar (mk_var "alice_s") (mk_app (mk_var "read_fn") (mk_var "alice"))) (mk_let "l2" (mk_aspar (mk_var "bob_s") (mk_app (mk_var "read_fn") (mk_var "bob"))) (mk_let "len" (mk_abs "_15_110" (mk_abs "l" (mk_abs "_15_113" (mk_let "l" (mk_unbox (mk_var "l")) (mk_ffi 1 "FFI.length" (FFI.length) [  (mk_var "l"); ] (fun x -> mk_v_opaque x slice_id compose_ids slice_id_sps)))))) (mk_let "n1" (mk_aspar (mk_var "alice_s") (mk_app (mk_app (mk_var "len") (mk_var "alice")) (mk_var "l1"))) (mk_let "n2" (mk_aspar (mk_var "bob_s") (mk_app (mk_app (mk_var "len") (mk_var "bob")) (mk_var "l2"))) (mk_let "g" (mk_abs "p" (mk_abs "n" (mk_abs "_15_128" (mk_unbox (mk_var "n"))))) (mk_let "n1'" (mk_assec (mk_var "ab") (mk_app (mk_app (mk_var "g") (mk_var "alice")) (mk_var "n1"))) (mk_let "n2'" (mk_assec (mk_var "ab") (mk_app (mk_app (mk_var "g") (mk_var "bob")) (mk_var "n2"))) (mk_let "l" (mk_app (mk_app (mk_app (mk_app (mk_app (mk_var "psi") (mk_var "l1")) (mk_var "l2")) (mk_var "n1'")) (mk_var "n2'")) (mk_const (C_opaque ((), Obj.magic 0)))) (mk_let "_15_143" (mk_const (C_unit ())) (mk_var "l")))))))))))) (mk_let "l" (mk_app (mk_var "psi_m") (E_const (C_unit ()))) (mk_ffi 1 "FFI.print_int_list" (FFI.print_int_list) [  (mk_var "l"); ] (fun x -> D_v (const_meta, V_unit))))))))))))))

