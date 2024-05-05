# DVE version T-2022.06_Full64
# Preferences written on Tue Nov 28 23:19:45 2023
gui_set_var -name {read_pref_file} -value {true}
gui_set_pref_value -category {Globals} -key {cbug_fifo_dump_enable_proc} -value {false}
gui_create_pref_key -category {Globals} -key {load_detail_for_funcov} -value_type {bool} -value {false}

gui_create_pref_category -category {schem_obj_name}
gui_create_pref_key -category {schem_obj_name} -key {show_cell_and_pin_with_symbol_name} -value_type {bool} -value {false}
gui_create_pref_key -category {schem_pin_hc} -key {textExtFont} -value_type {string} -value {Helvetica,10,-1,5,50,0,0,0,0,0}
gui_set_var -name {read_pref_file} -value {false}
