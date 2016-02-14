gelex evt_scanner_def.l
geyacc -v evt_decl_parser_out.txt -o evt_decl_parser.e -t evt_tokens evt_decl_parser_def.y 
geyacc -v evt_trace_parser_out.txt -o evt_trace_parser.e -t evt_tokens evt_trace_parser_def.y 
pause

