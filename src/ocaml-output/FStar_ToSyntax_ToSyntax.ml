open Prims
let (desugar_disjunctive_pattern :
  FStar_Syntax_Syntax.pat' FStar_Syntax_Syntax.withinfo_t Prims.list ->
    FStar_Syntax_Syntax.term' FStar_Syntax_Syntax.syntax
      FStar_Pervasives_Native.option ->
      FStar_Syntax_Syntax.term' FStar_Syntax_Syntax.syntax ->
        FStar_Syntax_Syntax.branch Prims.list)
  =
  fun pats  ->
    fun when_opt  ->
      fun branch1  ->
        FStar_All.pipe_right pats
          (FStar_List.map
             (fun pat  -> FStar_Syntax_Util.branch (pat, when_opt, branch1)))
  
let (trans_aqual :
  FStar_Parser_AST.arg_qualifier FStar_Pervasives_Native.option ->
    FStar_Syntax_Syntax.arg_qualifier FStar_Pervasives_Native.option)
  =
  fun uu___229_66  ->
    match uu___229_66 with
    | FStar_Pervasives_Native.Some (FStar_Parser_AST.Implicit ) ->
        FStar_Pervasives_Native.Some FStar_Syntax_Syntax.imp_tag
    | FStar_Pervasives_Native.Some (FStar_Parser_AST.Equality ) ->
        FStar_Pervasives_Native.Some FStar_Syntax_Syntax.Equality
    | uu____71 -> FStar_Pervasives_Native.None
  
let (trans_qual :
  FStar_Range.range ->
    FStar_Ident.lident FStar_Pervasives_Native.option ->
      FStar_Parser_AST.qualifier -> FStar_Syntax_Syntax.qualifier)
  =
  fun r  ->
    fun maybe_effect_id  ->
      fun uu___230_90  ->
        match uu___230_90 with
        | FStar_Parser_AST.Private  -> FStar_Syntax_Syntax.Private
        | FStar_Parser_AST.Assumption  -> FStar_Syntax_Syntax.Assumption
        | FStar_Parser_AST.Unfold_for_unification_and_vcgen  ->
            FStar_Syntax_Syntax.Unfold_for_unification_and_vcgen
        | FStar_Parser_AST.Inline_for_extraction  ->
            FStar_Syntax_Syntax.Inline_for_extraction
        | FStar_Parser_AST.NoExtract  -> FStar_Syntax_Syntax.NoExtract
        | FStar_Parser_AST.Irreducible  -> FStar_Syntax_Syntax.Irreducible
        | FStar_Parser_AST.Logic  -> FStar_Syntax_Syntax.Logic
        | FStar_Parser_AST.TotalEffect  -> FStar_Syntax_Syntax.TotalEffect
        | FStar_Parser_AST.Effect_qual  -> FStar_Syntax_Syntax.Effect
        | FStar_Parser_AST.New  -> FStar_Syntax_Syntax.New
        | FStar_Parser_AST.Abstract  -> FStar_Syntax_Syntax.Abstract
        | FStar_Parser_AST.Opaque  ->
            (FStar_Errors.log_issue r
               (FStar_Errors.Warning_DeprecatedOpaqueQualifier,
                 "The 'opaque' qualifier is deprecated since its use was strangely schizophrenic. There were two overloaded uses: (1) Given 'opaque val f : t', the behavior was to exclude the definition of 'f' to the SMT solver. This corresponds roughly to the new 'irreducible' qualifier. (2) Given 'opaque type t = t'', the behavior was to provide the definition of 't' to the SMT solver, but not to inline it, unless absolutely required for unification. This corresponds roughly to the behavior of 'unfoldable' (which is currently the default).");
             FStar_Syntax_Syntax.Visible_default)
        | FStar_Parser_AST.Reflectable  ->
            (match maybe_effect_id with
             | FStar_Pervasives_Native.None  ->
                 FStar_Errors.raise_error
                   (FStar_Errors.Fatal_ReflectOnlySupportedOnEffects,
                     "Qualifier reflect only supported on effects") r
             | FStar_Pervasives_Native.Some effect_id ->
                 FStar_Syntax_Syntax.Reflectable effect_id)
        | FStar_Parser_AST.Reifiable  -> FStar_Syntax_Syntax.Reifiable
        | FStar_Parser_AST.Noeq  -> FStar_Syntax_Syntax.Noeq
        | FStar_Parser_AST.Unopteq  -> FStar_Syntax_Syntax.Unopteq
        | FStar_Parser_AST.DefaultEffect  ->
            FStar_Errors.raise_error
              (FStar_Errors.Fatal_DefaultQualifierNotAllowedOnEffects,
                "The 'default' qualifier on effects is no longer supported")
              r
        | FStar_Parser_AST.Inline  ->
            FStar_Errors.raise_error
              (FStar_Errors.Fatal_UnsupportedQualifier,
                "Unsupported qualifier") r
        | FStar_Parser_AST.Visible  ->
            FStar_Errors.raise_error
              (FStar_Errors.Fatal_UnsupportedQualifier,
                "Unsupported qualifier") r
  
let (trans_pragma : FStar_Parser_AST.pragma -> FStar_Syntax_Syntax.pragma) =
  fun uu___231_99  ->
    match uu___231_99 with
    | FStar_Parser_AST.SetOptions s -> FStar_Syntax_Syntax.SetOptions s
    | FStar_Parser_AST.ResetOptions sopt ->
        FStar_Syntax_Syntax.ResetOptions sopt
    | FStar_Parser_AST.LightOff  -> FStar_Syntax_Syntax.LightOff
  
let (as_imp :
  FStar_Parser_AST.imp ->
    FStar_Syntax_Syntax.arg_qualifier FStar_Pervasives_Native.option)
  =
  fun uu___232_110  ->
    match uu___232_110 with
    | FStar_Parser_AST.Hash  ->
        FStar_Pervasives_Native.Some FStar_Syntax_Syntax.imp_tag
    | uu____113 -> FStar_Pervasives_Native.None
  
let arg_withimp_e :
  'Auu____120 .
    FStar_Parser_AST.imp ->
      'Auu____120 ->
        ('Auu____120,FStar_Syntax_Syntax.arg_qualifier
                       FStar_Pervasives_Native.option)
          FStar_Pervasives_Native.tuple2
  = fun imp  -> fun t  -> (t, (as_imp imp)) 
let arg_withimp_t :
  'Auu____145 .
    FStar_Parser_AST.imp ->
      'Auu____145 ->
        ('Auu____145,FStar_Syntax_Syntax.arg_qualifier
                       FStar_Pervasives_Native.option)
          FStar_Pervasives_Native.tuple2
  =
  fun imp  ->
    fun t  ->
      match imp with
      | FStar_Parser_AST.Hash  ->
          (t, (FStar_Pervasives_Native.Some FStar_Syntax_Syntax.imp_tag))
      | uu____164 -> (t, FStar_Pervasives_Native.None)
  
let (contains_binder : FStar_Parser_AST.binder Prims.list -> Prims.bool) =
  fun binders  ->
    FStar_All.pipe_right binders
      (FStar_Util.for_some
         (fun b  ->
            match b.FStar_Parser_AST.b with
            | FStar_Parser_AST.Annotated uu____181 -> true
            | uu____186 -> false))
  
let rec (unparen : FStar_Parser_AST.term -> FStar_Parser_AST.term) =
  fun t  ->
    match t.FStar_Parser_AST.tm with
    | FStar_Parser_AST.Paren t1 -> unparen t1
    | uu____193 -> t
  
let (tm_type_z : FStar_Range.range -> FStar_Parser_AST.term) =
  fun r  ->
    let uu____199 =
      let uu____200 = FStar_Ident.lid_of_path ["Type0"] r  in
      FStar_Parser_AST.Name uu____200  in
    FStar_Parser_AST.mk_term uu____199 r FStar_Parser_AST.Kind
  
let (tm_type : FStar_Range.range -> FStar_Parser_AST.term) =
  fun r  ->
    let uu____206 =
      let uu____207 = FStar_Ident.lid_of_path ["Type"] r  in
      FStar_Parser_AST.Name uu____207  in
    FStar_Parser_AST.mk_term uu____206 r FStar_Parser_AST.Kind
  
let rec (is_comp_type :
  FStar_Syntax_DsEnv.env -> FStar_Parser_AST.term -> Prims.bool) =
  fun env  ->
    fun t  ->
      let uu____218 =
        let uu____219 = unparen t  in uu____219.FStar_Parser_AST.tm  in
      match uu____218 with
      | FStar_Parser_AST.Name l ->
          let uu____221 = FStar_Syntax_DsEnv.try_lookup_effect_name env l  in
          FStar_All.pipe_right uu____221 FStar_Option.isSome
      | FStar_Parser_AST.Construct (l,uu____227) ->
          let uu____240 = FStar_Syntax_DsEnv.try_lookup_effect_name env l  in
          FStar_All.pipe_right uu____240 FStar_Option.isSome
      | FStar_Parser_AST.App (head1,uu____246,uu____247) ->
          is_comp_type env head1
      | FStar_Parser_AST.Paren t1 -> failwith "impossible"
      | FStar_Parser_AST.Ascribed (t1,uu____250,uu____251) ->
          is_comp_type env t1
      | FStar_Parser_AST.LetOpen (uu____256,t1) -> is_comp_type env t1
      | uu____258 -> false
  
let (unit_ty : FStar_Parser_AST.term) =
  FStar_Parser_AST.mk_term
    (FStar_Parser_AST.Name FStar_Parser_Const.unit_lid)
    FStar_Range.dummyRange FStar_Parser_AST.Type_level
  
let (compile_op_lid :
  Prims.int -> Prims.string -> FStar_Range.range -> FStar_Ident.lident) =
  fun n1  ->
    fun s  ->
      fun r  ->
        let uu____274 =
          let uu____277 =
            let uu____278 =
              let uu____283 = FStar_Parser_AST.compile_op n1 s r  in
              (uu____283, r)  in
            FStar_Ident.mk_ident uu____278  in
          [uu____277]  in
        FStar_All.pipe_right uu____274 FStar_Ident.lid_of_ids
  
let op_as_term :
  'Auu____296 .
    FStar_Syntax_DsEnv.env ->
      Prims.int ->
        'Auu____296 ->
          FStar_Ident.ident ->
            FStar_Syntax_Syntax.term FStar_Pervasives_Native.option
  =
  fun env  ->
    fun arity  ->
      fun rng  ->
        fun op  ->
          let r l dd =
            let uu____332 =
              let uu____333 =
                let uu____334 =
                  FStar_Ident.set_lid_range l op.FStar_Ident.idRange  in
                FStar_Syntax_Syntax.lid_as_fv uu____334 dd
                  FStar_Pervasives_Native.None
                 in
              FStar_All.pipe_right uu____333 FStar_Syntax_Syntax.fv_to_tm  in
            FStar_Pervasives_Native.Some uu____332  in
          let fallback uu____342 =
            let uu____343 = FStar_Ident.text_of_id op  in
            match uu____343 with
            | "=" ->
                r FStar_Parser_Const.op_Eq
                  FStar_Syntax_Syntax.delta_equational
            | ":=" ->
                r FStar_Parser_Const.write_lid
                  FStar_Syntax_Syntax.delta_equational
            | "<" ->
                r FStar_Parser_Const.op_LT
                  FStar_Syntax_Syntax.delta_equational
            | "<=" ->
                r FStar_Parser_Const.op_LTE
                  FStar_Syntax_Syntax.delta_equational
            | ">" ->
                r FStar_Parser_Const.op_GT
                  FStar_Syntax_Syntax.delta_equational
            | ">=" ->
                r FStar_Parser_Const.op_GTE
                  FStar_Syntax_Syntax.delta_equational
            | "&&" ->
                r FStar_Parser_Const.op_And
                  FStar_Syntax_Syntax.delta_equational
            | "||" ->
                r FStar_Parser_Const.op_Or
                  FStar_Syntax_Syntax.delta_equational
            | "+" ->
                r FStar_Parser_Const.op_Addition
                  FStar_Syntax_Syntax.delta_equational
            | "-" when arity = (Prims.parse_int "1") ->
                r FStar_Parser_Const.op_Minus
                  FStar_Syntax_Syntax.delta_equational
            | "-" ->
                r FStar_Parser_Const.op_Subtraction
                  FStar_Syntax_Syntax.delta_equational
            | "/" ->
                r FStar_Parser_Const.op_Division
                  FStar_Syntax_Syntax.delta_equational
            | "%" ->
                r FStar_Parser_Const.op_Modulus
                  FStar_Syntax_Syntax.delta_equational
            | "!" ->
                r FStar_Parser_Const.read_lid
                  FStar_Syntax_Syntax.delta_equational
            | "@" ->
                let uu____346 = FStar_Options.ml_ish ()  in
                if uu____346
                then
                  r FStar_Parser_Const.list_append_lid
                    FStar_Syntax_Syntax.delta_equational
                else
                  r FStar_Parser_Const.list_tot_append_lid
                    FStar_Syntax_Syntax.delta_equational
            | "^" ->
                r FStar_Parser_Const.strcat_lid
                  FStar_Syntax_Syntax.delta_equational
            | "|>" ->
                r FStar_Parser_Const.pipe_right_lid
                  FStar_Syntax_Syntax.delta_equational
            | "<|" ->
                r FStar_Parser_Const.pipe_left_lid
                  FStar_Syntax_Syntax.delta_equational
            | "<>" ->
                r FStar_Parser_Const.op_notEq
                  FStar_Syntax_Syntax.delta_equational
            | "~" ->
                r FStar_Parser_Const.not_lid
                  (FStar_Syntax_Syntax.Delta_constant_at_level
                     (Prims.parse_int "2"))
            | "==" ->
                r FStar_Parser_Const.eq2_lid
                  (FStar_Syntax_Syntax.Delta_constant_at_level
                     (Prims.parse_int "2"))
            | "<<" ->
                r FStar_Parser_Const.precedes_lid
                  FStar_Syntax_Syntax.delta_constant
            | "/\\" ->
                r FStar_Parser_Const.and_lid
                  (FStar_Syntax_Syntax.Delta_constant_at_level
                     (Prims.parse_int "1"))
            | "\\/" ->
                r FStar_Parser_Const.or_lid
                  (FStar_Syntax_Syntax.Delta_constant_at_level
                     (Prims.parse_int "1"))
            | "==>" ->
                r FStar_Parser_Const.imp_lid
                  (FStar_Syntax_Syntax.Delta_constant_at_level
                     (Prims.parse_int "1"))
            | "<==>" ->
                r FStar_Parser_Const.iff_lid
                  (FStar_Syntax_Syntax.Delta_constant_at_level
                     (Prims.parse_int "2"))
            | uu____350 -> FStar_Pervasives_Native.None  in
          let uu____351 =
            let uu____358 =
              compile_op_lid arity op.FStar_Ident.idText
                op.FStar_Ident.idRange
               in
            FStar_Syntax_DsEnv.try_lookup_lid env uu____358  in
          match uu____351 with
          | FStar_Pervasives_Native.Some t ->
              FStar_Pervasives_Native.Some (FStar_Pervasives_Native.fst t)
          | uu____370 -> fallback ()
  
let (sort_ftv : FStar_Ident.ident Prims.list -> FStar_Ident.ident Prims.list)
  =
  fun ftv  ->
    let uu____388 =
      FStar_Util.remove_dups
        (fun x  -> fun y  -> x.FStar_Ident.idText = y.FStar_Ident.idText) ftv
       in
    FStar_All.pipe_left
      (FStar_Util.sort_with
         (fun x  ->
            fun y  ->
              FStar_String.compare x.FStar_Ident.idText y.FStar_Ident.idText))
      uu____388
  
let rec (free_type_vars_b :
  FStar_Syntax_DsEnv.env ->
    FStar_Parser_AST.binder ->
      (FStar_Syntax_DsEnv.env,FStar_Ident.ident Prims.list)
        FStar_Pervasives_Native.tuple2)
  =
  fun env  ->
    fun binder  ->
      match binder.FStar_Parser_AST.b with
      | FStar_Parser_AST.Variable uu____435 -> (env, [])
      | FStar_Parser_AST.TVariable x ->
          let uu____439 = FStar_Syntax_DsEnv.push_bv env x  in
          (match uu____439 with | (env1,uu____451) -> (env1, [x]))
      | FStar_Parser_AST.Annotated (uu____454,term) ->
          let uu____456 = free_type_vars env term  in (env, uu____456)
      | FStar_Parser_AST.TAnnotated (id1,uu____462) ->
          let uu____463 = FStar_Syntax_DsEnv.push_bv env id1  in
          (match uu____463 with | (env1,uu____475) -> (env1, []))
      | FStar_Parser_AST.NoName t ->
          let uu____479 = free_type_vars env t  in (env, uu____479)

and (free_type_vars :
  FStar_Syntax_DsEnv.env ->
    FStar_Parser_AST.term -> FStar_Ident.ident Prims.list)
  =
  fun env  ->
    fun t  ->
      let uu____486 =
        let uu____487 = unparen t  in uu____487.FStar_Parser_AST.tm  in
      match uu____486 with
      | FStar_Parser_AST.Labeled uu____490 ->
          failwith "Impossible --- labeled source term"
      | FStar_Parser_AST.Tvar a ->
          let uu____500 = FStar_Syntax_DsEnv.try_lookup_id env a  in
          (match uu____500 with
           | FStar_Pervasives_Native.None  -> [a]
           | uu____513 -> [])
      | FStar_Parser_AST.Wild  -> []
      | FStar_Parser_AST.Const uu____520 -> []
      | FStar_Parser_AST.Uvar uu____521 -> []
      | FStar_Parser_AST.Var uu____522 -> []
      | FStar_Parser_AST.Projector uu____523 -> []
      | FStar_Parser_AST.Discrim uu____528 -> []
      | FStar_Parser_AST.Name uu____529 -> []
      | FStar_Parser_AST.Requires (t1,uu____531) -> free_type_vars env t1
      | FStar_Parser_AST.Ensures (t1,uu____537) -> free_type_vars env t1
      | FStar_Parser_AST.NamedTyp (uu____542,t1) -> free_type_vars env t1
      | FStar_Parser_AST.Paren t1 -> failwith "impossible"
      | FStar_Parser_AST.Ascribed (t1,t',tacopt) ->
          let ts = t1 :: t' ::
            (match tacopt with
             | FStar_Pervasives_Native.None  -> []
             | FStar_Pervasives_Native.Some t2 -> [t2])
             in
          FStar_List.collect (free_type_vars env) ts
      | FStar_Parser_AST.Construct (uu____560,ts) ->
          FStar_List.collect
            (fun uu____581  ->
               match uu____581 with | (t1,uu____589) -> free_type_vars env t1)
            ts
      | FStar_Parser_AST.Op (uu____590,ts) ->
          FStar_List.collect (free_type_vars env) ts
      | FStar_Parser_AST.App (t1,t2,uu____598) ->
          let uu____599 = free_type_vars env t1  in
          let uu____602 = free_type_vars env t2  in
          FStar_List.append uu____599 uu____602
      | FStar_Parser_AST.Refine (b,t1) ->
          let uu____607 = free_type_vars_b env b  in
          (match uu____607 with
           | (env1,f) ->
               let uu____622 = free_type_vars env1 t1  in
               FStar_List.append f uu____622)
      | FStar_Parser_AST.Product (binders,body) ->
          let uu____631 =
            FStar_List.fold_left
              (fun uu____651  ->
                 fun binder  ->
                   match uu____651 with
                   | (env1,free) ->
                       let uu____671 = free_type_vars_b env1 binder  in
                       (match uu____671 with
                        | (env2,f) -> (env2, (FStar_List.append f free))))
              (env, []) binders
             in
          (match uu____631 with
           | (env1,free) ->
               let uu____702 = free_type_vars env1 body  in
               FStar_List.append free uu____702)
      | FStar_Parser_AST.Sum (binders,body) ->
          let uu____711 =
            FStar_List.fold_left
              (fun uu____731  ->
                 fun binder  ->
                   match uu____731 with
                   | (env1,free) ->
                       let uu____751 = free_type_vars_b env1 binder  in
                       (match uu____751 with
                        | (env2,f) -> (env2, (FStar_List.append f free))))
              (env, []) binders
             in
          (match uu____711 with
           | (env1,free) ->
               let uu____782 = free_type_vars env1 body  in
               FStar_List.append free uu____782)
      | FStar_Parser_AST.Project (t1,uu____786) -> free_type_vars env t1
      | FStar_Parser_AST.Attributes cattributes ->
          FStar_List.collect (free_type_vars env) cattributes
      | FStar_Parser_AST.Abs uu____790 -> []
      | FStar_Parser_AST.Let uu____797 -> []
      | FStar_Parser_AST.LetOpen uu____818 -> []
      | FStar_Parser_AST.If uu____823 -> []
      | FStar_Parser_AST.QForall uu____830 -> []
      | FStar_Parser_AST.QExists uu____843 -> []
      | FStar_Parser_AST.Record uu____856 -> []
      | FStar_Parser_AST.Match uu____869 -> []
      | FStar_Parser_AST.TryWith uu____884 -> []
      | FStar_Parser_AST.Bind uu____899 -> []
      | FStar_Parser_AST.Quote uu____906 -> []
      | FStar_Parser_AST.VQuote uu____911 -> []
      | FStar_Parser_AST.Antiquote uu____912 -> []
      | FStar_Parser_AST.Seq uu____917 -> []

let (head_and_args :
  FStar_Parser_AST.term ->
    (FStar_Parser_AST.term,(FStar_Parser_AST.term,FStar_Parser_AST.imp)
                             FStar_Pervasives_Native.tuple2 Prims.list)
      FStar_Pervasives_Native.tuple2)
  =
  fun t  ->
    let rec aux args t1 =
      let uu____970 =
        let uu____971 = unparen t1  in uu____971.FStar_Parser_AST.tm  in
      match uu____970 with
      | FStar_Parser_AST.App (t2,arg,imp) -> aux ((arg, imp) :: args) t2
      | FStar_Parser_AST.Construct (l,args') ->
          ({
             FStar_Parser_AST.tm = (FStar_Parser_AST.Name l);
             FStar_Parser_AST.range = (t1.FStar_Parser_AST.range);
             FStar_Parser_AST.level = (t1.FStar_Parser_AST.level)
           }, (FStar_List.append args' args))
      | uu____1013 -> (t1, args)  in
    aux [] t
  
let (close :
  FStar_Syntax_DsEnv.env -> FStar_Parser_AST.term -> FStar_Parser_AST.term) =
  fun env  ->
    fun t  ->
      let ftv =
        let uu____1037 = free_type_vars env t  in
        FStar_All.pipe_left sort_ftv uu____1037  in
      if (FStar_List.length ftv) = (Prims.parse_int "0")
      then t
      else
        (let binders =
           FStar_All.pipe_right ftv
             (FStar_List.map
                (fun x  ->
                   let uu____1055 =
                     let uu____1056 =
                       let uu____1061 = tm_type x.FStar_Ident.idRange  in
                       (x, uu____1061)  in
                     FStar_Parser_AST.TAnnotated uu____1056  in
                   FStar_Parser_AST.mk_binder uu____1055
                     x.FStar_Ident.idRange FStar_Parser_AST.Type_level
                     (FStar_Pervasives_Native.Some FStar_Parser_AST.Implicit)))
            in
         let result =
           FStar_Parser_AST.mk_term (FStar_Parser_AST.Product (binders, t))
             t.FStar_Parser_AST.range t.FStar_Parser_AST.level
            in
         result)
  
let (close_fun :
  FStar_Syntax_DsEnv.env -> FStar_Parser_AST.term -> FStar_Parser_AST.term) =
  fun env  ->
    fun t  ->
      let ftv =
        let uu____1078 = free_type_vars env t  in
        FStar_All.pipe_left sort_ftv uu____1078  in
      if (FStar_List.length ftv) = (Prims.parse_int "0")
      then t
      else
        (let binders =
           FStar_All.pipe_right ftv
             (FStar_List.map
                (fun x  ->
                   let uu____1096 =
                     let uu____1097 =
                       let uu____1102 = tm_type x.FStar_Ident.idRange  in
                       (x, uu____1102)  in
                     FStar_Parser_AST.TAnnotated uu____1097  in
                   FStar_Parser_AST.mk_binder uu____1096
                     x.FStar_Ident.idRange FStar_Parser_AST.Type_level
                     (FStar_Pervasives_Native.Some FStar_Parser_AST.Implicit)))
            in
         let t1 =
           let uu____1104 =
             let uu____1105 = unparen t  in uu____1105.FStar_Parser_AST.tm
              in
           match uu____1104 with
           | FStar_Parser_AST.Product uu____1106 -> t
           | uu____1113 ->
               FStar_Parser_AST.mk_term
                 (FStar_Parser_AST.App
                    ((FStar_Parser_AST.mk_term
                        (FStar_Parser_AST.Name
                           FStar_Parser_Const.effect_Tot_lid)
                        t.FStar_Parser_AST.range t.FStar_Parser_AST.level),
                      t, FStar_Parser_AST.Nothing)) t.FStar_Parser_AST.range
                 t.FStar_Parser_AST.level
            in
         let result =
           FStar_Parser_AST.mk_term (FStar_Parser_AST.Product (binders, t1))
             t1.FStar_Parser_AST.range t1.FStar_Parser_AST.level
            in
         result)
  
let rec (uncurry :
  FStar_Parser_AST.binder Prims.list ->
    FStar_Parser_AST.term ->
      (FStar_Parser_AST.binder Prims.list,FStar_Parser_AST.term)
        FStar_Pervasives_Native.tuple2)
  =
  fun bs  ->
    fun t  ->
      match t.FStar_Parser_AST.tm with
      | FStar_Parser_AST.Product (binders,t1) ->
          uncurry (FStar_List.append bs binders) t1
      | uu____1149 -> (bs, t)
  
let rec (is_var_pattern : FStar_Parser_AST.pattern -> Prims.bool) =
  fun p  ->
    match p.FStar_Parser_AST.pat with
    | FStar_Parser_AST.PatWild  -> true
    | FStar_Parser_AST.PatTvar (uu____1157,uu____1158) -> true
    | FStar_Parser_AST.PatVar (uu____1163,uu____1164) -> true
    | FStar_Parser_AST.PatAscribed (p1,uu____1170) -> is_var_pattern p1
    | uu____1183 -> false
  
let rec (is_app_pattern : FStar_Parser_AST.pattern -> Prims.bool) =
  fun p  ->
    match p.FStar_Parser_AST.pat with
    | FStar_Parser_AST.PatAscribed (p1,uu____1190) -> is_app_pattern p1
    | FStar_Parser_AST.PatApp
        ({ FStar_Parser_AST.pat = FStar_Parser_AST.PatVar uu____1203;
           FStar_Parser_AST.prange = uu____1204;_},uu____1205)
        -> true
    | uu____1216 -> false
  
let (replace_unit_pattern :
  FStar_Parser_AST.pattern -> FStar_Parser_AST.pattern) =
  fun p  ->
    match p.FStar_Parser_AST.pat with
    | FStar_Parser_AST.PatConst (FStar_Const.Const_unit ) ->
        FStar_Parser_AST.mk_pattern
          (FStar_Parser_AST.PatAscribed
             ((FStar_Parser_AST.mk_pattern FStar_Parser_AST.PatWild
                 p.FStar_Parser_AST.prange),
               (unit_ty, FStar_Pervasives_Native.None)))
          p.FStar_Parser_AST.prange
    | uu____1230 -> p
  
let rec (destruct_app_pattern :
  FStar_Syntax_DsEnv.env ->
    Prims.bool ->
      FStar_Parser_AST.pattern ->
        ((FStar_Ident.ident,FStar_Ident.lident) FStar_Util.either,FStar_Parser_AST.pattern
                                                                    Prims.list,
          (FStar_Parser_AST.term,FStar_Parser_AST.term
                                   FStar_Pervasives_Native.option)
            FStar_Pervasives_Native.tuple2 FStar_Pervasives_Native.option)
          FStar_Pervasives_Native.tuple3)
  =
  fun env  ->
    fun is_top_level1  ->
      fun p  ->
        match p.FStar_Parser_AST.pat with
        | FStar_Parser_AST.PatAscribed (p1,t) ->
            let uu____1300 = destruct_app_pattern env is_top_level1 p1  in
            (match uu____1300 with
             | (name,args,uu____1343) ->
                 (name, args, (FStar_Pervasives_Native.Some t)))
        | FStar_Parser_AST.PatApp
            ({
               FStar_Parser_AST.pat = FStar_Parser_AST.PatVar
                 (id1,uu____1393);
               FStar_Parser_AST.prange = uu____1394;_},args)
            when is_top_level1 ->
            let uu____1404 =
              let uu____1409 = FStar_Syntax_DsEnv.qualify env id1  in
              FStar_Util.Inr uu____1409  in
            (uu____1404, args, FStar_Pervasives_Native.None)
        | FStar_Parser_AST.PatApp
            ({
               FStar_Parser_AST.pat = FStar_Parser_AST.PatVar
                 (id1,uu____1431);
               FStar_Parser_AST.prange = uu____1432;_},args)
            -> ((FStar_Util.Inl id1), args, FStar_Pervasives_Native.None)
        | uu____1462 -> failwith "Not an app pattern"
  
let rec (gather_pattern_bound_vars_maybe_top :
  FStar_Ident.ident FStar_Util.set ->
    FStar_Parser_AST.pattern -> FStar_Ident.ident FStar_Util.set)
  =
  fun acc  ->
    fun p  ->
      let gather_pattern_bound_vars_from_list =
        FStar_List.fold_left gather_pattern_bound_vars_maybe_top acc  in
      match p.FStar_Parser_AST.pat with
      | FStar_Parser_AST.PatWild  -> acc
      | FStar_Parser_AST.PatConst uu____1512 -> acc
      | FStar_Parser_AST.PatVar
          (uu____1513,FStar_Pervasives_Native.Some (FStar_Parser_AST.Implicit
           ))
          -> acc
      | FStar_Parser_AST.PatName uu____1516 -> acc
      | FStar_Parser_AST.PatTvar uu____1517 -> acc
      | FStar_Parser_AST.PatOp uu____1524 -> acc
      | FStar_Parser_AST.PatApp (phead,pats) ->
          gather_pattern_bound_vars_from_list (phead :: pats)
      | FStar_Parser_AST.PatVar (x,uu____1532) -> FStar_Util.set_add x acc
      | FStar_Parser_AST.PatList pats ->
          gather_pattern_bound_vars_from_list pats
      | FStar_Parser_AST.PatTuple (pats,uu____1541) ->
          gather_pattern_bound_vars_from_list pats
      | FStar_Parser_AST.PatOr pats ->
          gather_pattern_bound_vars_from_list pats
      | FStar_Parser_AST.PatRecord guarded_pats ->
          let uu____1556 =
            FStar_List.map FStar_Pervasives_Native.snd guarded_pats  in
          gather_pattern_bound_vars_from_list uu____1556
      | FStar_Parser_AST.PatAscribed (pat,uu____1564) ->
          gather_pattern_bound_vars_maybe_top acc pat
  
let (gather_pattern_bound_vars :
  FStar_Parser_AST.pattern -> FStar_Ident.ident FStar_Util.set) =
  let acc =
    FStar_Util.new_set
      (fun id1  ->
         fun id2  ->
           if id1.FStar_Ident.idText = id2.FStar_Ident.idText
           then (Prims.parse_int "0")
           else (Prims.parse_int "1"))
     in
  fun p  -> gather_pattern_bound_vars_maybe_top acc p 
type bnd =
  | LocalBinder of (FStar_Syntax_Syntax.bv,FStar_Syntax_Syntax.aqual)
  FStar_Pervasives_Native.tuple2 
  | LetBinder of
  (FStar_Ident.lident,(FStar_Syntax_Syntax.term,FStar_Syntax_Syntax.term
                                                  FStar_Pervasives_Native.option)
                        FStar_Pervasives_Native.tuple2)
  FStar_Pervasives_Native.tuple2 
let (uu___is_LocalBinder : bnd -> Prims.bool) =
  fun projectee  ->
    match projectee with | LocalBinder _0 -> true | uu____1626 -> false
  
let (__proj__LocalBinder__item___0 :
  bnd ->
    (FStar_Syntax_Syntax.bv,FStar_Syntax_Syntax.aqual)
      FStar_Pervasives_Native.tuple2)
  = fun projectee  -> match projectee with | LocalBinder _0 -> _0 
let (uu___is_LetBinder : bnd -> Prims.bool) =
  fun projectee  ->
    match projectee with | LetBinder _0 -> true | uu____1662 -> false
  
let (__proj__LetBinder__item___0 :
  bnd ->
    (FStar_Ident.lident,(FStar_Syntax_Syntax.term,FStar_Syntax_Syntax.term
                                                    FStar_Pervasives_Native.option)
                          FStar_Pervasives_Native.tuple2)
      FStar_Pervasives_Native.tuple2)
  = fun projectee  -> match projectee with | LetBinder _0 -> _0 
let (binder_of_bnd :
  bnd ->
    (FStar_Syntax_Syntax.bv,FStar_Syntax_Syntax.aqual)
      FStar_Pervasives_Native.tuple2)
  =
  fun uu___233_1708  ->
    match uu___233_1708 with
    | LocalBinder (a,aq) -> (a, aq)
    | uu____1715 -> failwith "Impossible"
  
let (as_binder :
  FStar_Syntax_DsEnv.env ->
    FStar_Parser_AST.arg_qualifier FStar_Pervasives_Native.option ->
      (FStar_Ident.ident FStar_Pervasives_Native.option,FStar_Syntax_Syntax.term'
                                                          FStar_Syntax_Syntax.syntax)
        FStar_Pervasives_Native.tuple2 ->
        ((FStar_Syntax_Syntax.bv,FStar_Syntax_Syntax.aqual)
           FStar_Pervasives_Native.tuple2,FStar_Syntax_DsEnv.env)
          FStar_Pervasives_Native.tuple2)
  =
  fun env  ->
    fun imp  ->
      fun uu___234_1752  ->
        match uu___234_1752 with
        | (FStar_Pervasives_Native.None ,k) ->
            let uu____1778 = FStar_Syntax_Syntax.null_binder k  in
            (uu____1778, env)
        | (FStar_Pervasives_Native.Some a,k) ->
            let uu____1795 = FStar_Syntax_DsEnv.push_bv env a  in
            (match uu____1795 with
             | (env1,a1) ->
                 (((let uu___258_1815 = a1  in
                    {
                      FStar_Syntax_Syntax.ppname =
                        (uu___258_1815.FStar_Syntax_Syntax.ppname);
                      FStar_Syntax_Syntax.index =
                        (uu___258_1815.FStar_Syntax_Syntax.index);
                      FStar_Syntax_Syntax.sort = k
                    }), (trans_aqual imp)), env1))
  
type env_t = FStar_Syntax_DsEnv.env
type lenv_t = FStar_Syntax_Syntax.bv Prims.list
let (mk_lb :
  (FStar_Syntax_Syntax.term' FStar_Syntax_Syntax.syntax Prims.list,(FStar_Syntax_Syntax.bv,
                                                                    FStar_Syntax_Syntax.fv)
                                                                    FStar_Util.either,
    FStar_Syntax_Syntax.term' FStar_Syntax_Syntax.syntax,FStar_Syntax_Syntax.term'
                                                           FStar_Syntax_Syntax.syntax,
    FStar_Range.range) FStar_Pervasives_Native.tuple5 ->
    FStar_Syntax_Syntax.letbinding)
  =
  fun uu____1844  ->
    match uu____1844 with
    | (attrs,n1,t,e,pos) ->
        {
          FStar_Syntax_Syntax.lbname = n1;
          FStar_Syntax_Syntax.lbunivs = [];
          FStar_Syntax_Syntax.lbtyp = t;
          FStar_Syntax_Syntax.lbeff = FStar_Parser_Const.effect_ALL_lid;
          FStar_Syntax_Syntax.lbdef = e;
          FStar_Syntax_Syntax.lbattrs = attrs;
          FStar_Syntax_Syntax.lbpos = pos
        }
  
let (no_annot_abs :
  FStar_Syntax_Syntax.binders ->
    FStar_Syntax_Syntax.term' FStar_Syntax_Syntax.syntax ->
      FStar_Syntax_Syntax.term' FStar_Syntax_Syntax.syntax)
  =
  fun bs  ->
    fun t  -> FStar_Syntax_Util.abs bs t FStar_Pervasives_Native.None
  
let (mk_ref_read :
  FStar_Syntax_Syntax.term' FStar_Syntax_Syntax.syntax ->
    FStar_Syntax_Syntax.term' FStar_Syntax_Syntax.syntax)
  =
  fun tm  ->
    let tm' =
      let uu____1924 =
        let uu____1939 =
          let uu____1942 =
            FStar_Syntax_Syntax.lid_as_fv FStar_Parser_Const.sread_lid
              FStar_Syntax_Syntax.delta_constant FStar_Pervasives_Native.None
             in
          FStar_Syntax_Syntax.fv_to_tm uu____1942  in
        let uu____1943 =
          let uu____1952 =
            let uu____1959 = FStar_Syntax_Syntax.as_implicit false  in
            (tm, uu____1959)  in
          [uu____1952]  in
        (uu____1939, uu____1943)  in
      FStar_Syntax_Syntax.Tm_app uu____1924  in
    FStar_Syntax_Syntax.mk tm' FStar_Pervasives_Native.None
      tm.FStar_Syntax_Syntax.pos
  
let (mk_ref_alloc :
  FStar_Syntax_Syntax.term' FStar_Syntax_Syntax.syntax ->
    FStar_Syntax_Syntax.term' FStar_Syntax_Syntax.syntax)
  =
  fun tm  ->
    let tm' =
      let uu____1996 =
        let uu____2011 =
          let uu____2014 =
            FStar_Syntax_Syntax.lid_as_fv FStar_Parser_Const.salloc_lid
              FStar_Syntax_Syntax.delta_constant FStar_Pervasives_Native.None
             in
          FStar_Syntax_Syntax.fv_to_tm uu____2014  in
        let uu____2015 =
          let uu____2024 =
            let uu____2031 = FStar_Syntax_Syntax.as_implicit false  in
            (tm, uu____2031)  in
          [uu____2024]  in
        (uu____2011, uu____2015)  in
      FStar_Syntax_Syntax.Tm_app uu____1996  in
    FStar_Syntax_Syntax.mk tm' FStar_Pervasives_Native.None
      tm.FStar_Syntax_Syntax.pos
  
let (mk_ref_assign :
  FStar_Syntax_Syntax.term' FStar_Syntax_Syntax.syntax ->
    FStar_Syntax_Syntax.term' FStar_Syntax_Syntax.syntax ->
      FStar_Range.range ->
        FStar_Syntax_Syntax.term' FStar_Syntax_Syntax.syntax)
  =
  fun t1  ->
    fun t2  ->
      fun pos  ->
        let tm =
          let uu____2082 =
            let uu____2097 =
              let uu____2100 =
                FStar_Syntax_Syntax.lid_as_fv FStar_Parser_Const.swrite_lid
                  FStar_Syntax_Syntax.delta_constant
                  FStar_Pervasives_Native.None
                 in
              FStar_Syntax_Syntax.fv_to_tm uu____2100  in
            let uu____2101 =
              let uu____2110 =
                let uu____2117 = FStar_Syntax_Syntax.as_implicit false  in
                (t1, uu____2117)  in
              let uu____2120 =
                let uu____2129 =
                  let uu____2136 = FStar_Syntax_Syntax.as_implicit false  in
                  (t2, uu____2136)  in
                [uu____2129]  in
              uu____2110 :: uu____2120  in
            (uu____2097, uu____2101)  in
          FStar_Syntax_Syntax.Tm_app uu____2082  in
        FStar_Syntax_Syntax.mk tm FStar_Pervasives_Native.None pos
  
let (generalize_annotated_univs :
  FStar_Syntax_Syntax.sigelt -> FStar_Syntax_Syntax.sigelt) =
  fun s  ->
    let bs_univnames bs =
      let uu____2182 =
        let uu____2195 =
          FStar_Util.new_set FStar_Syntax_Syntax.order_univ_name  in
        FStar_List.fold_left
          (fun uvs  ->
             fun uu____2212  ->
               match uu____2212 with
               | ({ FStar_Syntax_Syntax.ppname = uu____2221;
                    FStar_Syntax_Syntax.index = uu____2222;
                    FStar_Syntax_Syntax.sort = t;_},uu____2224)
                   ->
                   let uu____2227 = FStar_Syntax_Free.univnames t  in
                   FStar_Util.set_union uvs uu____2227) uu____2195
         in
      FStar_All.pipe_right bs uu____2182  in
    let empty_set = FStar_Util.new_set FStar_Syntax_Syntax.order_univ_name
       in
    match s.FStar_Syntax_Syntax.sigel with
    | FStar_Syntax_Syntax.Sig_inductive_typ uu____2241 ->
        failwith
          "Impossible: collect_annotated_universes: bare data/type constructor"
    | FStar_Syntax_Syntax.Sig_datacon uu____2258 ->
        failwith
          "Impossible: collect_annotated_universes: bare data/type constructor"
    | FStar_Syntax_Syntax.Sig_bundle (sigs,lids) ->
        let uvs =
          let uu____2284 =
            FStar_All.pipe_right sigs
              (FStar_List.fold_left
                 (fun uvs  ->
                    fun se  ->
                      let se_univs =
                        match se.FStar_Syntax_Syntax.sigel with
                        | FStar_Syntax_Syntax.Sig_inductive_typ
                            (uu____2305,uu____2306,bs,t,uu____2309,uu____2310)
                            ->
                            let uu____2319 = bs_univnames bs  in
                            let uu____2322 = FStar_Syntax_Free.univnames t
                               in
                            FStar_Util.set_union uu____2319 uu____2322
                        | FStar_Syntax_Syntax.Sig_datacon
                            (uu____2325,uu____2326,t,uu____2328,uu____2329,uu____2330)
                            -> FStar_Syntax_Free.univnames t
                        | uu____2335 ->
                            failwith
                              "Impossible: collect_annotated_universes: Sig_bundle should not have a non data/type sigelt"
                         in
                      FStar_Util.set_union uvs se_univs) empty_set)
             in
          FStar_All.pipe_right uu____2284 FStar_Util.set_elements  in
        let usubst = FStar_Syntax_Subst.univ_var_closing uvs  in
        let uu___259_2343 = s  in
        let uu____2344 =
          let uu____2345 =
            let uu____2354 =
              FStar_All.pipe_right sigs
                (FStar_List.map
                   (fun se  ->
                      match se.FStar_Syntax_Syntax.sigel with
                      | FStar_Syntax_Syntax.Sig_inductive_typ
                          (lid,uu____2372,bs,t,lids1,lids2) ->
                          let uu___260_2385 = se  in
                          let uu____2386 =
                            let uu____2387 =
                              let uu____2404 =
                                FStar_Syntax_Subst.subst_binders usubst bs
                                 in
                              let uu____2405 =
                                let uu____2406 =
                                  FStar_Syntax_Subst.shift_subst
                                    (FStar_List.length bs) usubst
                                   in
                                FStar_Syntax_Subst.subst uu____2406 t  in
                              (lid, uvs, uu____2404, uu____2405, lids1,
                                lids2)
                               in
                            FStar_Syntax_Syntax.Sig_inductive_typ uu____2387
                             in
                          {
                            FStar_Syntax_Syntax.sigel = uu____2386;
                            FStar_Syntax_Syntax.sigrng =
                              (uu___260_2385.FStar_Syntax_Syntax.sigrng);
                            FStar_Syntax_Syntax.sigquals =
                              (uu___260_2385.FStar_Syntax_Syntax.sigquals);
                            FStar_Syntax_Syntax.sigmeta =
                              (uu___260_2385.FStar_Syntax_Syntax.sigmeta);
                            FStar_Syntax_Syntax.sigattrs =
                              (uu___260_2385.FStar_Syntax_Syntax.sigattrs)
                          }
                      | FStar_Syntax_Syntax.Sig_datacon
                          (lid,uu____2418,t,tlid,n1,lids1) ->
                          let uu___261_2427 = se  in
                          let uu____2428 =
                            let uu____2429 =
                              let uu____2444 =
                                FStar_Syntax_Subst.subst usubst t  in
                              (lid, uvs, uu____2444, tlid, n1, lids1)  in
                            FStar_Syntax_Syntax.Sig_datacon uu____2429  in
                          {
                            FStar_Syntax_Syntax.sigel = uu____2428;
                            FStar_Syntax_Syntax.sigrng =
                              (uu___261_2427.FStar_Syntax_Syntax.sigrng);
                            FStar_Syntax_Syntax.sigquals =
                              (uu___261_2427.FStar_Syntax_Syntax.sigquals);
                            FStar_Syntax_Syntax.sigmeta =
                              (uu___261_2427.FStar_Syntax_Syntax.sigmeta);
                            FStar_Syntax_Syntax.sigattrs =
                              (uu___261_2427.FStar_Syntax_Syntax.sigattrs)
                          }
                      | uu____2447 ->
                          failwith
                            "Impossible: collect_annotated_universes: Sig_bundle should not have a non data/type sigelt"))
               in
            (uu____2354, lids)  in
          FStar_Syntax_Syntax.Sig_bundle uu____2345  in
        {
          FStar_Syntax_Syntax.sigel = uu____2344;
          FStar_Syntax_Syntax.sigrng =
            (uu___259_2343.FStar_Syntax_Syntax.sigrng);
          FStar_Syntax_Syntax.sigquals =
            (uu___259_2343.FStar_Syntax_Syntax.sigquals);
          FStar_Syntax_Syntax.sigmeta =
            (uu___259_2343.FStar_Syntax_Syntax.sigmeta);
          FStar_Syntax_Syntax.sigattrs =
            (uu___259_2343.FStar_Syntax_Syntax.sigattrs)
        }
    | FStar_Syntax_Syntax.Sig_declare_typ (lid,uu____2453,t) ->
        let uvs =
          let uu____2456 = FStar_Syntax_Free.univnames t  in
          FStar_All.pipe_right uu____2456 FStar_Util.set_elements  in
        let uu___262_2461 = s  in
        let uu____2462 =
          let uu____2463 =
            let uu____2470 = FStar_Syntax_Subst.close_univ_vars uvs t  in
            (lid, uvs, uu____2470)  in
          FStar_Syntax_Syntax.Sig_declare_typ uu____2463  in
        {
          FStar_Syntax_Syntax.sigel = uu____2462;
          FStar_Syntax_Syntax.sigrng =
            (uu___262_2461.FStar_Syntax_Syntax.sigrng);
          FStar_Syntax_Syntax.sigquals =
            (uu___262_2461.FStar_Syntax_Syntax.sigquals);
          FStar_Syntax_Syntax.sigmeta =
            (uu___262_2461.FStar_Syntax_Syntax.sigmeta);
          FStar_Syntax_Syntax.sigattrs =
            (uu___262_2461.FStar_Syntax_Syntax.sigattrs)
        }
    | FStar_Syntax_Syntax.Sig_let ((b,lbs),lids) ->
        let lb_univnames lb =
          let uu____2492 =
            FStar_Syntax_Free.univnames lb.FStar_Syntax_Syntax.lbtyp  in
          let uu____2495 =
            match (lb.FStar_Syntax_Syntax.lbdef).FStar_Syntax_Syntax.n with
            | FStar_Syntax_Syntax.Tm_abs (bs,e,uu____2502) ->
                let uvs1 = bs_univnames bs  in
                let uvs2 =
                  match e.FStar_Syntax_Syntax.n with
                  | FStar_Syntax_Syntax.Tm_ascribed
                      (uu____2531,(FStar_Util.Inl t,uu____2533),uu____2534)
                      -> FStar_Syntax_Free.univnames t
                  | FStar_Syntax_Syntax.Tm_ascribed
                      (uu____2581,(FStar_Util.Inr c,uu____2583),uu____2584)
                      -> FStar_Syntax_Free.univnames_comp c
                  | uu____2631 -> empty_set  in
                FStar_Util.set_union uvs1 uvs2
            | FStar_Syntax_Syntax.Tm_ascribed
                (uu____2632,(FStar_Util.Inl t,uu____2634),uu____2635) ->
                FStar_Syntax_Free.univnames t
            | FStar_Syntax_Syntax.Tm_ascribed
                (uu____2682,(FStar_Util.Inr c,uu____2684),uu____2685) ->
                FStar_Syntax_Free.univnames_comp c
            | uu____2732 -> empty_set  in
          FStar_Util.set_union uu____2492 uu____2495  in
        let all_lb_univs =
          let uu____2736 =
            FStar_All.pipe_right lbs
              (FStar_List.fold_left
                 (fun uvs  ->
                    fun lb  ->
                      let uu____2752 = lb_univnames lb  in
                      FStar_Util.set_union uvs uu____2752) empty_set)
             in
          FStar_All.pipe_right uu____2736 FStar_Util.set_elements  in
        let usubst = FStar_Syntax_Subst.univ_var_closing all_lb_univs  in
        let uu___263_2762 = s  in
        let uu____2763 =
          let uu____2764 =
            let uu____2771 =
              let uu____2772 =
                FStar_All.pipe_right lbs
                  (FStar_List.map
                     (fun lb  ->
                        let uu___264_2784 = lb  in
                        let uu____2785 =
                          FStar_Syntax_Subst.subst usubst
                            lb.FStar_Syntax_Syntax.lbtyp
                           in
                        let uu____2788 =
                          FStar_Syntax_Subst.subst usubst
                            lb.FStar_Syntax_Syntax.lbdef
                           in
                        {
                          FStar_Syntax_Syntax.lbname =
                            (uu___264_2784.FStar_Syntax_Syntax.lbname);
                          FStar_Syntax_Syntax.lbunivs = all_lb_univs;
                          FStar_Syntax_Syntax.lbtyp = uu____2785;
                          FStar_Syntax_Syntax.lbeff =
                            (uu___264_2784.FStar_Syntax_Syntax.lbeff);
                          FStar_Syntax_Syntax.lbdef = uu____2788;
                          FStar_Syntax_Syntax.lbattrs =
                            (uu___264_2784.FStar_Syntax_Syntax.lbattrs);
                          FStar_Syntax_Syntax.lbpos =
                            (uu___264_2784.FStar_Syntax_Syntax.lbpos)
                        }))
                 in
              (b, uu____2772)  in
            (uu____2771, lids)  in
          FStar_Syntax_Syntax.Sig_let uu____2764  in
        {
          FStar_Syntax_Syntax.sigel = uu____2763;
          FStar_Syntax_Syntax.sigrng =
            (uu___263_2762.FStar_Syntax_Syntax.sigrng);
          FStar_Syntax_Syntax.sigquals =
            (uu___263_2762.FStar_Syntax_Syntax.sigquals);
          FStar_Syntax_Syntax.sigmeta =
            (uu___263_2762.FStar_Syntax_Syntax.sigmeta);
          FStar_Syntax_Syntax.sigattrs =
            (uu___263_2762.FStar_Syntax_Syntax.sigattrs)
        }
    | FStar_Syntax_Syntax.Sig_assume (lid,uu____2796,fml) ->
        let uvs =
          let uu____2799 = FStar_Syntax_Free.univnames fml  in
          FStar_All.pipe_right uu____2799 FStar_Util.set_elements  in
        let uu___265_2804 = s  in
        let uu____2805 =
          let uu____2806 =
            let uu____2813 = FStar_Syntax_Subst.close_univ_vars uvs fml  in
            (lid, uvs, uu____2813)  in
          FStar_Syntax_Syntax.Sig_assume uu____2806  in
        {
          FStar_Syntax_Syntax.sigel = uu____2805;
          FStar_Syntax_Syntax.sigrng =
            (uu___265_2804.FStar_Syntax_Syntax.sigrng);
          FStar_Syntax_Syntax.sigquals =
            (uu___265_2804.FStar_Syntax_Syntax.sigquals);
          FStar_Syntax_Syntax.sigmeta =
            (uu___265_2804.FStar_Syntax_Syntax.sigmeta);
          FStar_Syntax_Syntax.sigattrs =
            (uu___265_2804.FStar_Syntax_Syntax.sigattrs)
        }
    | FStar_Syntax_Syntax.Sig_effect_abbrev (lid,uu____2815,bs,c,flags1) ->
        let uvs =
          let uu____2824 =
            let uu____2827 = bs_univnames bs  in
            let uu____2830 = FStar_Syntax_Free.univnames_comp c  in
            FStar_Util.set_union uu____2827 uu____2830  in
          FStar_All.pipe_right uu____2824 FStar_Util.set_elements  in
        let usubst = FStar_Syntax_Subst.univ_var_closing uvs  in
        let uu___266_2838 = s  in
        let uu____2839 =
          let uu____2840 =
            let uu____2853 = FStar_Syntax_Subst.subst_binders usubst bs  in
            let uu____2854 = FStar_Syntax_Subst.subst_comp usubst c  in
            (lid, uvs, uu____2853, uu____2854, flags1)  in
          FStar_Syntax_Syntax.Sig_effect_abbrev uu____2840  in
        {
          FStar_Syntax_Syntax.sigel = uu____2839;
          FStar_Syntax_Syntax.sigrng =
            (uu___266_2838.FStar_Syntax_Syntax.sigrng);
          FStar_Syntax_Syntax.sigquals =
            (uu___266_2838.FStar_Syntax_Syntax.sigquals);
          FStar_Syntax_Syntax.sigmeta =
            (uu___266_2838.FStar_Syntax_Syntax.sigmeta);
          FStar_Syntax_Syntax.sigattrs =
            (uu___266_2838.FStar_Syntax_Syntax.sigattrs)
        }
    | uu____2857 -> s
  
let (is_special_effect_combinator : Prims.string -> Prims.bool) =
  fun uu___235_2862  ->
    match uu___235_2862 with
    | "repr" -> true
    | "post" -> true
    | "pre" -> true
    | "wp" -> true
    | uu____2863 -> false
  
let rec (sum_to_universe :
  FStar_Syntax_Syntax.universe -> Prims.int -> FStar_Syntax_Syntax.universe)
  =
  fun u  ->
    fun n1  ->
      if n1 = (Prims.parse_int "0")
      then u
      else
        (let uu____2875 = sum_to_universe u (n1 - (Prims.parse_int "1"))  in
         FStar_Syntax_Syntax.U_succ uu____2875)
  
let (int_to_universe : Prims.int -> FStar_Syntax_Syntax.universe) =
  fun n1  -> sum_to_universe FStar_Syntax_Syntax.U_zero n1 
let rec (desugar_maybe_non_constant_universe :
  FStar_Parser_AST.term ->
    (Prims.int,FStar_Syntax_Syntax.universe) FStar_Util.either)
  =
  fun t  ->
    let uu____2894 =
      let uu____2895 = unparen t  in uu____2895.FStar_Parser_AST.tm  in
    match uu____2894 with
    | FStar_Parser_AST.Wild  ->
        let uu____2900 =
          let uu____2901 = FStar_Syntax_Unionfind.univ_fresh ()  in
          FStar_Syntax_Syntax.U_unif uu____2901  in
        FStar_Util.Inr uu____2900
    | FStar_Parser_AST.Uvar u ->
        FStar_Util.Inr (FStar_Syntax_Syntax.U_name u)
    | FStar_Parser_AST.Const (FStar_Const.Const_int (repr,uu____2912)) ->
        let n1 = FStar_Util.int_of_string repr  in
        (if n1 < (Prims.parse_int "0")
         then
           FStar_Errors.raise_error
             (FStar_Errors.Fatal_NegativeUniverseConstFatal_NotSupported,
               (Prims.strcat
                  "Negative universe constant  are not supported : " repr))
             t.FStar_Parser_AST.range
         else ();
         FStar_Util.Inl n1)
    | FStar_Parser_AST.Op (op_plus,t1::t2::[]) ->
        let u1 = desugar_maybe_non_constant_universe t1  in
        let u2 = desugar_maybe_non_constant_universe t2  in
        (match (u1, u2) with
         | (FStar_Util.Inl n1,FStar_Util.Inl n2) -> FStar_Util.Inl (n1 + n2)
         | (FStar_Util.Inl n1,FStar_Util.Inr u) ->
             let uu____2977 = sum_to_universe u n1  in
             FStar_Util.Inr uu____2977
         | (FStar_Util.Inr u,FStar_Util.Inl n1) ->
             let uu____2988 = sum_to_universe u n1  in
             FStar_Util.Inr uu____2988
         | (FStar_Util.Inr u11,FStar_Util.Inr u21) ->
             let uu____2999 =
               let uu____3004 =
                 let uu____3005 = FStar_Parser_AST.term_to_string t  in
                 Prims.strcat
                   "This universe might contain a sum of two universe variables "
                   uu____3005
                  in
               (FStar_Errors.Fatal_UniverseMightContainSumOfTwoUnivVars,
                 uu____3004)
                in
             FStar_Errors.raise_error uu____2999 t.FStar_Parser_AST.range)
    | FStar_Parser_AST.App uu____3010 ->
        let rec aux t1 univargs =
          let uu____3044 =
            let uu____3045 = unparen t1  in uu____3045.FStar_Parser_AST.tm
             in
          match uu____3044 with
          | FStar_Parser_AST.App (t2,targ,uu____3052) ->
              let uarg = desugar_maybe_non_constant_universe targ  in
              aux t2 (uarg :: univargs)
          | FStar_Parser_AST.Var max_lid1 ->
              if
                FStar_List.existsb
                  (fun uu___236_3075  ->
                     match uu___236_3075 with
                     | FStar_Util.Inr uu____3080 -> true
                     | uu____3081 -> false) univargs
              then
                let uu____3086 =
                  let uu____3087 =
                    FStar_List.map
                      (fun uu___237_3096  ->
                         match uu___237_3096 with
                         | FStar_Util.Inl n1 -> int_to_universe n1
                         | FStar_Util.Inr u -> u) univargs
                     in
                  FStar_Syntax_Syntax.U_max uu____3087  in
                FStar_Util.Inr uu____3086
              else
                (let nargs =
                   FStar_List.map
                     (fun uu___238_3113  ->
                        match uu___238_3113 with
                        | FStar_Util.Inl n1 -> n1
                        | FStar_Util.Inr uu____3119 -> failwith "impossible")
                     univargs
                    in
                 let uu____3120 =
                   FStar_List.fold_left
                     (fun m  -> fun n1  -> if m > n1 then m else n1)
                     (Prims.parse_int "0") nargs
                    in
                 FStar_Util.Inl uu____3120)
          | uu____3126 ->
              let uu____3127 =
                let uu____3132 =
                  let uu____3133 =
                    let uu____3134 = FStar_Parser_AST.term_to_string t1  in
                    Prims.strcat uu____3134 " in universe context"  in
                  Prims.strcat "Unexpected term " uu____3133  in
                (FStar_Errors.Fatal_UnexpectedTermInUniverse, uu____3132)  in
              FStar_Errors.raise_error uu____3127 t1.FStar_Parser_AST.range
           in
        aux t []
    | uu____3143 ->
        let uu____3144 =
          let uu____3149 =
            let uu____3150 =
              let uu____3151 = FStar_Parser_AST.term_to_string t  in
              Prims.strcat uu____3151 " in universe context"  in
            Prims.strcat "Unexpected term " uu____3150  in
          (FStar_Errors.Fatal_UnexpectedTermInUniverse, uu____3149)  in
        FStar_Errors.raise_error uu____3144 t.FStar_Parser_AST.range
  
let rec (desugar_universe :
  FStar_Parser_AST.term -> FStar_Syntax_Syntax.universe) =
  fun t  ->
    let u = desugar_maybe_non_constant_universe t  in
    match u with
    | FStar_Util.Inl n1 -> int_to_universe n1
    | FStar_Util.Inr u1 -> u1
  
let (check_no_aq : FStar_Syntax_Syntax.antiquotations -> unit) =
  fun aq  ->
    match aq with
    | [] -> ()
    | (bv,b,e)::uu____3184 ->
        let uu____3207 =
          let uu____3212 =
            let uu____3213 = FStar_Syntax_Print.term_to_string e  in
            FStar_Util.format2 "Unexpected antiquotation: %s(%s)"
              (if b then "`@" else "`#") uu____3213
             in
          (FStar_Errors.Fatal_UnexpectedAntiquotation, uu____3212)  in
        FStar_Errors.raise_error uu____3207 e.FStar_Syntax_Syntax.pos
  
let check_fields :
  'Auu____3223 .
    FStar_Syntax_DsEnv.env ->
      (FStar_Ident.lident,'Auu____3223) FStar_Pervasives_Native.tuple2
        Prims.list -> FStar_Range.range -> FStar_Syntax_DsEnv.record_or_dc
  =
  fun env  ->
    fun fields  ->
      fun rg  ->
        let uu____3251 = FStar_List.hd fields  in
        match uu____3251 with
        | (f,uu____3261) ->
            (FStar_Syntax_DsEnv.fail_if_qualified_by_curmodule env f;
             (let record =
                FStar_Syntax_DsEnv.fail_or env
                  (FStar_Syntax_DsEnv.try_lookup_record_by_field_name env) f
                 in
              let check_field uu____3273 =
                match uu____3273 with
                | (f',uu____3279) ->
                    (FStar_Syntax_DsEnv.fail_if_qualified_by_curmodule env f';
                     (let uu____3281 =
                        FStar_Syntax_DsEnv.belongs_to_record env f' record
                         in
                      if uu____3281
                      then ()
                      else
                        (let msg =
                           FStar_Util.format3
                             "Field %s belongs to record type %s, whereas field %s does not"
                             f.FStar_Ident.str
                             (record.FStar_Syntax_DsEnv.typename).FStar_Ident.str
                             f'.FStar_Ident.str
                            in
                         FStar_Errors.raise_error
                           (FStar_Errors.Fatal_FieldsNotBelongToSameRecordType,
                             msg) rg)))
                 in
              (let uu____3285 = FStar_List.tl fields  in
               FStar_List.iter check_field uu____3285);
              (match () with | () -> record)))
  
let rec (desugar_data_pat :
  FStar_Syntax_DsEnv.env ->
    FStar_Parser_AST.pattern ->
      Prims.bool ->
        (env_t,bnd,FStar_Syntax_Syntax.pat Prims.list)
          FStar_Pervasives_Native.tuple3)
  =
  fun env  ->
    fun p  ->
      fun is_mut  ->
        let check_linear_pattern_variables pats r =
          let rec pat_vars p1 =
            match p1.FStar_Syntax_Syntax.v with
            | FStar_Syntax_Syntax.Pat_dot_term uu____3636 ->
                FStar_Syntax_Syntax.no_names
            | FStar_Syntax_Syntax.Pat_wild uu____3643 ->
                FStar_Syntax_Syntax.no_names
            | FStar_Syntax_Syntax.Pat_constant uu____3644 ->
                FStar_Syntax_Syntax.no_names
            | FStar_Syntax_Syntax.Pat_var x ->
                FStar_Util.set_add x FStar_Syntax_Syntax.no_names
            | FStar_Syntax_Syntax.Pat_cons (uu____3646,pats1) ->
                let aux out uu____3684 =
                  match uu____3684 with
                  | (p2,uu____3696) ->
                      let intersection =
                        let uu____3704 = pat_vars p2  in
                        FStar_Util.set_intersect uu____3704 out  in
                      let uu____3707 = FStar_Util.set_is_empty intersection
                         in
                      if uu____3707
                      then
                        let uu____3710 = pat_vars p2  in
                        FStar_Util.set_union out uu____3710
                      else
                        (let duplicate_bv =
                           let uu____3715 =
                             FStar_Util.set_elements intersection  in
                           FStar_List.hd uu____3715  in
                         let uu____3718 =
                           let uu____3723 =
                             FStar_Util.format1
                               "Non-linear patterns are not permitted. %s appears more than once in this pattern."
                               (duplicate_bv.FStar_Syntax_Syntax.ppname).FStar_Ident.idText
                              in
                           (FStar_Errors.Fatal_NonLinearPatternNotPermitted,
                             uu____3723)
                            in
                         FStar_Errors.raise_error uu____3718 r)
                   in
                FStar_List.fold_left aux FStar_Syntax_Syntax.no_names pats1
             in
          match pats with
          | [] -> ()
          | p1::[] ->
              let uu____3743 = pat_vars p1  in
              FStar_All.pipe_right uu____3743 (fun a237  -> ())
          | p1::ps ->
              let pvars = pat_vars p1  in
              let aux p2 =
                let uu____3771 =
                  let uu____3772 = pat_vars p2  in
                  FStar_Util.set_eq pvars uu____3772  in
                if uu____3771
                then ()
                else
                  (let nonlinear_vars =
                     let uu____3779 = pat_vars p2  in
                     FStar_Util.set_symmetric_difference pvars uu____3779  in
                   let first_nonlinear_var =
                     let uu____3783 = FStar_Util.set_elements nonlinear_vars
                        in
                     FStar_List.hd uu____3783  in
                   let uu____3786 =
                     let uu____3791 =
                       FStar_Util.format1
                         "Patterns in this match are incoherent, variable %s is bound in some but not all patterns."
                         (first_nonlinear_var.FStar_Syntax_Syntax.ppname).FStar_Ident.idText
                        in
                     (FStar_Errors.Fatal_IncoherentPatterns, uu____3791)  in
                   FStar_Errors.raise_error uu____3786 r)
                 in
              FStar_List.iter aux ps
           in
        (match (is_mut, (p.FStar_Parser_AST.pat)) with
         | (false ,uu____3795) -> ()
         | (true ,FStar_Parser_AST.PatVar uu____3796) -> ()
         | (true ,uu____3803) ->
             FStar_Errors.raise_error
               (FStar_Errors.Fatal_LetMutableForVariablesOnly,
                 "let-mutable is for variables only")
               p.FStar_Parser_AST.prange);
        (let resolvex l e x =
           let uu____3826 =
             FStar_All.pipe_right l
               (FStar_Util.find_opt
                  (fun y  ->
                     (y.FStar_Syntax_Syntax.ppname).FStar_Ident.idText =
                       x.FStar_Ident.idText))
              in
           match uu____3826 with
           | FStar_Pervasives_Native.Some y -> (l, e, y)
           | uu____3842 ->
               let uu____3845 =
                 if is_mut
                 then FStar_Syntax_DsEnv.push_bv_mutable e x
                 else FStar_Syntax_DsEnv.push_bv e x  in
               (match uu____3845 with | (e1,x1) -> ((x1 :: l), e1, x1))
            in
         let rec aux' top loc env1 p1 =
           let pos q =
             FStar_Syntax_Syntax.withinfo q p1.FStar_Parser_AST.prange  in
           let pos_r r q = FStar_Syntax_Syntax.withinfo q r  in
           let orig = p1  in
           match p1.FStar_Parser_AST.pat with
           | FStar_Parser_AST.PatOr uu____3957 -> failwith "impossible"
           | FStar_Parser_AST.PatOp op ->
               let uu____3973 =
                 let uu____3974 =
                   let uu____3975 =
                     let uu____3982 =
                       let uu____3983 =
                         let uu____3988 =
                           FStar_Parser_AST.compile_op (Prims.parse_int "0")
                             op.FStar_Ident.idText op.FStar_Ident.idRange
                            in
                         (uu____3988, (op.FStar_Ident.idRange))  in
                       FStar_Ident.mk_ident uu____3983  in
                     (uu____3982, FStar_Pervasives_Native.None)  in
                   FStar_Parser_AST.PatVar uu____3975  in
                 {
                   FStar_Parser_AST.pat = uu____3974;
                   FStar_Parser_AST.prange = (p1.FStar_Parser_AST.prange)
                 }  in
               aux loc env1 uu____3973
           | FStar_Parser_AST.PatAscribed (p2,(t,tacopt)) ->
               ((match tacopt with
                 | FStar_Pervasives_Native.None  -> ()
                 | FStar_Pervasives_Native.Some uu____4005 ->
                     FStar_Errors.raise_error
                       (FStar_Errors.Fatal_TypeWithinPatternsAllowedOnVariablesOnly,
                         "Type ascriptions within patterns are cannot be associated with a tactic")
                       orig.FStar_Parser_AST.prange);
                (let uu____4006 = aux loc env1 p2  in
                 match uu____4006 with
                 | (loc1,env',binder,p3,imp) ->
                     let annot_pat_var p4 t1 =
                       match p4.FStar_Syntax_Syntax.v with
                       | FStar_Syntax_Syntax.Pat_var x ->
                           let uu___267_4064 = p4  in
                           {
                             FStar_Syntax_Syntax.v =
                               (FStar_Syntax_Syntax.Pat_var
                                  (let uu___268_4069 = x  in
                                   {
                                     FStar_Syntax_Syntax.ppname =
                                       (uu___268_4069.FStar_Syntax_Syntax.ppname);
                                     FStar_Syntax_Syntax.index =
                                       (uu___268_4069.FStar_Syntax_Syntax.index);
                                     FStar_Syntax_Syntax.sort = t1
                                   }));
                             FStar_Syntax_Syntax.p =
                               (uu___267_4064.FStar_Syntax_Syntax.p)
                           }
                       | FStar_Syntax_Syntax.Pat_wild x ->
                           let uu___269_4071 = p4  in
                           {
                             FStar_Syntax_Syntax.v =
                               (FStar_Syntax_Syntax.Pat_wild
                                  (let uu___270_4076 = x  in
                                   {
                                     FStar_Syntax_Syntax.ppname =
                                       (uu___270_4076.FStar_Syntax_Syntax.ppname);
                                     FStar_Syntax_Syntax.index =
                                       (uu___270_4076.FStar_Syntax_Syntax.index);
                                     FStar_Syntax_Syntax.sort = t1
                                   }));
                             FStar_Syntax_Syntax.p =
                               (uu___269_4071.FStar_Syntax_Syntax.p)
                           }
                       | uu____4077 when top -> p4
                       | uu____4078 ->
                           FStar_Errors.raise_error
                             (FStar_Errors.Fatal_TypeWithinPatternsAllowedOnVariablesOnly,
                               "Type ascriptions within patterns are only allowed on variables")
                             orig.FStar_Parser_AST.prange
                        in
                     let uu____4081 =
                       match binder with
                       | LetBinder uu____4094 -> failwith "impossible"
                       | LocalBinder (x,aq) ->
                           let t1 =
                             let uu____4114 = close_fun env1 t  in
                             desugar_term env1 uu____4114  in
                           (if
                              (match (x.FStar_Syntax_Syntax.sort).FStar_Syntax_Syntax.n
                               with
                               | FStar_Syntax_Syntax.Tm_unknown  -> false
                               | uu____4116 -> true)
                            then
                              (let uu____4117 =
                                 let uu____4122 =
                                   let uu____4123 =
                                     FStar_Syntax_Print.bv_to_string x  in
                                   let uu____4124 =
                                     FStar_Syntax_Print.term_to_string
                                       x.FStar_Syntax_Syntax.sort
                                      in
                                   let uu____4125 =
                                     FStar_Syntax_Print.term_to_string t1  in
                                   FStar_Util.format3
                                     "Multiple ascriptions for %s in pattern, type %s was shadowed by %s\n"
                                     uu____4123 uu____4124 uu____4125
                                    in
                                 (FStar_Errors.Warning_MultipleAscriptions,
                                   uu____4122)
                                  in
                               FStar_Errors.log_issue
                                 orig.FStar_Parser_AST.prange uu____4117)
                            else ();
                            (let uu____4127 = annot_pat_var p3 t1  in
                             (uu____4127,
                               (LocalBinder
                                  ((let uu___271_4133 = x  in
                                    {
                                      FStar_Syntax_Syntax.ppname =
                                        (uu___271_4133.FStar_Syntax_Syntax.ppname);
                                      FStar_Syntax_Syntax.index =
                                        (uu___271_4133.FStar_Syntax_Syntax.index);
                                      FStar_Syntax_Syntax.sort = t1
                                    }), aq)))))
                        in
                     (match uu____4081 with
                      | (p4,binder1) -> (loc1, env', binder1, p4, imp))))
           | FStar_Parser_AST.PatWild  ->
               let x =
                 FStar_Syntax_Syntax.new_bv
                   (FStar_Pervasives_Native.Some (p1.FStar_Parser_AST.prange))
                   FStar_Syntax_Syntax.tun
                  in
               let uu____4155 =
                 FStar_All.pipe_left pos (FStar_Syntax_Syntax.Pat_wild x)  in
               (loc, env1, (LocalBinder (x, FStar_Pervasives_Native.None)),
                 uu____4155, false)
           | FStar_Parser_AST.PatConst c ->
               let x =
                 FStar_Syntax_Syntax.new_bv
                   (FStar_Pervasives_Native.Some (p1.FStar_Parser_AST.prange))
                   FStar_Syntax_Syntax.tun
                  in
               let uu____4164 =
                 FStar_All.pipe_left pos (FStar_Syntax_Syntax.Pat_constant c)
                  in
               (loc, env1, (LocalBinder (x, FStar_Pervasives_Native.None)),
                 uu____4164, false)
           | FStar_Parser_AST.PatTvar (x,aq) ->
               let imp =
                 aq =
                   (FStar_Pervasives_Native.Some FStar_Parser_AST.Implicit)
                  in
               let aq1 = trans_aqual aq  in
               let uu____4183 = resolvex loc env1 x  in
               (match uu____4183 with
                | (loc1,env2,xbv) ->
                    let uu____4205 =
                      FStar_All.pipe_left pos
                        (FStar_Syntax_Syntax.Pat_var xbv)
                       in
                    (loc1, env2, (LocalBinder (xbv, aq1)), uu____4205, imp))
           | FStar_Parser_AST.PatVar (x,aq) ->
               let imp =
                 aq =
                   (FStar_Pervasives_Native.Some FStar_Parser_AST.Implicit)
                  in
               let aq1 = trans_aqual aq  in
               let uu____4224 = resolvex loc env1 x  in
               (match uu____4224 with
                | (loc1,env2,xbv) ->
                    let uu____4246 =
                      FStar_All.pipe_left pos
                        (FStar_Syntax_Syntax.Pat_var xbv)
                       in
                    (loc1, env2, (LocalBinder (xbv, aq1)), uu____4246, imp))
           | FStar_Parser_AST.PatName l ->
               let l1 =
                 FStar_Syntax_DsEnv.fail_or env1
                   (FStar_Syntax_DsEnv.try_lookup_datacon env1) l
                  in
               let x =
                 FStar_Syntax_Syntax.new_bv
                   (FStar_Pervasives_Native.Some (p1.FStar_Parser_AST.prange))
                   FStar_Syntax_Syntax.tun
                  in
               let uu____4256 =
                 FStar_All.pipe_left pos
                   (FStar_Syntax_Syntax.Pat_cons (l1, []))
                  in
               (loc, env1, (LocalBinder (x, FStar_Pervasives_Native.None)),
                 uu____4256, false)
           | FStar_Parser_AST.PatApp
               ({ FStar_Parser_AST.pat = FStar_Parser_AST.PatName l;
                  FStar_Parser_AST.prange = uu____4278;_},args)
               ->
               let uu____4284 =
                 FStar_List.fold_right
                   (fun arg  ->
                      fun uu____4325  ->
                        match uu____4325 with
                        | (loc1,env2,args1) ->
                            let uu____4373 = aux loc1 env2 arg  in
                            (match uu____4373 with
                             | (loc2,env3,uu____4402,arg1,imp) ->
                                 (loc2, env3, ((arg1, imp) :: args1)))) args
                   (loc, env1, [])
                  in
               (match uu____4284 with
                | (loc1,env2,args1) ->
                    let l1 =
                      FStar_Syntax_DsEnv.fail_or env2
                        (FStar_Syntax_DsEnv.try_lookup_datacon env2) l
                       in
                    let x =
                      FStar_Syntax_Syntax.new_bv
                        (FStar_Pervasives_Native.Some
                           (p1.FStar_Parser_AST.prange))
                        FStar_Syntax_Syntax.tun
                       in
                    let uu____4472 =
                      FStar_All.pipe_left pos
                        (FStar_Syntax_Syntax.Pat_cons (l1, args1))
                       in
                    (loc1, env2,
                      (LocalBinder (x, FStar_Pervasives_Native.None)),
                      uu____4472, false))
           | FStar_Parser_AST.PatApp uu____4487 ->
               FStar_Errors.raise_error
                 (FStar_Errors.Fatal_UnexpectedPattern, "Unexpected pattern")
                 p1.FStar_Parser_AST.prange
           | FStar_Parser_AST.PatList pats ->
               let uu____4509 =
                 FStar_List.fold_right
                   (fun pat  ->
                      fun uu____4542  ->
                        match uu____4542 with
                        | (loc1,env2,pats1) ->
                            let uu____4574 = aux loc1 env2 pat  in
                            (match uu____4574 with
                             | (loc2,env3,uu____4599,pat1,uu____4601) ->
                                 (loc2, env3, (pat1 :: pats1)))) pats
                   (loc, env1, [])
                  in
               (match uu____4509 with
                | (loc1,env2,pats1) ->
                    let pat =
                      let uu____4644 =
                        let uu____4647 =
                          let uu____4654 =
                            FStar_Range.end_range p1.FStar_Parser_AST.prange
                             in
                          pos_r uu____4654  in
                        let uu____4655 =
                          let uu____4656 =
                            let uu____4669 =
                              FStar_Syntax_Syntax.lid_as_fv
                                FStar_Parser_Const.nil_lid
                                FStar_Syntax_Syntax.delta_constant
                                (FStar_Pervasives_Native.Some
                                   FStar_Syntax_Syntax.Data_ctor)
                               in
                            (uu____4669, [])  in
                          FStar_Syntax_Syntax.Pat_cons uu____4656  in
                        FStar_All.pipe_left uu____4647 uu____4655  in
                      FStar_List.fold_right
                        (fun hd1  ->
                           fun tl1  ->
                             let r =
                               FStar_Range.union_ranges
                                 hd1.FStar_Syntax_Syntax.p
                                 tl1.FStar_Syntax_Syntax.p
                                in
                             let uu____4701 =
                               let uu____4702 =
                                 let uu____4715 =
                                   FStar_Syntax_Syntax.lid_as_fv
                                     FStar_Parser_Const.cons_lid
                                     FStar_Syntax_Syntax.delta_constant
                                     (FStar_Pervasives_Native.Some
                                        FStar_Syntax_Syntax.Data_ctor)
                                    in
                                 (uu____4715, [(hd1, false); (tl1, false)])
                                  in
                               FStar_Syntax_Syntax.Pat_cons uu____4702  in
                             FStar_All.pipe_left (pos_r r) uu____4701) pats1
                        uu____4644
                       in
                    let x =
                      FStar_Syntax_Syntax.new_bv
                        (FStar_Pervasives_Native.Some
                           (p1.FStar_Parser_AST.prange))
                        FStar_Syntax_Syntax.tun
                       in
                    (loc1, env2,
                      (LocalBinder (x, FStar_Pervasives_Native.None)), pat,
                      false))
           | FStar_Parser_AST.PatTuple (args,dep1) ->
               let uu____4757 =
                 FStar_List.fold_left
                   (fun uu____4797  ->
                      fun p2  ->
                        match uu____4797 with
                        | (loc1,env2,pats) ->
                            let uu____4846 = aux loc1 env2 p2  in
                            (match uu____4846 with
                             | (loc2,env3,uu____4875,pat,uu____4877) ->
                                 (loc2, env3, ((pat, false) :: pats))))
                   (loc, env1, []) args
                  in
               (match uu____4757 with
                | (loc1,env2,args1) ->
                    let args2 = FStar_List.rev args1  in
                    let l =
                      if dep1
                      then
                        FStar_Parser_Const.mk_dtuple_data_lid
                          (FStar_List.length args2)
                          p1.FStar_Parser_AST.prange
                      else
                        FStar_Parser_Const.mk_tuple_data_lid
                          (FStar_List.length args2)
                          p1.FStar_Parser_AST.prange
                       in
                    let uu____4972 =
                      FStar_Syntax_DsEnv.fail_or env2
                        (FStar_Syntax_DsEnv.try_lookup_lid env2) l
                       in
                    (match uu____4972 with
                     | (constr,uu____4994) ->
                         let l1 =
                           match constr.FStar_Syntax_Syntax.n with
                           | FStar_Syntax_Syntax.Tm_fvar fv -> fv
                           | uu____4997 -> failwith "impossible"  in
                         let x =
                           FStar_Syntax_Syntax.new_bv
                             (FStar_Pervasives_Native.Some
                                (p1.FStar_Parser_AST.prange))
                             FStar_Syntax_Syntax.tun
                            in
                         let uu____4999 =
                           FStar_All.pipe_left pos
                             (FStar_Syntax_Syntax.Pat_cons (l1, args2))
                            in
                         (loc1, env2,
                           (LocalBinder (x, FStar_Pervasives_Native.None)),
                           uu____4999, false)))
           | FStar_Parser_AST.PatRecord [] ->
               FStar_Errors.raise_error
                 (FStar_Errors.Fatal_UnexpectedPattern, "Unexpected pattern")
                 p1.FStar_Parser_AST.prange
           | FStar_Parser_AST.PatRecord fields ->
               let record =
                 check_fields env1 fields p1.FStar_Parser_AST.prange  in
               let fields1 =
                 FStar_All.pipe_right fields
                   (FStar_List.map
                      (fun uu____5068  ->
                         match uu____5068 with
                         | (f,p2) -> ((f.FStar_Ident.ident), p2)))
                  in
               let args =
                 FStar_All.pipe_right record.FStar_Syntax_DsEnv.fields
                   (FStar_List.map
                      (fun uu____5098  ->
                         match uu____5098 with
                         | (f,uu____5104) ->
                             let uu____5105 =
                               FStar_All.pipe_right fields1
                                 (FStar_List.tryFind
                                    (fun uu____5131  ->
                                       match uu____5131 with
                                       | (g,uu____5137) ->
                                           f.FStar_Ident.idText =
                                             g.FStar_Ident.idText))
                                in
                             (match uu____5105 with
                              | FStar_Pervasives_Native.None  ->
                                  FStar_Parser_AST.mk_pattern
                                    FStar_Parser_AST.PatWild
                                    p1.FStar_Parser_AST.prange
                              | FStar_Pervasives_Native.Some (uu____5142,p2)
                                  -> p2)))
                  in
               let app =
                 let uu____5149 =
                   let uu____5150 =
                     let uu____5157 =
                       let uu____5158 =
                         let uu____5159 =
                           FStar_Ident.lid_of_ids
                             (FStar_List.append
                                (record.FStar_Syntax_DsEnv.typename).FStar_Ident.ns
                                [record.FStar_Syntax_DsEnv.constrname])
                            in
                         FStar_Parser_AST.PatName uu____5159  in
                       FStar_Parser_AST.mk_pattern uu____5158
                         p1.FStar_Parser_AST.prange
                        in
                     (uu____5157, args)  in
                   FStar_Parser_AST.PatApp uu____5150  in
                 FStar_Parser_AST.mk_pattern uu____5149
                   p1.FStar_Parser_AST.prange
                  in
               let uu____5162 = aux loc env1 app  in
               (match uu____5162 with
                | (env2,e,b,p2,uu____5191) ->
                    let p3 =
                      match p2.FStar_Syntax_Syntax.v with
                      | FStar_Syntax_Syntax.Pat_cons (fv,args1) ->
                          let uu____5219 =
                            let uu____5220 =
                              let uu____5233 =
                                let uu___272_5234 = fv  in
                                let uu____5235 =
                                  let uu____5238 =
                                    let uu____5239 =
                                      let uu____5246 =
                                        FStar_All.pipe_right
                                          record.FStar_Syntax_DsEnv.fields
                                          (FStar_List.map
                                             FStar_Pervasives_Native.fst)
                                         in
                                      ((record.FStar_Syntax_DsEnv.typename),
                                        uu____5246)
                                       in
                                    FStar_Syntax_Syntax.Record_ctor
                                      uu____5239
                                     in
                                  FStar_Pervasives_Native.Some uu____5238  in
                                {
                                  FStar_Syntax_Syntax.fv_name =
                                    (uu___272_5234.FStar_Syntax_Syntax.fv_name);
                                  FStar_Syntax_Syntax.fv_delta =
                                    (uu___272_5234.FStar_Syntax_Syntax.fv_delta);
                                  FStar_Syntax_Syntax.fv_qual = uu____5235
                                }  in
                              (uu____5233, args1)  in
                            FStar_Syntax_Syntax.Pat_cons uu____5220  in
                          FStar_All.pipe_left pos uu____5219
                      | uu____5273 -> p2  in
                    (env2, e, b, p3, false))
         
         and aux loc env1 p1 = aux' false loc env1 p1
          in
         let aux_maybe_or env1 p1 =
           let loc = []  in
           match p1.FStar_Parser_AST.pat with
           | FStar_Parser_AST.PatOr [] -> failwith "impossible"
           | FStar_Parser_AST.PatOr (p2::ps) ->
               let uu____5327 = aux' true loc env1 p2  in
               (match uu____5327 with
                | (loc1,env2,var,p3,uu____5354) ->
                    let uu____5359 =
                      FStar_List.fold_left
                        (fun uu____5391  ->
                           fun p4  ->
                             match uu____5391 with
                             | (loc2,env3,ps1) ->
                                 let uu____5424 = aux' true loc2 env3 p4  in
                                 (match uu____5424 with
                                  | (loc3,env4,uu____5449,p5,uu____5451) ->
                                      (loc3, env4, (p5 :: ps1))))
                        (loc1, env2, []) ps
                       in
                    (match uu____5359 with
                     | (loc2,env3,ps1) ->
                         let pats = p3 :: (FStar_List.rev ps1)  in
                         (env3, var, pats)))
           | uu____5502 ->
               let uu____5503 = aux' true loc env1 p1  in
               (match uu____5503 with
                | (loc1,env2,vars,pat,b) -> (env2, vars, [pat]))
            in
         let uu____5543 = aux_maybe_or env p  in
         match uu____5543 with
         | (env1,b,pats) ->
             (check_linear_pattern_variables pats p.FStar_Parser_AST.prange;
              (env1, b, pats)))

and (desugar_binding_pat_maybe_top :
  Prims.bool ->
    FStar_Syntax_DsEnv.env ->
      FStar_Parser_AST.pattern ->
        Prims.bool ->
          (env_t,bnd,FStar_Syntax_Syntax.pat Prims.list)
            FStar_Pervasives_Native.tuple3)
  =
  fun top  ->
    fun env  ->
      fun p  ->
        fun is_mut  ->
          let mklet x =
            let uu____5602 =
              let uu____5603 =
                let uu____5614 = FStar_Syntax_DsEnv.qualify env x  in
                (uu____5614,
                  (FStar_Syntax_Syntax.tun, FStar_Pervasives_Native.None))
                 in
              LetBinder uu____5603  in
            (env, uu____5602, [])  in
          if top
          then
            match p.FStar_Parser_AST.pat with
            | FStar_Parser_AST.PatOp x ->
                let uu____5642 =
                  let uu____5643 =
                    let uu____5648 =
                      FStar_Parser_AST.compile_op (Prims.parse_int "0")
                        x.FStar_Ident.idText x.FStar_Ident.idRange
                       in
                    (uu____5648, (x.FStar_Ident.idRange))  in
                  FStar_Ident.mk_ident uu____5643  in
                mklet uu____5642
            | FStar_Parser_AST.PatVar (x,uu____5650) -> mklet x
            | FStar_Parser_AST.PatAscribed
                ({
                   FStar_Parser_AST.pat = FStar_Parser_AST.PatVar
                     (x,uu____5656);
                   FStar_Parser_AST.prange = uu____5657;_},(t,tacopt))
                ->
                let tacopt1 = FStar_Util.map_opt tacopt (desugar_term env)
                   in
                let uu____5677 =
                  let uu____5678 =
                    let uu____5689 = FStar_Syntax_DsEnv.qualify env x  in
                    let uu____5690 =
                      let uu____5697 = desugar_term env t  in
                      (uu____5697, tacopt1)  in
                    (uu____5689, uu____5690)  in
                  LetBinder uu____5678  in
                (env, uu____5677, [])
            | uu____5708 ->
                FStar_Errors.raise_error
                  (FStar_Errors.Fatal_UnexpectedPattern,
                    "Unexpected pattern at the top-level")
                  p.FStar_Parser_AST.prange
          else
            (let uu____5718 = desugar_data_pat env p is_mut  in
             match uu____5718 with
             | (env1,binder,p1) ->
                 let p2 =
                   match p1 with
                   | {
                       FStar_Syntax_Syntax.v = FStar_Syntax_Syntax.Pat_var
                         uu____5747;
                       FStar_Syntax_Syntax.p = uu____5748;_}::[] -> []
                   | {
                       FStar_Syntax_Syntax.v = FStar_Syntax_Syntax.Pat_wild
                         uu____5749;
                       FStar_Syntax_Syntax.p = uu____5750;_}::[] -> []
                   | uu____5751 -> p1  in
                 (env1, binder, p2))

and (desugar_binding_pat :
  FStar_Syntax_DsEnv.env ->
    FStar_Parser_AST.pattern ->
      (env_t,bnd,FStar_Syntax_Syntax.pat Prims.list)
        FStar_Pervasives_Native.tuple3)
  = fun env  -> fun p  -> desugar_binding_pat_maybe_top false env p false

and (desugar_match_pat_maybe_top :
  Prims.bool ->
    FStar_Syntax_DsEnv.env ->
      FStar_Parser_AST.pattern ->
        (env_t,FStar_Syntax_Syntax.pat Prims.list)
          FStar_Pervasives_Native.tuple2)
  =
  fun uu____5758  ->
    fun env  ->
      fun pat  ->
        let uu____5761 = desugar_data_pat env pat false  in
        match uu____5761 with | (env1,uu____5777,pat1) -> (env1, pat1)

and (desugar_match_pat :
  FStar_Syntax_DsEnv.env ->
    FStar_Parser_AST.pattern ->
      (env_t,FStar_Syntax_Syntax.pat Prims.list)
        FStar_Pervasives_Native.tuple2)
  = fun env  -> fun p  -> desugar_match_pat_maybe_top false env p

and (desugar_term_aq :
  FStar_Syntax_DsEnv.env ->
    FStar_Parser_AST.term ->
      (FStar_Syntax_Syntax.term,FStar_Syntax_Syntax.antiquotations)
        FStar_Pervasives_Native.tuple2)
  =
  fun env  ->
    fun e  ->
      let env1 = FStar_Syntax_DsEnv.set_expect_typ env false  in
      desugar_term_maybe_top false env1 e

and (desugar_term :
  FStar_Syntax_DsEnv.env -> FStar_Parser_AST.term -> FStar_Syntax_Syntax.term)
  =
  fun env  ->
    fun e  ->
      let uu____5796 = desugar_term_aq env e  in
      match uu____5796 with | (t,aq) -> (check_no_aq aq; t)

and (desugar_typ_aq :
  FStar_Syntax_DsEnv.env ->
    FStar_Parser_AST.term ->
      (FStar_Syntax_Syntax.term,FStar_Syntax_Syntax.antiquotations)
        FStar_Pervasives_Native.tuple2)
  =
  fun env  ->
    fun e  ->
      let env1 = FStar_Syntax_DsEnv.set_expect_typ env true  in
      desugar_term_maybe_top false env1 e

and (desugar_typ :
  FStar_Syntax_DsEnv.env -> FStar_Parser_AST.term -> FStar_Syntax_Syntax.term)
  =
  fun env  ->
    fun e  ->
      let uu____5813 = desugar_typ_aq env e  in
      match uu____5813 with | (t,aq) -> (check_no_aq aq; t)

and (desugar_machine_integer :
  FStar_Syntax_DsEnv.env ->
    Prims.string ->
      (FStar_Const.signedness,FStar_Const.width)
        FStar_Pervasives_Native.tuple2 ->
        FStar_Range.range -> FStar_Syntax_Syntax.term)
  =
  fun env  ->
    fun repr  ->
      fun uu____5823  ->
        fun range  ->
          match uu____5823 with
          | (signedness,width) ->
              let tnm =
                Prims.strcat "FStar."
                  (Prims.strcat
                     (match signedness with
                      | FStar_Const.Unsigned  -> "U"
                      | FStar_Const.Signed  -> "")
                     (Prims.strcat "Int"
                        (match width with
                         | FStar_Const.Int8  -> "8"
                         | FStar_Const.Int16  -> "16"
                         | FStar_Const.Int32  -> "32"
                         | FStar_Const.Int64  -> "64")))
                 in
              ((let uu____5833 =
                  let uu____5834 =
                    FStar_Const.within_bounds repr signedness width  in
                  Prims.op_Negation uu____5834  in
                if uu____5833
                then
                  let uu____5835 =
                    let uu____5840 =
                      FStar_Util.format2
                        "%s is not in the expected range for %s" repr tnm
                       in
                    (FStar_Errors.Error_OutOfRange, uu____5840)  in
                  FStar_Errors.log_issue range uu____5835
                else ());
               (let private_intro_nm =
                  Prims.strcat tnm
                    (Prims.strcat ".__"
                       (Prims.strcat
                          (match signedness with
                           | FStar_Const.Unsigned  -> "u"
                           | FStar_Const.Signed  -> "") "int_to_t"))
                   in
                let intro_nm =
                  Prims.strcat tnm
                    (Prims.strcat "."
                       (Prims.strcat
                          (match signedness with
                           | FStar_Const.Unsigned  -> "u"
                           | FStar_Const.Signed  -> "") "int_to_t"))
                   in
                let lid =
                  let uu____5845 = FStar_Ident.path_of_text intro_nm  in
                  FStar_Ident.lid_of_path uu____5845 range  in
                let lid1 =
                  let uu____5849 = FStar_Syntax_DsEnv.try_lookup_lid env lid
                     in
                  match uu____5849 with
                  | FStar_Pervasives_Native.Some (intro_term,uu____5859) ->
                      (match intro_term.FStar_Syntax_Syntax.n with
                       | FStar_Syntax_Syntax.Tm_fvar fv ->
                           let private_lid =
                             let uu____5868 =
                               FStar_Ident.path_of_text private_intro_nm  in
                             FStar_Ident.lid_of_path uu____5868 range  in
                           let private_fv =
                             let uu____5870 =
                               FStar_Syntax_Util.incr_delta_depth
                                 fv.FStar_Syntax_Syntax.fv_delta
                                in
                             FStar_Syntax_Syntax.lid_as_fv private_lid
                               uu____5870 fv.FStar_Syntax_Syntax.fv_qual
                              in
                           let uu___273_5871 = intro_term  in
                           {
                             FStar_Syntax_Syntax.n =
                               (FStar_Syntax_Syntax.Tm_fvar private_fv);
                             FStar_Syntax_Syntax.pos =
                               (uu___273_5871.FStar_Syntax_Syntax.pos);
                             FStar_Syntax_Syntax.vars =
                               (uu___273_5871.FStar_Syntax_Syntax.vars)
                           }
                       | uu____5872 ->
                           failwith
                             (Prims.strcat "Unexpected non-fvar for "
                                intro_nm))
                  | FStar_Pervasives_Native.None  ->
                      let uu____5879 =
                        let uu____5884 =
                          FStar_Util.format1
                            "Unexpected numeric literal.  Restart F* to load %s."
                            tnm
                           in
                        (FStar_Errors.Fatal_UnexpectedNumericLiteral,
                          uu____5884)
                         in
                      FStar_Errors.raise_error uu____5879 range
                   in
                let repr1 =
                  FStar_Syntax_Syntax.mk
                    (FStar_Syntax_Syntax.Tm_constant
                       (FStar_Const.Const_int
                          (repr, FStar_Pervasives_Native.None)))
                    FStar_Pervasives_Native.None range
                   in
                let t =
                  let uu____5903 =
                    let uu____5910 =
                      let uu____5911 =
                        let uu____5926 =
                          let uu____5935 =
                            let uu____5942 =
                              FStar_Syntax_Syntax.as_implicit false  in
                            (repr1, uu____5942)  in
                          [uu____5935]  in
                        (lid1, uu____5926)  in
                      FStar_Syntax_Syntax.Tm_app uu____5911  in
                    FStar_Syntax_Syntax.mk uu____5910  in
                  uu____5903 FStar_Pervasives_Native.None range  in
                let maybe_ascribe_as_overloaded_int t1 =
                  let uu____5982 =
                    let uu____5983 = FStar_Options.integer_overloading ()  in
                    Prims.op_Negation uu____5983  in
                  if uu____5982
                  then t1
                  else
                    (let tnm1 =
                       Prims.strcat "FStar.Integers."
                         (Prims.strcat
                            (match signedness with
                             | FStar_Const.Unsigned  -> "u"
                             | FStar_Const.Signed  -> "")
                            (Prims.strcat "int_"
                               (match width with
                                | FStar_Const.Int8  -> "8"
                                | FStar_Const.Int16  -> "16"
                                | FStar_Const.Int32  -> "32"
                                | FStar_Const.Int64  -> "64")))
                        in
                     let nm = FStar_Ident.lid_of_str tnm1  in
                     let uu____5989 =
                       FStar_Syntax_DsEnv.try_lookup_lid env nm  in
                     match uu____5989 with
                     | FStar_Pervasives_Native.None  -> t1
                     | FStar_Pervasives_Native.Some (ty,_mut) ->
                         FStar_Syntax_Util.ascribe t1
                           ((FStar_Util.Inl ty),
                             FStar_Pervasives_Native.None))
                   in
                maybe_ascribe_as_overloaded_int t))

and (desugar_name :
  (FStar_Syntax_Syntax.term' -> FStar_Syntax_Syntax.term) ->
    (FStar_Syntax_Syntax.term ->
       FStar_Syntax_Syntax.term' FStar_Syntax_Syntax.syntax)
      -> env_t -> Prims.bool -> FStar_Ident.lid -> FStar_Syntax_Syntax.term)
  =
  fun mk1  ->
    fun setpos  ->
      fun env  ->
        fun resolve  ->
          fun l  ->
            let uu____6037 =
              let uu____6046 =
                (if resolve
                 then FStar_Syntax_DsEnv.try_lookup_lid_with_attributes
                 else
                   FStar_Syntax_DsEnv.try_lookup_lid_with_attributes_no_resolve)
                  env
                 in
              FStar_Syntax_DsEnv.fail_or env uu____6046 l  in
            match uu____6037 with
            | (tm,mut,attrs) ->
                let warn_if_deprecated attrs1 =
                  FStar_List.iter
                    (fun a  ->
                       match a.FStar_Syntax_Syntax.n with
                       | FStar_Syntax_Syntax.Tm_app
                           ({
                              FStar_Syntax_Syntax.n =
                                FStar_Syntax_Syntax.Tm_fvar fv;
                              FStar_Syntax_Syntax.pos = uu____6101;
                              FStar_Syntax_Syntax.vars = uu____6102;_},args)
                           when
                           FStar_Ident.lid_equals
                             (fv.FStar_Syntax_Syntax.fv_name).FStar_Syntax_Syntax.v
                             FStar_Parser_Const.deprecated_attr
                           ->
                           let msg =
                             let uu____6125 =
                               FStar_Syntax_Print.term_to_string tm  in
                             Prims.strcat uu____6125 " is deprecated"  in
                           let msg1 =
                             if
                               (FStar_List.length args) >
                                 (Prims.parse_int "0")
                             then
                               let uu____6133 =
                                 let uu____6134 =
                                   let uu____6137 = FStar_List.hd args  in
                                   FStar_Pervasives_Native.fst uu____6137  in
                                 uu____6134.FStar_Syntax_Syntax.n  in
                               match uu____6133 with
                               | FStar_Syntax_Syntax.Tm_constant
                                   (FStar_Const.Const_string (s,uu____6153))
                                   when
                                   Prims.op_Negation
                                     ((FStar_Util.trim_string s) = "")
                                   ->
                                   Prims.strcat msg
                                     (Prims.strcat ", use "
                                        (Prims.strcat s " instead"))
                               | uu____6154 -> msg
                             else msg  in
                           let uu____6156 = FStar_Ident.range_of_lid l  in
                           FStar_Errors.log_issue uu____6156
                             (FStar_Errors.Warning_DeprecatedDefinition,
                               msg1)
                       | FStar_Syntax_Syntax.Tm_fvar fv when
                           FStar_Ident.lid_equals
                             (fv.FStar_Syntax_Syntax.fv_name).FStar_Syntax_Syntax.v
                             FStar_Parser_Const.deprecated_attr
                           ->
                           let msg =
                             let uu____6159 =
                               FStar_Syntax_Print.term_to_string tm  in
                             Prims.strcat uu____6159 " is deprecated"  in
                           let uu____6160 = FStar_Ident.range_of_lid l  in
                           FStar_Errors.log_issue uu____6160
                             (FStar_Errors.Warning_DeprecatedDefinition, msg)
                       | uu____6161 -> ()) attrs1
                   in
                (warn_if_deprecated attrs;
                 (let tm1 = setpos tm  in
                  if mut
                  then
                    let uu____6166 =
                      let uu____6167 =
                        let uu____6174 = mk_ref_read tm1  in
                        (uu____6174,
                          (FStar_Syntax_Syntax.Meta_desugared
                             FStar_Syntax_Syntax.Mutable_rval))
                         in
                      FStar_Syntax_Syntax.Tm_meta uu____6167  in
                    FStar_All.pipe_left mk1 uu____6166
                  else tm1))

and (desugar_attributes :
  env_t ->
    FStar_Parser_AST.term Prims.list -> FStar_Syntax_Syntax.cflags Prims.list)
  =
  fun env  ->
    fun cattributes  ->
      let desugar_attribute t =
        let uu____6192 =
          let uu____6193 = unparen t  in uu____6193.FStar_Parser_AST.tm  in
        match uu____6192 with
        | FStar_Parser_AST.Var
            { FStar_Ident.ns = uu____6194; FStar_Ident.ident = uu____6195;
              FStar_Ident.nsstr = uu____6196; FStar_Ident.str = "cps";_}
            -> FStar_Syntax_Syntax.CPS
        | uu____6199 ->
            let uu____6200 =
              let uu____6205 =
                let uu____6206 = FStar_Parser_AST.term_to_string t  in
                Prims.strcat "Unknown attribute " uu____6206  in
              (FStar_Errors.Fatal_UnknownAttribute, uu____6205)  in
            FStar_Errors.raise_error uu____6200 t.FStar_Parser_AST.range
         in
      FStar_List.map desugar_attribute cattributes

and (desugar_term_maybe_top :
  Prims.bool ->
    env_t ->
      FStar_Parser_AST.term ->
        (FStar_Syntax_Syntax.term,FStar_Syntax_Syntax.antiquotations)
          FStar_Pervasives_Native.tuple2)
  =
  fun top_level  ->
    fun env  ->
      fun top  ->
        let mk1 e =
          FStar_Syntax_Syntax.mk e FStar_Pervasives_Native.None
            top.FStar_Parser_AST.range
           in
        let noaqs = []  in
        let join_aqs aqs = FStar_List.flatten aqs  in
        let setpos e =
          let uu___274_6301 = e  in
          {
            FStar_Syntax_Syntax.n = (uu___274_6301.FStar_Syntax_Syntax.n);
            FStar_Syntax_Syntax.pos = (top.FStar_Parser_AST.range);
            FStar_Syntax_Syntax.vars =
              (uu___274_6301.FStar_Syntax_Syntax.vars)
          }  in
        let uu____6304 =
          let uu____6305 = unparen top  in uu____6305.FStar_Parser_AST.tm  in
        match uu____6304 with
        | FStar_Parser_AST.Wild  -> ((setpos FStar_Syntax_Syntax.tun), noaqs)
        | FStar_Parser_AST.Labeled uu____6310 ->
            let uu____6317 = desugar_formula env top  in (uu____6317, noaqs)
        | FStar_Parser_AST.Requires (t,lopt) ->
            let uu____6324 = desugar_formula env t  in (uu____6324, noaqs)
        | FStar_Parser_AST.Ensures (t,lopt) ->
            let uu____6331 = desugar_formula env t  in (uu____6331, noaqs)
        | FStar_Parser_AST.Attributes ts ->
            failwith
              "Attributes should not be desugared by desugar_term_maybe_top"
        | FStar_Parser_AST.Const (FStar_Const.Const_int
            (i,FStar_Pervasives_Native.Some size)) ->
            let uu____6355 =
              desugar_machine_integer env i size top.FStar_Parser_AST.range
               in
            (uu____6355, noaqs)
        | FStar_Parser_AST.Const c ->
            let uu____6357 = mk1 (FStar_Syntax_Syntax.Tm_constant c)  in
            (uu____6357, noaqs)
        | FStar_Parser_AST.Op
            ({ FStar_Ident.idText = "=!="; FStar_Ident.idRange = r;_},args)
            ->
            let e =
              let uu____6365 =
                let uu____6366 =
                  let uu____6373 = FStar_Ident.mk_ident ("==", r)  in
                  (uu____6373, args)  in
                FStar_Parser_AST.Op uu____6366  in
              FStar_Parser_AST.mk_term uu____6365 top.FStar_Parser_AST.range
                top.FStar_Parser_AST.level
               in
            let uu____6376 =
              let uu____6377 =
                let uu____6378 =
                  let uu____6385 = FStar_Ident.mk_ident ("~", r)  in
                  (uu____6385, [e])  in
                FStar_Parser_AST.Op uu____6378  in
              FStar_Parser_AST.mk_term uu____6377 top.FStar_Parser_AST.range
                top.FStar_Parser_AST.level
               in
            desugar_term_aq env uu____6376
        | FStar_Parser_AST.Op (op_star,uu____6389::uu____6390::[]) when
            (let uu____6395 = FStar_Ident.text_of_id op_star  in
             uu____6395 = "*") &&
              (let uu____6397 =
                 op_as_term env (Prims.parse_int "2")
                   top.FStar_Parser_AST.range op_star
                  in
               FStar_All.pipe_right uu____6397 FStar_Option.isNone)
            ->
            let rec flatten1 t =
              match t.FStar_Parser_AST.tm with
              | FStar_Parser_AST.Op
                  ({ FStar_Ident.idText = "*";
                     FStar_Ident.idRange = uu____6412;_},t1::t2::[])
                  ->
                  let uu____6417 = flatten1 t1  in
                  FStar_List.append uu____6417 [t2]
              | uu____6420 -> [t]  in
            let uu____6421 =
              let uu____6446 =
                let uu____6469 =
                  let uu____6472 = unparen top  in flatten1 uu____6472  in
                FStar_All.pipe_right uu____6469
                  (FStar_List.map
                     (fun t  ->
                        let uu____6507 = desugar_typ_aq env t  in
                        match uu____6507 with
                        | (t',aq) ->
                            let uu____6518 = FStar_Syntax_Syntax.as_arg t'
                               in
                            (uu____6518, aq)))
                 in
              FStar_All.pipe_right uu____6446 FStar_List.unzip  in
            (match uu____6421 with
             | (targs,aqs) ->
                 let uu____6627 =
                   let uu____6632 =
                     FStar_Parser_Const.mk_tuple_lid
                       (FStar_List.length targs) top.FStar_Parser_AST.range
                      in
                   FStar_Syntax_DsEnv.fail_or env
                     (FStar_Syntax_DsEnv.try_lookup_lid env) uu____6632
                    in
                 (match uu____6627 with
                  | (tup,uu____6648) ->
                      let uu____6649 =
                        mk1 (FStar_Syntax_Syntax.Tm_app (tup, targs))  in
                      (uu____6649, (join_aqs aqs))))
        | FStar_Parser_AST.Tvar a ->
            let uu____6661 =
              let uu____6662 =
                let uu____6665 =
                  FStar_Syntax_DsEnv.fail_or2
                    (FStar_Syntax_DsEnv.try_lookup_id env) a
                   in
                FStar_Pervasives_Native.fst uu____6665  in
              FStar_All.pipe_left setpos uu____6662  in
            (uu____6661, noaqs)
        | FStar_Parser_AST.Uvar u ->
            let uu____6677 =
              let uu____6682 =
                let uu____6683 =
                  let uu____6684 = FStar_Ident.text_of_id u  in
                  Prims.strcat uu____6684 " in non-universe context"  in
                Prims.strcat "Unexpected universe variable " uu____6683  in
              (FStar_Errors.Fatal_UnexpectedUniverseVariable, uu____6682)  in
            FStar_Errors.raise_error uu____6677 top.FStar_Parser_AST.range
        | FStar_Parser_AST.Op (s,args) ->
            let uu____6695 =
              op_as_term env (FStar_List.length args)
                top.FStar_Parser_AST.range s
               in
            (match uu____6695 with
             | FStar_Pervasives_Native.None  ->
                 let uu____6702 =
                   let uu____6707 =
                     let uu____6708 = FStar_Ident.text_of_id s  in
                     Prims.strcat "Unexpected or unbound operator: "
                       uu____6708
                      in
                   (FStar_Errors.Fatal_UnepxectedOrUnboundOperator,
                     uu____6707)
                    in
                 FStar_Errors.raise_error uu____6702
                   top.FStar_Parser_AST.range
             | FStar_Pervasives_Native.Some op ->
                 if (FStar_List.length args) > (Prims.parse_int "0")
                 then
                   let uu____6718 =
                     let uu____6743 =
                       FStar_All.pipe_right args
                         (FStar_List.map
                            (fun t  ->
                               let uu____6805 = desugar_term_aq env t  in
                               match uu____6805 with
                               | (t',s1) ->
                                   ((t', FStar_Pervasives_Native.None), s1)))
                        in
                     FStar_All.pipe_right uu____6743 FStar_List.unzip  in
                   (match uu____6718 with
                    | (args1,aqs) ->
                        let uu____6938 =
                          mk1 (FStar_Syntax_Syntax.Tm_app (op, args1))  in
                        (uu____6938, (join_aqs aqs)))
                 else (op, noaqs))
        | FStar_Parser_AST.Construct (n1,(a,uu____6952)::[]) when
            n1.FStar_Ident.str = "SMTPat" ->
            let uu____6967 =
              let uu___275_6968 = top  in
              let uu____6969 =
                let uu____6970 =
                  let uu____6977 =
                    let uu___276_6978 = top  in
                    let uu____6979 =
                      let uu____6980 =
                        FStar_Ident.lid_of_path ["Prims"; "smt_pat"]
                          top.FStar_Parser_AST.range
                         in
                      FStar_Parser_AST.Var uu____6980  in
                    {
                      FStar_Parser_AST.tm = uu____6979;
                      FStar_Parser_AST.range =
                        (uu___276_6978.FStar_Parser_AST.range);
                      FStar_Parser_AST.level =
                        (uu___276_6978.FStar_Parser_AST.level)
                    }  in
                  (uu____6977, a, FStar_Parser_AST.Nothing)  in
                FStar_Parser_AST.App uu____6970  in
              {
                FStar_Parser_AST.tm = uu____6969;
                FStar_Parser_AST.range =
                  (uu___275_6968.FStar_Parser_AST.range);
                FStar_Parser_AST.level =
                  (uu___275_6968.FStar_Parser_AST.level)
              }  in
            desugar_term_maybe_top top_level env uu____6967
        | FStar_Parser_AST.Construct (n1,(a,uu____6983)::[]) when
            n1.FStar_Ident.str = "SMTPatT" ->
            (FStar_Errors.log_issue top.FStar_Parser_AST.range
               (FStar_Errors.Warning_SMTPatTDeprecated,
                 "SMTPatT is deprecated; please just use SMTPat");
             (let uu____6999 =
                let uu___277_7000 = top  in
                let uu____7001 =
                  let uu____7002 =
                    let uu____7009 =
                      let uu___278_7010 = top  in
                      let uu____7011 =
                        let uu____7012 =
                          FStar_Ident.lid_of_path ["Prims"; "smt_pat"]
                            top.FStar_Parser_AST.range
                           in
                        FStar_Parser_AST.Var uu____7012  in
                      {
                        FStar_Parser_AST.tm = uu____7011;
                        FStar_Parser_AST.range =
                          (uu___278_7010.FStar_Parser_AST.range);
                        FStar_Parser_AST.level =
                          (uu___278_7010.FStar_Parser_AST.level)
                      }  in
                    (uu____7009, a, FStar_Parser_AST.Nothing)  in
                  FStar_Parser_AST.App uu____7002  in
                {
                  FStar_Parser_AST.tm = uu____7001;
                  FStar_Parser_AST.range =
                    (uu___277_7000.FStar_Parser_AST.range);
                  FStar_Parser_AST.level =
                    (uu___277_7000.FStar_Parser_AST.level)
                }  in
              desugar_term_maybe_top top_level env uu____6999))
        | FStar_Parser_AST.Construct (n1,(a,uu____7015)::[]) when
            n1.FStar_Ident.str = "SMTPatOr" ->
            let uu____7030 =
              let uu___279_7031 = top  in
              let uu____7032 =
                let uu____7033 =
                  let uu____7040 =
                    let uu___280_7041 = top  in
                    let uu____7042 =
                      let uu____7043 =
                        FStar_Ident.lid_of_path ["Prims"; "smt_pat_or"]
                          top.FStar_Parser_AST.range
                         in
                      FStar_Parser_AST.Var uu____7043  in
                    {
                      FStar_Parser_AST.tm = uu____7042;
                      FStar_Parser_AST.range =
                        (uu___280_7041.FStar_Parser_AST.range);
                      FStar_Parser_AST.level =
                        (uu___280_7041.FStar_Parser_AST.level)
                    }  in
                  (uu____7040, a, FStar_Parser_AST.Nothing)  in
                FStar_Parser_AST.App uu____7033  in
              {
                FStar_Parser_AST.tm = uu____7032;
                FStar_Parser_AST.range =
                  (uu___279_7031.FStar_Parser_AST.range);
                FStar_Parser_AST.level =
                  (uu___279_7031.FStar_Parser_AST.level)
              }  in
            desugar_term_maybe_top top_level env uu____7030
        | FStar_Parser_AST.Name
            { FStar_Ident.ns = uu____7044; FStar_Ident.ident = uu____7045;
              FStar_Ident.nsstr = uu____7046; FStar_Ident.str = "Type0";_}
            ->
            let uu____7049 =
              mk1 (FStar_Syntax_Syntax.Tm_type FStar_Syntax_Syntax.U_zero)
               in
            (uu____7049, noaqs)
        | FStar_Parser_AST.Name
            { FStar_Ident.ns = uu____7050; FStar_Ident.ident = uu____7051;
              FStar_Ident.nsstr = uu____7052; FStar_Ident.str = "Type";_}
            ->
            let uu____7055 =
              mk1 (FStar_Syntax_Syntax.Tm_type FStar_Syntax_Syntax.U_unknown)
               in
            (uu____7055, noaqs)
        | FStar_Parser_AST.Construct
            ({ FStar_Ident.ns = uu____7056; FStar_Ident.ident = uu____7057;
               FStar_Ident.nsstr = uu____7058; FStar_Ident.str = "Type";_},
             (t,FStar_Parser_AST.UnivApp )::[])
            ->
            let uu____7076 =
              let uu____7077 =
                let uu____7078 = desugar_universe t  in
                FStar_Syntax_Syntax.Tm_type uu____7078  in
              mk1 uu____7077  in
            (uu____7076, noaqs)
        | FStar_Parser_AST.Name
            { FStar_Ident.ns = uu____7079; FStar_Ident.ident = uu____7080;
              FStar_Ident.nsstr = uu____7081; FStar_Ident.str = "Effect";_}
            ->
            let uu____7084 =
              mk1 (FStar_Syntax_Syntax.Tm_constant FStar_Const.Const_effect)
               in
            (uu____7084, noaqs)
        | FStar_Parser_AST.Name
            { FStar_Ident.ns = uu____7085; FStar_Ident.ident = uu____7086;
              FStar_Ident.nsstr = uu____7087; FStar_Ident.str = "True";_}
            ->
            let uu____7090 =
              let uu____7091 =
                FStar_Ident.set_lid_range FStar_Parser_Const.true_lid
                  top.FStar_Parser_AST.range
                 in
              FStar_Syntax_Syntax.fvar uu____7091
                FStar_Syntax_Syntax.delta_constant
                FStar_Pervasives_Native.None
               in
            (uu____7090, noaqs)
        | FStar_Parser_AST.Name
            { FStar_Ident.ns = uu____7092; FStar_Ident.ident = uu____7093;
              FStar_Ident.nsstr = uu____7094; FStar_Ident.str = "False";_}
            ->
            let uu____7097 =
              let uu____7098 =
                FStar_Ident.set_lid_range FStar_Parser_Const.false_lid
                  top.FStar_Parser_AST.range
                 in
              FStar_Syntax_Syntax.fvar uu____7098
                FStar_Syntax_Syntax.delta_constant
                FStar_Pervasives_Native.None
               in
            (uu____7097, noaqs)
        | FStar_Parser_AST.Projector
            (eff_name,{ FStar_Ident.idText = txt;
                        FStar_Ident.idRange = uu____7101;_})
            when
            (is_special_effect_combinator txt) &&
              (FStar_Syntax_DsEnv.is_effect_name env eff_name)
            ->
            (FStar_Syntax_DsEnv.fail_if_qualified_by_curmodule env eff_name;
             (let uu____7103 =
                FStar_Syntax_DsEnv.try_lookup_effect_defn env eff_name  in
              match uu____7103 with
              | FStar_Pervasives_Native.Some ed ->
                  let lid = FStar_Syntax_Util.dm4f_lid ed txt  in
                  let uu____7112 =
                    FStar_Syntax_Syntax.fvar lid
                      (FStar_Syntax_Syntax.Delta_constant_at_level
                         (Prims.parse_int "1")) FStar_Pervasives_Native.None
                     in
                  (uu____7112, noaqs)
              | FStar_Pervasives_Native.None  ->
                  let uu____7113 =
                    let uu____7114 = FStar_Ident.text_of_lid eff_name  in
                    FStar_Util.format2
                      "Member %s of effect %s is not accessible (using an effect abbreviation instead of the original effect ?)"
                      uu____7114 txt
                     in
                  failwith uu____7113))
        | FStar_Parser_AST.Var l ->
            (FStar_Syntax_DsEnv.fail_if_qualified_by_curmodule env l;
             (let uu____7121 = desugar_name mk1 setpos env true l  in
              (uu____7121, noaqs)))
        | FStar_Parser_AST.Name l ->
            (FStar_Syntax_DsEnv.fail_if_qualified_by_curmodule env l;
             (let uu____7124 = desugar_name mk1 setpos env true l  in
              (uu____7124, noaqs)))
        | FStar_Parser_AST.Projector (l,i) ->
            (FStar_Syntax_DsEnv.fail_if_qualified_by_curmodule env l;
             (let name =
                let uu____7135 = FStar_Syntax_DsEnv.try_lookup_datacon env l
                   in
                match uu____7135 with
                | FStar_Pervasives_Native.Some uu____7144 ->
                    FStar_Pervasives_Native.Some (true, l)
                | FStar_Pervasives_Native.None  ->
                    let uu____7149 =
                      FStar_Syntax_DsEnv.try_lookup_root_effect_name env l
                       in
                    (match uu____7149 with
                     | FStar_Pervasives_Native.Some new_name ->
                         FStar_Pervasives_Native.Some (false, new_name)
                     | uu____7163 -> FStar_Pervasives_Native.None)
                 in
              match name with
              | FStar_Pervasives_Native.Some (resolve,new_name) ->
                  let uu____7180 =
                    let uu____7181 =
                      FStar_Syntax_Util.mk_field_projector_name_from_ident
                        new_name i
                       in
                    desugar_name mk1 setpos env resolve uu____7181  in
                  (uu____7180, noaqs)
              | uu____7182 ->
                  let uu____7189 =
                    let uu____7194 =
                      FStar_Util.format1
                        "Data constructor or effect %s not found"
                        l.FStar_Ident.str
                       in
                    (FStar_Errors.Fatal_EffectNotFound, uu____7194)  in
                  FStar_Errors.raise_error uu____7189
                    top.FStar_Parser_AST.range))
        | FStar_Parser_AST.Discrim lid ->
            (FStar_Syntax_DsEnv.fail_if_qualified_by_curmodule env lid;
             (let uu____7201 = FStar_Syntax_DsEnv.try_lookup_datacon env lid
                 in
              match uu____7201 with
              | FStar_Pervasives_Native.None  ->
                  let uu____7208 =
                    let uu____7213 =
                      FStar_Util.format1 "Data constructor %s not found"
                        lid.FStar_Ident.str
                       in
                    (FStar_Errors.Fatal_DataContructorNotFound, uu____7213)
                     in
                  FStar_Errors.raise_error uu____7208
                    top.FStar_Parser_AST.range
              | uu____7218 ->
                  let lid' = FStar_Syntax_Util.mk_discriminator lid  in
                  let uu____7222 = desugar_name mk1 setpos env true lid'  in
                  (uu____7222, noaqs)))
        | FStar_Parser_AST.Construct (l,args) ->
            (FStar_Syntax_DsEnv.fail_if_qualified_by_curmodule env l;
             (let uu____7238 = FStar_Syntax_DsEnv.try_lookup_datacon env l
                 in
              match uu____7238 with
              | FStar_Pervasives_Native.Some head1 ->
                  let head2 = mk1 (FStar_Syntax_Syntax.Tm_fvar head1)  in
                  (match args with
                   | [] -> (head2, noaqs)
                   | uu____7257 ->
                       let uu____7264 =
                         FStar_Util.take
                           (fun uu____7288  ->
                              match uu____7288 with
                              | (uu____7293,imp) ->
                                  imp = FStar_Parser_AST.UnivApp) args
                          in
                       (match uu____7264 with
                        | (universes,args1) ->
                            let universes1 =
                              FStar_List.map
                                (fun x  ->
                                   desugar_universe
                                     (FStar_Pervasives_Native.fst x))
                                universes
                               in
                            let uu____7338 =
                              let uu____7363 =
                                FStar_List.map
                                  (fun uu____7406  ->
                                     match uu____7406 with
                                     | (t,imp) ->
                                         let uu____7423 =
                                           desugar_term_aq env t  in
                                         (match uu____7423 with
                                          | (te,aq) ->
                                              ((arg_withimp_e imp te), aq)))
                                  args1
                                 in
                              FStar_All.pipe_right uu____7363
                                FStar_List.unzip
                               in
                            (match uu____7338 with
                             | (args2,aqs) ->
                                 let head3 =
                                   if universes1 = []
                                   then head2
                                   else
                                     mk1
                                       (FStar_Syntax_Syntax.Tm_uinst
                                          (head2, universes1))
                                    in
                                 let uu____7564 =
                                   mk1
                                     (FStar_Syntax_Syntax.Tm_app
                                        (head3, args2))
                                    in
                                 (uu____7564, (join_aqs aqs)))))
              | FStar_Pervasives_Native.None  ->
                  let err =
                    let uu____7580 =
                      FStar_Syntax_DsEnv.try_lookup_effect_name env l  in
                    match uu____7580 with
                    | FStar_Pervasives_Native.None  ->
                        (FStar_Errors.Fatal_ConstructorNotFound,
                          (Prims.strcat "Constructor "
                             (Prims.strcat l.FStar_Ident.str " not found")))
                    | FStar_Pervasives_Native.Some uu____7587 ->
                        (FStar_Errors.Fatal_UnexpectedEffect,
                          (Prims.strcat "Effect "
                             (Prims.strcat l.FStar_Ident.str
                                " used at an unexpected position")))
                     in
                  FStar_Errors.raise_error err top.FStar_Parser_AST.range))
        | FStar_Parser_AST.Sum (binders,t) ->
            let uu____7598 =
              FStar_List.fold_left
                (fun uu____7639  ->
                   fun b  ->
                     match uu____7639 with
                     | (env1,tparams,typs) ->
                         let uu____7688 = desugar_binder env1 b  in
                         (match uu____7688 with
                          | (xopt,t1) ->
                              let uu____7715 =
                                match xopt with
                                | FStar_Pervasives_Native.None  ->
                                    let uu____7724 =
                                      FStar_Syntax_Syntax.new_bv
                                        (FStar_Pervasives_Native.Some
                                           (top.FStar_Parser_AST.range))
                                        FStar_Syntax_Syntax.tun
                                       in
                                    (env1, uu____7724)
                                | FStar_Pervasives_Native.Some x ->
                                    FStar_Syntax_DsEnv.push_bv env1 x
                                 in
                              (match uu____7715 with
                               | (env2,x) ->
                                   let uu____7742 =
                                     let uu____7745 =
                                       let uu____7748 =
                                         let uu____7749 =
                                           no_annot_abs tparams t1  in
                                         FStar_All.pipe_left
                                           FStar_Syntax_Syntax.as_arg
                                           uu____7749
                                          in
                                       [uu____7748]  in
                                     FStar_List.append typs uu____7745  in
                                   (env2,
                                     (FStar_List.append tparams
                                        [(((let uu___281_7767 = x  in
                                            {
                                              FStar_Syntax_Syntax.ppname =
                                                (uu___281_7767.FStar_Syntax_Syntax.ppname);
                                              FStar_Syntax_Syntax.index =
                                                (uu___281_7767.FStar_Syntax_Syntax.index);
                                              FStar_Syntax_Syntax.sort = t1
                                            })),
                                           FStar_Pervasives_Native.None)]),
                                     uu____7742)))) (env, [], [])
                (FStar_List.append binders
                   [FStar_Parser_AST.mk_binder (FStar_Parser_AST.NoName t)
                      t.FStar_Parser_AST.range FStar_Parser_AST.Type_level
                      FStar_Pervasives_Native.None])
               in
            (match uu____7598 with
             | (env1,uu____7789,targs) ->
                 let uu____7807 =
                   let uu____7812 =
                     FStar_Parser_Const.mk_dtuple_lid
                       (FStar_List.length targs) top.FStar_Parser_AST.range
                      in
                   FStar_Syntax_DsEnv.fail_or env1
                     (FStar_Syntax_DsEnv.try_lookup_lid env1) uu____7812
                    in
                 (match uu____7807 with
                  | (tup,uu____7822) ->
                      let uu____7823 =
                        FStar_All.pipe_left mk1
                          (FStar_Syntax_Syntax.Tm_app (tup, targs))
                         in
                      (uu____7823, noaqs)))
        | FStar_Parser_AST.Product (binders,t) ->
            let uu____7840 = uncurry binders t  in
            (match uu____7840 with
             | (bs,t1) ->
                 let rec aux env1 bs1 uu___239_7882 =
                   match uu___239_7882 with
                   | [] ->
                       let cod =
                         desugar_comp top.FStar_Parser_AST.range env1 t1  in
                       let uu____7896 =
                         FStar_Syntax_Util.arrow (FStar_List.rev bs1) cod  in
                       FStar_All.pipe_left setpos uu____7896
                   | hd1::tl1 ->
                       let bb = desugar_binder env1 hd1  in
                       let uu____7918 =
                         as_binder env1 hd1.FStar_Parser_AST.aqual bb  in
                       (match uu____7918 with
                        | (b,env2) -> aux env2 (b :: bs1) tl1)
                    in
                 let uu____7943 = aux env [] bs  in (uu____7943, noaqs))
        | FStar_Parser_AST.Refine (b,f) ->
            let uu____7950 = desugar_binder env b  in
            (match uu____7950 with
             | (FStar_Pervasives_Native.None ,uu____7961) ->
                 failwith "Missing binder in refinement"
             | b1 ->
                 let uu____7975 =
                   as_binder env FStar_Pervasives_Native.None b1  in
                 (match uu____7975 with
                  | ((x,uu____7989),env1) ->
                      let f1 = desugar_formula env1 f  in
                      let uu____7996 =
                        let uu____7997 = FStar_Syntax_Util.refine x f1  in
                        FStar_All.pipe_left setpos uu____7997  in
                      (uu____7996, noaqs)))
        | FStar_Parser_AST.Abs (binders,body) ->
            let binders1 =
              FStar_All.pipe_right binders
                (FStar_List.map replace_unit_pattern)
               in
            let uu____8015 =
              FStar_List.fold_left
                (fun uu____8035  ->
                   fun pat  ->
                     match uu____8035 with
                     | (env1,ftvs) ->
                         (match pat.FStar_Parser_AST.pat with
                          | FStar_Parser_AST.PatAscribed
                              (uu____8061,(t,FStar_Pervasives_Native.None ))
                              ->
                              let uu____8071 =
                                let uu____8074 = free_type_vars env1 t  in
                                FStar_List.append uu____8074 ftvs  in
                              (env1, uu____8071)
                          | FStar_Parser_AST.PatAscribed
                              (uu____8079,(t,FStar_Pervasives_Native.Some
                                           tac))
                              ->
                              let uu____8090 =
                                let uu____8093 = free_type_vars env1 t  in
                                let uu____8096 =
                                  let uu____8099 = free_type_vars env1 tac
                                     in
                                  FStar_List.append uu____8099 ftvs  in
                                FStar_List.append uu____8093 uu____8096  in
                              (env1, uu____8090)
                          | uu____8104 -> (env1, ftvs))) (env, []) binders1
               in
            (match uu____8015 with
             | (uu____8113,ftv) ->
                 let ftv1 = sort_ftv ftv  in
                 let binders2 =
                   let uu____8125 =
                     FStar_All.pipe_right ftv1
                       (FStar_List.map
                          (fun a  ->
                             FStar_Parser_AST.mk_pattern
                               (FStar_Parser_AST.PatTvar
                                  (a,
                                    (FStar_Pervasives_Native.Some
                                       FStar_Parser_AST.Implicit)))
                               top.FStar_Parser_AST.range))
                      in
                   FStar_List.append uu____8125 binders1  in
                 let rec aux env1 bs sc_pat_opt uu___240_8180 =
                   match uu___240_8180 with
                   | [] ->
                       let uu____8205 = desugar_term_aq env1 body  in
                       (match uu____8205 with
                        | (body1,aq) ->
                            let body2 =
                              match sc_pat_opt with
                              | FStar_Pervasives_Native.Some (sc,pat) ->
                                  let body2 =
                                    let uu____8242 =
                                      let uu____8243 =
                                        FStar_Syntax_Syntax.pat_bvs pat  in
                                      FStar_All.pipe_right uu____8243
                                        (FStar_List.map
                                           FStar_Syntax_Syntax.mk_binder)
                                       in
                                    FStar_Syntax_Subst.close uu____8242 body1
                                     in
                                  FStar_Syntax_Syntax.mk
                                    (FStar_Syntax_Syntax.Tm_match
                                       (sc,
                                         [(pat, FStar_Pervasives_Native.None,
                                            body2)]))
                                    FStar_Pervasives_Native.None
                                    body2.FStar_Syntax_Syntax.pos
                              | FStar_Pervasives_Native.None  -> body1  in
                            let uu____8312 =
                              let uu____8315 =
                                no_annot_abs (FStar_List.rev bs) body2  in
                              setpos uu____8315  in
                            (uu____8312, aq))
                   | p::rest ->
                       let uu____8328 = desugar_binding_pat env1 p  in
                       (match uu____8328 with
                        | (env2,b,pat) ->
                            let pat1 =
                              match pat with
                              | [] -> FStar_Pervasives_Native.None
                              | p1::[] -> FStar_Pervasives_Native.Some p1
                              | uu____8364 ->
                                  FStar_Errors.raise_error
                                    (FStar_Errors.Fatal_UnsupportedDisjuctivePatterns,
                                      "Disjunctive patterns are not supported in abstractions")
                                    p.FStar_Parser_AST.prange
                               in
                            let uu____8371 =
                              match b with
                              | LetBinder uu____8408 -> failwith "Impossible"
                              | LocalBinder (x,aq) ->
                                  let sc_pat_opt1 =
                                    match (pat1, sc_pat_opt) with
                                    | (FStar_Pervasives_Native.None
                                       ,uu____8474) -> sc_pat_opt
                                    | (FStar_Pervasives_Native.Some
                                       p1,FStar_Pervasives_Native.None ) ->
                                        let uu____8528 =
                                          let uu____8537 =
                                            FStar_Syntax_Syntax.bv_to_name x
                                             in
                                          (uu____8537, p1)  in
                                        FStar_Pervasives_Native.Some
                                          uu____8528
                                    | (FStar_Pervasives_Native.Some
                                       p1,FStar_Pervasives_Native.Some
                                       (sc,p')) ->
                                        (match ((sc.FStar_Syntax_Syntax.n),
                                                 (p'.FStar_Syntax_Syntax.v))
                                         with
                                         | (FStar_Syntax_Syntax.Tm_name
                                            uu____8599,uu____8600) ->
                                             let tup2 =
                                               let uu____8602 =
                                                 FStar_Parser_Const.mk_tuple_data_lid
                                                   (Prims.parse_int "2")
                                                   top.FStar_Parser_AST.range
                                                  in
                                               FStar_Syntax_Syntax.lid_as_fv
                                                 uu____8602
                                                 FStar_Syntax_Syntax.delta_constant
                                                 (FStar_Pervasives_Native.Some
                                                    FStar_Syntax_Syntax.Data_ctor)
                                                in
                                             let sc1 =
                                               let uu____8606 =
                                                 let uu____8613 =
                                                   let uu____8614 =
                                                     let uu____8629 =
                                                       mk1
                                                         (FStar_Syntax_Syntax.Tm_fvar
                                                            tup2)
                                                        in
                                                     let uu____8632 =
                                                       let uu____8641 =
                                                         FStar_Syntax_Syntax.as_arg
                                                           sc
                                                          in
                                                       let uu____8648 =
                                                         let uu____8657 =
                                                           let uu____8664 =
                                                             FStar_Syntax_Syntax.bv_to_name
                                                               x
                                                              in
                                                           FStar_All.pipe_left
                                                             FStar_Syntax_Syntax.as_arg
                                                             uu____8664
                                                            in
                                                         [uu____8657]  in
                                                       uu____8641 ::
                                                         uu____8648
                                                        in
                                                     (uu____8629, uu____8632)
                                                      in
                                                   FStar_Syntax_Syntax.Tm_app
                                                     uu____8614
                                                    in
                                                 FStar_Syntax_Syntax.mk
                                                   uu____8613
                                                  in
                                               uu____8606
                                                 FStar_Pervasives_Native.None
                                                 top.FStar_Parser_AST.range
                                                in
                                             let p2 =
                                               let uu____8705 =
                                                 FStar_Range.union_ranges
                                                   p'.FStar_Syntax_Syntax.p
                                                   p1.FStar_Syntax_Syntax.p
                                                  in
                                               FStar_Syntax_Syntax.withinfo
                                                 (FStar_Syntax_Syntax.Pat_cons
                                                    (tup2,
                                                      [(p', false);
                                                      (p1, false)]))
                                                 uu____8705
                                                in
                                             FStar_Pervasives_Native.Some
                                               (sc1, p2)
                                         | (FStar_Syntax_Syntax.Tm_app
                                            (uu____8748,args),FStar_Syntax_Syntax.Pat_cons
                                            (uu____8750,pats)) ->
                                             let tupn =
                                               let uu____8789 =
                                                 FStar_Parser_Const.mk_tuple_data_lid
                                                   ((Prims.parse_int "1") +
                                                      (FStar_List.length args))
                                                   top.FStar_Parser_AST.range
                                                  in
                                               FStar_Syntax_Syntax.lid_as_fv
                                                 uu____8789
                                                 FStar_Syntax_Syntax.delta_constant
                                                 (FStar_Pervasives_Native.Some
                                                    FStar_Syntax_Syntax.Data_ctor)
                                                in
                                             let sc1 =
                                               let uu____8799 =
                                                 let uu____8800 =
                                                   let uu____8815 =
                                                     mk1
                                                       (FStar_Syntax_Syntax.Tm_fvar
                                                          tupn)
                                                      in
                                                   let uu____8818 =
                                                     let uu____8827 =
                                                       let uu____8836 =
                                                         let uu____8843 =
                                                           FStar_Syntax_Syntax.bv_to_name
                                                             x
                                                            in
                                                         FStar_All.pipe_left
                                                           FStar_Syntax_Syntax.as_arg
                                                           uu____8843
                                                          in
                                                       [uu____8836]  in
                                                     FStar_List.append args
                                                       uu____8827
                                                      in
                                                   (uu____8815, uu____8818)
                                                    in
                                                 FStar_Syntax_Syntax.Tm_app
                                                   uu____8800
                                                  in
                                               mk1 uu____8799  in
                                             let p2 =
                                               let uu____8881 =
                                                 FStar_Range.union_ranges
                                                   p'.FStar_Syntax_Syntax.p
                                                   p1.FStar_Syntax_Syntax.p
                                                  in
                                               FStar_Syntax_Syntax.withinfo
                                                 (FStar_Syntax_Syntax.Pat_cons
                                                    (tupn,
                                                      (FStar_List.append pats
                                                         [(p1, false)])))
                                                 uu____8881
                                                in
                                             FStar_Pervasives_Native.Some
                                               (sc1, p2)
                                         | uu____8922 ->
                                             failwith "Impossible")
                                     in
                                  ((x, aq), sc_pat_opt1)
                               in
                            (match uu____8371 with
                             | (b1,sc_pat_opt1) ->
                                 aux env2 (b1 :: bs) sc_pat_opt1 rest))
                    in
                 aux env [] FStar_Pervasives_Native.None binders2)
        | FStar_Parser_AST.App
            (uu____9003,uu____9004,FStar_Parser_AST.UnivApp ) ->
            let rec aux universes e =
              let uu____9026 =
                let uu____9027 = unparen e  in uu____9027.FStar_Parser_AST.tm
                 in
              match uu____9026 with
              | FStar_Parser_AST.App (e1,t,FStar_Parser_AST.UnivApp ) ->
                  let univ_arg = desugar_universe t  in
                  aux (univ_arg :: universes) e1
              | uu____9037 ->
                  let uu____9038 = desugar_term_aq env e  in
                  (match uu____9038 with
                   | (head1,aq) ->
                       let uu____9051 =
                         mk1
                           (FStar_Syntax_Syntax.Tm_uinst (head1, universes))
                          in
                       (uu____9051, aq))
               in
            aux [] top
        | FStar_Parser_AST.App uu____9058 ->
            let rec aux args aqs e =
              let uu____9137 =
                let uu____9138 = unparen e  in uu____9138.FStar_Parser_AST.tm
                 in
              match uu____9137 with
              | FStar_Parser_AST.App (e1,t,imp) when
                  imp <> FStar_Parser_AST.UnivApp ->
                  let uu____9158 = desugar_term_aq env t  in
                  (match uu____9158 with
                   | (t1,aq) ->
                       let arg = arg_withimp_e imp t1  in
                       aux (arg :: args) (aq :: aqs) e1)
              | uu____9208 ->
                  let uu____9209 = desugar_term_aq env e  in
                  (match uu____9209 with
                   | (head1,aq) ->
                       let uu____9232 =
                         mk1 (FStar_Syntax_Syntax.Tm_app (head1, args))  in
                       (uu____9232, (join_aqs (aq :: aqs))))
               in
            aux [] [] top
        | FStar_Parser_AST.Bind (x,t1,t2) ->
            let xpat =
              FStar_Parser_AST.mk_pattern
                (FStar_Parser_AST.PatVar (x, FStar_Pervasives_Native.None))
                x.FStar_Ident.idRange
               in
            let k =
              FStar_Parser_AST.mk_term (FStar_Parser_AST.Abs ([xpat], t2))
                t2.FStar_Parser_AST.range t2.FStar_Parser_AST.level
               in
            let bind_lid =
              FStar_Ident.lid_of_path ["bind"] x.FStar_Ident.idRange  in
            let bind1 =
              FStar_Parser_AST.mk_term (FStar_Parser_AST.Var bind_lid)
                x.FStar_Ident.idRange FStar_Parser_AST.Expr
               in
            let uu____9294 =
              FStar_Parser_AST.mkExplicitApp bind1 [t1; k]
                top.FStar_Parser_AST.range
               in
            desugar_term_aq env uu____9294
        | FStar_Parser_AST.Seq (t1,t2) ->
            let t =
              FStar_Parser_AST.mk_term
                (FStar_Parser_AST.Let
                   (FStar_Parser_AST.NoLetQualifier,
                     [(FStar_Pervasives_Native.None,
                        ((FStar_Parser_AST.mk_pattern
                            FStar_Parser_AST.PatWild
                            t1.FStar_Parser_AST.range), t1))], t2))
                top.FStar_Parser_AST.range FStar_Parser_AST.Expr
               in
            let uu____9346 = desugar_term_aq env t  in
            (match uu____9346 with
             | (tm,s) ->
                 let uu____9357 =
                   mk1
                     (FStar_Syntax_Syntax.Tm_meta
                        (tm,
                          (FStar_Syntax_Syntax.Meta_desugared
                             FStar_Syntax_Syntax.Sequence)))
                    in
                 (uu____9357, s))
        | FStar_Parser_AST.LetOpen (lid,e) ->
            let env1 = FStar_Syntax_DsEnv.push_namespace env lid  in
            let uu____9363 =
              let uu____9376 = FStar_Syntax_DsEnv.expect_typ env1  in
              if uu____9376 then desugar_typ_aq else desugar_term_aq  in
            uu____9363 env1 e
        | FStar_Parser_AST.Let (qual,lbs,body) ->
            let is_rec = qual = FStar_Parser_AST.Rec  in
            let ds_let_rec_or_app uu____9431 =
              let bindings = lbs  in
              let funs =
                FStar_All.pipe_right bindings
                  (FStar_List.map
                     (fun uu____9574  ->
                        match uu____9574 with
                        | (attr_opt,(p,def)) ->
                            let uu____9632 = is_app_pattern p  in
                            if uu____9632
                            then
                              let uu____9663 =
                                destruct_app_pattern env top_level p  in
                              (attr_opt, uu____9663, def)
                            else
                              (match FStar_Parser_AST.un_function p def with
                               | FStar_Pervasives_Native.Some (p1,def1) ->
                                   let uu____9745 =
                                     destruct_app_pattern env top_level p1
                                      in
                                   (attr_opt, uu____9745, def1)
                               | uu____9790 ->
                                   (match p.FStar_Parser_AST.pat with
                                    | FStar_Parser_AST.PatAscribed
                                        ({
                                           FStar_Parser_AST.pat =
                                             FStar_Parser_AST.PatVar
                                             (id1,uu____9828);
                                           FStar_Parser_AST.prange =
                                             uu____9829;_},t)
                                        ->
                                        if top_level
                                        then
                                          let uu____9877 =
                                            let uu____9898 =
                                              let uu____9903 =
                                                FStar_Syntax_DsEnv.qualify
                                                  env id1
                                                 in
                                              FStar_Util.Inr uu____9903  in
                                            (uu____9898, [],
                                              (FStar_Pervasives_Native.Some t))
                                             in
                                          (attr_opt, uu____9877, def)
                                        else
                                          (attr_opt,
                                            ((FStar_Util.Inl id1), [],
                                              (FStar_Pervasives_Native.Some t)),
                                            def)
                                    | FStar_Parser_AST.PatVar
                                        (id1,uu____9994) ->
                                        if top_level
                                        then
                                          let uu____10029 =
                                            let uu____10050 =
                                              let uu____10055 =
                                                FStar_Syntax_DsEnv.qualify
                                                  env id1
                                                 in
                                              FStar_Util.Inr uu____10055  in
                                            (uu____10050, [],
                                              FStar_Pervasives_Native.None)
                                             in
                                          (attr_opt, uu____10029, def)
                                        else
                                          (attr_opt,
                                            ((FStar_Util.Inl id1), [],
                                              FStar_Pervasives_Native.None),
                                            def)
                                    | uu____10145 ->
                                        FStar_Errors.raise_error
                                          (FStar_Errors.Fatal_UnexpectedLetBinding,
                                            "Unexpected let binding")
                                          p.FStar_Parser_AST.prange))))
                 in
              let uu____10176 =
                FStar_List.fold_left
                  (fun uu____10249  ->
                     fun uu____10250  ->
                       match (uu____10249, uu____10250) with
                       | ((env1,fnames,rec_bindings),(_attr_opt,(f,uu____10358,uu____10359),uu____10360))
                           ->
                           let uu____10477 =
                             match f with
                             | FStar_Util.Inl x ->
                                 let uu____10503 =
                                   FStar_Syntax_DsEnv.push_bv env1 x  in
                                 (match uu____10503 with
                                  | (env2,xx) ->
                                      let uu____10522 =
                                        let uu____10525 =
                                          FStar_Syntax_Syntax.mk_binder xx
                                           in
                                        uu____10525 :: rec_bindings  in
                                      (env2, (FStar_Util.Inl xx),
                                        uu____10522))
                             | FStar_Util.Inr l ->
                                 let uu____10533 =
                                   FStar_Syntax_DsEnv.push_top_level_rec_binding
                                     env1 l.FStar_Ident.ident
                                     FStar_Syntax_Syntax.delta_equational
                                    in
                                 (uu____10533, (FStar_Util.Inr l),
                                   rec_bindings)
                              in
                           (match uu____10477 with
                            | (env2,lbname,rec_bindings1) ->
                                (env2, (lbname :: fnames), rec_bindings1)))
                  (env, [], []) funs
                 in
              match uu____10176 with
              | (env',fnames,rec_bindings) ->
                  let fnames1 = FStar_List.rev fnames  in
                  let rec_bindings1 = FStar_List.rev rec_bindings  in
                  let desugar_one_def env1 lbname uu____10681 =
                    match uu____10681 with
                    | (attrs_opt,(uu____10717,args,result_t),def) ->
                        let args1 =
                          FStar_All.pipe_right args
                            (FStar_List.map replace_unit_pattern)
                           in
                        let pos = def.FStar_Parser_AST.range  in
                        let def1 =
                          match result_t with
                          | FStar_Pervasives_Native.None  -> def
                          | FStar_Pervasives_Native.Some (t,tacopt) ->
                              let t1 =
                                let uu____10805 = is_comp_type env1 t  in
                                if uu____10805
                                then
                                  ((let uu____10807 =
                                      FStar_All.pipe_right args1
                                        (FStar_List.tryFind
                                           (fun x  ->
                                              let uu____10817 =
                                                is_var_pattern x  in
                                              Prims.op_Negation uu____10817))
                                       in
                                    match uu____10807 with
                                    | FStar_Pervasives_Native.None  -> ()
                                    | FStar_Pervasives_Native.Some p ->
                                        FStar_Errors.raise_error
                                          (FStar_Errors.Fatal_ComputationTypeNotAllowed,
                                            "Computation type annotations are only permitted on let-bindings without inlined patterns; replace this pattern with a variable")
                                          p.FStar_Parser_AST.prange);
                                   t)
                                else
                                  (let uu____10820 =
                                     ((FStar_Options.ml_ish ()) &&
                                        (let uu____10822 =
                                           FStar_Syntax_DsEnv.try_lookup_effect_name
                                             env1
                                             FStar_Parser_Const.effect_ML_lid
                                            in
                                         FStar_Option.isSome uu____10822))
                                       &&
                                       ((Prims.op_Negation is_rec) ||
                                          ((FStar_List.length args1) <>
                                             (Prims.parse_int "0")))
                                      in
                                   if uu____10820
                                   then FStar_Parser_AST.ml_comp t
                                   else FStar_Parser_AST.tot_comp t)
                                 in
                              FStar_Parser_AST.mk_term
                                (FStar_Parser_AST.Ascribed (def, t1, tacopt))
                                def.FStar_Parser_AST.range
                                FStar_Parser_AST.Expr
                           in
                        let def2 =
                          match args1 with
                          | [] -> def1
                          | uu____10829 ->
                              FStar_Parser_AST.mk_term
                                (FStar_Parser_AST.un_curry_abs args1 def1)
                                top.FStar_Parser_AST.range
                                top.FStar_Parser_AST.level
                           in
                        let body1 = desugar_term env1 def2  in
                        let lbname1 =
                          match lbname with
                          | FStar_Util.Inl x -> FStar_Util.Inl x
                          | FStar_Util.Inr l ->
                              let uu____10844 =
                                let uu____10845 =
                                  FStar_Syntax_Util.incr_delta_qualifier
                                    body1
                                   in
                                FStar_Syntax_Syntax.lid_as_fv l uu____10845
                                  FStar_Pervasives_Native.None
                                 in
                              FStar_Util.Inr uu____10844
                           in
                        let body2 =
                          if is_rec
                          then FStar_Syntax_Subst.close rec_bindings1 body1
                          else body1  in
                        let attrs =
                          match attrs_opt with
                          | FStar_Pervasives_Native.None  -> []
                          | FStar_Pervasives_Native.Some l ->
                              FStar_List.map (desugar_term env1) l
                           in
                        mk_lb
                          (attrs, lbname1, FStar_Syntax_Syntax.tun, body2,
                            pos)
                     in
                  let lbs1 =
                    FStar_List.map2
                      (desugar_one_def (if is_rec then env' else env))
                      fnames1 funs
                     in
                  let uu____10922 = desugar_term_aq env' body  in
                  (match uu____10922 with
                   | (body1,aq) ->
                       let uu____10935 =
                         let uu____10938 =
                           let uu____10939 =
                             let uu____10952 =
                               FStar_Syntax_Subst.close rec_bindings1 body1
                                in
                             ((is_rec, lbs1), uu____10952)  in
                           FStar_Syntax_Syntax.Tm_let uu____10939  in
                         FStar_All.pipe_left mk1 uu____10938  in
                       (uu____10935, aq))
               in
            let ds_non_rec attrs_opt pat t1 t2 =
              let attrs =
                match attrs_opt with
                | FStar_Pervasives_Native.None  -> []
                | FStar_Pervasives_Native.Some l ->
                    FStar_List.map (desugar_term env) l
                 in
              let t11 = desugar_term env t1  in
              let is_mutable = qual = FStar_Parser_AST.Mutable  in
              let t12 = if is_mutable then mk_ref_alloc t11 else t11  in
              let uu____11032 =
                desugar_binding_pat_maybe_top top_level env pat is_mutable
                 in
              match uu____11032 with
              | (env1,binder,pat1) ->
                  let uu____11054 =
                    match binder with
                    | LetBinder (l,(t,_tacopt)) ->
                        let uu____11080 = desugar_term_aq env1 t2  in
                        (match uu____11080 with
                         | (body1,aq) ->
                             let fv =
                               let uu____11094 =
                                 FStar_Syntax_Util.incr_delta_qualifier t12
                                  in
                               FStar_Syntax_Syntax.lid_as_fv l uu____11094
                                 FStar_Pervasives_Native.None
                                in
                             let uu____11095 =
                               FStar_All.pipe_left mk1
                                 (FStar_Syntax_Syntax.Tm_let
                                    ((false,
                                       [mk_lb
                                          (attrs, (FStar_Util.Inr fv), t,
                                            t12,
                                            (t12.FStar_Syntax_Syntax.pos))]),
                                      body1))
                                in
                             (uu____11095, aq))
                    | LocalBinder (x,uu____11125) ->
                        let uu____11126 = desugar_term_aq env1 t2  in
                        (match uu____11126 with
                         | (body1,aq) ->
                             let body2 =
                               match pat1 with
                               | [] -> body1
                               | {
                                   FStar_Syntax_Syntax.v =
                                     FStar_Syntax_Syntax.Pat_wild uu____11140;
                                   FStar_Syntax_Syntax.p = uu____11141;_}::[]
                                   -> body1
                               | uu____11142 ->
                                   let uu____11145 =
                                     let uu____11152 =
                                       let uu____11153 =
                                         let uu____11176 =
                                           FStar_Syntax_Syntax.bv_to_name x
                                            in
                                         let uu____11179 =
                                           desugar_disjunctive_pattern pat1
                                             FStar_Pervasives_Native.None
                                             body1
                                            in
                                         (uu____11176, uu____11179)  in
                                       FStar_Syntax_Syntax.Tm_match
                                         uu____11153
                                        in
                                     FStar_Syntax_Syntax.mk uu____11152  in
                                   uu____11145 FStar_Pervasives_Native.None
                                     top.FStar_Parser_AST.range
                                in
                             let uu____11219 =
                               let uu____11222 =
                                 let uu____11223 =
                                   let uu____11236 =
                                     let uu____11239 =
                                       let uu____11240 =
                                         FStar_Syntax_Syntax.mk_binder x  in
                                       [uu____11240]  in
                                     FStar_Syntax_Subst.close uu____11239
                                       body2
                                      in
                                   ((false,
                                      [mk_lb
                                         (attrs, (FStar_Util.Inl x),
                                           (x.FStar_Syntax_Syntax.sort), t12,
                                           (t12.FStar_Syntax_Syntax.pos))]),
                                     uu____11236)
                                    in
                                 FStar_Syntax_Syntax.Tm_let uu____11223  in
                               FStar_All.pipe_left mk1 uu____11222  in
                             (uu____11219, aq))
                     in
                  (match uu____11054 with
                   | (tm,aq) ->
                       if is_mutable
                       then
                         let uu____11297 =
                           FStar_All.pipe_left mk1
                             (FStar_Syntax_Syntax.Tm_meta
                                (tm,
                                  (FStar_Syntax_Syntax.Meta_desugared
                                     FStar_Syntax_Syntax.Mutable_alloc)))
                            in
                         (uu____11297, aq)
                       else (tm, aq))
               in
            let uu____11309 = FStar_List.hd lbs  in
            (match uu____11309 with
             | (attrs,(head_pat,defn)) ->
                 let uu____11353 = is_rec || (is_app_pattern head_pat)  in
                 if uu____11353
                 then ds_let_rec_or_app ()
                 else ds_non_rec attrs head_pat defn body)
        | FStar_Parser_AST.If (t1,t2,t3) ->
            let x =
              FStar_Syntax_Syntax.new_bv
                (FStar_Pervasives_Native.Some (t3.FStar_Parser_AST.range))
                FStar_Syntax_Syntax.tun
               in
            let t_bool1 =
              let uu____11366 =
                let uu____11367 =
                  FStar_Syntax_Syntax.lid_as_fv FStar_Parser_Const.bool_lid
                    FStar_Syntax_Syntax.delta_constant
                    FStar_Pervasives_Native.None
                   in
                FStar_Syntax_Syntax.Tm_fvar uu____11367  in
              mk1 uu____11366  in
            let uu____11368 = desugar_term_aq env t1  in
            (match uu____11368 with
             | (t1',aq1) ->
                 let uu____11379 = desugar_term_aq env t2  in
                 (match uu____11379 with
                  | (t2',aq2) ->
                      let uu____11390 = desugar_term_aq env t3  in
                      (match uu____11390 with
                       | (t3',aq3) ->
                           let uu____11401 =
                             let uu____11402 =
                               let uu____11403 =
                                 let uu____11426 =
                                   let uu____11443 =
                                     let uu____11458 =
                                       FStar_Syntax_Syntax.withinfo
                                         (FStar_Syntax_Syntax.Pat_constant
                                            (FStar_Const.Const_bool true))
                                         t2.FStar_Parser_AST.range
                                        in
                                     (uu____11458,
                                       FStar_Pervasives_Native.None, t2')
                                      in
                                   let uu____11471 =
                                     let uu____11488 =
                                       let uu____11503 =
                                         FStar_Syntax_Syntax.withinfo
                                           (FStar_Syntax_Syntax.Pat_wild x)
                                           t3.FStar_Parser_AST.range
                                          in
                                       (uu____11503,
                                         FStar_Pervasives_Native.None, t3')
                                        in
                                     [uu____11488]  in
                                   uu____11443 :: uu____11471  in
                                 (t1', uu____11426)  in
                               FStar_Syntax_Syntax.Tm_match uu____11403  in
                             mk1 uu____11402  in
                           (uu____11401, (join_aqs [aq1; aq2; aq3])))))
        | FStar_Parser_AST.TryWith (e,branches) ->
            let r = top.FStar_Parser_AST.range  in
            let handler = FStar_Parser_AST.mk_function branches r r  in
            let body =
              FStar_Parser_AST.mk_function
                [((FStar_Parser_AST.mk_pattern
                     (FStar_Parser_AST.PatConst FStar_Const.Const_unit) r),
                   FStar_Pervasives_Native.None, e)] r r
               in
            let a1 =
              FStar_Parser_AST.mk_term
                (FStar_Parser_AST.App
                   ((FStar_Parser_AST.mk_term
                       (FStar_Parser_AST.Var FStar_Parser_Const.try_with_lid)
                       r top.FStar_Parser_AST.level), body,
                     FStar_Parser_AST.Nothing)) r top.FStar_Parser_AST.level
               in
            let a2 =
              FStar_Parser_AST.mk_term
                (FStar_Parser_AST.App (a1, handler, FStar_Parser_AST.Nothing))
                r top.FStar_Parser_AST.level
               in
            desugar_term_aq env a2
        | FStar_Parser_AST.Match (e,branches) ->
            let desugar_branch uu____11702 =
              match uu____11702 with
              | (pat,wopt,b) ->
                  let uu____11724 = desugar_match_pat env pat  in
                  (match uu____11724 with
                   | (env1,pat1) ->
                       let wopt1 =
                         match wopt with
                         | FStar_Pervasives_Native.None  ->
                             FStar_Pervasives_Native.None
                         | FStar_Pervasives_Native.Some e1 ->
                             let uu____11755 = desugar_term env1 e1  in
                             FStar_Pervasives_Native.Some uu____11755
                          in
                       let uu____11760 = desugar_term_aq env1 b  in
                       (match uu____11760 with
                        | (b1,aq) ->
                            let uu____11773 =
                              desugar_disjunctive_pattern pat1 wopt1 b1  in
                            (uu____11773, aq)))
               in
            let uu____11778 = desugar_term_aq env e  in
            (match uu____11778 with
             | (e1,aq) ->
                 let uu____11789 =
                   let uu____11822 =
                     let uu____11857 = FStar_List.map desugar_branch branches
                        in
                     FStar_All.pipe_right uu____11857 FStar_List.unzip  in
                   FStar_All.pipe_right uu____11822
                     (fun uu____12089  ->
                        match uu____12089 with
                        | (x,y) -> ((FStar_List.flatten x), y))
                    in
                 (match uu____11789 with
                  | (brs,aqs) ->
                      let uu____12322 =
                        FStar_All.pipe_left mk1
                          (FStar_Syntax_Syntax.Tm_match (e1, brs))
                         in
                      (uu____12322, (join_aqs (aq :: aqs)))))
        | FStar_Parser_AST.Ascribed (e,t,tac_opt) ->
            let annot =
              let uu____12367 = is_comp_type env t  in
              if uu____12367
              then
                let uu____12376 = desugar_comp t.FStar_Parser_AST.range env t
                   in
                FStar_Util.Inr uu____12376
              else
                (let uu____12384 = desugar_term env t  in
                 FStar_Util.Inl uu____12384)
               in
            let tac_opt1 = FStar_Util.map_opt tac_opt (desugar_term env)  in
            let uu____12398 = desugar_term_aq env e  in
            (match uu____12398 with
             | (e1,aq) ->
                 let uu____12409 =
                   FStar_All.pipe_left mk1
                     (FStar_Syntax_Syntax.Tm_ascribed
                        (e1, (annot, tac_opt1), FStar_Pervasives_Native.None))
                    in
                 (uu____12409, aq))
        | FStar_Parser_AST.Record (uu____12442,[]) ->
            FStar_Errors.raise_error
              (FStar_Errors.Fatal_UnexpectedEmptyRecord,
                "Unexpected empty record") top.FStar_Parser_AST.range
        | FStar_Parser_AST.Record (eopt,fields) ->
            let record = check_fields env fields top.FStar_Parser_AST.range
               in
            let user_ns =
              let uu____12483 = FStar_List.hd fields  in
              match uu____12483 with | (f,uu____12495) -> f.FStar_Ident.ns
               in
            let get_field xopt f =
              let found =
                FStar_All.pipe_right fields
                  (FStar_Util.find_opt
                     (fun uu____12541  ->
                        match uu____12541 with
                        | (g,uu____12547) ->
                            f.FStar_Ident.idText =
                              (g.FStar_Ident.ident).FStar_Ident.idText))
                 in
              let fn = FStar_Ident.lid_of_ids (FStar_List.append user_ns [f])
                 in
              match found with
              | FStar_Pervasives_Native.Some (uu____12553,e) -> (fn, e)
              | FStar_Pervasives_Native.None  ->
                  (match xopt with
                   | FStar_Pervasives_Native.None  ->
                       let uu____12567 =
                         let uu____12572 =
                           FStar_Util.format2
                             "Field %s of record type %s is missing"
                             f.FStar_Ident.idText
                             (record.FStar_Syntax_DsEnv.typename).FStar_Ident.str
                            in
                         (FStar_Errors.Fatal_MissingFieldInRecord,
                           uu____12572)
                          in
                       FStar_Errors.raise_error uu____12567
                         top.FStar_Parser_AST.range
                   | FStar_Pervasives_Native.Some x ->
                       (fn,
                         (FStar_Parser_AST.mk_term
                            (FStar_Parser_AST.Project (x, fn))
                            x.FStar_Parser_AST.range x.FStar_Parser_AST.level)))
               in
            let user_constrname =
              FStar_Ident.lid_of_ids
                (FStar_List.append user_ns
                   [record.FStar_Syntax_DsEnv.constrname])
               in
            let recterm =
              match eopt with
              | FStar_Pervasives_Native.None  ->
                  let uu____12580 =
                    let uu____12591 =
                      FStar_All.pipe_right record.FStar_Syntax_DsEnv.fields
                        (FStar_List.map
                           (fun uu____12622  ->
                              match uu____12622 with
                              | (f,uu____12632) ->
                                  let uu____12633 =
                                    let uu____12634 =
                                      get_field FStar_Pervasives_Native.None
                                        f
                                       in
                                    FStar_All.pipe_left
                                      FStar_Pervasives_Native.snd uu____12634
                                     in
                                  (uu____12633, FStar_Parser_AST.Nothing)))
                       in
                    (user_constrname, uu____12591)  in
                  FStar_Parser_AST.Construct uu____12580
              | FStar_Pervasives_Native.Some e ->
                  let x = FStar_Ident.gen e.FStar_Parser_AST.range  in
                  let xterm =
                    let uu____12652 =
                      let uu____12653 = FStar_Ident.lid_of_ids [x]  in
                      FStar_Parser_AST.Var uu____12653  in
                    FStar_Parser_AST.mk_term uu____12652
                      x.FStar_Ident.idRange FStar_Parser_AST.Expr
                     in
                  let record1 =
                    let uu____12655 =
                      let uu____12668 =
                        FStar_All.pipe_right record.FStar_Syntax_DsEnv.fields
                          (FStar_List.map
                             (fun uu____12698  ->
                                match uu____12698 with
                                | (f,uu____12708) ->
                                    get_field
                                      (FStar_Pervasives_Native.Some xterm) f))
                         in
                      (FStar_Pervasives_Native.None, uu____12668)  in
                    FStar_Parser_AST.Record uu____12655  in
                  FStar_Parser_AST.Let
                    (FStar_Parser_AST.NoLetQualifier,
                      [(FStar_Pervasives_Native.None,
                         ((FStar_Parser_AST.mk_pattern
                             (FStar_Parser_AST.PatVar
                                (x, FStar_Pervasives_Native.None))
                             x.FStar_Ident.idRange), e))],
                      (FStar_Parser_AST.mk_term record1
                         top.FStar_Parser_AST.range
                         top.FStar_Parser_AST.level))
               in
            let recterm1 =
              FStar_Parser_AST.mk_term recterm top.FStar_Parser_AST.range
                top.FStar_Parser_AST.level
               in
            let uu____12768 = desugar_term_aq env recterm1  in
            (match uu____12768 with
             | (e,s) ->
                 (match e.FStar_Syntax_Syntax.n with
                  | FStar_Syntax_Syntax.Tm_app
                      ({
                         FStar_Syntax_Syntax.n = FStar_Syntax_Syntax.Tm_fvar
                           fv;
                         FStar_Syntax_Syntax.pos = uu____12784;
                         FStar_Syntax_Syntax.vars = uu____12785;_},args)
                      ->
                      let uu____12807 =
                        let uu____12808 =
                          let uu____12809 =
                            let uu____12824 =
                              let uu____12827 =
                                FStar_Ident.set_lid_range
                                  (fv.FStar_Syntax_Syntax.fv_name).FStar_Syntax_Syntax.v
                                  e.FStar_Syntax_Syntax.pos
                                 in
                              let uu____12828 =
                                let uu____12831 =
                                  let uu____12832 =
                                    let uu____12839 =
                                      FStar_All.pipe_right
                                        record.FStar_Syntax_DsEnv.fields
                                        (FStar_List.map
                                           FStar_Pervasives_Native.fst)
                                       in
                                    ((record.FStar_Syntax_DsEnv.typename),
                                      uu____12839)
                                     in
                                  FStar_Syntax_Syntax.Record_ctor uu____12832
                                   in
                                FStar_Pervasives_Native.Some uu____12831  in
                              FStar_Syntax_Syntax.fvar uu____12827
                                FStar_Syntax_Syntax.delta_constant
                                uu____12828
                               in
                            (uu____12824, args)  in
                          FStar_Syntax_Syntax.Tm_app uu____12809  in
                        FStar_All.pipe_left mk1 uu____12808  in
                      (uu____12807, s)
                  | uu____12866 -> (e, s)))
        | FStar_Parser_AST.Project (e,f) ->
            (FStar_Syntax_DsEnv.fail_if_qualified_by_curmodule env f;
             (let uu____12870 =
                FStar_Syntax_DsEnv.fail_or env
                  (FStar_Syntax_DsEnv.try_lookup_dc_by_field_name env) f
                 in
              match uu____12870 with
              | (constrname,is_rec) ->
                  let uu____12885 = desugar_term_aq env e  in
                  (match uu____12885 with
                   | (e1,s) ->
                       let projname =
                         FStar_Syntax_Util.mk_field_projector_name_from_ident
                           constrname f.FStar_Ident.ident
                          in
                       let qual =
                         if is_rec
                         then
                           FStar_Pervasives_Native.Some
                             (FStar_Syntax_Syntax.Record_projector
                                (constrname, (f.FStar_Ident.ident)))
                         else FStar_Pervasives_Native.None  in
                       let uu____12903 =
                         let uu____12904 =
                           let uu____12905 =
                             let uu____12920 =
                               let uu____12923 =
                                 let uu____12924 = FStar_Ident.range_of_lid f
                                    in
                                 FStar_Ident.set_lid_range projname
                                   uu____12924
                                  in
                               FStar_Syntax_Syntax.fvar uu____12923
                                 (FStar_Syntax_Syntax.Delta_equational_at_level
                                    (Prims.parse_int "1")) qual
                                in
                             let uu____12925 =
                               let uu____12934 =
                                 FStar_Syntax_Syntax.as_arg e1  in
                               [uu____12934]  in
                             (uu____12920, uu____12925)  in
                           FStar_Syntax_Syntax.Tm_app uu____12905  in
                         FStar_All.pipe_left mk1 uu____12904  in
                       (uu____12903, s))))
        | FStar_Parser_AST.NamedTyp (uu____12963,e) -> desugar_term_aq env e
        | FStar_Parser_AST.Paren e -> failwith "impossible"
        | FStar_Parser_AST.VQuote e ->
            let tm = desugar_term env e  in
            let uu____12972 =
              let uu____12973 = FStar_Syntax_Subst.compress tm  in
              uu____12973.FStar_Syntax_Syntax.n  in
            (match uu____12972 with
             | FStar_Syntax_Syntax.Tm_fvar fv ->
                 let uu____12981 =
                   let uu___282_12982 =
                     let uu____12983 =
                       let uu____12984 = FStar_Syntax_Syntax.lid_of_fv fv  in
                       FStar_Ident.string_of_lid uu____12984  in
                     FStar_Syntax_Util.exp_string uu____12983  in
                   {
                     FStar_Syntax_Syntax.n =
                       (uu___282_12982.FStar_Syntax_Syntax.n);
                     FStar_Syntax_Syntax.pos = (e.FStar_Parser_AST.range);
                     FStar_Syntax_Syntax.vars =
                       (uu___282_12982.FStar_Syntax_Syntax.vars)
                   }  in
                 (uu____12981, noaqs)
             | uu____12985 ->
                 let uu____12986 =
                   let uu____12991 =
                     let uu____12992 = FStar_Syntax_Print.term_to_string tm
                        in
                     Prims.strcat "VQuote, expected an fvar, got: "
                       uu____12992
                      in
                   (FStar_Errors.Fatal_UnexpectedTermVQuote, uu____12991)  in
                 FStar_Errors.raise_error uu____12986
                   top.FStar_Parser_AST.range)
        | FStar_Parser_AST.Quote (e,FStar_Parser_AST.Static ) ->
            let uu____12998 = desugar_term_aq env e  in
            (match uu____12998 with
             | (tm,vts) ->
                 let qi =
                   {
                     FStar_Syntax_Syntax.qkind =
                       FStar_Syntax_Syntax.Quote_static;
                     FStar_Syntax_Syntax.antiquotes = vts
                   }  in
                 let uu____13010 =
                   FStar_All.pipe_left mk1
                     (FStar_Syntax_Syntax.Tm_quoted (tm, qi))
                    in
                 (uu____13010, noaqs))
        | FStar_Parser_AST.Antiquote (b,e) ->
            let bv =
              FStar_Syntax_Syntax.new_bv
                (FStar_Pervasives_Native.Some (e.FStar_Parser_AST.range))
                FStar_Syntax_Syntax.tun
               in
            let uu____13016 = FStar_Syntax_Syntax.bv_to_name bv  in
            let uu____13017 =
              let uu____13018 =
                let uu____13027 = desugar_term env e  in (bv, b, uu____13027)
                 in
              [uu____13018]  in
            (uu____13016, uu____13017)
        | FStar_Parser_AST.Quote (e,FStar_Parser_AST.Dynamic ) ->
            let qi =
              {
                FStar_Syntax_Syntax.qkind = FStar_Syntax_Syntax.Quote_dynamic;
                FStar_Syntax_Syntax.antiquotes = []
              }  in
            let uu____13058 =
              let uu____13059 =
                let uu____13060 =
                  let uu____13067 = desugar_term env e  in (uu____13067, qi)
                   in
                FStar_Syntax_Syntax.Tm_quoted uu____13060  in
              FStar_All.pipe_left mk1 uu____13059  in
            (uu____13058, noaqs)
        | uu____13072 when
            top.FStar_Parser_AST.level = FStar_Parser_AST.Formula ->
            let uu____13073 = desugar_formula env top  in
            (uu____13073, noaqs)
        | uu____13074 ->
            let uu____13075 =
              let uu____13080 =
                let uu____13081 = FStar_Parser_AST.term_to_string top  in
                Prims.strcat "Unexpected term: " uu____13081  in
              (FStar_Errors.Fatal_UnexpectedTerm, uu____13080)  in
            FStar_Errors.raise_error uu____13075 top.FStar_Parser_AST.range

and (not_ascribed : FStar_Parser_AST.term -> Prims.bool) =
  fun t  ->
    match t.FStar_Parser_AST.tm with
    | FStar_Parser_AST.Ascribed uu____13087 -> false
    | uu____13096 -> true

and (desugar_args :
  FStar_Syntax_DsEnv.env ->
    (FStar_Parser_AST.term,FStar_Parser_AST.imp)
      FStar_Pervasives_Native.tuple2 Prims.list ->
      (FStar_Syntax_Syntax.term,FStar_Syntax_Syntax.arg_qualifier
                                  FStar_Pervasives_Native.option)
        FStar_Pervasives_Native.tuple2 Prims.list)
  =
  fun env  ->
    fun args  ->
      FStar_All.pipe_right args
        (FStar_List.map
           (fun uu____13133  ->
              match uu____13133 with
              | (a,imp) ->
                  let uu____13146 = desugar_term env a  in
                  arg_withimp_e imp uu____13146))

and (desugar_comp :
  FStar_Range.range ->
    FStar_Syntax_DsEnv.env ->
      FStar_Parser_AST.term ->
        FStar_Syntax_Syntax.comp' FStar_Syntax_Syntax.syntax)
  =
  fun r  ->
    fun env  ->
      fun t  ->
        let fail1 err = FStar_Errors.raise_error err r  in
        let is_requires uu____13178 =
          match uu____13178 with
          | (t1,uu____13184) ->
              let uu____13185 =
                let uu____13186 = unparen t1  in
                uu____13186.FStar_Parser_AST.tm  in
              (match uu____13185 with
               | FStar_Parser_AST.Requires uu____13187 -> true
               | uu____13194 -> false)
           in
        let is_ensures uu____13204 =
          match uu____13204 with
          | (t1,uu____13210) ->
              let uu____13211 =
                let uu____13212 = unparen t1  in
                uu____13212.FStar_Parser_AST.tm  in
              (match uu____13211 with
               | FStar_Parser_AST.Ensures uu____13213 -> true
               | uu____13220 -> false)
           in
        let is_app head1 uu____13235 =
          match uu____13235 with
          | (t1,uu____13241) ->
              let uu____13242 =
                let uu____13243 = unparen t1  in
                uu____13243.FStar_Parser_AST.tm  in
              (match uu____13242 with
               | FStar_Parser_AST.App
                   ({ FStar_Parser_AST.tm = FStar_Parser_AST.Var d;
                      FStar_Parser_AST.range = uu____13245;
                      FStar_Parser_AST.level = uu____13246;_},uu____13247,uu____13248)
                   -> (d.FStar_Ident.ident).FStar_Ident.idText = head1
               | uu____13249 -> false)
           in
        let is_smt_pat uu____13259 =
          match uu____13259 with
          | (t1,uu____13265) ->
              let uu____13266 =
                let uu____13267 = unparen t1  in
                uu____13267.FStar_Parser_AST.tm  in
              (match uu____13266 with
               | FStar_Parser_AST.Construct
                   (cons1,({
                             FStar_Parser_AST.tm = FStar_Parser_AST.Construct
                               (smtpat,uu____13270);
                             FStar_Parser_AST.range = uu____13271;
                             FStar_Parser_AST.level = uu____13272;_},uu____13273)::uu____13274::[])
                   ->
                   (FStar_Ident.lid_equals cons1 FStar_Parser_Const.cons_lid)
                     &&
                     (FStar_Util.for_some
                        (fun s  -> smtpat.FStar_Ident.str = s)
                        ["SMTPat"; "SMTPatT"; "SMTPatOr"])
               | FStar_Parser_AST.Construct
                   (cons1,({
                             FStar_Parser_AST.tm = FStar_Parser_AST.Var
                               smtpat;
                             FStar_Parser_AST.range = uu____13313;
                             FStar_Parser_AST.level = uu____13314;_},uu____13315)::uu____13316::[])
                   ->
                   (FStar_Ident.lid_equals cons1 FStar_Parser_Const.cons_lid)
                     &&
                     (FStar_Util.for_some
                        (fun s  -> smtpat.FStar_Ident.str = s)
                        ["smt_pat"; "smt_pat_or"])
               | uu____13341 -> false)
           in
        let is_decreases = is_app "decreases"  in
        let pre_process_comp_typ t1 =
          let uu____13373 = head_and_args t1  in
          match uu____13373 with
          | (head1,args) ->
              (match head1.FStar_Parser_AST.tm with
               | FStar_Parser_AST.Name lemma when
                   (lemma.FStar_Ident.ident).FStar_Ident.idText = "Lemma" ->
                   let unit_tm =
                     ((FStar_Parser_AST.mk_term
                         (FStar_Parser_AST.Name FStar_Parser_Const.unit_lid)
                         t1.FStar_Parser_AST.range
                         FStar_Parser_AST.Type_level),
                       FStar_Parser_AST.Nothing)
                      in
                   let nil_pat =
                     ((FStar_Parser_AST.mk_term
                         (FStar_Parser_AST.Name FStar_Parser_Const.nil_lid)
                         t1.FStar_Parser_AST.range FStar_Parser_AST.Expr),
                       FStar_Parser_AST.Nothing)
                      in
                   let req_true =
                     let req =
                       FStar_Parser_AST.Requires
                         ((FStar_Parser_AST.mk_term
                             (FStar_Parser_AST.Name
                                FStar_Parser_Const.true_lid)
                             t1.FStar_Parser_AST.range
                             FStar_Parser_AST.Formula),
                           FStar_Pervasives_Native.None)
                        in
                     ((FStar_Parser_AST.mk_term req t1.FStar_Parser_AST.range
                         FStar_Parser_AST.Type_level),
                       FStar_Parser_AST.Nothing)
                      in
                   let thunk_ens_ ens =
                     let wildpat =
                       FStar_Parser_AST.mk_pattern FStar_Parser_AST.PatWild
                         ens.FStar_Parser_AST.range
                        in
                     FStar_Parser_AST.mk_term
                       (FStar_Parser_AST.Abs ([wildpat], ens))
                       ens.FStar_Parser_AST.range FStar_Parser_AST.Expr
                      in
                   let thunk_ens uu____13471 =
                     match uu____13471 with
                     | (e,i) ->
                         let uu____13482 = thunk_ens_ e  in (uu____13482, i)
                      in
                   let fail_lemma uu____13494 =
                     let expected_one_of =
                       ["Lemma post";
                       "Lemma (ensures post)";
                       "Lemma (requires pre) (ensures post)";
                       "Lemma post [SMTPat ...]";
                       "Lemma (ensures post) [SMTPat ...]";
                       "Lemma (ensures post) (decreases d)";
                       "Lemma (ensures post) (decreases d) [SMTPat ...]";
                       "Lemma (requires pre) (ensures post) (decreases d)";
                       "Lemma (requires pre) (ensures post) [SMTPat ...]";
                       "Lemma (requires pre) (ensures post) (decreases d) [SMTPat ...]"]
                        in
                     let msg = FStar_String.concat "\n\t" expected_one_of  in
                     FStar_Errors.raise_error
                       (FStar_Errors.Fatal_InvalidLemmaArgument,
                         (Prims.strcat
                            "Invalid arguments to 'Lemma'; expected one of the following:\n\t"
                            msg)) t1.FStar_Parser_AST.range
                      in
                   let args1 =
                     match args with
                     | [] -> fail_lemma ()
                     | req::[] when is_requires req -> fail_lemma ()
                     | smtpat::[] when is_smt_pat smtpat -> fail_lemma ()
                     | dec::[] when is_decreases dec -> fail_lemma ()
                     | ens::[] ->
                         let uu____13574 =
                           let uu____13581 =
                             let uu____13588 = thunk_ens ens  in
                             [uu____13588; nil_pat]  in
                           req_true :: uu____13581  in
                         unit_tm :: uu____13574
                     | req::ens::[] when
                         (is_requires req) && (is_ensures ens) ->
                         let uu____13635 =
                           let uu____13642 =
                             let uu____13649 = thunk_ens ens  in
                             [uu____13649; nil_pat]  in
                           req :: uu____13642  in
                         unit_tm :: uu____13635
                     | ens::smtpat::[] when
                         (((let uu____13698 = is_requires ens  in
                            Prims.op_Negation uu____13698) &&
                             (let uu____13700 = is_smt_pat ens  in
                              Prims.op_Negation uu____13700))
                            &&
                            (let uu____13702 = is_decreases ens  in
                             Prims.op_Negation uu____13702))
                           && (is_smt_pat smtpat)
                         ->
                         let uu____13703 =
                           let uu____13710 =
                             let uu____13717 = thunk_ens ens  in
                             [uu____13717; smtpat]  in
                           req_true :: uu____13710  in
                         unit_tm :: uu____13703
                     | ens::dec::[] when
                         (is_ensures ens) && (is_decreases dec) ->
                         let uu____13764 =
                           let uu____13771 =
                             let uu____13778 = thunk_ens ens  in
                             [uu____13778; nil_pat; dec]  in
                           req_true :: uu____13771  in
                         unit_tm :: uu____13764
                     | ens::dec::smtpat::[] when
                         ((is_ensures ens) && (is_decreases dec)) &&
                           (is_smt_pat smtpat)
                         ->
                         let uu____13838 =
                           let uu____13845 =
                             let uu____13852 = thunk_ens ens  in
                             [uu____13852; smtpat; dec]  in
                           req_true :: uu____13845  in
                         unit_tm :: uu____13838
                     | req::ens::dec::[] when
                         ((is_requires req) && (is_ensures ens)) &&
                           (is_decreases dec)
                         ->
                         let uu____13912 =
                           let uu____13919 =
                             let uu____13926 = thunk_ens ens  in
                             [uu____13926; nil_pat; dec]  in
                           req :: uu____13919  in
                         unit_tm :: uu____13912
                     | req::ens::smtpat::[] when
                         ((is_requires req) && (is_ensures ens)) &&
                           (is_smt_pat smtpat)
                         ->
                         let uu____13986 =
                           let uu____13993 =
                             let uu____14000 = thunk_ens ens  in
                             [uu____14000; smtpat]  in
                           req :: uu____13993  in
                         unit_tm :: uu____13986
                     | req::ens::dec::smtpat::[] when
                         (((is_requires req) && (is_ensures ens)) &&
                            (is_smt_pat smtpat))
                           && (is_decreases dec)
                         ->
                         let uu____14065 =
                           let uu____14072 =
                             let uu____14079 = thunk_ens ens  in
                             [uu____14079; dec; smtpat]  in
                           req :: uu____14072  in
                         unit_tm :: uu____14065
                     | _other -> fail_lemma ()  in
                   let head_and_attributes =
                     FStar_Syntax_DsEnv.fail_or env
                       (FStar_Syntax_DsEnv.try_lookup_effect_name_and_attributes
                          env) lemma
                      in
                   (head_and_attributes, args1)
               | FStar_Parser_AST.Name l when
                   FStar_Syntax_DsEnv.is_effect_name env l ->
                   let uu____14141 =
                     FStar_Syntax_DsEnv.fail_or env
                       (FStar_Syntax_DsEnv.try_lookup_effect_name_and_attributes
                          env) l
                      in
                   (uu____14141, args)
               | FStar_Parser_AST.Name l when
                   (let uu____14169 = FStar_Syntax_DsEnv.current_module env
                       in
                    FStar_Ident.lid_equals uu____14169
                      FStar_Parser_Const.prims_lid)
                     && ((l.FStar_Ident.ident).FStar_Ident.idText = "Tot")
                   ->
                   let uu____14170 =
                     let uu____14177 =
                       FStar_Ident.set_lid_range
                         FStar_Parser_Const.effect_Tot_lid
                         head1.FStar_Parser_AST.range
                        in
                     (uu____14177, [])  in
                   (uu____14170, args)
               | FStar_Parser_AST.Name l when
                   (let uu____14195 = FStar_Syntax_DsEnv.current_module env
                       in
                    FStar_Ident.lid_equals uu____14195
                      FStar_Parser_Const.prims_lid)
                     && ((l.FStar_Ident.ident).FStar_Ident.idText = "GTot")
                   ->
                   let uu____14196 =
                     let uu____14203 =
                       FStar_Ident.set_lid_range
                         FStar_Parser_Const.effect_GTot_lid
                         head1.FStar_Parser_AST.range
                        in
                     (uu____14203, [])  in
                   (uu____14196, args)
               | FStar_Parser_AST.Name l when
                   (((l.FStar_Ident.ident).FStar_Ident.idText = "Type") ||
                      ((l.FStar_Ident.ident).FStar_Ident.idText = "Type0"))
                     || ((l.FStar_Ident.ident).FStar_Ident.idText = "Effect")
                   ->
                   let uu____14219 =
                     let uu____14226 =
                       FStar_Ident.set_lid_range
                         FStar_Parser_Const.effect_Tot_lid
                         head1.FStar_Parser_AST.range
                        in
                     (uu____14226, [])  in
                   (uu____14219, [(t1, FStar_Parser_AST.Nothing)])
               | uu____14249 ->
                   let default_effect =
                     let uu____14251 = FStar_Options.ml_ish ()  in
                     if uu____14251
                     then FStar_Parser_Const.effect_ML_lid
                     else
                       ((let uu____14254 =
                           FStar_Options.warn_default_effects ()  in
                         if uu____14254
                         then
                           FStar_Errors.log_issue
                             head1.FStar_Parser_AST.range
                             (FStar_Errors.Warning_UseDefaultEffect,
                               "Using default effect Tot")
                         else ());
                        FStar_Parser_Const.effect_Tot_lid)
                      in
                   let uu____14256 =
                     let uu____14263 =
                       FStar_Ident.set_lid_range default_effect
                         head1.FStar_Parser_AST.range
                        in
                     (uu____14263, [])  in
                   (uu____14256, [(t1, FStar_Parser_AST.Nothing)]))
           in
        let uu____14286 = pre_process_comp_typ t  in
        match uu____14286 with
        | ((eff,cattributes),args) ->
            (if (FStar_List.length args) = (Prims.parse_int "0")
             then
               (let uu____14335 =
                  let uu____14340 =
                    let uu____14341 = FStar_Syntax_Print.lid_to_string eff
                       in
                    FStar_Util.format1 "Not enough args to effect %s"
                      uu____14341
                     in
                  (FStar_Errors.Fatal_NotEnoughArgsToEffect, uu____14340)  in
                fail1 uu____14335)
             else ();
             (let is_universe uu____14352 =
                match uu____14352 with
                | (uu____14357,imp) -> imp = FStar_Parser_AST.UnivApp  in
              let uu____14359 = FStar_Util.take is_universe args  in
              match uu____14359 with
              | (universes,args1) ->
                  let universes1 =
                    FStar_List.map
                      (fun uu____14418  ->
                         match uu____14418 with
                         | (u,imp) -> desugar_universe u) universes
                     in
                  let uu____14425 =
                    let uu____14440 = FStar_List.hd args1  in
                    let uu____14449 = FStar_List.tl args1  in
                    (uu____14440, uu____14449)  in
                  (match uu____14425 with
                   | (result_arg,rest) ->
                       let result_typ =
                         desugar_typ env
                           (FStar_Pervasives_Native.fst result_arg)
                          in
                       let rest1 = desugar_args env rest  in
                       let uu____14504 =
                         let is_decrease uu____14542 =
                           match uu____14542 with
                           | (t1,uu____14552) ->
                               (match t1.FStar_Syntax_Syntax.n with
                                | FStar_Syntax_Syntax.Tm_app
                                    ({
                                       FStar_Syntax_Syntax.n =
                                         FStar_Syntax_Syntax.Tm_fvar fv;
                                       FStar_Syntax_Syntax.pos = uu____14562;
                                       FStar_Syntax_Syntax.vars = uu____14563;_},uu____14564::[])
                                    ->
                                    FStar_Syntax_Syntax.fv_eq_lid fv
                                      FStar_Parser_Const.decreases_lid
                                | uu____14595 -> false)
                            in
                         FStar_All.pipe_right rest1
                           (FStar_List.partition is_decrease)
                          in
                       (match uu____14504 with
                        | (dec,rest2) ->
                            let decreases_clause =
                              FStar_All.pipe_right dec
                                (FStar_List.map
                                   (fun uu____14711  ->
                                      match uu____14711 with
                                      | (t1,uu____14721) ->
                                          (match t1.FStar_Syntax_Syntax.n
                                           with
                                           | FStar_Syntax_Syntax.Tm_app
                                               (uu____14730,(arg,uu____14732)::[])
                                               ->
                                               FStar_Syntax_Syntax.DECREASES
                                                 arg
                                           | uu____14761 -> failwith "impos")))
                               in
                            let no_additional_args =
                              let is_empty l =
                                match l with
                                | [] -> true
                                | uu____14778 -> false  in
                              (((is_empty decreases_clause) &&
                                  (is_empty rest2))
                                 && (is_empty cattributes))
                                && (is_empty universes1)
                               in
                            let uu____14789 =
                              no_additional_args &&
                                (FStar_Ident.lid_equals eff
                                   FStar_Parser_Const.effect_Tot_lid)
                               in
                            if uu____14789
                            then FStar_Syntax_Syntax.mk_Total result_typ
                            else
                              (let uu____14793 =
                                 no_additional_args &&
                                   (FStar_Ident.lid_equals eff
                                      FStar_Parser_Const.effect_GTot_lid)
                                  in
                               if uu____14793
                               then FStar_Syntax_Syntax.mk_GTotal result_typ
                               else
                                 (let flags1 =
                                    let uu____14800 =
                                      FStar_Ident.lid_equals eff
                                        FStar_Parser_Const.effect_Lemma_lid
                                       in
                                    if uu____14800
                                    then [FStar_Syntax_Syntax.LEMMA]
                                    else
                                      (let uu____14804 =
                                         FStar_Ident.lid_equals eff
                                           FStar_Parser_Const.effect_Tot_lid
                                          in
                                       if uu____14804
                                       then [FStar_Syntax_Syntax.TOTAL]
                                       else
                                         (let uu____14808 =
                                            FStar_Ident.lid_equals eff
                                              FStar_Parser_Const.effect_ML_lid
                                             in
                                          if uu____14808
                                          then [FStar_Syntax_Syntax.MLEFFECT]
                                          else
                                            (let uu____14812 =
                                               FStar_Ident.lid_equals eff
                                                 FStar_Parser_Const.effect_GTot_lid
                                                in
                                             if uu____14812
                                             then
                                               [FStar_Syntax_Syntax.SOMETRIVIAL]
                                             else [])))
                                     in
                                  let flags2 =
                                    FStar_List.append flags1 cattributes  in
                                  let rest3 =
                                    let uu____14828 =
                                      FStar_Ident.lid_equals eff
                                        FStar_Parser_Const.effect_Lemma_lid
                                       in
                                    if uu____14828
                                    then
                                      match rest2 with
                                      | req::ens::(pat,aq)::[] ->
                                          let pat1 =
                                            match pat.FStar_Syntax_Syntax.n
                                            with
                                            | FStar_Syntax_Syntax.Tm_fvar fv
                                                when
                                                FStar_Syntax_Syntax.fv_eq_lid
                                                  fv
                                                  FStar_Parser_Const.nil_lid
                                                ->
                                                let nil =
                                                  FStar_Syntax_Syntax.mk_Tm_uinst
                                                    pat
                                                    [FStar_Syntax_Syntax.U_zero]
                                                   in
                                                let pattern =
                                                  let uu____14913 =
                                                    FStar_Ident.set_lid_range
                                                      FStar_Parser_Const.pattern_lid
                                                      pat.FStar_Syntax_Syntax.pos
                                                     in
                                                  FStar_Syntax_Syntax.fvar
                                                    uu____14913
                                                    FStar_Syntax_Syntax.delta_constant
                                                    FStar_Pervasives_Native.None
                                                   in
                                                FStar_Syntax_Syntax.mk_Tm_app
                                                  nil
                                                  [(pattern,
                                                     (FStar_Pervasives_Native.Some
                                                        FStar_Syntax_Syntax.imp_tag))]
                                                  FStar_Pervasives_Native.None
                                                  pat.FStar_Syntax_Syntax.pos
                                            | uu____14928 -> pat  in
                                          let uu____14929 =
                                            let uu____14938 =
                                              let uu____14947 =
                                                let uu____14954 =
                                                  FStar_Syntax_Syntax.mk
                                                    (FStar_Syntax_Syntax.Tm_meta
                                                       (pat1,
                                                         (FStar_Syntax_Syntax.Meta_desugared
                                                            FStar_Syntax_Syntax.Meta_smt_pat)))
                                                    FStar_Pervasives_Native.None
                                                    pat1.FStar_Syntax_Syntax.pos
                                                   in
                                                (uu____14954, aq)  in
                                              [uu____14947]  in
                                            ens :: uu____14938  in
                                          req :: uu____14929
                                      | uu____14985 -> rest2
                                    else rest2  in
                                  FStar_Syntax_Syntax.mk_Comp
                                    {
                                      FStar_Syntax_Syntax.comp_univs =
                                        universes1;
                                      FStar_Syntax_Syntax.effect_name = eff;
                                      FStar_Syntax_Syntax.result_typ =
                                        result_typ;
                                      FStar_Syntax_Syntax.effect_args = rest3;
                                      FStar_Syntax_Syntax.flags =
                                        (FStar_List.append flags2
                                           decreases_clause)
                                    }))))))

and (desugar_formula :
  FStar_Syntax_DsEnv.env -> FStar_Parser_AST.term -> FStar_Syntax_Syntax.term)
  =
  fun env  ->
    fun f  ->
      let connective s =
        match s with
        | "/\\" -> FStar_Pervasives_Native.Some FStar_Parser_Const.and_lid
        | "\\/" -> FStar_Pervasives_Native.Some FStar_Parser_Const.or_lid
        | "==>" -> FStar_Pervasives_Native.Some FStar_Parser_Const.imp_lid
        | "<==>" -> FStar_Pervasives_Native.Some FStar_Parser_Const.iff_lid
        | "~" -> FStar_Pervasives_Native.Some FStar_Parser_Const.not_lid
        | uu____15009 -> FStar_Pervasives_Native.None  in
      let mk1 t =
        FStar_Syntax_Syntax.mk t FStar_Pervasives_Native.None
          f.FStar_Parser_AST.range
         in
      let setpos t =
        let uu___283_15030 = t  in
        {
          FStar_Syntax_Syntax.n = (uu___283_15030.FStar_Syntax_Syntax.n);
          FStar_Syntax_Syntax.pos = (f.FStar_Parser_AST.range);
          FStar_Syntax_Syntax.vars =
            (uu___283_15030.FStar_Syntax_Syntax.vars)
        }  in
      let desugar_quant q b pats body =
        let tk =
          desugar_binder env
            (let uu___284_15072 = b  in
             {
               FStar_Parser_AST.b = (uu___284_15072.FStar_Parser_AST.b);
               FStar_Parser_AST.brange =
                 (uu___284_15072.FStar_Parser_AST.brange);
               FStar_Parser_AST.blevel = FStar_Parser_AST.Formula;
               FStar_Parser_AST.aqual =
                 (uu___284_15072.FStar_Parser_AST.aqual)
             })
           in
        let desugar_pats env1 pats1 =
          FStar_List.map
            (fun es  ->
               FStar_All.pipe_right es
                 (FStar_List.map
                    (fun e  ->
                       let uu____15135 = desugar_term env1 e  in
                       FStar_All.pipe_left
                         (arg_withimp_t FStar_Parser_AST.Nothing) uu____15135)))
            pats1
           in
        match tk with
        | (FStar_Pervasives_Native.Some a,k) ->
            let uu____15148 = FStar_Syntax_DsEnv.push_bv env a  in
            (match uu____15148 with
             | (env1,a1) ->
                 let a2 =
                   let uu___285_15158 = a1  in
                   {
                     FStar_Syntax_Syntax.ppname =
                       (uu___285_15158.FStar_Syntax_Syntax.ppname);
                     FStar_Syntax_Syntax.index =
                       (uu___285_15158.FStar_Syntax_Syntax.index);
                     FStar_Syntax_Syntax.sort = k
                   }  in
                 let pats1 = desugar_pats env1 pats  in
                 let body1 = desugar_formula env1 body  in
                 let body2 =
                   match pats1 with
                   | [] -> body1
                   | uu____15184 ->
                       mk1
                         (FStar_Syntax_Syntax.Tm_meta
                            (body1, (FStar_Syntax_Syntax.Meta_pattern pats1)))
                    in
                 let body3 =
                   let uu____15198 =
                     let uu____15201 =
                       let uu____15202 = FStar_Syntax_Syntax.mk_binder a2  in
                       [uu____15202]  in
                     no_annot_abs uu____15201 body2  in
                   FStar_All.pipe_left setpos uu____15198  in
                 let uu____15217 =
                   let uu____15218 =
                     let uu____15233 =
                       let uu____15236 =
                         FStar_Ident.set_lid_range q
                           b.FStar_Parser_AST.brange
                          in
                       FStar_Syntax_Syntax.fvar uu____15236
                         (FStar_Syntax_Syntax.Delta_constant_at_level
                            (Prims.parse_int "1"))
                         FStar_Pervasives_Native.None
                        in
                     let uu____15237 =
                       let uu____15246 = FStar_Syntax_Syntax.as_arg body3  in
                       [uu____15246]  in
                     (uu____15233, uu____15237)  in
                   FStar_Syntax_Syntax.Tm_app uu____15218  in
                 FStar_All.pipe_left mk1 uu____15217)
        | uu____15277 -> failwith "impossible"  in
      let push_quant q binders pats body =
        match binders with
        | b::b'::_rest ->
            let rest = b' :: _rest  in
            let body1 =
              let uu____15357 = q (rest, pats, body)  in
              let uu____15364 =
                FStar_Range.union_ranges b'.FStar_Parser_AST.brange
                  body.FStar_Parser_AST.range
                 in
              FStar_Parser_AST.mk_term uu____15357 uu____15364
                FStar_Parser_AST.Formula
               in
            let uu____15365 = q ([b], [], body1)  in
            FStar_Parser_AST.mk_term uu____15365 f.FStar_Parser_AST.range
              FStar_Parser_AST.Formula
        | uu____15374 -> failwith "impossible"  in
      let uu____15377 =
        let uu____15378 = unparen f  in uu____15378.FStar_Parser_AST.tm  in
      match uu____15377 with
      | FStar_Parser_AST.Labeled (f1,l,p) ->
          let f2 = desugar_formula env f1  in
          FStar_All.pipe_left mk1
            (FStar_Syntax_Syntax.Tm_meta
               (f2,
                 (FStar_Syntax_Syntax.Meta_labeled
                    (l, (f2.FStar_Syntax_Syntax.pos), p))))
      | FStar_Parser_AST.QForall ([],uu____15385,uu____15386) ->
          failwith "Impossible: Quantifier without binders"
      | FStar_Parser_AST.QExists ([],uu____15397,uu____15398) ->
          failwith "Impossible: Quantifier without binders"
      | FStar_Parser_AST.QForall (_1::_2::_3,pats,body) ->
          let binders = _1 :: _2 :: _3  in
          let uu____15429 =
            push_quant (fun x  -> FStar_Parser_AST.QForall x) binders pats
              body
             in
          desugar_formula env uu____15429
      | FStar_Parser_AST.QExists (_1::_2::_3,pats,body) ->
          let binders = _1 :: _2 :: _3  in
          let uu____15465 =
            push_quant (fun x  -> FStar_Parser_AST.QExists x) binders pats
              body
             in
          desugar_formula env uu____15465
      | FStar_Parser_AST.QForall (b::[],pats,body) ->
          desugar_quant FStar_Parser_Const.forall_lid b pats body
      | FStar_Parser_AST.QExists (b::[],pats,body) ->
          desugar_quant FStar_Parser_Const.exists_lid b pats body
      | FStar_Parser_AST.Paren f1 -> failwith "impossible"
      | uu____15508 -> desugar_term env f

and (typars_of_binders :
  FStar_Syntax_DsEnv.env ->
    FStar_Parser_AST.binder Prims.list ->
      (FStar_Syntax_DsEnv.env,(FStar_Syntax_Syntax.bv,FStar_Syntax_Syntax.arg_qualifier
                                                        FStar_Pervasives_Native.option)
                                FStar_Pervasives_Native.tuple2 Prims.list)
        FStar_Pervasives_Native.tuple2)
  =
  fun env  ->
    fun bs  ->
      let uu____15513 =
        FStar_List.fold_left
          (fun uu____15549  ->
             fun b  ->
               match uu____15549 with
               | (env1,out) ->
                   let tk =
                     desugar_binder env1
                       (let uu___286_15601 = b  in
                        {
                          FStar_Parser_AST.b =
                            (uu___286_15601.FStar_Parser_AST.b);
                          FStar_Parser_AST.brange =
                            (uu___286_15601.FStar_Parser_AST.brange);
                          FStar_Parser_AST.blevel = FStar_Parser_AST.Formula;
                          FStar_Parser_AST.aqual =
                            (uu___286_15601.FStar_Parser_AST.aqual)
                        })
                      in
                   (match tk with
                    | (FStar_Pervasives_Native.Some a,k) ->
                        let uu____15618 = FStar_Syntax_DsEnv.push_bv env1 a
                           in
                        (match uu____15618 with
                         | (env2,a1) ->
                             let a2 =
                               let uu___287_15638 = a1  in
                               {
                                 FStar_Syntax_Syntax.ppname =
                                   (uu___287_15638.FStar_Syntax_Syntax.ppname);
                                 FStar_Syntax_Syntax.index =
                                   (uu___287_15638.FStar_Syntax_Syntax.index);
                                 FStar_Syntax_Syntax.sort = k
                               }  in
                             (env2,
                               ((a2, (trans_aqual b.FStar_Parser_AST.aqual))
                               :: out)))
                    | uu____15655 ->
                        FStar_Errors.raise_error
                          (FStar_Errors.Fatal_UnexpectedBinder,
                            "Unexpected binder") b.FStar_Parser_AST.brange))
          (env, []) bs
         in
      match uu____15513 with | (env1,tpars) -> (env1, (FStar_List.rev tpars))

and (desugar_binder :
  FStar_Syntax_DsEnv.env ->
    FStar_Parser_AST.binder ->
      (FStar_Ident.ident FStar_Pervasives_Native.option,FStar_Syntax_Syntax.term)
        FStar_Pervasives_Native.tuple2)
  =
  fun env  ->
    fun b  ->
      match b.FStar_Parser_AST.b with
      | FStar_Parser_AST.TAnnotated (x,t) ->
          let uu____15742 = desugar_typ env t  in
          ((FStar_Pervasives_Native.Some x), uu____15742)
      | FStar_Parser_AST.Annotated (x,t) ->
          let uu____15747 = desugar_typ env t  in
          ((FStar_Pervasives_Native.Some x), uu____15747)
      | FStar_Parser_AST.TVariable x ->
          let uu____15751 =
            FStar_Syntax_Syntax.mk
              (FStar_Syntax_Syntax.Tm_type FStar_Syntax_Syntax.U_unknown)
              FStar_Pervasives_Native.None x.FStar_Ident.idRange
             in
          ((FStar_Pervasives_Native.Some x), uu____15751)
      | FStar_Parser_AST.NoName t ->
          let uu____15755 = desugar_typ env t  in
          (FStar_Pervasives_Native.None, uu____15755)
      | FStar_Parser_AST.Variable x ->
          ((FStar_Pervasives_Native.Some x), FStar_Syntax_Syntax.tun)

let (mk_data_discriminators :
  FStar_Syntax_Syntax.qualifier Prims.list ->
    FStar_Syntax_DsEnv.env ->
      FStar_Ident.lident Prims.list -> FStar_Syntax_Syntax.sigelt Prims.list)
  =
  fun quals  ->
    fun env  ->
      fun datas  ->
        let quals1 =
          FStar_All.pipe_right quals
            (FStar_List.filter
               (fun uu___241_15794  ->
                  match uu___241_15794 with
                  | FStar_Syntax_Syntax.Abstract  -> true
                  | FStar_Syntax_Syntax.Private  -> true
                  | uu____15795 -> false))
           in
        let quals2 q =
          let uu____15808 =
            (let uu____15811 = FStar_Syntax_DsEnv.iface env  in
             Prims.op_Negation uu____15811) ||
              (FStar_Syntax_DsEnv.admitted_iface env)
             in
          if uu____15808
          then FStar_List.append (FStar_Syntax_Syntax.Assumption :: q) quals1
          else FStar_List.append q quals1  in
        FStar_All.pipe_right datas
          (FStar_List.map
             (fun d  ->
                let disc_name = FStar_Syntax_Util.mk_discriminator d  in
                let uu____15825 = FStar_Ident.range_of_lid disc_name  in
                let uu____15826 =
                  quals2
                    [FStar_Syntax_Syntax.OnlyName;
                    FStar_Syntax_Syntax.Discriminator d]
                   in
                {
                  FStar_Syntax_Syntax.sigel =
                    (FStar_Syntax_Syntax.Sig_declare_typ
                       (disc_name, [], FStar_Syntax_Syntax.tun));
                  FStar_Syntax_Syntax.sigrng = uu____15825;
                  FStar_Syntax_Syntax.sigquals = uu____15826;
                  FStar_Syntax_Syntax.sigmeta =
                    FStar_Syntax_Syntax.default_sigmeta;
                  FStar_Syntax_Syntax.sigattrs = []
                }))
  
let (mk_indexed_projector_names :
  FStar_Syntax_Syntax.qualifier Prims.list ->
    FStar_Syntax_Syntax.fv_qual ->
      FStar_Syntax_DsEnv.env ->
        FStar_Ident.lident ->
          FStar_Syntax_Syntax.binder Prims.list ->
            FStar_Syntax_Syntax.sigelt Prims.list)
  =
  fun iquals  ->
    fun fvq  ->
      fun env  ->
        fun lid  ->
          fun fields  ->
            let p = FStar_Ident.range_of_lid lid  in
            let uu____15865 =
              FStar_All.pipe_right fields
                (FStar_List.mapi
                   (fun i  ->
                      fun uu____15899  ->
                        match uu____15899 with
                        | (x,uu____15907) ->
                            let uu____15908 =
                              FStar_Syntax_Util.mk_field_projector_name lid x
                                i
                               in
                            (match uu____15908 with
                             | (field_name,uu____15916) ->
                                 let only_decl =
                                   ((let uu____15920 =
                                       FStar_Syntax_DsEnv.current_module env
                                        in
                                     FStar_Ident.lid_equals
                                       FStar_Parser_Const.prims_lid
                                       uu____15920)
                                      ||
                                      (fvq <> FStar_Syntax_Syntax.Data_ctor))
                                     ||
                                     (let uu____15922 =
                                        let uu____15923 =
                                          FStar_Syntax_DsEnv.current_module
                                            env
                                           in
                                        uu____15923.FStar_Ident.str  in
                                      FStar_Options.dont_gen_projectors
                                        uu____15922)
                                    in
                                 let no_decl =
                                   FStar_Syntax_Syntax.is_type
                                     x.FStar_Syntax_Syntax.sort
                                    in
                                 let quals q =
                                   if only_decl
                                   then
                                     let uu____15939 =
                                       FStar_List.filter
                                         (fun uu___242_15943  ->
                                            match uu___242_15943 with
                                            | FStar_Syntax_Syntax.Abstract 
                                                -> false
                                            | uu____15944 -> true) q
                                        in
                                     FStar_Syntax_Syntax.Assumption ::
                                       uu____15939
                                   else q  in
                                 let quals1 =
                                   let iquals1 =
                                     FStar_All.pipe_right iquals
                                       (FStar_List.filter
                                          (fun uu___243_15957  ->
                                             match uu___243_15957 with
                                             | FStar_Syntax_Syntax.Abstract 
                                                 -> true
                                             | FStar_Syntax_Syntax.Private 
                                                 -> true
                                             | uu____15958 -> false))
                                      in
                                   quals (FStar_Syntax_Syntax.OnlyName ::
                                     (FStar_Syntax_Syntax.Projector
                                        (lid, (x.FStar_Syntax_Syntax.ppname)))
                                     :: iquals1)
                                    in
                                 let decl =
                                   let uu____15960 =
                                     FStar_Ident.range_of_lid field_name  in
                                   {
                                     FStar_Syntax_Syntax.sigel =
                                       (FStar_Syntax_Syntax.Sig_declare_typ
                                          (field_name, [],
                                            FStar_Syntax_Syntax.tun));
                                     FStar_Syntax_Syntax.sigrng = uu____15960;
                                     FStar_Syntax_Syntax.sigquals = quals1;
                                     FStar_Syntax_Syntax.sigmeta =
                                       FStar_Syntax_Syntax.default_sigmeta;
                                     FStar_Syntax_Syntax.sigattrs = []
                                   }  in
                                 if only_decl
                                 then [decl]
                                 else
                                   (let dd =
                                      let uu____15965 =
                                        FStar_All.pipe_right quals1
                                          (FStar_List.contains
                                             FStar_Syntax_Syntax.Abstract)
                                         in
                                      if uu____15965
                                      then
                                        FStar_Syntax_Syntax.Delta_abstract
                                          (FStar_Syntax_Syntax.Delta_equational_at_level
                                             (Prims.parse_int "1"))
                                      else
                                        FStar_Syntax_Syntax.Delta_equational_at_level
                                          (Prims.parse_int "1")
                                       in
                                    let lb =
                                      let uu____15970 =
                                        let uu____15975 =
                                          FStar_Syntax_Syntax.lid_as_fv
                                            field_name dd
                                            FStar_Pervasives_Native.None
                                           in
                                        FStar_Util.Inr uu____15975  in
                                      {
                                        FStar_Syntax_Syntax.lbname =
                                          uu____15970;
                                        FStar_Syntax_Syntax.lbunivs = [];
                                        FStar_Syntax_Syntax.lbtyp =
                                          FStar_Syntax_Syntax.tun;
                                        FStar_Syntax_Syntax.lbeff =
                                          FStar_Parser_Const.effect_Tot_lid;
                                        FStar_Syntax_Syntax.lbdef =
                                          FStar_Syntax_Syntax.tun;
                                        FStar_Syntax_Syntax.lbattrs = [];
                                        FStar_Syntax_Syntax.lbpos =
                                          FStar_Range.dummyRange
                                      }  in
                                    let impl =
                                      let uu____15979 =
                                        let uu____15980 =
                                          let uu____15987 =
                                            let uu____15990 =
                                              let uu____15991 =
                                                FStar_All.pipe_right
                                                  lb.FStar_Syntax_Syntax.lbname
                                                  FStar_Util.right
                                                 in
                                              FStar_All.pipe_right
                                                uu____15991
                                                (fun fv  ->
                                                   (fv.FStar_Syntax_Syntax.fv_name).FStar_Syntax_Syntax.v)
                                               in
                                            [uu____15990]  in
                                          ((false, [lb]), uu____15987)  in
                                        FStar_Syntax_Syntax.Sig_let
                                          uu____15980
                                         in
                                      {
                                        FStar_Syntax_Syntax.sigel =
                                          uu____15979;
                                        FStar_Syntax_Syntax.sigrng = p;
                                        FStar_Syntax_Syntax.sigquals = quals1;
                                        FStar_Syntax_Syntax.sigmeta =
                                          FStar_Syntax_Syntax.default_sigmeta;
                                        FStar_Syntax_Syntax.sigattrs = []
                                      }  in
                                    if no_decl then [impl] else [decl; impl]))))
               in
            FStar_All.pipe_right uu____15865 FStar_List.flatten
  
let (mk_data_projector_names :
  FStar_Syntax_Syntax.qualifier Prims.list ->
    FStar_Syntax_DsEnv.env ->
      FStar_Syntax_Syntax.sigelt -> FStar_Syntax_Syntax.sigelt Prims.list)
  =
  fun iquals  ->
    fun env  ->
      fun se  ->
        match se.FStar_Syntax_Syntax.sigel with
        | FStar_Syntax_Syntax.Sig_datacon
            (lid,uu____16035,t,uu____16037,n1,uu____16039) when
            let uu____16044 =
              FStar_Ident.lid_equals lid FStar_Parser_Const.lexcons_lid  in
            Prims.op_Negation uu____16044 ->
            let uu____16045 = FStar_Syntax_Util.arrow_formals t  in
            (match uu____16045 with
             | (formals,uu____16061) ->
                 (match formals with
                  | [] -> []
                  | uu____16084 ->
                      let filter_records uu___244_16098 =
                        match uu___244_16098 with
                        | FStar_Syntax_Syntax.RecordConstructor
                            (uu____16101,fns) ->
                            FStar_Pervasives_Native.Some
                              (FStar_Syntax_Syntax.Record_ctor (lid, fns))
                        | uu____16113 -> FStar_Pervasives_Native.None  in
                      let fv_qual =
                        let uu____16115 =
                          FStar_Util.find_map se.FStar_Syntax_Syntax.sigquals
                            filter_records
                           in
                        match uu____16115 with
                        | FStar_Pervasives_Native.None  ->
                            FStar_Syntax_Syntax.Data_ctor
                        | FStar_Pervasives_Native.Some q -> q  in
                      let iquals1 =
                        if
                          FStar_List.contains FStar_Syntax_Syntax.Abstract
                            iquals
                        then FStar_Syntax_Syntax.Private :: iquals
                        else iquals  in
                      let uu____16125 = FStar_Util.first_N n1 formals  in
                      (match uu____16125 with
                       | (uu____16148,rest) ->
                           mk_indexed_projector_names iquals1 fv_qual env lid
                             rest)))
        | uu____16174 -> []
  
let (mk_typ_abbrev :
  FStar_Ident.lident ->
    FStar_Syntax_Syntax.univ_name Prims.list ->
      (FStar_Syntax_Syntax.bv,FStar_Syntax_Syntax.aqual)
        FStar_Pervasives_Native.tuple2 Prims.list ->
        FStar_Syntax_Syntax.typ FStar_Pervasives_Native.option ->
          FStar_Syntax_Syntax.term' FStar_Syntax_Syntax.syntax ->
            FStar_Ident.lident Prims.list ->
              FStar_Syntax_Syntax.qualifier Prims.list ->
                FStar_Range.range -> FStar_Syntax_Syntax.sigelt)
  =
  fun lid  ->
    fun uvs  ->
      fun typars  ->
        fun kopt  ->
          fun t  ->
            fun lids  ->
              fun quals  ->
                fun rng  ->
                  let dd =
                    let uu____16248 =
                      FStar_All.pipe_right quals
                        (FStar_List.contains FStar_Syntax_Syntax.Abstract)
                       in
                    if uu____16248
                    then
                      let uu____16251 =
                        FStar_Syntax_Util.incr_delta_qualifier t  in
                      FStar_Syntax_Syntax.Delta_abstract uu____16251
                    else FStar_Syntax_Util.incr_delta_qualifier t  in
                  let lb =
                    let uu____16254 =
                      let uu____16259 =
                        FStar_Syntax_Syntax.lid_as_fv lid dd
                          FStar_Pervasives_Native.None
                         in
                      FStar_Util.Inr uu____16259  in
                    let uu____16260 =
                      if FStar_Util.is_some kopt
                      then
                        let uu____16265 =
                          let uu____16268 =
                            FStar_All.pipe_right kopt FStar_Util.must  in
                          FStar_Syntax_Syntax.mk_Total uu____16268  in
                        FStar_Syntax_Util.arrow typars uu____16265
                      else FStar_Syntax_Syntax.tun  in
                    let uu____16272 = no_annot_abs typars t  in
                    {
                      FStar_Syntax_Syntax.lbname = uu____16254;
                      FStar_Syntax_Syntax.lbunivs = uvs;
                      FStar_Syntax_Syntax.lbtyp = uu____16260;
                      FStar_Syntax_Syntax.lbeff =
                        FStar_Parser_Const.effect_Tot_lid;
                      FStar_Syntax_Syntax.lbdef = uu____16272;
                      FStar_Syntax_Syntax.lbattrs = [];
                      FStar_Syntax_Syntax.lbpos = rng
                    }  in
                  {
                    FStar_Syntax_Syntax.sigel =
                      (FStar_Syntax_Syntax.Sig_let ((false, [lb]), lids));
                    FStar_Syntax_Syntax.sigrng = rng;
                    FStar_Syntax_Syntax.sigquals = quals;
                    FStar_Syntax_Syntax.sigmeta =
                      FStar_Syntax_Syntax.default_sigmeta;
                    FStar_Syntax_Syntax.sigattrs = []
                  }
  
let rec (desugar_tycon :
  FStar_Syntax_DsEnv.env ->
    FStar_Parser_AST.decl ->
      FStar_Syntax_Syntax.qualifier Prims.list ->
        FStar_Parser_AST.tycon Prims.list ->
          (env_t,FStar_Syntax_Syntax.sigelts) FStar_Pervasives_Native.tuple2)
  =
  fun env  ->
    fun d  ->
      fun quals  ->
        fun tcs  ->
          let rng = d.FStar_Parser_AST.drange  in
          let tycon_id uu___245_16323 =
            match uu___245_16323 with
            | FStar_Parser_AST.TyconAbstract (id1,uu____16325,uu____16326) ->
                id1
            | FStar_Parser_AST.TyconAbbrev
                (id1,uu____16336,uu____16337,uu____16338) -> id1
            | FStar_Parser_AST.TyconRecord
                (id1,uu____16348,uu____16349,uu____16350) -> id1
            | FStar_Parser_AST.TyconVariant
                (id1,uu____16380,uu____16381,uu____16382) -> id1
             in
          let binder_to_term b =
            match b.FStar_Parser_AST.b with
            | FStar_Parser_AST.Annotated (x,uu____16426) ->
                let uu____16427 =
                  let uu____16428 = FStar_Ident.lid_of_ids [x]  in
                  FStar_Parser_AST.Var uu____16428  in
                FStar_Parser_AST.mk_term uu____16427 x.FStar_Ident.idRange
                  FStar_Parser_AST.Expr
            | FStar_Parser_AST.Variable x ->
                let uu____16430 =
                  let uu____16431 = FStar_Ident.lid_of_ids [x]  in
                  FStar_Parser_AST.Var uu____16431  in
                FStar_Parser_AST.mk_term uu____16430 x.FStar_Ident.idRange
                  FStar_Parser_AST.Expr
            | FStar_Parser_AST.TAnnotated (a,uu____16433) ->
                FStar_Parser_AST.mk_term (FStar_Parser_AST.Tvar a)
                  a.FStar_Ident.idRange FStar_Parser_AST.Type_level
            | FStar_Parser_AST.TVariable a ->
                FStar_Parser_AST.mk_term (FStar_Parser_AST.Tvar a)
                  a.FStar_Ident.idRange FStar_Parser_AST.Type_level
            | FStar_Parser_AST.NoName t -> t  in
          let tot =
            FStar_Parser_AST.mk_term
              (FStar_Parser_AST.Name FStar_Parser_Const.effect_Tot_lid) rng
              FStar_Parser_AST.Expr
             in
          let with_constructor_effect t =
            FStar_Parser_AST.mk_term
              (FStar_Parser_AST.App (tot, t, FStar_Parser_AST.Nothing))
              t.FStar_Parser_AST.range t.FStar_Parser_AST.level
             in
          let apply_binders t binders =
            let imp_of_aqual b =
              match b.FStar_Parser_AST.aqual with
              | FStar_Pervasives_Native.Some (FStar_Parser_AST.Implicit ) ->
                  FStar_Parser_AST.Hash
              | uu____16464 -> FStar_Parser_AST.Nothing  in
            FStar_List.fold_left
              (fun out  ->
                 fun b  ->
                   let uu____16470 =
                     let uu____16471 =
                       let uu____16478 = binder_to_term b  in
                       (out, uu____16478, (imp_of_aqual b))  in
                     FStar_Parser_AST.App uu____16471  in
                   FStar_Parser_AST.mk_term uu____16470
                     out.FStar_Parser_AST.range out.FStar_Parser_AST.level) t
              binders
             in
          let tycon_record_as_variant uu___246_16490 =
            match uu___246_16490 with
            | FStar_Parser_AST.TyconRecord (id1,parms,kopt,fields) ->
                let constrName =
                  FStar_Ident.mk_ident
                    ((Prims.strcat "Mk" id1.FStar_Ident.idText),
                      (id1.FStar_Ident.idRange))
                   in
                let mfields =
                  FStar_List.map
                    (fun uu____16546  ->
                       match uu____16546 with
                       | (x,t,uu____16557) ->
                           let uu____16562 =
                             let uu____16563 =
                               let uu____16568 =
                                 FStar_Syntax_Util.mangle_field_name x  in
                               (uu____16568, t)  in
                             FStar_Parser_AST.Annotated uu____16563  in
                           FStar_Parser_AST.mk_binder uu____16562
                             x.FStar_Ident.idRange FStar_Parser_AST.Expr
                             FStar_Pervasives_Native.None) fields
                   in
                let result =
                  let uu____16570 =
                    let uu____16571 =
                      let uu____16572 = FStar_Ident.lid_of_ids [id1]  in
                      FStar_Parser_AST.Var uu____16572  in
                    FStar_Parser_AST.mk_term uu____16571
                      id1.FStar_Ident.idRange FStar_Parser_AST.Type_level
                     in
                  apply_binders uu____16570 parms  in
                let constrTyp =
                  FStar_Parser_AST.mk_term
                    (FStar_Parser_AST.Product
                       (mfields, (with_constructor_effect result)))
                    id1.FStar_Ident.idRange FStar_Parser_AST.Type_level
                   in
                let uu____16576 =
                  FStar_All.pipe_right fields
                    (FStar_List.map
                       (fun uu____16603  ->
                          match uu____16603 with
                          | (x,uu____16613,uu____16614) ->
                              FStar_Syntax_Util.unmangle_field_name x))
                   in
                ((FStar_Parser_AST.TyconVariant
                    (id1, parms, kopt,
                      [(constrName, (FStar_Pervasives_Native.Some constrTyp),
                         FStar_Pervasives_Native.None, false)])),
                  uu____16576)
            | uu____16667 -> failwith "impossible"  in
          let desugar_abstract_tc quals1 _env mutuals uu___247_16706 =
            match uu___247_16706 with
            | FStar_Parser_AST.TyconAbstract (id1,binders,kopt) ->
                let uu____16730 = typars_of_binders _env binders  in
                (match uu____16730 with
                 | (_env',typars) ->
                     let k =
                       match kopt with
                       | FStar_Pervasives_Native.None  ->
                           FStar_Syntax_Util.ktype
                       | FStar_Pervasives_Native.Some k ->
                           desugar_term _env' k
                        in
                     let tconstr =
                       let uu____16772 =
                         let uu____16773 =
                           let uu____16774 = FStar_Ident.lid_of_ids [id1]  in
                           FStar_Parser_AST.Var uu____16774  in
                         FStar_Parser_AST.mk_term uu____16773
                           id1.FStar_Ident.idRange
                           FStar_Parser_AST.Type_level
                          in
                       apply_binders uu____16772 binders  in
                     let qlid = FStar_Syntax_DsEnv.qualify _env id1  in
                     let typars1 = FStar_Syntax_Subst.close_binders typars
                        in
                     let k1 = FStar_Syntax_Subst.close typars1 k  in
                     let se =
                       {
                         FStar_Syntax_Syntax.sigel =
                           (FStar_Syntax_Syntax.Sig_inductive_typ
                              (qlid, [], typars1, k1, mutuals, []));
                         FStar_Syntax_Syntax.sigrng = rng;
                         FStar_Syntax_Syntax.sigquals = quals1;
                         FStar_Syntax_Syntax.sigmeta =
                           FStar_Syntax_Syntax.default_sigmeta;
                         FStar_Syntax_Syntax.sigattrs = []
                       }  in
                     let _env1 =
                       FStar_Syntax_DsEnv.push_top_level_rec_binding _env id1
                         FStar_Syntax_Syntax.delta_constant
                        in
                     let _env2 =
                       FStar_Syntax_DsEnv.push_top_level_rec_binding _env'
                         id1 FStar_Syntax_Syntax.delta_constant
                        in
                     (_env1, _env2, se, tconstr))
            | uu____16785 -> failwith "Unexpected tycon"  in
          let push_tparams env1 bs =
            let uu____16833 =
              FStar_List.fold_left
                (fun uu____16873  ->
                   fun uu____16874  ->
                     match (uu____16873, uu____16874) with
                     | ((env2,tps),(x,imp)) ->
                         let uu____16965 =
                           FStar_Syntax_DsEnv.push_bv env2
                             x.FStar_Syntax_Syntax.ppname
                            in
                         (match uu____16965 with
                          | (env3,y) -> (env3, ((y, imp) :: tps))))
                (env1, []) bs
               in
            match uu____16833 with
            | (env2,bs1) -> (env2, (FStar_List.rev bs1))  in
          match tcs with
          | (FStar_Parser_AST.TyconAbstract (id1,bs,kopt))::[] ->
              let kopt1 =
                match kopt with
                | FStar_Pervasives_Native.None  ->
                    let uu____17078 = tm_type_z id1.FStar_Ident.idRange  in
                    FStar_Pervasives_Native.Some uu____17078
                | uu____17079 -> kopt  in
              let tc = FStar_Parser_AST.TyconAbstract (id1, bs, kopt1)  in
              let uu____17087 = desugar_abstract_tc quals env [] tc  in
              (match uu____17087 with
               | (uu____17100,uu____17101,se,uu____17103) ->
                   let se1 =
                     match se.FStar_Syntax_Syntax.sigel with
                     | FStar_Syntax_Syntax.Sig_inductive_typ
                         (l,uu____17106,typars,k,[],[]) ->
                         let quals1 = se.FStar_Syntax_Syntax.sigquals  in
                         let quals2 =
                           if
                             FStar_List.contains
                               FStar_Syntax_Syntax.Assumption quals1
                           then quals1
                           else
                             ((let uu____17123 =
                                 let uu____17124 = FStar_Options.ml_ish ()
                                    in
                                 Prims.op_Negation uu____17124  in
                               if uu____17123
                               then
                                 let uu____17125 =
                                   let uu____17130 =
                                     let uu____17131 =
                                       FStar_Syntax_Print.lid_to_string l  in
                                     FStar_Util.format1
                                       "Adding an implicit 'assume new' qualifier on %s"
                                       uu____17131
                                      in
                                   (FStar_Errors.Warning_AddImplicitAssumeNewQualifier,
                                     uu____17130)
                                    in
                                 FStar_Errors.log_issue
                                   se.FStar_Syntax_Syntax.sigrng uu____17125
                               else ());
                              FStar_Syntax_Syntax.Assumption
                              ::
                              FStar_Syntax_Syntax.New
                              ::
                              quals1)
                            in
                         let t =
                           match typars with
                           | [] -> k
                           | uu____17138 ->
                               let uu____17139 =
                                 let uu____17146 =
                                   let uu____17147 =
                                     let uu____17160 =
                                       FStar_Syntax_Syntax.mk_Total k  in
                                     (typars, uu____17160)  in
                                   FStar_Syntax_Syntax.Tm_arrow uu____17147
                                    in
                                 FStar_Syntax_Syntax.mk uu____17146  in
                               uu____17139 FStar_Pervasives_Native.None
                                 se.FStar_Syntax_Syntax.sigrng
                            in
                         let uu___288_17174 = se  in
                         {
                           FStar_Syntax_Syntax.sigel =
                             (FStar_Syntax_Syntax.Sig_declare_typ (l, [], t));
                           FStar_Syntax_Syntax.sigrng =
                             (uu___288_17174.FStar_Syntax_Syntax.sigrng);
                           FStar_Syntax_Syntax.sigquals = quals2;
                           FStar_Syntax_Syntax.sigmeta =
                             (uu___288_17174.FStar_Syntax_Syntax.sigmeta);
                           FStar_Syntax_Syntax.sigattrs =
                             (uu___288_17174.FStar_Syntax_Syntax.sigattrs)
                         }
                     | uu____17175 -> failwith "Impossible"  in
                   let env1 = FStar_Syntax_DsEnv.push_sigelt env se1  in
                   let env2 =
                     let uu____17178 = FStar_Syntax_DsEnv.qualify env1 id1
                        in
                     FStar_Syntax_DsEnv.push_doc env1 uu____17178
                       d.FStar_Parser_AST.doc
                      in
                   (env2, [se1]))
          | (FStar_Parser_AST.TyconAbbrev (id1,binders,kopt,t))::[] ->
              let uu____17191 = typars_of_binders env binders  in
              (match uu____17191 with
               | (env',typars) ->
                   let kopt1 =
                     match kopt with
                     | FStar_Pervasives_Native.None  ->
                         let uu____17231 =
                           FStar_Util.for_some
                             (fun uu___248_17233  ->
                                match uu___248_17233 with
                                | FStar_Syntax_Syntax.Effect  -> true
                                | uu____17234 -> false) quals
                            in
                         if uu____17231
                         then
                           FStar_Pervasives_Native.Some
                             FStar_Syntax_Syntax.teff
                         else FStar_Pervasives_Native.None
                     | FStar_Pervasives_Native.Some k ->
                         let uu____17239 = desugar_term env' k  in
                         FStar_Pervasives_Native.Some uu____17239
                      in
                   let t0 = t  in
                   let quals1 =
                     let uu____17244 =
                       FStar_All.pipe_right quals
                         (FStar_Util.for_some
                            (fun uu___249_17248  ->
                               match uu___249_17248 with
                               | FStar_Syntax_Syntax.Logic  -> true
                               | uu____17249 -> false))
                        in
                     if uu____17244
                     then quals
                     else
                       if
                         t0.FStar_Parser_AST.level = FStar_Parser_AST.Formula
                       then FStar_Syntax_Syntax.Logic :: quals
                       else quals
                      in
                   let qlid = FStar_Syntax_DsEnv.qualify env id1  in
                   let se =
                     let uu____17258 =
                       FStar_All.pipe_right quals1
                         (FStar_List.contains FStar_Syntax_Syntax.Effect)
                        in
                     if uu____17258
                     then
                       let uu____17261 =
                         let uu____17268 =
                           let uu____17269 = unparen t  in
                           uu____17269.FStar_Parser_AST.tm  in
                         match uu____17268 with
                         | FStar_Parser_AST.Construct (head1,args) ->
                             let uu____17290 =
                               match FStar_List.rev args with
                               | (last_arg,uu____17320)::args_rev ->
                                   let uu____17332 =
                                     let uu____17333 = unparen last_arg  in
                                     uu____17333.FStar_Parser_AST.tm  in
                                   (match uu____17332 with
                                    | FStar_Parser_AST.Attributes ts ->
                                        (ts, (FStar_List.rev args_rev))
                                    | uu____17361 -> ([], args))
                               | uu____17370 -> ([], args)  in
                             (match uu____17290 with
                              | (cattributes,args1) ->
                                  let uu____17409 =
                                    desugar_attributes env cattributes  in
                                  ((FStar_Parser_AST.mk_term
                                      (FStar_Parser_AST.Construct
                                         (head1, args1))
                                      t.FStar_Parser_AST.range
                                      t.FStar_Parser_AST.level), uu____17409))
                         | uu____17420 -> (t, [])  in
                       match uu____17261 with
                       | (t1,cattributes) ->
                           let c =
                             desugar_comp t1.FStar_Parser_AST.range env' t1
                              in
                           let typars1 =
                             FStar_Syntax_Subst.close_binders typars  in
                           let c1 = FStar_Syntax_Subst.close_comp typars1 c
                              in
                           let quals2 =
                             FStar_All.pipe_right quals1
                               (FStar_List.filter
                                  (fun uu___250_17442  ->
                                     match uu___250_17442 with
                                     | FStar_Syntax_Syntax.Effect  -> false
                                     | uu____17443 -> true))
                              in
                           {
                             FStar_Syntax_Syntax.sigel =
                               (FStar_Syntax_Syntax.Sig_effect_abbrev
                                  (qlid, [], typars1, c1,
                                    (FStar_List.append cattributes
                                       (FStar_Syntax_Util.comp_flags c1))));
                             FStar_Syntax_Syntax.sigrng = rng;
                             FStar_Syntax_Syntax.sigquals = quals2;
                             FStar_Syntax_Syntax.sigmeta =
                               FStar_Syntax_Syntax.default_sigmeta;
                             FStar_Syntax_Syntax.sigattrs = []
                           }
                     else
                       (let t1 = desugar_typ env' t  in
                        mk_typ_abbrev qlid [] typars kopt1 t1 [qlid] quals1
                          rng)
                      in
                   let env1 = FStar_Syntax_DsEnv.push_sigelt env se  in
                   let env2 =
                     FStar_Syntax_DsEnv.push_doc env1 qlid
                       d.FStar_Parser_AST.doc
                      in
                   (env2, [se]))
          | (FStar_Parser_AST.TyconRecord uu____17450)::[] ->
              let trec = FStar_List.hd tcs  in
              let uu____17474 = tycon_record_as_variant trec  in
              (match uu____17474 with
               | (t,fs) ->
                   let uu____17491 =
                     let uu____17494 =
                       let uu____17495 =
                         let uu____17504 =
                           let uu____17507 =
                             FStar_Syntax_DsEnv.current_module env  in
                           FStar_Ident.ids_of_lid uu____17507  in
                         (uu____17504, fs)  in
                       FStar_Syntax_Syntax.RecordType uu____17495  in
                     uu____17494 :: quals  in
                   desugar_tycon env d uu____17491 [t])
          | uu____17512::uu____17513 ->
              let env0 = env  in
              let mutuals =
                FStar_List.map
                  (fun x  ->
                     FStar_All.pipe_left (FStar_Syntax_DsEnv.qualify env)
                       (tycon_id x)) tcs
                 in
              let rec collect_tcs quals1 et tc =
                let uu____17680 = et  in
                match uu____17680 with
                | (env1,tcs1) ->
                    (match tc with
                     | FStar_Parser_AST.TyconRecord uu____17905 ->
                         let trec = tc  in
                         let uu____17929 = tycon_record_as_variant trec  in
                         (match uu____17929 with
                          | (t,fs) ->
                              let uu____17988 =
                                let uu____17991 =
                                  let uu____17992 =
                                    let uu____18001 =
                                      let uu____18004 =
                                        FStar_Syntax_DsEnv.current_module
                                          env1
                                         in
                                      FStar_Ident.ids_of_lid uu____18004  in
                                    (uu____18001, fs)  in
                                  FStar_Syntax_Syntax.RecordType uu____17992
                                   in
                                uu____17991 :: quals1  in
                              collect_tcs uu____17988 (env1, tcs1) t)
                     | FStar_Parser_AST.TyconVariant
                         (id1,binders,kopt,constructors) ->
                         let uu____18091 =
                           desugar_abstract_tc quals1 env1 mutuals
                             (FStar_Parser_AST.TyconAbstract
                                (id1, binders, kopt))
                            in
                         (match uu____18091 with
                          | (env2,uu____18151,se,tconstr) ->
                              (env2,
                                ((FStar_Util.Inl
                                    (se, constructors, tconstr, quals1)) ::
                                tcs1)))
                     | FStar_Parser_AST.TyconAbbrev (id1,binders,kopt,t) ->
                         let uu____18300 =
                           desugar_abstract_tc quals1 env1 mutuals
                             (FStar_Parser_AST.TyconAbstract
                                (id1, binders, kopt))
                            in
                         (match uu____18300 with
                          | (env2,uu____18360,se,tconstr) ->
                              (env2,
                                ((FStar_Util.Inr (se, binders, t, quals1)) ::
                                tcs1)))
                     | uu____18485 ->
                         failwith "Unrecognized mutual type definition")
                 in
              let uu____18532 =
                FStar_List.fold_left (collect_tcs quals) (env, []) tcs  in
              (match uu____18532 with
               | (env1,tcs1) ->
                   let tcs2 = FStar_List.rev tcs1  in
                   let docs_tps_sigelts =
                     FStar_All.pipe_right tcs2
                       (FStar_List.collect
                          (fun uu___252_19043  ->
                             match uu___252_19043 with
                             | FStar_Util.Inr
                                 ({
                                    FStar_Syntax_Syntax.sigel =
                                      FStar_Syntax_Syntax.Sig_inductive_typ
                                      (id1,uvs,tpars,k,uu____19110,uu____19111);
                                    FStar_Syntax_Syntax.sigrng = uu____19112;
                                    FStar_Syntax_Syntax.sigquals =
                                      uu____19113;
                                    FStar_Syntax_Syntax.sigmeta = uu____19114;
                                    FStar_Syntax_Syntax.sigattrs =
                                      uu____19115;_},binders,t,quals1)
                                 ->
                                 let t1 =
                                   let uu____19178 =
                                     typars_of_binders env1 binders  in
                                   match uu____19178 with
                                   | (env2,tpars1) ->
                                       let uu____19211 =
                                         push_tparams env2 tpars1  in
                                       (match uu____19211 with
                                        | (env_tps,tpars2) ->
                                            let t1 = desugar_typ env_tps t
                                               in
                                            let tpars3 =
                                              FStar_Syntax_Subst.close_binders
                                                tpars2
                                               in
                                            FStar_Syntax_Subst.close tpars3
                                              t1)
                                    in
                                 let uu____19246 =
                                   let uu____19267 =
                                     mk_typ_abbrev id1 uvs tpars
                                       (FStar_Pervasives_Native.Some k) t1
                                       [id1] quals1 rng
                                      in
                                   ((id1, (d.FStar_Parser_AST.doc)), [],
                                     uu____19267)
                                    in
                                 [uu____19246]
                             | FStar_Util.Inl
                                 ({
                                    FStar_Syntax_Syntax.sigel =
                                      FStar_Syntax_Syntax.Sig_inductive_typ
                                      (tname,univs1,tpars,k,mutuals1,uu____19335);
                                    FStar_Syntax_Syntax.sigrng = uu____19336;
                                    FStar_Syntax_Syntax.sigquals =
                                      tname_quals;
                                    FStar_Syntax_Syntax.sigmeta = uu____19338;
                                    FStar_Syntax_Syntax.sigattrs =
                                      uu____19339;_},constrs,tconstr,quals1)
                                 ->
                                 let mk_tot t =
                                   let tot1 =
                                     FStar_Parser_AST.mk_term
                                       (FStar_Parser_AST.Name
                                          FStar_Parser_Const.effect_Tot_lid)
                                       t.FStar_Parser_AST.range
                                       t.FStar_Parser_AST.level
                                      in
                                   FStar_Parser_AST.mk_term
                                     (FStar_Parser_AST.App
                                        (tot1, t, FStar_Parser_AST.Nothing))
                                     t.FStar_Parser_AST.range
                                     t.FStar_Parser_AST.level
                                    in
                                 let tycon = (tname, tpars, k)  in
                                 let uu____19437 = push_tparams env1 tpars
                                    in
                                 (match uu____19437 with
                                  | (env_tps,tps) ->
                                      let data_tpars =
                                        FStar_List.map
                                          (fun uu____19514  ->
                                             match uu____19514 with
                                             | (x,uu____19528) ->
                                                 (x,
                                                   (FStar_Pervasives_Native.Some
                                                      (FStar_Syntax_Syntax.Implicit
                                                         true)))) tps
                                         in
                                      let tot_tconstr = mk_tot tconstr  in
                                      let uu____19536 =
                                        let uu____19565 =
                                          FStar_All.pipe_right constrs
                                            (FStar_List.map
                                               (fun uu____19679  ->
                                                  match uu____19679 with
                                                  | (id1,topt,doc1,of_notation)
                                                      ->
                                                      let t =
                                                        if of_notation
                                                        then
                                                          match topt with
                                                          | FStar_Pervasives_Native.Some
                                                              t ->
                                                              FStar_Parser_AST.mk_term
                                                                (FStar_Parser_AST.Product
                                                                   ([
                                                                    FStar_Parser_AST.mk_binder
                                                                    (FStar_Parser_AST.NoName
                                                                    t)
                                                                    t.FStar_Parser_AST.range
                                                                    t.FStar_Parser_AST.level
                                                                    FStar_Pervasives_Native.None],
                                                                    tot_tconstr))
                                                                t.FStar_Parser_AST.range
                                                                t.FStar_Parser_AST.level
                                                          | FStar_Pervasives_Native.None
                                                               -> tconstr
                                                        else
                                                          (match topt with
                                                           | FStar_Pervasives_Native.None
                                                                ->
                                                               failwith
                                                                 "Impossible"
                                                           | FStar_Pervasives_Native.Some
                                                               t -> t)
                                                         in
                                                      let t1 =
                                                        let uu____19735 =
                                                          close env_tps t  in
                                                        desugar_term env_tps
                                                          uu____19735
                                                         in
                                                      let name =
                                                        FStar_Syntax_DsEnv.qualify
                                                          env1 id1
                                                         in
                                                      let quals2 =
                                                        FStar_All.pipe_right
                                                          tname_quals
                                                          (FStar_List.collect
                                                             (fun
                                                                uu___251_19746
                                                                 ->
                                                                match uu___251_19746
                                                                with
                                                                | FStar_Syntax_Syntax.RecordType
                                                                    fns ->
                                                                    [
                                                                    FStar_Syntax_Syntax.RecordConstructor
                                                                    fns]
                                                                | uu____19758
                                                                    -> []))
                                                         in
                                                      let ntps =
                                                        FStar_List.length
                                                          data_tpars
                                                         in
                                                      let uu____19766 =
                                                        let uu____19787 =
                                                          let uu____19788 =
                                                            let uu____19789 =
                                                              let uu____19804
                                                                =
                                                                let uu____19805
                                                                  =
                                                                  let uu____19808
                                                                    =
                                                                    FStar_All.pipe_right
                                                                    t1
                                                                    FStar_Syntax_Util.name_function_binders
                                                                     in
                                                                  FStar_Syntax_Syntax.mk_Total
                                                                    uu____19808
                                                                   in
                                                                FStar_Syntax_Util.arrow
                                                                  data_tpars
                                                                  uu____19805
                                                                 in
                                                              (name, univs1,
                                                                uu____19804,
                                                                tname, ntps,
                                                                mutuals1)
                                                               in
                                                            FStar_Syntax_Syntax.Sig_datacon
                                                              uu____19789
                                                             in
                                                          {
                                                            FStar_Syntax_Syntax.sigel
                                                              = uu____19788;
                                                            FStar_Syntax_Syntax.sigrng
                                                              = rng;
                                                            FStar_Syntax_Syntax.sigquals
                                                              = quals2;
                                                            FStar_Syntax_Syntax.sigmeta
                                                              =
                                                              FStar_Syntax_Syntax.default_sigmeta;
                                                            FStar_Syntax_Syntax.sigattrs
                                                              = []
                                                          }  in
                                                        ((name, doc1), tps,
                                                          uu____19787)
                                                         in
                                                      (name, uu____19766)))
                                           in
                                        FStar_All.pipe_left FStar_List.split
                                          uu____19565
                                         in
                                      (match uu____19536 with
                                       | (constrNames,constrs1) ->
                                           ((tname, (d.FStar_Parser_AST.doc)),
                                             [],
                                             {
                                               FStar_Syntax_Syntax.sigel =
                                                 (FStar_Syntax_Syntax.Sig_inductive_typ
                                                    (tname, univs1, tpars, k,
                                                      mutuals1, constrNames));
                                               FStar_Syntax_Syntax.sigrng =
                                                 rng;
                                               FStar_Syntax_Syntax.sigquals =
                                                 tname_quals;
                                               FStar_Syntax_Syntax.sigmeta =
                                                 FStar_Syntax_Syntax.default_sigmeta;
                                               FStar_Syntax_Syntax.sigattrs =
                                                 []
                                             })
                                           :: constrs1))
                             | uu____20045 -> failwith "impossible"))
                      in
                   let name_docs =
                     FStar_All.pipe_right docs_tps_sigelts
                       (FStar_List.map
                          (fun uu____20177  ->
                             match uu____20177 with
                             | (name_doc,uu____20205,uu____20206) -> name_doc))
                      in
                   let sigelts =
                     FStar_All.pipe_right docs_tps_sigelts
                       (FStar_List.map
                          (fun uu____20286  ->
                             match uu____20286 with
                             | (uu____20307,uu____20308,se) -> se))
                      in
                   let uu____20338 =
                     let uu____20345 =
                       FStar_List.collect FStar_Syntax_Util.lids_of_sigelt
                         sigelts
                        in
                     FStar_Syntax_MutRecTy.disentangle_abbrevs_from_bundle
                       sigelts quals uu____20345 rng
                      in
                   (match uu____20338 with
                    | (bundle,abbrevs) ->
                        let env2 = FStar_Syntax_DsEnv.push_sigelt env0 bundle
                           in
                        let env3 =
                          FStar_List.fold_left FStar_Syntax_DsEnv.push_sigelt
                            env2 abbrevs
                           in
                        let data_ops =
                          FStar_All.pipe_right docs_tps_sigelts
                            (FStar_List.collect
                               (fun uu____20411  ->
                                  match uu____20411 with
                                  | (uu____20434,tps,se) ->
                                      mk_data_projector_names quals env3 se))
                           in
                        let discs =
                          FStar_All.pipe_right sigelts
                            (FStar_List.collect
                               (fun se  ->
                                  match se.FStar_Syntax_Syntax.sigel with
                                  | FStar_Syntax_Syntax.Sig_inductive_typ
                                      (tname,uu____20485,tps,k,uu____20488,constrs)
                                      when
                                      (FStar_List.length constrs) >
                                        (Prims.parse_int "1")
                                      ->
                                      let quals1 =
                                        se.FStar_Syntax_Syntax.sigquals  in
                                      let quals2 =
                                        if
                                          FStar_List.contains
                                            FStar_Syntax_Syntax.Abstract
                                            quals1
                                        then FStar_Syntax_Syntax.Private ::
                                          quals1
                                        else quals1  in
                                      mk_data_discriminators quals2 env3
                                        constrs
                                  | uu____20507 -> []))
                           in
                        let ops = FStar_List.append discs data_ops  in
                        let env4 =
                          FStar_List.fold_left FStar_Syntax_DsEnv.push_sigelt
                            env3 ops
                           in
                        let env5 =
                          FStar_List.fold_left
                            (fun acc  ->
                               fun uu____20524  ->
                                 match uu____20524 with
                                 | (lid,doc1) ->
                                     FStar_Syntax_DsEnv.push_doc env4 lid
                                       doc1) env4 name_docs
                           in
                        (env5,
                          (FStar_List.append [bundle]
                             (FStar_List.append abbrevs ops)))))
          | [] -> failwith "impossible"
  
let (desugar_binders :
  FStar_Syntax_DsEnv.env ->
    FStar_Parser_AST.binder Prims.list ->
      (FStar_Syntax_DsEnv.env,(FStar_Syntax_Syntax.bv,FStar_Syntax_Syntax.aqual)
                                FStar_Pervasives_Native.tuple2 Prims.list)
        FStar_Pervasives_Native.tuple2)
  =
  fun env  ->
    fun binders  ->
      let uu____20565 =
        FStar_List.fold_left
          (fun uu____20596  ->
             fun b  ->
               match uu____20596 with
               | (env1,binders1) ->
                   let uu____20632 = desugar_binder env1 b  in
                   (match uu____20632 with
                    | (FStar_Pervasives_Native.Some a,k) ->
                        let uu____20653 =
                          as_binder env1 b.FStar_Parser_AST.aqual
                            ((FStar_Pervasives_Native.Some a), k)
                           in
                        (match uu____20653 with
                         | (binder,env2) -> (env2, (binder :: binders1)))
                    | uu____20696 ->
                        FStar_Errors.raise_error
                          (FStar_Errors.Fatal_MissingNameInBinder,
                            "Missing name in binder")
                          b.FStar_Parser_AST.brange)) (env, []) binders
         in
      match uu____20565 with
      | (env1,binders1) -> (env1, (FStar_List.rev binders1))
  
let (push_reflect_effect :
  FStar_Syntax_DsEnv.env ->
    FStar_Syntax_Syntax.qualifier Prims.list ->
      FStar_Ident.lid -> FStar_Range.range -> FStar_Syntax_DsEnv.env)
  =
  fun env  ->
    fun quals  ->
      fun effect_name  ->
        fun range  ->
          let uu____20781 =
            FStar_All.pipe_right quals
              (FStar_Util.for_some
                 (fun uu___253_20786  ->
                    match uu___253_20786 with
                    | FStar_Syntax_Syntax.Reflectable uu____20787 -> true
                    | uu____20788 -> false))
             in
          if uu____20781
          then
            let monad_env =
              FStar_Syntax_DsEnv.enter_monad_scope env
                effect_name.FStar_Ident.ident
               in
            let reflect_lid =
              let uu____20791 = FStar_Ident.id_of_text "reflect"  in
              FStar_All.pipe_right uu____20791
                (FStar_Syntax_DsEnv.qualify monad_env)
               in
            let quals1 =
              [FStar_Syntax_Syntax.Assumption;
              FStar_Syntax_Syntax.Reflectable effect_name]  in
            let refl_decl =
              {
                FStar_Syntax_Syntax.sigel =
                  (FStar_Syntax_Syntax.Sig_declare_typ
                     (reflect_lid, [], FStar_Syntax_Syntax.tun));
                FStar_Syntax_Syntax.sigrng = range;
                FStar_Syntax_Syntax.sigquals = quals1;
                FStar_Syntax_Syntax.sigmeta =
                  FStar_Syntax_Syntax.default_sigmeta;
                FStar_Syntax_Syntax.sigattrs = []
              }  in
            FStar_Syntax_DsEnv.push_sigelt env refl_decl
          else env
  
let (get_fail_attr :
  Prims.bool ->
    FStar_Syntax_Syntax.term ->
      (Prims.int Prims.list,Prims.bool) FStar_Pervasives_Native.tuple2
        FStar_Pervasives_Native.option)
  =
  fun warn  ->
    fun at1  ->
      let uu____20823 = FStar_Syntax_Util.head_and_args at1  in
      match uu____20823 with
      | (hd1,args) ->
          let uu____20868 =
            let uu____20881 =
              let uu____20882 = FStar_Syntax_Subst.compress hd1  in
              uu____20882.FStar_Syntax_Syntax.n  in
            (uu____20881, args)  in
          (match uu____20868 with
           | (FStar_Syntax_Syntax.Tm_fvar fv,(a1,uu____20903)::[]) when
               FStar_Syntax_Syntax.fv_eq_lid fv FStar_Parser_Const.fail_attr
               ->
               let uu____20928 =
                 let uu____20933 =
                   FStar_Syntax_Embeddings.e_list
                     FStar_Syntax_Embeddings.e_int
                    in
                 FStar_Syntax_Embeddings.unembed uu____20933 a1  in
               (match uu____20928 with
                | FStar_Pervasives_Native.Some [] ->
                    FStar_Errors.raise_error
                      (FStar_Errors.Error_EmptyFailErrs,
                        "Found ill-applied fail, argument should be a non-empty list of integers")
                      at1.FStar_Syntax_Syntax.pos
                | FStar_Pervasives_Native.Some es ->
                    let uu____20963 =
                      let uu____20970 =
                        FStar_List.map FStar_BigInt.to_int_fs es  in
                      (uu____20970, false)  in
                    FStar_Pervasives_Native.Some uu____20963
                | FStar_Pervasives_Native.None  ->
                    (if warn
                     then
                       FStar_Errors.log_issue at1.FStar_Syntax_Syntax.pos
                         (FStar_Errors.Warning_UnappliedFail,
                           "Found ill-applied fail, argument should be a non-empty list of integer literals")
                     else ();
                     FStar_Pervasives_Native.None))
           | (FStar_Syntax_Syntax.Tm_fvar fv,[]) when
               FStar_Syntax_Syntax.fv_eq_lid fv FStar_Parser_Const.fail_attr
               -> FStar_Pervasives_Native.Some ([], false)
           | (FStar_Syntax_Syntax.Tm_fvar fv,uu____21015) when
               FStar_Syntax_Syntax.fv_eq_lid fv FStar_Parser_Const.fail_attr
               ->
               (if warn
                then
                  FStar_Errors.log_issue at1.FStar_Syntax_Syntax.pos
                    (FStar_Errors.Warning_UnappliedFail,
                      "Found ill-applied fail, argument should be a non-empty list of integer literals")
                else ();
                FStar_Pervasives_Native.None)
           | (FStar_Syntax_Syntax.Tm_fvar fv,[]) when
               FStar_Syntax_Syntax.fv_eq_lid fv
                 FStar_Parser_Const.fail_lax_attr
               -> FStar_Pervasives_Native.Some ([], true)
           | uu____21063 -> FStar_Pervasives_Native.None)
  
let rec (desugar_effect :
  FStar_Syntax_DsEnv.env ->
    FStar_Parser_AST.decl ->
      FStar_Parser_AST.qualifiers ->
        FStar_Ident.ident ->
          FStar_Parser_AST.binder Prims.list ->
            FStar_Parser_AST.term ->
              FStar_Parser_AST.decl Prims.list ->
                FStar_Parser_AST.term Prims.list ->
                  (FStar_Syntax_DsEnv.env,FStar_Syntax_Syntax.sigelt
                                            Prims.list)
                    FStar_Pervasives_Native.tuple2)
  =
  fun env  ->
    fun d  ->
      fun quals  ->
        fun eff_name  ->
          fun eff_binders  ->
            fun eff_typ  ->
              fun eff_decls  ->
                fun attrs  ->
                  let env0 = env  in
                  let monad_env =
                    FStar_Syntax_DsEnv.enter_monad_scope env eff_name  in
                  let uu____21230 = desugar_binders monad_env eff_binders  in
                  match uu____21230 with
                  | (env1,binders) ->
                      let eff_t = desugar_term env1 eff_typ  in
                      let for_free =
                        let uu____21263 =
                          let uu____21264 =
                            let uu____21271 =
                              FStar_Syntax_Util.arrow_formals eff_t  in
                            FStar_Pervasives_Native.fst uu____21271  in
                          FStar_List.length uu____21264  in
                        uu____21263 = (Prims.parse_int "1")  in
                      let mandatory_members =
                        let rr_members = ["repr"; "return"; "bind"]  in
                        if for_free
                        then rr_members
                        else
                          FStar_List.append rr_members
                            ["return_wp";
                            "bind_wp";
                            "if_then_else";
                            "ite_wp";
                            "stronger";
                            "close_wp";
                            "assert_p";
                            "assume_p";
                            "null_wp";
                            "trivial"]
                         in
                      let name_of_eff_decl decl =
                        match decl.FStar_Parser_AST.d with
                        | FStar_Parser_AST.Tycon
                            (uu____21311,(FStar_Parser_AST.TyconAbbrev
                                          (name,uu____21313,uu____21314,uu____21315),uu____21316)::[])
                            -> FStar_Ident.text_of_id name
                        | uu____21349 ->
                            failwith "Malformed effect member declaration."
                         in
                      let uu____21350 =
                        FStar_List.partition
                          (fun decl  ->
                             let uu____21362 = name_of_eff_decl decl  in
                             FStar_List.mem uu____21362 mandatory_members)
                          eff_decls
                         in
                      (match uu____21350 with
                       | (mandatory_members_decls,actions) ->
                           let uu____21379 =
                             FStar_All.pipe_right mandatory_members_decls
                               (FStar_List.fold_left
                                  (fun uu____21408  ->
                                     fun decl  ->
                                       match uu____21408 with
                                       | (env2,out) ->
                                           let uu____21428 =
                                             desugar_decl env2 decl  in
                                           (match uu____21428 with
                                            | (env3,ses) ->
                                                let uu____21441 =
                                                  let uu____21444 =
                                                    FStar_List.hd ses  in
                                                  uu____21444 :: out  in
                                                (env3, uu____21441)))
                                  (env1, []))
                              in
                           (match uu____21379 with
                            | (env2,decls) ->
                                let binders1 =
                                  FStar_Syntax_Subst.close_binders binders
                                   in
                                let actions_docs =
                                  FStar_All.pipe_right actions
                                    (FStar_List.map
                                       (fun d1  ->
                                          match d1.FStar_Parser_AST.d with
                                          | FStar_Parser_AST.Tycon
                                              (uu____21512,(FStar_Parser_AST.TyconAbbrev
                                                            (name,action_params,uu____21515,
                                                             {
                                                               FStar_Parser_AST.tm
                                                                 =
                                                                 FStar_Parser_AST.Construct
                                                                 (uu____21516,
                                                                  (def,uu____21518)::
                                                                  (cps_type,uu____21520)::[]);
                                                               FStar_Parser_AST.range
                                                                 =
                                                                 uu____21521;
                                                               FStar_Parser_AST.level
                                                                 =
                                                                 uu____21522;_}),doc1)::[])
                                              when Prims.op_Negation for_free
                                              ->
                                              let uu____21574 =
                                                desugar_binders env2
                                                  action_params
                                                 in
                                              (match uu____21574 with
                                               | (env3,action_params1) ->
                                                   let action_params2 =
                                                     FStar_Syntax_Subst.close_binders
                                                       action_params1
                                                      in
                                                   let uu____21606 =
                                                     let uu____21607 =
                                                       FStar_Syntax_DsEnv.qualify
                                                         env3 name
                                                        in
                                                     let uu____21608 =
                                                       let uu____21609 =
                                                         desugar_term env3
                                                           def
                                                          in
                                                       FStar_Syntax_Subst.close
                                                         (FStar_List.append
                                                            binders1
                                                            action_params2)
                                                         uu____21609
                                                        in
                                                     let uu____21614 =
                                                       let uu____21615 =
                                                         desugar_typ env3
                                                           cps_type
                                                          in
                                                       FStar_Syntax_Subst.close
                                                         (FStar_List.append
                                                            binders1
                                                            action_params2)
                                                         uu____21615
                                                        in
                                                     {
                                                       FStar_Syntax_Syntax.action_name
                                                         = uu____21607;
                                                       FStar_Syntax_Syntax.action_unqualified_name
                                                         = name;
                                                       FStar_Syntax_Syntax.action_univs
                                                         = [];
                                                       FStar_Syntax_Syntax.action_params
                                                         = action_params2;
                                                       FStar_Syntax_Syntax.action_defn
                                                         = uu____21608;
                                                       FStar_Syntax_Syntax.action_typ
                                                         = uu____21614
                                                     }  in
                                                   (uu____21606, doc1))
                                          | FStar_Parser_AST.Tycon
                                              (uu____21622,(FStar_Parser_AST.TyconAbbrev
                                                            (name,action_params,uu____21625,defn),doc1)::[])
                                              when for_free ->
                                              let uu____21660 =
                                                desugar_binders env2
                                                  action_params
                                                 in
                                              (match uu____21660 with
                                               | (env3,action_params1) ->
                                                   let action_params2 =
                                                     FStar_Syntax_Subst.close_binders
                                                       action_params1
                                                      in
                                                   let uu____21692 =
                                                     let uu____21693 =
                                                       FStar_Syntax_DsEnv.qualify
                                                         env3 name
                                                        in
                                                     let uu____21694 =
                                                       let uu____21695 =
                                                         desugar_term env3
                                                           defn
                                                          in
                                                       FStar_Syntax_Subst.close
                                                         (FStar_List.append
                                                            binders1
                                                            action_params2)
                                                         uu____21695
                                                        in
                                                     {
                                                       FStar_Syntax_Syntax.action_name
                                                         = uu____21693;
                                                       FStar_Syntax_Syntax.action_unqualified_name
                                                         = name;
                                                       FStar_Syntax_Syntax.action_univs
                                                         = [];
                                                       FStar_Syntax_Syntax.action_params
                                                         = action_params2;
                                                       FStar_Syntax_Syntax.action_defn
                                                         = uu____21694;
                                                       FStar_Syntax_Syntax.action_typ
                                                         =
                                                         FStar_Syntax_Syntax.tun
                                                     }  in
                                                   (uu____21692, doc1))
                                          | uu____21702 ->
                                              FStar_Errors.raise_error
                                                (FStar_Errors.Fatal_MalformedActionDeclaration,
                                                  "Malformed action declaration; if this is an \"effect for free\", just provide the direct-style declaration. If this is not an \"effect for free\", please provide a pair of the definition and its cps-type with arrows inserted in the right place (see examples).")
                                                d1.FStar_Parser_AST.drange))
                                   in
                                let actions1 =
                                  FStar_List.map FStar_Pervasives_Native.fst
                                    actions_docs
                                   in
                                let eff_t1 =
                                  FStar_Syntax_Subst.close binders1 eff_t  in
                                let lookup1 s =
                                  let l =
                                    let uu____21734 =
                                      FStar_Ident.mk_ident
                                        (s, (d.FStar_Parser_AST.drange))
                                       in
                                    FStar_Syntax_DsEnv.qualify env2
                                      uu____21734
                                     in
                                  let uu____21735 =
                                    let uu____21736 =
                                      FStar_Syntax_DsEnv.fail_or env2
                                        (FStar_Syntax_DsEnv.try_lookup_definition
                                           env2) l
                                       in
                                    FStar_All.pipe_left
                                      (FStar_Syntax_Subst.close binders1)
                                      uu____21736
                                     in
                                  ([], uu____21735)  in
                                let mname =
                                  FStar_Syntax_DsEnv.qualify env0 eff_name
                                   in
                                let qualifiers =
                                  FStar_List.map
                                    (trans_qual d.FStar_Parser_AST.drange
                                       (FStar_Pervasives_Native.Some mname))
                                    quals
                                   in
                                let se =
                                  if for_free
                                  then
                                    let dummy_tscheme =
                                      let uu____21753 =
                                        FStar_Syntax_Syntax.mk
                                          FStar_Syntax_Syntax.Tm_unknown
                                          FStar_Pervasives_Native.None
                                          FStar_Range.dummyRange
                                         in
                                      ([], uu____21753)  in
                                    let uu____21760 =
                                      let uu____21761 =
                                        let uu____21762 =
                                          let uu____21763 = lookup1 "repr"
                                             in
                                          FStar_Pervasives_Native.snd
                                            uu____21763
                                           in
                                        let uu____21772 = lookup1 "return"
                                           in
                                        let uu____21773 = lookup1 "bind"  in
                                        let uu____21774 =
                                          FStar_List.map (desugar_term env2)
                                            attrs
                                           in
                                        {
                                          FStar_Syntax_Syntax.cattributes =
                                            [];
                                          FStar_Syntax_Syntax.mname = mname;
                                          FStar_Syntax_Syntax.univs = [];
                                          FStar_Syntax_Syntax.binders =
                                            binders1;
                                          FStar_Syntax_Syntax.signature =
                                            eff_t1;
                                          FStar_Syntax_Syntax.ret_wp =
                                            dummy_tscheme;
                                          FStar_Syntax_Syntax.bind_wp =
                                            dummy_tscheme;
                                          FStar_Syntax_Syntax.if_then_else =
                                            dummy_tscheme;
                                          FStar_Syntax_Syntax.ite_wp =
                                            dummy_tscheme;
                                          FStar_Syntax_Syntax.stronger =
                                            dummy_tscheme;
                                          FStar_Syntax_Syntax.close_wp =
                                            dummy_tscheme;
                                          FStar_Syntax_Syntax.assert_p =
                                            dummy_tscheme;
                                          FStar_Syntax_Syntax.assume_p =
                                            dummy_tscheme;
                                          FStar_Syntax_Syntax.null_wp =
                                            dummy_tscheme;
                                          FStar_Syntax_Syntax.trivial =
                                            dummy_tscheme;
                                          FStar_Syntax_Syntax.repr =
                                            uu____21762;
                                          FStar_Syntax_Syntax.return_repr =
                                            uu____21772;
                                          FStar_Syntax_Syntax.bind_repr =
                                            uu____21773;
                                          FStar_Syntax_Syntax.actions =
                                            actions1;
                                          FStar_Syntax_Syntax.eff_attrs =
                                            uu____21774
                                        }  in
                                      FStar_Syntax_Syntax.Sig_new_effect_for_free
                                        uu____21761
                                       in
                                    {
                                      FStar_Syntax_Syntax.sigel = uu____21760;
                                      FStar_Syntax_Syntax.sigrng =
                                        (d.FStar_Parser_AST.drange);
                                      FStar_Syntax_Syntax.sigquals =
                                        qualifiers;
                                      FStar_Syntax_Syntax.sigmeta =
                                        FStar_Syntax_Syntax.default_sigmeta;
                                      FStar_Syntax_Syntax.sigattrs = []
                                    }
                                  else
                                    (let rr =
                                       FStar_Util.for_some
                                         (fun uu___254_21780  ->
                                            match uu___254_21780 with
                                            | FStar_Syntax_Syntax.Reifiable 
                                                -> true
                                            | FStar_Syntax_Syntax.Reflectable
                                                uu____21781 -> true
                                            | uu____21782 -> false)
                                         qualifiers
                                        in
                                     let un_ts =
                                       ([], FStar_Syntax_Syntax.tun)  in
                                     let uu____21796 =
                                       let uu____21797 =
                                         let uu____21798 =
                                           lookup1 "return_wp"  in
                                         let uu____21799 = lookup1 "bind_wp"
                                            in
                                         let uu____21800 =
                                           lookup1 "if_then_else"  in
                                         let uu____21801 = lookup1 "ite_wp"
                                            in
                                         let uu____21802 = lookup1 "stronger"
                                            in
                                         let uu____21803 = lookup1 "close_wp"
                                            in
                                         let uu____21804 = lookup1 "assert_p"
                                            in
                                         let uu____21805 = lookup1 "assume_p"
                                            in
                                         let uu____21806 = lookup1 "null_wp"
                                            in
                                         let uu____21807 = lookup1 "trivial"
                                            in
                                         let uu____21808 =
                                           if rr
                                           then
                                             let uu____21809 = lookup1 "repr"
                                                in
                                             FStar_All.pipe_left
                                               FStar_Pervasives_Native.snd
                                               uu____21809
                                           else FStar_Syntax_Syntax.tun  in
                                         let uu____21825 =
                                           if rr
                                           then lookup1 "return"
                                           else un_ts  in
                                         let uu____21827 =
                                           if rr
                                           then lookup1 "bind"
                                           else un_ts  in
                                         let uu____21829 =
                                           FStar_List.map (desugar_term env2)
                                             attrs
                                            in
                                         {
                                           FStar_Syntax_Syntax.cattributes =
                                             [];
                                           FStar_Syntax_Syntax.mname = mname;
                                           FStar_Syntax_Syntax.univs = [];
                                           FStar_Syntax_Syntax.binders =
                                             binders1;
                                           FStar_Syntax_Syntax.signature =
                                             eff_t1;
                                           FStar_Syntax_Syntax.ret_wp =
                                             uu____21798;
                                           FStar_Syntax_Syntax.bind_wp =
                                             uu____21799;
                                           FStar_Syntax_Syntax.if_then_else =
                                             uu____21800;
                                           FStar_Syntax_Syntax.ite_wp =
                                             uu____21801;
                                           FStar_Syntax_Syntax.stronger =
                                             uu____21802;
                                           FStar_Syntax_Syntax.close_wp =
                                             uu____21803;
                                           FStar_Syntax_Syntax.assert_p =
                                             uu____21804;
                                           FStar_Syntax_Syntax.assume_p =
                                             uu____21805;
                                           FStar_Syntax_Syntax.null_wp =
                                             uu____21806;
                                           FStar_Syntax_Syntax.trivial =
                                             uu____21807;
                                           FStar_Syntax_Syntax.repr =
                                             uu____21808;
                                           FStar_Syntax_Syntax.return_repr =
                                             uu____21825;
                                           FStar_Syntax_Syntax.bind_repr =
                                             uu____21827;
                                           FStar_Syntax_Syntax.actions =
                                             actions1;
                                           FStar_Syntax_Syntax.eff_attrs =
                                             uu____21829
                                         }  in
                                       FStar_Syntax_Syntax.Sig_new_effect
                                         uu____21797
                                        in
                                     {
                                       FStar_Syntax_Syntax.sigel =
                                         uu____21796;
                                       FStar_Syntax_Syntax.sigrng =
                                         (d.FStar_Parser_AST.drange);
                                       FStar_Syntax_Syntax.sigquals =
                                         qualifiers;
                                       FStar_Syntax_Syntax.sigmeta =
                                         FStar_Syntax_Syntax.default_sigmeta;
                                       FStar_Syntax_Syntax.sigattrs = []
                                     })
                                   in
                                let env3 =
                                  FStar_Syntax_DsEnv.push_sigelt env0 se  in
                                let env4 =
                                  FStar_Syntax_DsEnv.push_doc env3 mname
                                    d.FStar_Parser_AST.doc
                                   in
                                let env5 =
                                  FStar_All.pipe_right actions_docs
                                    (FStar_List.fold_left
                                       (fun env5  ->
                                          fun uu____21855  ->
                                            match uu____21855 with
                                            | (a,doc1) ->
                                                let env6 =
                                                  let uu____21869 =
                                                    FStar_Syntax_Util.action_as_lb
                                                      mname a
                                                      (a.FStar_Syntax_Syntax.action_defn).FStar_Syntax_Syntax.pos
                                                     in
                                                  FStar_Syntax_DsEnv.push_sigelt
                                                    env5 uu____21869
                                                   in
                                                FStar_Syntax_DsEnv.push_doc
                                                  env6
                                                  a.FStar_Syntax_Syntax.action_name
                                                  doc1) env4)
                                   in
                                let env6 =
                                  push_reflect_effect env5 qualifiers mname
                                    d.FStar_Parser_AST.drange
                                   in
                                let env7 =
                                  FStar_Syntax_DsEnv.push_doc env6 mname
                                    d.FStar_Parser_AST.doc
                                   in
                                (env7, [se])))

and (desugar_redefine_effect :
  FStar_Syntax_DsEnv.env ->
    FStar_Parser_AST.decl ->
      (FStar_Ident.lident FStar_Pervasives_Native.option ->
         FStar_Parser_AST.qualifier -> FStar_Syntax_Syntax.qualifier)
        ->
        FStar_Parser_AST.qualifier Prims.list ->
          FStar_Ident.ident ->
            FStar_Parser_AST.binder Prims.list ->
              FStar_Parser_AST.term ->
                (FStar_Syntax_DsEnv.env,FStar_Syntax_Syntax.sigelt Prims.list)
                  FStar_Pervasives_Native.tuple2)
  =
  fun env  ->
    fun d  ->
      fun trans_qual1  ->
        fun quals  ->
          fun eff_name  ->
            fun eff_binders  ->
              fun defn  ->
                let env0 = env  in
                let env1 = FStar_Syntax_DsEnv.enter_monad_scope env eff_name
                   in
                let uu____21893 = desugar_binders env1 eff_binders  in
                match uu____21893 with
                | (env2,binders) ->
                    let uu____21924 =
                      let uu____21935 = head_and_args defn  in
                      match uu____21935 with
                      | (head1,args) ->
                          let lid =
                            match head1.FStar_Parser_AST.tm with
                            | FStar_Parser_AST.Name l -> l
                            | uu____21972 ->
                                let uu____21973 =
                                  let uu____21978 =
                                    let uu____21979 =
                                      let uu____21980 =
                                        FStar_Parser_AST.term_to_string head1
                                         in
                                      Prims.strcat uu____21980 " not found"
                                       in
                                    Prims.strcat "Effect " uu____21979  in
                                  (FStar_Errors.Fatal_EffectNotFound,
                                    uu____21978)
                                   in
                                FStar_Errors.raise_error uu____21973
                                  d.FStar_Parser_AST.drange
                             in
                          let ed =
                            FStar_Syntax_DsEnv.fail_or env2
                              (FStar_Syntax_DsEnv.try_lookup_effect_defn env2)
                              lid
                             in
                          let uu____21982 =
                            match FStar_List.rev args with
                            | (last_arg,uu____22012)::args_rev ->
                                let uu____22024 =
                                  let uu____22025 = unparen last_arg  in
                                  uu____22025.FStar_Parser_AST.tm  in
                                (match uu____22024 with
                                 | FStar_Parser_AST.Attributes ts ->
                                     (ts, (FStar_List.rev args_rev))
                                 | uu____22053 -> ([], args))
                            | uu____22062 -> ([], args)  in
                          (match uu____21982 with
                           | (cattributes,args1) ->
                               let uu____22105 = desugar_args env2 args1  in
                               let uu____22106 =
                                 desugar_attributes env2 cattributes  in
                               (lid, ed, uu____22105, uu____22106))
                       in
                    (match uu____21924 with
                     | (ed_lid,ed,args,cattributes) ->
                         let binders1 =
                           FStar_Syntax_Subst.close_binders binders  in
                         (if
                            (FStar_List.length args) <>
                              (FStar_List.length
                                 ed.FStar_Syntax_Syntax.binders)
                          then
                            FStar_Errors.raise_error
                              (FStar_Errors.Fatal_ArgumentLengthMismatch,
                                "Unexpected number of arguments to effect constructor")
                              defn.FStar_Parser_AST.range
                          else ();
                          (let uu____22138 =
                             FStar_Syntax_Subst.open_term'
                               ed.FStar_Syntax_Syntax.binders
                               FStar_Syntax_Syntax.t_unit
                              in
                           match uu____22138 with
                           | (ed_binders,uu____22152,ed_binders_opening) ->
                               let sub1 uu____22165 =
                                 match uu____22165 with
                                 | (us,x) ->
                                     let x1 =
                                       let uu____22179 =
                                         FStar_Syntax_Subst.shift_subst
                                           (FStar_List.length us)
                                           ed_binders_opening
                                          in
                                       FStar_Syntax_Subst.subst uu____22179 x
                                        in
                                     let s =
                                       FStar_Syntax_Util.subst_of_list
                                         ed_binders args
                                        in
                                     let uu____22183 =
                                       let uu____22184 =
                                         FStar_Syntax_Subst.subst s x1  in
                                       (us, uu____22184)  in
                                     FStar_Syntax_Subst.close_tscheme
                                       binders1 uu____22183
                                  in
                               let mname =
                                 FStar_Syntax_DsEnv.qualify env0 eff_name  in
                               let ed1 =
                                 let uu____22193 =
                                   let uu____22194 =
                                     sub1
                                       ([],
                                         (ed.FStar_Syntax_Syntax.signature))
                                      in
                                   FStar_Pervasives_Native.snd uu____22194
                                    in
                                 let uu____22209 =
                                   sub1 ed.FStar_Syntax_Syntax.ret_wp  in
                                 let uu____22210 =
                                   sub1 ed.FStar_Syntax_Syntax.bind_wp  in
                                 let uu____22211 =
                                   sub1 ed.FStar_Syntax_Syntax.if_then_else
                                    in
                                 let uu____22212 =
                                   sub1 ed.FStar_Syntax_Syntax.ite_wp  in
                                 let uu____22213 =
                                   sub1 ed.FStar_Syntax_Syntax.stronger  in
                                 let uu____22214 =
                                   sub1 ed.FStar_Syntax_Syntax.close_wp  in
                                 let uu____22215 =
                                   sub1 ed.FStar_Syntax_Syntax.assert_p  in
                                 let uu____22216 =
                                   sub1 ed.FStar_Syntax_Syntax.assume_p  in
                                 let uu____22217 =
                                   sub1 ed.FStar_Syntax_Syntax.null_wp  in
                                 let uu____22218 =
                                   sub1 ed.FStar_Syntax_Syntax.trivial  in
                                 let uu____22219 =
                                   let uu____22220 =
                                     sub1 ([], (ed.FStar_Syntax_Syntax.repr))
                                      in
                                   FStar_Pervasives_Native.snd uu____22220
                                    in
                                 let uu____22235 =
                                   sub1 ed.FStar_Syntax_Syntax.return_repr
                                    in
                                 let uu____22236 =
                                   sub1 ed.FStar_Syntax_Syntax.bind_repr  in
                                 let uu____22237 =
                                   FStar_List.map
                                     (fun action  ->
                                        let uu____22245 =
                                          FStar_Syntax_DsEnv.qualify env2
                                            action.FStar_Syntax_Syntax.action_unqualified_name
                                           in
                                        let uu____22246 =
                                          let uu____22247 =
                                            sub1
                                              ([],
                                                (action.FStar_Syntax_Syntax.action_defn))
                                             in
                                          FStar_Pervasives_Native.snd
                                            uu____22247
                                           in
                                        let uu____22262 =
                                          let uu____22263 =
                                            sub1
                                              ([],
                                                (action.FStar_Syntax_Syntax.action_typ))
                                             in
                                          FStar_Pervasives_Native.snd
                                            uu____22263
                                           in
                                        {
                                          FStar_Syntax_Syntax.action_name =
                                            uu____22245;
                                          FStar_Syntax_Syntax.action_unqualified_name
                                            =
                                            (action.FStar_Syntax_Syntax.action_unqualified_name);
                                          FStar_Syntax_Syntax.action_univs =
                                            (action.FStar_Syntax_Syntax.action_univs);
                                          FStar_Syntax_Syntax.action_params =
                                            (action.FStar_Syntax_Syntax.action_params);
                                          FStar_Syntax_Syntax.action_defn =
                                            uu____22246;
                                          FStar_Syntax_Syntax.action_typ =
                                            uu____22262
                                        }) ed.FStar_Syntax_Syntax.actions
                                    in
                                 {
                                   FStar_Syntax_Syntax.cattributes =
                                     cattributes;
                                   FStar_Syntax_Syntax.mname = mname;
                                   FStar_Syntax_Syntax.univs =
                                     (ed.FStar_Syntax_Syntax.univs);
                                   FStar_Syntax_Syntax.binders = binders1;
                                   FStar_Syntax_Syntax.signature =
                                     uu____22193;
                                   FStar_Syntax_Syntax.ret_wp = uu____22209;
                                   FStar_Syntax_Syntax.bind_wp = uu____22210;
                                   FStar_Syntax_Syntax.if_then_else =
                                     uu____22211;
                                   FStar_Syntax_Syntax.ite_wp = uu____22212;
                                   FStar_Syntax_Syntax.stronger = uu____22213;
                                   FStar_Syntax_Syntax.close_wp = uu____22214;
                                   FStar_Syntax_Syntax.assert_p = uu____22215;
                                   FStar_Syntax_Syntax.assume_p = uu____22216;
                                   FStar_Syntax_Syntax.null_wp = uu____22217;
                                   FStar_Syntax_Syntax.trivial = uu____22218;
                                   FStar_Syntax_Syntax.repr = uu____22219;
                                   FStar_Syntax_Syntax.return_repr =
                                     uu____22235;
                                   FStar_Syntax_Syntax.bind_repr =
                                     uu____22236;
                                   FStar_Syntax_Syntax.actions = uu____22237;
                                   FStar_Syntax_Syntax.eff_attrs =
                                     (ed.FStar_Syntax_Syntax.eff_attrs)
                                 }  in
                               let se =
                                 let for_free =
                                   let uu____22280 =
                                     let uu____22281 =
                                       let uu____22288 =
                                         FStar_Syntax_Util.arrow_formals
                                           ed1.FStar_Syntax_Syntax.signature
                                          in
                                       FStar_Pervasives_Native.fst
                                         uu____22288
                                        in
                                     FStar_List.length uu____22281  in
                                   uu____22280 = (Prims.parse_int "1")  in
                                 let uu____22313 =
                                   let uu____22316 =
                                     trans_qual1
                                       (FStar_Pervasives_Native.Some mname)
                                      in
                                   FStar_List.map uu____22316 quals  in
                                 {
                                   FStar_Syntax_Syntax.sigel =
                                     (if for_free
                                      then
                                        FStar_Syntax_Syntax.Sig_new_effect_for_free
                                          ed1
                                      else
                                        FStar_Syntax_Syntax.Sig_new_effect
                                          ed1);
                                   FStar_Syntax_Syntax.sigrng =
                                     (d.FStar_Parser_AST.drange);
                                   FStar_Syntax_Syntax.sigquals = uu____22313;
                                   FStar_Syntax_Syntax.sigmeta =
                                     FStar_Syntax_Syntax.default_sigmeta;
                                   FStar_Syntax_Syntax.sigattrs = []
                                 }  in
                               let monad_env = env2  in
                               let env3 =
                                 FStar_Syntax_DsEnv.push_sigelt env0 se  in
                               let env4 =
                                 FStar_Syntax_DsEnv.push_doc env3 ed_lid
                                   d.FStar_Parser_AST.doc
                                  in
                               let env5 =
                                 FStar_All.pipe_right
                                   ed1.FStar_Syntax_Syntax.actions
                                   (FStar_List.fold_left
                                      (fun env5  ->
                                         fun a  ->
                                           let doc1 =
                                             FStar_Syntax_DsEnv.try_lookup_doc
                                               env5
                                               a.FStar_Syntax_Syntax.action_name
                                              in
                                           let env6 =
                                             let uu____22338 =
                                               FStar_Syntax_Util.action_as_lb
                                                 mname a
                                                 (a.FStar_Syntax_Syntax.action_defn).FStar_Syntax_Syntax.pos
                                                in
                                             FStar_Syntax_DsEnv.push_sigelt
                                               env5 uu____22338
                                              in
                                           FStar_Syntax_DsEnv.push_doc env6
                                             a.FStar_Syntax_Syntax.action_name
                                             doc1) env4)
                                  in
                               let env6 =
                                 let uu____22340 =
                                   FStar_All.pipe_right quals
                                     (FStar_List.contains
                                        FStar_Parser_AST.Reflectable)
                                    in
                                 if uu____22340
                                 then
                                   let reflect_lid =
                                     let uu____22344 =
                                       FStar_Ident.id_of_text "reflect"  in
                                     FStar_All.pipe_right uu____22344
                                       (FStar_Syntax_DsEnv.qualify monad_env)
                                      in
                                   let quals1 =
                                     [FStar_Syntax_Syntax.Assumption;
                                     FStar_Syntax_Syntax.Reflectable mname]
                                      in
                                   let refl_decl =
                                     {
                                       FStar_Syntax_Syntax.sigel =
                                         (FStar_Syntax_Syntax.Sig_declare_typ
                                            (reflect_lid, [],
                                              FStar_Syntax_Syntax.tun));
                                       FStar_Syntax_Syntax.sigrng =
                                         (d.FStar_Parser_AST.drange);
                                       FStar_Syntax_Syntax.sigquals = quals1;
                                       FStar_Syntax_Syntax.sigmeta =
                                         FStar_Syntax_Syntax.default_sigmeta;
                                       FStar_Syntax_Syntax.sigattrs = []
                                     }  in
                                   FStar_Syntax_DsEnv.push_sigelt env5
                                     refl_decl
                                 else env5  in
                               let env7 =
                                 FStar_Syntax_DsEnv.push_doc env6 mname
                                   d.FStar_Parser_AST.doc
                                  in
                               (env7, [se]))))

and (mk_comment_attr :
  FStar_Parser_AST.decl ->
    FStar_Syntax_Syntax.term' FStar_Syntax_Syntax.syntax)
  =
  fun d  ->
    let uu____22354 =
      match d.FStar_Parser_AST.doc with
      | FStar_Pervasives_Native.None  -> ("", [])
      | FStar_Pervasives_Native.Some fsdoc -> fsdoc  in
    match uu____22354 with
    | (text,kv) ->
        let summary =
          match FStar_List.assoc "summary" kv with
          | FStar_Pervasives_Native.None  -> ""
          | FStar_Pervasives_Native.Some s ->
              Prims.strcat "  " (Prims.strcat s "\n")
           in
        let pp =
          match FStar_List.assoc "type" kv with
          | FStar_Pervasives_Native.Some uu____22405 ->
              let uu____22406 =
                let uu____22407 =
                  FStar_Parser_ToDocument.signature_to_document d  in
                FStar_Pprint.pretty_string 0.95 (Prims.parse_int "80")
                  uu____22407
                 in
              Prims.strcat "\n  " uu____22406
          | uu____22408 -> ""  in
        let other =
          FStar_List.filter_map
            (fun uu____22421  ->
               match uu____22421 with
               | (k,v1) ->
                   if (k <> "summary") && (k <> "type")
                   then
                     FStar_Pervasives_Native.Some
                       (Prims.strcat k (Prims.strcat ": " v1))
                   else FStar_Pervasives_Native.None) kv
           in
        let other1 =
          if other <> []
          then Prims.strcat (FStar_String.concat "\n" other) "\n"
          else ""  in
        let str =
          Prims.strcat summary (Prims.strcat pp (Prims.strcat other1 text))
           in
        let fv =
          let uu____22439 = FStar_Ident.lid_of_str "FStar.Pervasives.Comment"
             in
          FStar_Syntax_Syntax.fvar uu____22439
            FStar_Syntax_Syntax.delta_constant FStar_Pervasives_Native.None
           in
        let arg = FStar_Syntax_Util.exp_string str  in
        let uu____22441 =
          let uu____22450 = FStar_Syntax_Syntax.as_arg arg  in [uu____22450]
           in
        FStar_Syntax_Util.mk_app fv uu____22441

and (desugar_decl_aux :
  env_t ->
    FStar_Parser_AST.decl ->
      (env_t,FStar_Syntax_Syntax.sigelts) FStar_Pervasives_Native.tuple2)
  =
  fun env  ->
    fun d  ->
      let uu____22475 = desugar_decl_noattrs env d  in
      match uu____22475 with
      | (env1,sigelts) ->
          let attrs = d.FStar_Parser_AST.attrs  in
          let attrs1 = FStar_List.map (desugar_term env1) attrs  in
          let attrs2 =
            let uu____22493 = mk_comment_attr d  in uu____22493 :: attrs1  in
          let uu____22494 =
            FStar_List.mapi
              (fun i  ->
                 fun sigelt  ->
                   if i = (Prims.parse_int "0")
                   then
                     let uu___289_22500 = sigelt  in
                     {
                       FStar_Syntax_Syntax.sigel =
                         (uu___289_22500.FStar_Syntax_Syntax.sigel);
                       FStar_Syntax_Syntax.sigrng =
                         (uu___289_22500.FStar_Syntax_Syntax.sigrng);
                       FStar_Syntax_Syntax.sigquals =
                         (uu___289_22500.FStar_Syntax_Syntax.sigquals);
                       FStar_Syntax_Syntax.sigmeta =
                         (uu___289_22500.FStar_Syntax_Syntax.sigmeta);
                       FStar_Syntax_Syntax.sigattrs = attrs2
                     }
                   else
                     (let uu___290_22502 = sigelt  in
                      let uu____22503 =
                        FStar_List.filter
                          (fun at1  ->
                             let uu____22509 = get_fail_attr false at1  in
                             FStar_Option.isNone uu____22509) attrs2
                         in
                      {
                        FStar_Syntax_Syntax.sigel =
                          (uu___290_22502.FStar_Syntax_Syntax.sigel);
                        FStar_Syntax_Syntax.sigrng =
                          (uu___290_22502.FStar_Syntax_Syntax.sigrng);
                        FStar_Syntax_Syntax.sigquals =
                          (uu___290_22502.FStar_Syntax_Syntax.sigquals);
                        FStar_Syntax_Syntax.sigmeta =
                          (uu___290_22502.FStar_Syntax_Syntax.sigmeta);
                        FStar_Syntax_Syntax.sigattrs = uu____22503
                      })) sigelts
             in
          (env1, uu____22494)

and (desugar_decl :
  env_t ->
    FStar_Parser_AST.decl ->
      (env_t,FStar_Syntax_Syntax.sigelts) FStar_Pervasives_Native.tuple2)
  =
  fun env  ->
    fun d  ->
      let uu____22530 = desugar_decl_aux env d  in
      match uu____22530 with
      | (env1,ses) ->
          let uu____22541 =
            FStar_All.pipe_right ses
              (FStar_List.map generalize_annotated_univs)
             in
          (env1, uu____22541)

and (desugar_decl_noattrs :
  env_t ->
    FStar_Parser_AST.decl ->
      (env_t,FStar_Syntax_Syntax.sigelts) FStar_Pervasives_Native.tuple2)
  =
  fun env  ->
    fun d  ->
      let trans_qual1 = trans_qual d.FStar_Parser_AST.drange  in
      match d.FStar_Parser_AST.d with
      | FStar_Parser_AST.Pragma p ->
          let p1 = trans_pragma p  in
          (FStar_Syntax_Util.process_pragma p1 d.FStar_Parser_AST.drange;
           (let se =
              {
                FStar_Syntax_Syntax.sigel =
                  (FStar_Syntax_Syntax.Sig_pragma p1);
                FStar_Syntax_Syntax.sigrng = (d.FStar_Parser_AST.drange);
                FStar_Syntax_Syntax.sigquals = [];
                FStar_Syntax_Syntax.sigmeta =
                  FStar_Syntax_Syntax.default_sigmeta;
                FStar_Syntax_Syntax.sigattrs = []
              }  in
            (env, [se])))
      | FStar_Parser_AST.Fsdoc uu____22569 -> (env, [])
      | FStar_Parser_AST.TopLevelModule id1 -> (env, [])
      | FStar_Parser_AST.Open lid ->
          let env1 = FStar_Syntax_DsEnv.push_namespace env lid  in (env1, [])
      | FStar_Parser_AST.Include lid ->
          let env1 = FStar_Syntax_DsEnv.push_include env lid  in (env1, [])
      | FStar_Parser_AST.ModuleAbbrev (x,l) ->
          let uu____22577 = FStar_Syntax_DsEnv.push_module_abbrev env x l  in
          (uu____22577, [])
      | FStar_Parser_AST.Tycon (is_effect,tcs) ->
          let quals =
            if is_effect
            then FStar_Parser_AST.Effect_qual :: (d.FStar_Parser_AST.quals)
            else d.FStar_Parser_AST.quals  in
          let tcs1 =
            FStar_List.map
              (fun uu____22614  ->
                 match uu____22614 with | (x,uu____22622) -> x) tcs
             in
          let uu____22627 =
            FStar_List.map (trans_qual1 FStar_Pervasives_Native.None) quals
             in
          desugar_tycon env d uu____22627 tcs1
      | FStar_Parser_AST.TopLevelLet (isrec,lets) ->
          let quals = d.FStar_Parser_AST.quals  in
          let expand_toplevel_pattern =
            (isrec = FStar_Parser_AST.NoLetQualifier) &&
              (match lets with
               | ({
                    FStar_Parser_AST.pat = FStar_Parser_AST.PatOp uu____22649;
                    FStar_Parser_AST.prange = uu____22650;_},uu____22651)::[]
                   -> false
               | ({
                    FStar_Parser_AST.pat = FStar_Parser_AST.PatVar
                      uu____22660;
                    FStar_Parser_AST.prange = uu____22661;_},uu____22662)::[]
                   -> false
               | ({
                    FStar_Parser_AST.pat = FStar_Parser_AST.PatAscribed
                      ({
                         FStar_Parser_AST.pat = FStar_Parser_AST.PatVar
                           uu____22677;
                         FStar_Parser_AST.prange = uu____22678;_},uu____22679);
                    FStar_Parser_AST.prange = uu____22680;_},uu____22681)::[]
                   -> false
               | (p,uu____22709)::[] ->
                   let uu____22718 = is_app_pattern p  in
                   Prims.op_Negation uu____22718
               | uu____22719 -> false)
             in
          if Prims.op_Negation expand_toplevel_pattern
          then
            let lets1 =
              FStar_List.map (fun x  -> (FStar_Pervasives_Native.None, x))
                lets
               in
            let as_inner_let =
              FStar_Parser_AST.mk_term
                (FStar_Parser_AST.Let
                   (isrec, lets1,
                     (FStar_Parser_AST.mk_term
                        (FStar_Parser_AST.Const FStar_Const.Const_unit)
                        d.FStar_Parser_AST.drange FStar_Parser_AST.Expr)))
                d.FStar_Parser_AST.drange FStar_Parser_AST.Expr
               in
            let uu____22792 = desugar_term_maybe_top true env as_inner_let
               in
            (match uu____22792 with
             | (ds_lets,aq) ->
                 (check_no_aq aq;
                  (let uu____22804 =
                     let uu____22805 =
                       FStar_All.pipe_left FStar_Syntax_Subst.compress
                         ds_lets
                        in
                     uu____22805.FStar_Syntax_Syntax.n  in
                   match uu____22804 with
                   | FStar_Syntax_Syntax.Tm_let (lbs,uu____22815) ->
                       let fvs =
                         FStar_All.pipe_right
                           (FStar_Pervasives_Native.snd lbs)
                           (FStar_List.map
                              (fun lb  ->
                                 FStar_Util.right
                                   lb.FStar_Syntax_Syntax.lbname))
                          in
                       let quals1 =
                         match quals with
                         | uu____22848::uu____22849 ->
                             FStar_List.map
                               (trans_qual1 FStar_Pervasives_Native.None)
                               quals
                         | uu____22852 ->
                             FStar_All.pipe_right
                               (FStar_Pervasives_Native.snd lbs)
                               (FStar_List.collect
                                  (fun uu___255_22867  ->
                                     match uu___255_22867 with
                                     | {
                                         FStar_Syntax_Syntax.lbname =
                                           FStar_Util.Inl uu____22870;
                                         FStar_Syntax_Syntax.lbunivs =
                                           uu____22871;
                                         FStar_Syntax_Syntax.lbtyp =
                                           uu____22872;
                                         FStar_Syntax_Syntax.lbeff =
                                           uu____22873;
                                         FStar_Syntax_Syntax.lbdef =
                                           uu____22874;
                                         FStar_Syntax_Syntax.lbattrs =
                                           uu____22875;
                                         FStar_Syntax_Syntax.lbpos =
                                           uu____22876;_}
                                         -> []
                                     | {
                                         FStar_Syntax_Syntax.lbname =
                                           FStar_Util.Inr fv;
                                         FStar_Syntax_Syntax.lbunivs =
                                           uu____22888;
                                         FStar_Syntax_Syntax.lbtyp =
                                           uu____22889;
                                         FStar_Syntax_Syntax.lbeff =
                                           uu____22890;
                                         FStar_Syntax_Syntax.lbdef =
                                           uu____22891;
                                         FStar_Syntax_Syntax.lbattrs =
                                           uu____22892;
                                         FStar_Syntax_Syntax.lbpos =
                                           uu____22893;_}
                                         ->
                                         FStar_Syntax_DsEnv.lookup_letbinding_quals
                                           env
                                           (fv.FStar_Syntax_Syntax.fv_name).FStar_Syntax_Syntax.v))
                          in
                       let quals2 =
                         let uu____22907 =
                           FStar_All.pipe_right lets1
                             (FStar_Util.for_some
                                (fun uu____22938  ->
                                   match uu____22938 with
                                   | (uu____22951,(uu____22952,t)) ->
                                       t.FStar_Parser_AST.level =
                                         FStar_Parser_AST.Formula))
                            in
                         if uu____22907
                         then FStar_Syntax_Syntax.Logic :: quals1
                         else quals1  in
                       let lbs1 =
                         let uu____22970 =
                           FStar_All.pipe_right quals2
                             (FStar_List.contains
                                FStar_Syntax_Syntax.Abstract)
                            in
                         if uu____22970
                         then
                           let uu____22973 =
                             FStar_All.pipe_right
                               (FStar_Pervasives_Native.snd lbs)
                               (FStar_List.map
                                  (fun lb  ->
                                     let fv =
                                       FStar_Util.right
                                         lb.FStar_Syntax_Syntax.lbname
                                        in
                                     let uu___291_22987 = lb  in
                                     {
                                       FStar_Syntax_Syntax.lbname =
                                         (FStar_Util.Inr
                                            (let uu___292_22989 = fv  in
                                             {
                                               FStar_Syntax_Syntax.fv_name =
                                                 (uu___292_22989.FStar_Syntax_Syntax.fv_name);
                                               FStar_Syntax_Syntax.fv_delta =
                                                 (FStar_Syntax_Syntax.Delta_abstract
                                                    (fv.FStar_Syntax_Syntax.fv_delta));
                                               FStar_Syntax_Syntax.fv_qual =
                                                 (uu___292_22989.FStar_Syntax_Syntax.fv_qual)
                                             }));
                                       FStar_Syntax_Syntax.lbunivs =
                                         (uu___291_22987.FStar_Syntax_Syntax.lbunivs);
                                       FStar_Syntax_Syntax.lbtyp =
                                         (uu___291_22987.FStar_Syntax_Syntax.lbtyp);
                                       FStar_Syntax_Syntax.lbeff =
                                         (uu___291_22987.FStar_Syntax_Syntax.lbeff);
                                       FStar_Syntax_Syntax.lbdef =
                                         (uu___291_22987.FStar_Syntax_Syntax.lbdef);
                                       FStar_Syntax_Syntax.lbattrs =
                                         (uu___291_22987.FStar_Syntax_Syntax.lbattrs);
                                       FStar_Syntax_Syntax.lbpos =
                                         (uu___291_22987.FStar_Syntax_Syntax.lbpos)
                                     }))
                              in
                           ((FStar_Pervasives_Native.fst lbs), uu____22973)
                         else lbs  in
                       let names1 =
                         FStar_All.pipe_right fvs
                           (FStar_List.map
                              (fun fv  ->
                                 (fv.FStar_Syntax_Syntax.fv_name).FStar_Syntax_Syntax.v))
                          in
                       let attrs =
                         FStar_List.map (desugar_term env)
                           d.FStar_Parser_AST.attrs
                          in
                       let s =
                         {
                           FStar_Syntax_Syntax.sigel =
                             (FStar_Syntax_Syntax.Sig_let (lbs1, names1));
                           FStar_Syntax_Syntax.sigrng =
                             (d.FStar_Parser_AST.drange);
                           FStar_Syntax_Syntax.sigquals = quals2;
                           FStar_Syntax_Syntax.sigmeta =
                             FStar_Syntax_Syntax.default_sigmeta;
                           FStar_Syntax_Syntax.sigattrs = attrs
                         }  in
                       let env1 = FStar_Syntax_DsEnv.push_sigelt env s  in
                       let env2 =
                         FStar_List.fold_left
                           (fun env2  ->
                              fun id1  ->
                                FStar_Syntax_DsEnv.push_doc env2 id1
                                  d.FStar_Parser_AST.doc) env1 names1
                          in
                       (env2, [s])
                   | uu____23016 ->
                       failwith "Desugaring a let did not produce a let")))
          else
            (let uu____23022 =
               match lets with
               | (pat,body)::[] -> (pat, body)
               | uu____23041 ->
                   failwith
                     "expand_toplevel_pattern should only allow single definition lets"
                in
             match uu____23022 with
             | (pat,body) ->
                 let fresh_toplevel_name =
                   FStar_Ident.gen FStar_Range.dummyRange  in
                 let fresh_pat =
                   let var_pat =
                     FStar_Parser_AST.mk_pattern
                       (FStar_Parser_AST.PatVar
                          (fresh_toplevel_name, FStar_Pervasives_Native.None))
                       FStar_Range.dummyRange
                      in
                   match pat.FStar_Parser_AST.pat with
                   | FStar_Parser_AST.PatAscribed (pat1,ty) ->
                       let uu___293_23077 = pat1  in
                       {
                         FStar_Parser_AST.pat =
                           (FStar_Parser_AST.PatAscribed (var_pat, ty));
                         FStar_Parser_AST.prange =
                           (uu___293_23077.FStar_Parser_AST.prange)
                       }
                   | uu____23084 -> var_pat  in
                 let main_let =
                   desugar_decl env
                     (let uu___294_23091 = d  in
                      {
                        FStar_Parser_AST.d =
                          (FStar_Parser_AST.TopLevelLet
                             (isrec, [(fresh_pat, body)]));
                        FStar_Parser_AST.drange =
                          (uu___294_23091.FStar_Parser_AST.drange);
                        FStar_Parser_AST.doc =
                          (uu___294_23091.FStar_Parser_AST.doc);
                        FStar_Parser_AST.quals = (FStar_Parser_AST.Private ::
                          (d.FStar_Parser_AST.quals));
                        FStar_Parser_AST.attrs =
                          (uu___294_23091.FStar_Parser_AST.attrs)
                      })
                    in
                 let build_projection uu____23127 id1 =
                   match uu____23127 with
                   | (env1,ses) ->
                       let main =
                         let uu____23148 =
                           let uu____23149 =
                             FStar_Ident.lid_of_ids [fresh_toplevel_name]  in
                           FStar_Parser_AST.Var uu____23149  in
                         FStar_Parser_AST.mk_term uu____23148
                           FStar_Range.dummyRange FStar_Parser_AST.Expr
                          in
                       let lid = FStar_Ident.lid_of_ids [id1]  in
                       let projectee =
                         FStar_Parser_AST.mk_term (FStar_Parser_AST.Var lid)
                           FStar_Range.dummyRange FStar_Parser_AST.Expr
                          in
                       let body1 =
                         FStar_Parser_AST.mk_term
                           (FStar_Parser_AST.Match
                              (main,
                                [(pat, FStar_Pervasives_Native.None,
                                   projectee)])) FStar_Range.dummyRange
                           FStar_Parser_AST.Expr
                          in
                       let bv_pat =
                         FStar_Parser_AST.mk_pattern
                           (FStar_Parser_AST.PatVar
                              (id1, FStar_Pervasives_Native.None))
                           FStar_Range.dummyRange
                          in
                       let id_decl =
                         FStar_Parser_AST.mk_decl
                           (FStar_Parser_AST.TopLevelLet
                              (FStar_Parser_AST.NoLetQualifier,
                                [(bv_pat, body1)])) FStar_Range.dummyRange []
                          in
                       let uu____23199 = desugar_decl env1 id_decl  in
                       (match uu____23199 with
                        | (env2,ses') -> (env2, (FStar_List.append ses ses')))
                    in
                 let bvs =
                   let uu____23217 = gather_pattern_bound_vars pat  in
                   FStar_All.pipe_right uu____23217 FStar_Util.set_elements
                    in
                 FStar_List.fold_left build_projection main_let bvs)
      | FStar_Parser_AST.Main t ->
          let e = desugar_term env t  in
          let se =
            {
              FStar_Syntax_Syntax.sigel = (FStar_Syntax_Syntax.Sig_main e);
              FStar_Syntax_Syntax.sigrng = (d.FStar_Parser_AST.drange);
              FStar_Syntax_Syntax.sigquals = [];
              FStar_Syntax_Syntax.sigmeta =
                FStar_Syntax_Syntax.default_sigmeta;
              FStar_Syntax_Syntax.sigattrs = []
            }  in
          (env, [se])
      | FStar_Parser_AST.Assume (id1,t) ->
          let f = desugar_formula env t  in
          let lid = FStar_Syntax_DsEnv.qualify env id1  in
          let env1 =
            FStar_Syntax_DsEnv.push_doc env lid d.FStar_Parser_AST.doc  in
          (env1,
            [{
               FStar_Syntax_Syntax.sigel =
                 (FStar_Syntax_Syntax.Sig_assume (lid, [], f));
               FStar_Syntax_Syntax.sigrng = (d.FStar_Parser_AST.drange);
               FStar_Syntax_Syntax.sigquals =
                 [FStar_Syntax_Syntax.Assumption];
               FStar_Syntax_Syntax.sigmeta =
                 FStar_Syntax_Syntax.default_sigmeta;
               FStar_Syntax_Syntax.sigattrs = []
             }])
      | FStar_Parser_AST.Val (id1,t) ->
          let quals = d.FStar_Parser_AST.quals  in
          let t1 =
            let uu____23240 = close_fun env t  in
            desugar_term env uu____23240  in
          let quals1 =
            let uu____23244 =
              (FStar_Syntax_DsEnv.iface env) &&
                (FStar_Syntax_DsEnv.admitted_iface env)
               in
            if uu____23244
            then FStar_Parser_AST.Assumption :: quals
            else quals  in
          let lid = FStar_Syntax_DsEnv.qualify env id1  in
          let se =
            let uu____23250 =
              FStar_List.map (trans_qual1 FStar_Pervasives_Native.None)
                quals1
               in
            {
              FStar_Syntax_Syntax.sigel =
                (FStar_Syntax_Syntax.Sig_declare_typ (lid, [], t1));
              FStar_Syntax_Syntax.sigrng = (d.FStar_Parser_AST.drange);
              FStar_Syntax_Syntax.sigquals = uu____23250;
              FStar_Syntax_Syntax.sigmeta =
                FStar_Syntax_Syntax.default_sigmeta;
              FStar_Syntax_Syntax.sigattrs = []
            }  in
          let env1 = FStar_Syntax_DsEnv.push_sigelt env se  in
          let env2 =
            FStar_Syntax_DsEnv.push_doc env1 lid d.FStar_Parser_AST.doc  in
          (env2, [se])
      | FStar_Parser_AST.Exception (id1,FStar_Pervasives_Native.None ) ->
          let uu____23258 =
            FStar_Syntax_DsEnv.fail_or env
              (FStar_Syntax_DsEnv.try_lookup_lid env)
              FStar_Parser_Const.exn_lid
             in
          (match uu____23258 with
           | (t,uu____23272) ->
               let l = FStar_Syntax_DsEnv.qualify env id1  in
               let qual = [FStar_Syntax_Syntax.ExceptionConstructor]  in
               let se =
                 {
                   FStar_Syntax_Syntax.sigel =
                     (FStar_Syntax_Syntax.Sig_datacon
                        (l, [], t, FStar_Parser_Const.exn_lid,
                          (Prims.parse_int "0"),
                          [FStar_Parser_Const.exn_lid]));
                   FStar_Syntax_Syntax.sigrng = (d.FStar_Parser_AST.drange);
                   FStar_Syntax_Syntax.sigquals = qual;
                   FStar_Syntax_Syntax.sigmeta =
                     FStar_Syntax_Syntax.default_sigmeta;
                   FStar_Syntax_Syntax.sigattrs = []
                 }  in
               let se' =
                 {
                   FStar_Syntax_Syntax.sigel =
                     (FStar_Syntax_Syntax.Sig_bundle ([se], [l]));
                   FStar_Syntax_Syntax.sigrng = (d.FStar_Parser_AST.drange);
                   FStar_Syntax_Syntax.sigquals = qual;
                   FStar_Syntax_Syntax.sigmeta =
                     FStar_Syntax_Syntax.default_sigmeta;
                   FStar_Syntax_Syntax.sigattrs = []
                 }  in
               let env1 = FStar_Syntax_DsEnv.push_sigelt env se'  in
               let env2 =
                 FStar_Syntax_DsEnv.push_doc env1 l d.FStar_Parser_AST.doc
                  in
               let data_ops = mk_data_projector_names [] env2 se  in
               let discs = mk_data_discriminators [] env2 [l]  in
               let env3 =
                 FStar_List.fold_left FStar_Syntax_DsEnv.push_sigelt env2
                   (FStar_List.append discs data_ops)
                  in
               (env3, (FStar_List.append (se' :: discs) data_ops)))
      | FStar_Parser_AST.Exception (id1,FStar_Pervasives_Native.Some term) ->
          let t = desugar_term env term  in
          let t1 =
            let uu____23302 =
              let uu____23309 = FStar_Syntax_Syntax.null_binder t  in
              [uu____23309]  in
            let uu____23322 =
              let uu____23325 =
                let uu____23326 =
                  FStar_Syntax_DsEnv.fail_or env
                    (FStar_Syntax_DsEnv.try_lookup_lid env)
                    FStar_Parser_Const.exn_lid
                   in
                FStar_Pervasives_Native.fst uu____23326  in
              FStar_All.pipe_left FStar_Syntax_Syntax.mk_Total uu____23325
               in
            FStar_Syntax_Util.arrow uu____23302 uu____23322  in
          let l = FStar_Syntax_DsEnv.qualify env id1  in
          let qual = [FStar_Syntax_Syntax.ExceptionConstructor]  in
          let se =
            {
              FStar_Syntax_Syntax.sigel =
                (FStar_Syntax_Syntax.Sig_datacon
                   (l, [], t1, FStar_Parser_Const.exn_lid,
                     (Prims.parse_int "0"), [FStar_Parser_Const.exn_lid]));
              FStar_Syntax_Syntax.sigrng = (d.FStar_Parser_AST.drange);
              FStar_Syntax_Syntax.sigquals = qual;
              FStar_Syntax_Syntax.sigmeta =
                FStar_Syntax_Syntax.default_sigmeta;
              FStar_Syntax_Syntax.sigattrs = []
            }  in
          let se' =
            {
              FStar_Syntax_Syntax.sigel =
                (FStar_Syntax_Syntax.Sig_bundle ([se], [l]));
              FStar_Syntax_Syntax.sigrng = (d.FStar_Parser_AST.drange);
              FStar_Syntax_Syntax.sigquals = qual;
              FStar_Syntax_Syntax.sigmeta =
                FStar_Syntax_Syntax.default_sigmeta;
              FStar_Syntax_Syntax.sigattrs = []
            }  in
          let env1 = FStar_Syntax_DsEnv.push_sigelt env se'  in
          let env2 =
            FStar_Syntax_DsEnv.push_doc env1 l d.FStar_Parser_AST.doc  in
          let data_ops = mk_data_projector_names [] env2 se  in
          let discs = mk_data_discriminators [] env2 [l]  in
          let env3 =
            FStar_List.fold_left FStar_Syntax_DsEnv.push_sigelt env2
              (FStar_List.append discs data_ops)
             in
          (env3, (FStar_List.append (se' :: discs) data_ops))
      | FStar_Parser_AST.NewEffect (FStar_Parser_AST.RedefineEffect
          (eff_name,eff_binders,defn)) ->
          let quals = d.FStar_Parser_AST.quals  in
          desugar_redefine_effect env d trans_qual1 quals eff_name
            eff_binders defn
      | FStar_Parser_AST.NewEffect (FStar_Parser_AST.DefineEffect
          (eff_name,eff_binders,eff_typ,eff_decls)) ->
          let quals = d.FStar_Parser_AST.quals  in
          let attrs = d.FStar_Parser_AST.attrs  in
          desugar_effect env d quals eff_name eff_binders eff_typ eff_decls
            attrs
      | FStar_Parser_AST.SubEffect l ->
          let lookup1 l1 =
            let uu____23387 =
              FStar_Syntax_DsEnv.try_lookup_effect_name env l1  in
            match uu____23387 with
            | FStar_Pervasives_Native.None  ->
                let uu____23390 =
                  let uu____23395 =
                    let uu____23396 =
                      let uu____23397 = FStar_Syntax_Print.lid_to_string l1
                         in
                      Prims.strcat uu____23397 " not found"  in
                    Prims.strcat "Effect name " uu____23396  in
                  (FStar_Errors.Fatal_EffectNotFound, uu____23395)  in
                FStar_Errors.raise_error uu____23390
                  d.FStar_Parser_AST.drange
            | FStar_Pervasives_Native.Some l2 -> l2  in
          let src = lookup1 l.FStar_Parser_AST.msource  in
          let dst = lookup1 l.FStar_Parser_AST.mdest  in
          let uu____23401 =
            match l.FStar_Parser_AST.lift_op with
            | FStar_Parser_AST.NonReifiableLift t ->
                let uu____23419 =
                  let uu____23422 =
                    let uu____23423 = desugar_term env t  in
                    ([], uu____23423)  in
                  FStar_Pervasives_Native.Some uu____23422  in
                (uu____23419, FStar_Pervasives_Native.None)
            | FStar_Parser_AST.ReifiableLift (wp,t) ->
                let uu____23436 =
                  let uu____23439 =
                    let uu____23440 = desugar_term env wp  in
                    ([], uu____23440)  in
                  FStar_Pervasives_Native.Some uu____23439  in
                let uu____23447 =
                  let uu____23450 =
                    let uu____23451 = desugar_term env t  in
                    ([], uu____23451)  in
                  FStar_Pervasives_Native.Some uu____23450  in
                (uu____23436, uu____23447)
            | FStar_Parser_AST.LiftForFree t ->
                let uu____23463 =
                  let uu____23466 =
                    let uu____23467 = desugar_term env t  in
                    ([], uu____23467)  in
                  FStar_Pervasives_Native.Some uu____23466  in
                (FStar_Pervasives_Native.None, uu____23463)
             in
          (match uu____23401 with
           | (lift_wp,lift) ->
               let se =
                 {
                   FStar_Syntax_Syntax.sigel =
                     (FStar_Syntax_Syntax.Sig_sub_effect
                        {
                          FStar_Syntax_Syntax.source = src;
                          FStar_Syntax_Syntax.target = dst;
                          FStar_Syntax_Syntax.lift_wp = lift_wp;
                          FStar_Syntax_Syntax.lift = lift
                        });
                   FStar_Syntax_Syntax.sigrng = (d.FStar_Parser_AST.drange);
                   FStar_Syntax_Syntax.sigquals = [];
                   FStar_Syntax_Syntax.sigmeta =
                     FStar_Syntax_Syntax.default_sigmeta;
                   FStar_Syntax_Syntax.sigattrs = []
                 }  in
               (env, [se]))
      | FStar_Parser_AST.Splice (ids,t) ->
          let t1 = desugar_term env t  in
          let se =
            let uu____23501 =
              let uu____23502 =
                let uu____23509 =
                  FStar_List.map (FStar_Syntax_DsEnv.qualify env) ids  in
                (uu____23509, t1)  in
              FStar_Syntax_Syntax.Sig_splice uu____23502  in
            {
              FStar_Syntax_Syntax.sigel = uu____23501;
              FStar_Syntax_Syntax.sigrng = (d.FStar_Parser_AST.drange);
              FStar_Syntax_Syntax.sigquals = [];
              FStar_Syntax_Syntax.sigmeta =
                FStar_Syntax_Syntax.default_sigmeta;
              FStar_Syntax_Syntax.sigattrs = []
            }  in
          let env1 = FStar_Syntax_DsEnv.push_sigelt env se  in (env1, [se])

let (desugar_decls :
  env_t ->
    FStar_Parser_AST.decl Prims.list ->
      (env_t,FStar_Syntax_Syntax.sigelt Prims.list)
        FStar_Pervasives_Native.tuple2)
  =
  fun env  ->
    fun decls  ->
      let uu____23535 =
        FStar_List.fold_left
          (fun uu____23555  ->
             fun d  ->
               match uu____23555 with
               | (env1,sigelts) ->
                   let uu____23575 = desugar_decl env1 d  in
                   (match uu____23575 with
                    | (env2,se) -> (env2, (FStar_List.append sigelts se))))
          (env, []) decls
         in
      match uu____23535 with
      | (env1,sigelts) ->
          let rec forward acc uu___257_23620 =
            match uu___257_23620 with
            | se1::se2::sigelts1 ->
                (match ((se1.FStar_Syntax_Syntax.sigel),
                         (se2.FStar_Syntax_Syntax.sigel))
                 with
                 | (FStar_Syntax_Syntax.Sig_declare_typ
                    uu____23634,FStar_Syntax_Syntax.Sig_let uu____23635) ->
                     let uu____23648 =
                       let uu____23651 =
                         let uu___295_23652 = se2  in
                         let uu____23653 =
                           let uu____23656 =
                             FStar_List.filter
                               (fun uu___256_23670  ->
                                  match uu___256_23670 with
                                  | {
                                      FStar_Syntax_Syntax.n =
                                        FStar_Syntax_Syntax.Tm_app
                                        ({
                                           FStar_Syntax_Syntax.n =
                                             FStar_Syntax_Syntax.Tm_fvar fv;
                                           FStar_Syntax_Syntax.pos =
                                             uu____23674;
                                           FStar_Syntax_Syntax.vars =
                                             uu____23675;_},uu____23676);
                                      FStar_Syntax_Syntax.pos = uu____23677;
                                      FStar_Syntax_Syntax.vars = uu____23678;_}
                                      when
                                      let uu____23701 =
                                        let uu____23702 =
                                          FStar_Syntax_Syntax.lid_of_fv fv
                                           in
                                        FStar_Ident.string_of_lid uu____23702
                                         in
                                      uu____23701 =
                                        "FStar.Pervasives.Comment"
                                      -> true
                                  | uu____23703 -> false)
                               se1.FStar_Syntax_Syntax.sigattrs
                              in
                           FStar_List.append uu____23656
                             se2.FStar_Syntax_Syntax.sigattrs
                            in
                         {
                           FStar_Syntax_Syntax.sigel =
                             (uu___295_23652.FStar_Syntax_Syntax.sigel);
                           FStar_Syntax_Syntax.sigrng =
                             (uu___295_23652.FStar_Syntax_Syntax.sigrng);
                           FStar_Syntax_Syntax.sigquals =
                             (uu___295_23652.FStar_Syntax_Syntax.sigquals);
                           FStar_Syntax_Syntax.sigmeta =
                             (uu___295_23652.FStar_Syntax_Syntax.sigmeta);
                           FStar_Syntax_Syntax.sigattrs = uu____23653
                         }  in
                       uu____23651 :: se1 :: acc  in
                     forward uu____23648 sigelts1
                 | uu____23708 -> forward (se1 :: acc) (se2 :: sigelts1))
            | sigelts1 -> FStar_List.rev_append acc sigelts1  in
          let uu____23716 = forward [] sigelts  in (env1, uu____23716)
  
let (open_prims_all :
  (FStar_Parser_AST.decoration Prims.list -> FStar_Parser_AST.decl)
    Prims.list)
  =
  [FStar_Parser_AST.mk_decl
     (FStar_Parser_AST.Open FStar_Parser_Const.prims_lid)
     FStar_Range.dummyRange;
  FStar_Parser_AST.mk_decl (FStar_Parser_AST.Open FStar_Parser_Const.all_lid)
    FStar_Range.dummyRange]
  
let (desugar_modul_common :
  FStar_Syntax_Syntax.modul FStar_Pervasives_Native.option ->
    FStar_Syntax_DsEnv.env ->
      FStar_Parser_AST.modul ->
        (env_t,FStar_Syntax_Syntax.modul,Prims.bool)
          FStar_Pervasives_Native.tuple3)
  =
  fun curmod  ->
    fun env  ->
      fun m  ->
        let env1 =
          match (curmod, m) with
          | (FStar_Pervasives_Native.None ,uu____23777) -> env
          | (FStar_Pervasives_Native.Some
             { FStar_Syntax_Syntax.name = prev_lid;
               FStar_Syntax_Syntax.declarations = uu____23781;
               FStar_Syntax_Syntax.exports = uu____23782;
               FStar_Syntax_Syntax.is_interface = uu____23783;_},FStar_Parser_AST.Module
             (current_lid,uu____23785)) when
              (FStar_Ident.lid_equals prev_lid current_lid) &&
                (FStar_Options.interactive ())
              -> env
          | (FStar_Pervasives_Native.Some prev_mod,uu____23793) ->
              let uu____23796 =
                FStar_Syntax_DsEnv.finish_module_or_interface env prev_mod
                 in
              FStar_Pervasives_Native.fst uu____23796
           in
        let uu____23801 =
          match m with
          | FStar_Parser_AST.Interface (mname,decls,admitted) ->
              let uu____23837 =
                FStar_Syntax_DsEnv.prepare_module_or_interface true admitted
                  env1 mname FStar_Syntax_DsEnv.default_mii
                 in
              (uu____23837, mname, decls, true)
          | FStar_Parser_AST.Module (mname,decls) ->
              let uu____23854 =
                FStar_Syntax_DsEnv.prepare_module_or_interface false false
                  env1 mname FStar_Syntax_DsEnv.default_mii
                 in
              (uu____23854, mname, decls, false)
           in
        match uu____23801 with
        | ((env2,pop_when_done),mname,decls,intf) ->
            let uu____23884 = desugar_decls env2 decls  in
            (match uu____23884 with
             | (env3,sigelts) ->
                 let modul =
                   {
                     FStar_Syntax_Syntax.name = mname;
                     FStar_Syntax_Syntax.declarations = sigelts;
                     FStar_Syntax_Syntax.exports = [];
                     FStar_Syntax_Syntax.is_interface = intf
                   }  in
                 (env3, modul, pop_when_done))
  
let (as_interface : FStar_Parser_AST.modul -> FStar_Parser_AST.modul) =
  fun m  ->
    match m with
    | FStar_Parser_AST.Module (mname,decls) ->
        FStar_Parser_AST.Interface (mname, decls, true)
    | i -> i
  
let (desugar_partial_modul :
  FStar_Syntax_Syntax.modul FStar_Pervasives_Native.option ->
    env_t ->
      FStar_Parser_AST.modul ->
        (env_t,FStar_Syntax_Syntax.modul) FStar_Pervasives_Native.tuple2)
  =
  fun curmod  ->
    fun env  ->
      fun m  ->
        let m1 =
          let uu____23946 =
            (FStar_Options.interactive ()) &&
              (let uu____23948 =
                 let uu____23949 =
                   let uu____23950 = FStar_Options.file_list ()  in
                   FStar_List.hd uu____23950  in
                 FStar_Util.get_file_extension uu____23949  in
               FStar_List.mem uu____23948 ["fsti"; "fsi"])
             in
          if uu____23946 then as_interface m else m  in
        let uu____23954 = desugar_modul_common curmod env m1  in
        match uu____23954 with
        | (env1,modul,pop_when_done) ->
            if pop_when_done
            then
              let uu____23972 = FStar_Syntax_DsEnv.pop ()  in
              (uu____23972, modul)
            else (env1, modul)
  
let (desugar_modul :
  FStar_Syntax_DsEnv.env ->
    FStar_Parser_AST.modul ->
      (env_t,FStar_Syntax_Syntax.modul) FStar_Pervasives_Native.tuple2)
  =
  fun env  ->
    fun m  ->
      let uu____23992 =
        desugar_modul_common FStar_Pervasives_Native.None env m  in
      match uu____23992 with
      | (env1,modul,pop_when_done) ->
          let uu____24006 =
            FStar_Syntax_DsEnv.finish_module_or_interface env1 modul  in
          (match uu____24006 with
           | (env2,modul1) ->
               ((let uu____24018 =
                   FStar_Options.dump_module
                     (modul1.FStar_Syntax_Syntax.name).FStar_Ident.str
                    in
                 if uu____24018
                 then
                   let uu____24019 =
                     FStar_Syntax_Print.modul_to_string modul1  in
                   FStar_Util.print1 "Module after desugaring:\n%s\n"
                     uu____24019
                 else ());
                (let uu____24021 =
                   if pop_when_done
                   then
                     FStar_Syntax_DsEnv.export_interface
                       modul1.FStar_Syntax_Syntax.name env2
                   else env2  in
                 (uu____24021, modul1))))
  
let with_options : 'a . (unit -> 'a) -> 'a =
  fun f  ->
    FStar_Options.push ();
    (let res = f ()  in
     let light = FStar_Options.ml_ish ()  in
     FStar_Options.pop ();
     if light then FStar_Options.set_ml_ish () else ();
     res)
  
let (ast_modul_to_modul :
  FStar_Parser_AST.modul ->
    FStar_Syntax_Syntax.modul FStar_Syntax_DsEnv.withenv)
  =
  fun modul  ->
    fun env  ->
      with_options
        (fun uu____24068  ->
           let uu____24069 = desugar_modul env modul  in
           match uu____24069 with | (e,m) -> (m, e))
  
let (decls_to_sigelts :
  FStar_Parser_AST.decl Prims.list ->
    FStar_Syntax_Syntax.sigelts FStar_Syntax_DsEnv.withenv)
  =
  fun decls  ->
    fun env  ->
      with_options
        (fun uu____24110  ->
           let uu____24111 = desugar_decls env decls  in
           match uu____24111 with | (env1,sigelts) -> (sigelts, env1))
  
let (partial_ast_modul_to_modul :
  FStar_Syntax_Syntax.modul FStar_Pervasives_Native.option ->
    FStar_Parser_AST.modul ->
      FStar_Syntax_Syntax.modul FStar_Syntax_DsEnv.withenv)
  =
  fun modul  ->
    fun a_modul  ->
      fun env  ->
        with_options
          (fun uu____24165  ->
             let uu____24166 = desugar_partial_modul modul env a_modul  in
             match uu____24166 with | (env1,modul1) -> (modul1, env1))
  
let (add_modul_to_env :
  FStar_Syntax_Syntax.modul ->
    FStar_Syntax_DsEnv.module_inclusion_info ->
      (FStar_Syntax_Syntax.term -> FStar_Syntax_Syntax.term) ->
        unit FStar_Syntax_DsEnv.withenv)
  =
  fun m  ->
    fun mii  ->
      fun erase_univs  ->
        fun en  ->
          let erase_univs_ed ed =
            let erase_binders bs =
              match bs with
              | [] -> []
              | uu____24252 ->
                  let t =
                    let uu____24260 =
                      FStar_Syntax_Syntax.mk
                        (FStar_Syntax_Syntax.Tm_abs
                           (bs, FStar_Syntax_Syntax.t_unit,
                             FStar_Pervasives_Native.None))
                        FStar_Pervasives_Native.None FStar_Range.dummyRange
                       in
                    erase_univs uu____24260  in
                  let uu____24271 =
                    let uu____24272 = FStar_Syntax_Subst.compress t  in
                    uu____24272.FStar_Syntax_Syntax.n  in
                  (match uu____24271 with
                   | FStar_Syntax_Syntax.Tm_abs (bs1,uu____24282,uu____24283)
                       -> bs1
                   | uu____24304 -> failwith "Impossible")
               in
            let uu____24311 =
              let uu____24318 = erase_binders ed.FStar_Syntax_Syntax.binders
                 in
              FStar_Syntax_Subst.open_term' uu____24318
                FStar_Syntax_Syntax.t_unit
               in
            match uu____24311 with
            | (binders,uu____24320,binders_opening) ->
                let erase_term t =
                  let uu____24328 =
                    let uu____24329 =
                      FStar_Syntax_Subst.subst binders_opening t  in
                    erase_univs uu____24329  in
                  FStar_Syntax_Subst.close binders uu____24328  in
                let erase_tscheme uu____24347 =
                  match uu____24347 with
                  | (us,t) ->
                      let t1 =
                        let uu____24367 =
                          FStar_Syntax_Subst.shift_subst
                            (FStar_List.length us) binders_opening
                           in
                        FStar_Syntax_Subst.subst uu____24367 t  in
                      let uu____24370 =
                        let uu____24371 = erase_univs t1  in
                        FStar_Syntax_Subst.close binders uu____24371  in
                      ([], uu____24370)
                   in
                let erase_action action =
                  let opening =
                    FStar_Syntax_Subst.shift_subst
                      (FStar_List.length
                         action.FStar_Syntax_Syntax.action_univs)
                      binders_opening
                     in
                  let erased_action_params =
                    match action.FStar_Syntax_Syntax.action_params with
                    | [] -> []
                    | uu____24390 ->
                        let bs =
                          let uu____24398 =
                            FStar_Syntax_Subst.subst_binders opening
                              action.FStar_Syntax_Syntax.action_params
                             in
                          FStar_All.pipe_left erase_binders uu____24398  in
                        let t =
                          FStar_Syntax_Syntax.mk
                            (FStar_Syntax_Syntax.Tm_abs
                               (bs, FStar_Syntax_Syntax.t_unit,
                                 FStar_Pervasives_Native.None))
                            FStar_Pervasives_Native.None
                            FStar_Range.dummyRange
                           in
                        let uu____24430 =
                          let uu____24431 =
                            let uu____24434 =
                              FStar_Syntax_Subst.close binders t  in
                            FStar_Syntax_Subst.compress uu____24434  in
                          uu____24431.FStar_Syntax_Syntax.n  in
                        (match uu____24430 with
                         | FStar_Syntax_Syntax.Tm_abs
                             (bs1,uu____24436,uu____24437) -> bs1
                         | uu____24458 -> failwith "Impossible")
                     in
                  let erase_term1 t =
                    let uu____24465 =
                      let uu____24466 = FStar_Syntax_Subst.subst opening t
                         in
                      erase_univs uu____24466  in
                    FStar_Syntax_Subst.close binders uu____24465  in
                  let uu___296_24467 = action  in
                  let uu____24468 =
                    erase_term1 action.FStar_Syntax_Syntax.action_defn  in
                  let uu____24469 =
                    erase_term1 action.FStar_Syntax_Syntax.action_typ  in
                  {
                    FStar_Syntax_Syntax.action_name =
                      (uu___296_24467.FStar_Syntax_Syntax.action_name);
                    FStar_Syntax_Syntax.action_unqualified_name =
                      (uu___296_24467.FStar_Syntax_Syntax.action_unqualified_name);
                    FStar_Syntax_Syntax.action_univs = [];
                    FStar_Syntax_Syntax.action_params = erased_action_params;
                    FStar_Syntax_Syntax.action_defn = uu____24468;
                    FStar_Syntax_Syntax.action_typ = uu____24469
                  }  in
                let uu___297_24470 = ed  in
                let uu____24471 = FStar_Syntax_Subst.close_binders binders
                   in
                let uu____24472 = erase_term ed.FStar_Syntax_Syntax.signature
                   in
                let uu____24473 = erase_tscheme ed.FStar_Syntax_Syntax.ret_wp
                   in
                let uu____24474 =
                  erase_tscheme ed.FStar_Syntax_Syntax.bind_wp  in
                let uu____24475 =
                  erase_tscheme ed.FStar_Syntax_Syntax.if_then_else  in
                let uu____24476 = erase_tscheme ed.FStar_Syntax_Syntax.ite_wp
                   in
                let uu____24477 =
                  erase_tscheme ed.FStar_Syntax_Syntax.stronger  in
                let uu____24478 =
                  erase_tscheme ed.FStar_Syntax_Syntax.close_wp  in
                let uu____24479 =
                  erase_tscheme ed.FStar_Syntax_Syntax.assert_p  in
                let uu____24480 =
                  erase_tscheme ed.FStar_Syntax_Syntax.assume_p  in
                let uu____24481 =
                  erase_tscheme ed.FStar_Syntax_Syntax.null_wp  in
                let uu____24482 =
                  erase_tscheme ed.FStar_Syntax_Syntax.trivial  in
                let uu____24483 = erase_term ed.FStar_Syntax_Syntax.repr  in
                let uu____24484 =
                  erase_tscheme ed.FStar_Syntax_Syntax.return_repr  in
                let uu____24485 =
                  erase_tscheme ed.FStar_Syntax_Syntax.bind_repr  in
                let uu____24486 =
                  FStar_List.map erase_action ed.FStar_Syntax_Syntax.actions
                   in
                {
                  FStar_Syntax_Syntax.cattributes =
                    (uu___297_24470.FStar_Syntax_Syntax.cattributes);
                  FStar_Syntax_Syntax.mname =
                    (uu___297_24470.FStar_Syntax_Syntax.mname);
                  FStar_Syntax_Syntax.univs = [];
                  FStar_Syntax_Syntax.binders = uu____24471;
                  FStar_Syntax_Syntax.signature = uu____24472;
                  FStar_Syntax_Syntax.ret_wp = uu____24473;
                  FStar_Syntax_Syntax.bind_wp = uu____24474;
                  FStar_Syntax_Syntax.if_then_else = uu____24475;
                  FStar_Syntax_Syntax.ite_wp = uu____24476;
                  FStar_Syntax_Syntax.stronger = uu____24477;
                  FStar_Syntax_Syntax.close_wp = uu____24478;
                  FStar_Syntax_Syntax.assert_p = uu____24479;
                  FStar_Syntax_Syntax.assume_p = uu____24480;
                  FStar_Syntax_Syntax.null_wp = uu____24481;
                  FStar_Syntax_Syntax.trivial = uu____24482;
                  FStar_Syntax_Syntax.repr = uu____24483;
                  FStar_Syntax_Syntax.return_repr = uu____24484;
                  FStar_Syntax_Syntax.bind_repr = uu____24485;
                  FStar_Syntax_Syntax.actions = uu____24486;
                  FStar_Syntax_Syntax.eff_attrs =
                    (uu___297_24470.FStar_Syntax_Syntax.eff_attrs)
                }
             in
          let push_sigelt1 env se =
            match se.FStar_Syntax_Syntax.sigel with
            | FStar_Syntax_Syntax.Sig_new_effect ed ->
                let se' =
                  let uu___298_24502 = se  in
                  let uu____24503 =
                    let uu____24504 = erase_univs_ed ed  in
                    FStar_Syntax_Syntax.Sig_new_effect uu____24504  in
                  {
                    FStar_Syntax_Syntax.sigel = uu____24503;
                    FStar_Syntax_Syntax.sigrng =
                      (uu___298_24502.FStar_Syntax_Syntax.sigrng);
                    FStar_Syntax_Syntax.sigquals =
                      (uu___298_24502.FStar_Syntax_Syntax.sigquals);
                    FStar_Syntax_Syntax.sigmeta =
                      (uu___298_24502.FStar_Syntax_Syntax.sigmeta);
                    FStar_Syntax_Syntax.sigattrs =
                      (uu___298_24502.FStar_Syntax_Syntax.sigattrs)
                  }  in
                let env1 = FStar_Syntax_DsEnv.push_sigelt env se'  in
                push_reflect_effect env1 se.FStar_Syntax_Syntax.sigquals
                  ed.FStar_Syntax_Syntax.mname se.FStar_Syntax_Syntax.sigrng
            | FStar_Syntax_Syntax.Sig_new_effect_for_free ed ->
                let se' =
                  let uu___299_24508 = se  in
                  let uu____24509 =
                    let uu____24510 = erase_univs_ed ed  in
                    FStar_Syntax_Syntax.Sig_new_effect_for_free uu____24510
                     in
                  {
                    FStar_Syntax_Syntax.sigel = uu____24509;
                    FStar_Syntax_Syntax.sigrng =
                      (uu___299_24508.FStar_Syntax_Syntax.sigrng);
                    FStar_Syntax_Syntax.sigquals =
                      (uu___299_24508.FStar_Syntax_Syntax.sigquals);
                    FStar_Syntax_Syntax.sigmeta =
                      (uu___299_24508.FStar_Syntax_Syntax.sigmeta);
                    FStar_Syntax_Syntax.sigattrs =
                      (uu___299_24508.FStar_Syntax_Syntax.sigattrs)
                  }  in
                let env1 = FStar_Syntax_DsEnv.push_sigelt env se'  in
                push_reflect_effect env1 se.FStar_Syntax_Syntax.sigquals
                  ed.FStar_Syntax_Syntax.mname se.FStar_Syntax_Syntax.sigrng
            | uu____24512 -> FStar_Syntax_DsEnv.push_sigelt env se  in
          let uu____24513 =
            FStar_Syntax_DsEnv.prepare_module_or_interface false false en
              m.FStar_Syntax_Syntax.name mii
             in
          match uu____24513 with
          | (en1,pop_when_done) ->
              let en2 =
                let uu____24525 =
                  FStar_Syntax_DsEnv.set_current_module en1
                    m.FStar_Syntax_Syntax.name
                   in
                FStar_List.fold_left push_sigelt1 uu____24525
                  m.FStar_Syntax_Syntax.exports
                 in
              let env = FStar_Syntax_DsEnv.finish en2 m  in
              let uu____24527 =
                if pop_when_done
                then
                  FStar_Syntax_DsEnv.export_interface
                    m.FStar_Syntax_Syntax.name env
                else env  in
              ((), uu____24527)
  