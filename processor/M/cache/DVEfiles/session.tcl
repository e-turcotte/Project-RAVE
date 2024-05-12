# Begin_DVE_Session_Save_Info
# DVE reload session
# Saved on Mon May 6 04:06:17 2024
# Designs open: 1
#   V1: /home/ecelrc/students/jnederveld/Project-RAVE/processor/M/cache/cache.vpd
# Toplevel windows open: 6
# 	TopLevel.1
# 	TopLevel.2
# 	TopLevel.3
# 	TopLevel.4
# 	TopLevel.5
# 	TopLevel.6
#   Source.1: cache_tb
#   Wave.1: 64 signals
#   Wave.2: 40 signals
#   Wave.3: 29 signals
#   Wave.4: 11 signals
#   Wave.5: 60 signals
#   Group count = 5
#   Group cs1 signal count = 64
#   Group ts signal count = 40
#   Group ds signal count = 29
#   Group pgT signal count = 11
#   Group outputAlign_instance signal count = 60
# End_DVE_Session_Save_Info

# DVE version: T-2022.06_Full64
# DVE build date: May 31 2022 20:53:03


#<Session mode="Reload" path="/home/ecelrc/students/jnederveld/Project-RAVE/processor/M/cache/DVEfiles/session.tcl" type="Debug">

gui_set_loading_session_type Reload
gui_continuetime_set

# Close design
if { [gui_sim_state -check active] } {
    gui_sim_terminate
}
gui_close_db -all
gui_expr_clear_all
gui_clear_window -type Wave
gui_clear_window -type List

# Application preferences
gui_set_pref_value -key app_default_font -value {Helvetica,10,-1,5,50,0,0,0,0,0}
gui_src_preferences -tabstop 8 -maxbits 24 -windownumber 1
#<WindowLayout>

# DVE top-level session


# Create and position top-level window: TopLevel.1

set TopLevel.1 TopLevel.1

# Docked window settings
set HSPane.1 HSPane.1
set Hier.1 Hier.1
set DLPane.1 DLPane.1
set Data.1 Data.1
set Console.1 Console.1
gui_sync_global -id ${TopLevel.1} -option true

# MDI window settings
set Source.1 Source.1
gui_update_layout -id ${Source.1} {{show_state maximized} {dock_state undocked} {dock_on_new_line false}}

# End MDI window settings


# Create and position top-level window: TopLevel.2

set TopLevel.2 TopLevel.2

# Docked window settings
gui_sync_global -id ${TopLevel.2} -option true

# MDI window settings
set Wave.1 Wave.1
gui_update_layout -id ${Wave.1} {{show_state maximized} {dock_state undocked} {dock_on_new_line false} {child_wave_left 276} {child_wave_right 673} {child_wave_colname 136} {child_wave_colvalue 136} {child_wave_col1 0} {child_wave_col2 1}}

# End MDI window settings


# Create and position top-level window: TopLevel.3

set TopLevel.3 TopLevel.3

# Docked window settings
gui_sync_global -id ${TopLevel.3} -option true

# MDI window settings
set Wave.2 Wave.2
gui_update_layout -id ${Wave.2} {{show_state maximized} {dock_state undocked} {dock_on_new_line false} {child_wave_left 593} {child_wave_right 1449} {child_wave_colname 353} {child_wave_colvalue 236} {child_wave_col1 0} {child_wave_col2 1}}

# End MDI window settings


# Create and position top-level window: TopLevel.4

set TopLevel.4 TopLevel.4

# Docked window settings
set Watch.1 Watch.1
gui_sync_global -id ${TopLevel.4} -option true

# MDI window settings
set Wave.3 Wave.3
gui_update_layout -id ${Wave.3} {{show_state maximized} {dock_state undocked} {dock_on_new_line false} {child_wave_left 594} {child_wave_right 1448} {child_wave_colname 175} {child_wave_colvalue 415} {child_wave_col1 0} {child_wave_col2 1}}

# End MDI window settings


# Create and position top-level window: TopLevel.5

set TopLevel.5 TopLevel.5

# Docked window settings
gui_sync_global -id ${TopLevel.5} -option true

# MDI window settings
set Wave.4 Wave.4
gui_update_layout -id ${Wave.4} {{show_state maximized} {dock_state undocked} {dock_on_new_line false} {child_wave_left 276} {child_wave_right 673} {child_wave_colname 136} {child_wave_colvalue 136} {child_wave_col1 0} {child_wave_col2 1}}

# End MDI window settings


# Create and position top-level window: TopLevel.6

set TopLevel.6 TopLevel.6

# Docked window settings
gui_sync_global -id ${TopLevel.6} -option true

# MDI window settings
set Wave.5 Wave.5
gui_update_layout -id ${Wave.5} {{show_state maximized} {dock_state undocked} {dock_on_new_line false} {child_wave_left 557} {child_wave_right 1357} {child_wave_colname 203} {child_wave_colvalue 350} {child_wave_col1 0} {child_wave_col2 1}}

# End MDI window settings


#</WindowLayout>

#<Database>

# DVE Open design session: 

if { ![gui_is_db_opened -db {/home/ecelrc/students/jnederveld/Project-RAVE/processor/M/cache/cache.vpd}] } {
	gui_open_db -design V1 -file /home/ecelrc/students/jnederveld/Project-RAVE/processor/M/cache/cache.vpd -nosource
}
gui_set_precision 10ps
gui_set_time_units 1ns
#</Database>

# DVE Global setting session: 


# Global: Bus

# Global: Expressions

# Global: Signal Time Shift

# Global: Signal Compare

# Global: Signal Groups
gui_load_child_values {cache_tb.cacheBank_E.cs1}
gui_load_child_values {cache_tb.cacheBank_E.cs1.ds}
gui_load_child_values {cache_tb.outputAlign_instance}
gui_load_child_values {cache_tb.cacheBank_E.cs1.pgT}
gui_load_child_values {cache_tb.cacheBank_E.cs1.ts}


set _session_group_10 cs1
gui_sg_create "$_session_group_10"
set cs1 "$_session_group_10"

gui_sg_addsignal -group "$_session_group_10" { cache_tb.cacheBank_E.cs1.clk cache_tb.cacheBank_E.cs1.rst cache_tb.cacheBank_E.cs1.set cache_tb.cacheBank_E.cs1.cache_id cache_tb.cacheBank_E.cs1.vAddress_in cache_tb.cacheBank_E.cs1.pAddress_in cache_tb.cacheBank_E.cs1.r cache_tb.cacheBank_E.cs1.w cache_tb.cacheBank_E.cs1.sw cache_tb.cacheBank_E.cs1.valid_in cache_tb.cacheBank_E.cs1.fromBUS cache_tb.cacheBank_E.cs1.PTC_ID_IN cache_tb.cacheBank_E.cs1.data_in cache_tb.cacheBank_E.cs1.mask_in cache_tb.cacheBank_E.cs1.PCD_IN cache_tb.cacheBank_E.cs1.MSHR_FULL cache_tb.cacheBank_E.cs1.MSHR_MISS cache_tb.cacheBank_E.cs1.SER0_FULL cache_tb.cacheBank_E.cs1.SER1_FULL cache_tb.cacheBank_E.cs1.cache_line cache_tb.cacheBank_E.cs1.MISS cache_tb.cacheBank_E.cs1.ex_clr cache_tb.cacheBank_E.cs1.ex_wb cache_tb.cacheBank_E.cs1.HIT cache_tb.cacheBank_E.cs1.stall cache_tb.cacheBank_E.cs1.valid_out cache_tb.cacheBank_E.cs1.extAddress cache_tb.cacheBank_E.cs1.index cache_tb.cacheBank_E.cs1.stall1 cache_tb.cacheBank_E.cs1.stall2 cache_tb.cacheBank_E.cs1.stall3 cache_tb.cacheBank_E.cs1.data_dump cache_tb.cacheBank_E.cs1.stall_n cache_tb.cacheBank_E.cs1.valid_in_n cache_tb.cacheBank_E.cs1.way cache_tb.cacheBank_E.cs1.HITS cache_tb.cacheBank_E.cs1.way_out cache_tb.cacheBank_E.cs1.PTC cache_tb.cacheBank_E.cs1.D cache_tb.cacheBank_E.cs1.tag_in cache_tb.cacheBank_E.cs1.tag_read cache_tb.cacheBank_E.cs1.tag_hit cache_tb.cacheBank_E.cs1.tag_data_read cache_tb.cacheBank_E.cs1.tag_dump cache_tb.cacheBank_E.cs1.LRU cache_tb.cacheBank_E.cs1.V cache_tb.cacheBank_E.cs1.clkn cache_tb.cacheBank_E.cs1.valn cache_tb.cacheBank_E.cs1.index_out cache_tb.cacheBank_E.cs1.tWrite cache_tb.cacheBank_E.cs1.D_sel cache_tb.cacheBank_E.cs1.V_sel cache_tb.cacheBank_E.cs1.PTC_sel cache_tb.cacheBank_E.cs1.MISS2 cache_tb.cacheBank_E.cs1.stall_pos cache_tb.cacheBank_E.cs1.stalln cache_tb.cacheBank_E.cs1.valid_dff cache_tb.cacheBank_E.cs1.writeData_p cache_tb.cacheBank_E.cs1.writeData cache_tb.cacheBank_E.cs1.writeTag_p cache_tb.cacheBank_E.cs1.writeTag cache_tb.cacheBank_E.cs1.writeTag_out cache_tb.cacheBank_E.cs1.writeData_out cache_tb.cacheBank_E.cs1.dWrite }

set _session_group_11 ts
gui_sg_create "$_session_group_11"
set ts "$_session_group_11"

gui_sg_addsignal -group "$_session_group_11" { cache_tb.cacheBank_E.cs1.ts.clk cache_tb.cacheBank_E.cs1.ts.valid cache_tb.cacheBank_E.cs1.ts.index cache_tb.cacheBank_E.cs1.ts.way cache_tb.cacheBank_E.cs1.ts.tag_in cache_tb.cacheBank_E.cs1.ts.V cache_tb.cacheBank_E.cs1.ts.PTC cache_tb.cacheBank_E.cs1.ts.w cache_tb.cacheBank_E.cs1.ts.r cache_tb.cacheBank_E.cs1.ts.isW cache_tb.cacheBank_E.cs1.ts.tag_out cache_tb.cacheBank_E.cs1.ts.hit cache_tb.cacheBank_E.cs1.ts.tag_dump cache_tb.cacheBank_E.cs1.ts.tagData_out_hit cache_tb.cacheBank_E.cs1.ts.tagData_based_on_hit cache_tb.cacheBank_E.cs1.ts.wNot cache_tb.cacheBank_E.cs1.ts.hit1 cache_tb.cacheBank_E.cs1.ts.writeSel cache_tb.cacheBank_E.cs1.ts.data cache_tb.cacheBank_E.cs1.ts.w_v cache_tb.cacheBank_E.cs1.ts.valid_n cache_tb.cacheBank_E.cs1.ts.read cache_tb.cacheBank_E.cs1.ts.R_not cache_tb.cacheBank_E.cs1.ts.way_n cache_tb.cacheBank_E.cs1.ts.write cache_tb.cacheBank_E.cs1.ts.clkn cache_tb.cacheBank_E.cs1.ts.buf1 cache_tb.cacheBank_E.cs1.ts.buf2 cache_tb.cacheBank_E.cs1.ts.buf3 cache_tb.cacheBank_E.cs1.ts.buf4 cache_tb.cacheBank_E.cs1.ts.buf5 cache_tb.cacheBank_E.cs1.ts.buf6 cache_tb.cacheBank_E.cs1.ts.buf7 cache_tb.cacheBank_E.cs1.ts.buf8 cache_tb.cacheBank_E.cs1.ts.buf9 cache_tb.cacheBank_E.cs1.ts.buf10 cache_tb.cacheBank_E.cs1.ts.buf11 cache_tb.cacheBank_E.cs1.ts.boabw cache_tb.cacheBank_E.cs1.ts.hmm cache_tb.cacheBank_E.cs1.ts.miss }

set _session_group_12 ds
gui_sg_create "$_session_group_12"
set ds "$_session_group_12"

gui_sg_addsignal -group "$_session_group_12" { cache_tb.cacheBank_E.cs1.ds.valid cache_tb.cacheBank_E.cs1.ds.index cache_tb.cacheBank_E.cs1.ds.way cache_tb.cacheBank_E.cs1.ds.data_in cache_tb.cacheBank_E.cs1.ds.mask_in cache_tb.cacheBank_E.cs1.ds.w cache_tb.cacheBank_E.cs1.ds.clk cache_tb.cacheBank_E.cs1.ds.data_out cache_tb.cacheBank_E.cs1.ds.cache_line cache_tb.cacheBank_E.cs1.ds.data_toWrite cache_tb.cacheBank_E.cs1.ds.data cache_tb.cacheBank_E.cs1.ds.clkn cache_tb.cacheBank_E.cs1.ds.valid_n cache_tb.cacheBank_E.cs1.ds.way_no cache_tb.cacheBank_E.cs1.ds.way_n cache_tb.cacheBank_E.cs1.ds.w_v cache_tb.cacheBank_E.cs1.ds.way_non cache_tb.cacheBank_E.cs1.ds.write cache_tb.cacheBank_E.cs1.ds.buf1 cache_tb.cacheBank_E.cs1.ds.buf2 cache_tb.cacheBank_E.cs1.ds.buf3 cache_tb.cacheBank_E.cs1.ds.buf4 cache_tb.cacheBank_E.cs1.ds.buf5 cache_tb.cacheBank_E.cs1.ds.buf6 cache_tb.cacheBank_E.cs1.ds.buf7 cache_tb.cacheBank_E.cs1.ds.buf8 cache_tb.cacheBank_E.cs1.ds.buf9 cache_tb.cacheBank_E.cs1.ds.buf10 cache_tb.cacheBank_E.cs1.ds.buf11 }

set _session_group_13 pgT
gui_sg_create "$_session_group_13"
set pgT "$_session_group_13"

gui_sg_addsignal -group "$_session_group_13" { cache_tb.cacheBank_E.cs1.pgT.clk cache_tb.cacheBank_E.cs1.pgT.signal cache_tb.cacheBank_E.cs1.pgT.pulse cache_tb.cacheBank_E.cs1.pgT.toPipeline cache_tb.cacheBank_E.cs1.pgT.buf1 cache_tb.cacheBank_E.cs1.pgT.buf2 cache_tb.cacheBank_E.cs1.pgT.buf3 cache_tb.cacheBank_E.cs1.pgT.buf4 cache_tb.cacheBank_E.cs1.pgT.buf5 cache_tb.cacheBank_E.cs1.pgT.buf6 cache_tb.cacheBank_E.cs1.pgT.buf7 }

set _session_group_14 outputAlign_instance
gui_sg_create "$_session_group_14"
set outputAlign_instance "$_session_group_14"

gui_sg_addsignal -group "$_session_group_14" { cache_tb.outputAlign_instance.E_cache_miss cache_tb.outputAlign_instance.E_cache_stall cache_tb.outputAlign_instance.E_data cache_tb.outputAlign_instance.E_needP1 cache_tb.outputAlign_instance.E_oddIsGreater cache_tb.outputAlign_instance.E_pAddress cache_tb.outputAlign_instance.E_size cache_tb.outputAlign_instance.E_vAddress cache_tb.outputAlign_instance.E_valid cache_tb.outputAlign_instance.E_wake cache_tb.outputAlign_instance.O_cache_miss cache_tb.outputAlign_instance.O_cache_stall cache_tb.outputAlign_instance.O_data cache_tb.outputAlign_instance.O_needP1 cache_tb.outputAlign_instance.O_oddIsGreater cache_tb.outputAlign_instance.O_pAddress cache_tb.outputAlign_instance.O_size cache_tb.outputAlign_instance.O_vAddress cache_tb.outputAlign_instance.O_valid cache_tb.outputAlign_instance.O_wake cache_tb.outputAlign_instance.P1n cache_tb.outputAlign_instance.PTC0 cache_tb.outputAlign_instance.PTC0_shift cache_tb.outputAlign_instance.PTC1 cache_tb.outputAlign_instance.PTCDATA cache_tb.outputAlign_instance.PTC_out1 cache_tb.outputAlign_instance.PTC_out cache_tb.outputAlign_instance.PTC_outx cache_tb.outputAlign_instance.cache_miss0 cache_tb.outputAlign_instance.cache_miss1 cache_tb.outputAlign_instance.cache_stall0 cache_tb.outputAlign_instance.cache_stall1 cache_tb.outputAlign_instance.data0 cache_tb.outputAlign_instance.data0_shift cache_tb.outputAlign_instance.data1 cache_tb.outputAlign_instance.data_out cache_tb.outputAlign_instance.muxData cache_tb.outputAlign_instance.needP10 cache_tb.outputAlign_instance.needP11 cache_tb.outputAlign_instance.oddIsGreater0 cache_tb.outputAlign_instance.oddIsGreater1 cache_tb.outputAlign_instance.oneSize cache_tb.outputAlign_instance.pAddress0 cache_tb.outputAlign_instance.pAddress1 cache_tb.outputAlign_instance.preSext cache_tb.outputAlign_instance.preVAL cache_tb.outputAlign_instance.sext cache_tb.outputAlign_instance.shift0_dec cache_tb.outputAlign_instance.shift0_enc cache_tb.outputAlign_instance.size0 cache_tb.outputAlign_instance.size1 cache_tb.outputAlign_instance.vAddress0 cache_tb.outputAlign_instance.vAddress1 cache_tb.outputAlign_instance.val1 cache_tb.outputAlign_instance.val2 cache_tb.outputAlign_instance.valid0 cache_tb.outputAlign_instance.valid1 cache_tb.outputAlign_instance.valid_out cache_tb.outputAlign_instance.wake0 cache_tb.outputAlign_instance.wake1 }

# Global: Highlighting

# Global: Stack
gui_change_stack_mode -mode list

# Global: Watch 'Watch'

gui_watch_page_delete -id Watch -all
gui_watch_page_add -id Watch
gui_watch_page_rename -id Watch -name {Watch 1}
gui_watch_list_add_expr -id Watch -expr {data_out[511:0]} -meta cache_tb.cacheBank_E.cs1.ds.data_out -type {Wire(Port Out)} -nonlocal -scope cache_tb.cacheBank_E.cs1.ds

gui_watch_page_add -id Watch
gui_watch_page_rename -id Watch -name {Watch 2}
gui_watch_page_add -id Watch
gui_watch_page_rename -id Watch -name {Watch 3}

# Post database loading setting...

# Restore C1 time
gui_set_time -C1_only 224.28



# Save global setting...

# Wave/List view global setting
gui_cov_show_value -switch false

# Close all empty TopLevel windows
foreach __top [gui_ekki_get_window_ids -type TopLevel] {
    if { [llength [gui_ekki_get_window_ids -parent $__top]] == 0} {
        gui_close_window -window $__top
    }
}
gui_set_loading_session_type noSession
# DVE View/pane content session: 


# Hier 'Hier.1'
gui_show_window -window ${Hier.1}
gui_list_set_filter -id ${Hier.1} -list { {Package 1} {All 0} {Process 1} {VirtPowSwitch 0} {UnnamedProcess 1} {UDP 0} {Function 1} {Block 1} {SrsnAndSpaCell 0} {OVA Unit 1} {LeafScCell 1} {LeafVlgCell 1} {Interface 1} {LeafVhdCell 1} {$unit 1} {NamedBlock 1} {Task 1} {VlgPackage 1} {ClassDef 1} {VirtIsoCell 0} }
gui_list_set_filter -id ${Hier.1} -text {*} -force
gui_change_design -id ${Hier.1} -design V1
catch {gui_list_expand -id ${Hier.1} cache_tb}
catch {gui_list_select -id ${Hier.1} {cache_tb.outputAlign_instance}}
gui_view_scroll -id ${Hier.1} -vertical -set 0
gui_view_scroll -id ${Hier.1} -horizontal -set 0

# Data 'Data.1'
gui_list_set_filter -id ${Data.1} -list { {Buffer 1} {Input 1} {Others 1} {Linkage 1} {Output 1} {LowPower 1} {Parameter 1} {All 1} {Aggregate 1} {LibBaseMember 1} {Event 1} {Assertion 1} {Constant 1} {Interface 1} {BaseMembers 1} {Signal 1} {$unit 1} {Inout 1} {Variable 1} }
gui_list_set_filter -id ${Data.1} -text {*}
gui_list_show_data -id ${Data.1} {cache_tb.outputAlign_instance}
gui_view_scroll -id ${Data.1} -vertical -set 0
gui_view_scroll -id ${Data.1} -horizontal -set 0
gui_view_scroll -id ${Hier.1} -vertical -set 0
gui_view_scroll -id ${Hier.1} -horizontal -set 0

# Source 'Source.1'
gui_src_value_annotate -id ${Source.1} -switch false
gui_set_env TOGGLE::VALUEANNOTATE 0
gui_open_source -id ${Source.1}  -replace -active cache_tb /home/ecelrc/students/jnederveld/Project-RAVE/processor/M/cache/cache_tb.v
gui_view_scroll -id ${Source.1} -vertical -set 0
gui_src_set_reusable -id ${Source.1}

# View 'Wave.1'
gui_wv_sync -id ${Wave.1} -switch false
set groupExD [gui_get_pref_value -category Wave -key exclusiveSG]
gui_set_pref_value -category Wave -key exclusiveSG -value {false}
set origWaveHeight [gui_get_pref_value -category Wave -key waveRowHeight]
gui_list_set_height -id Wave -height 25
set origGroupCreationState [gui_list_create_group_when_add -wave]
gui_list_create_group_when_add -wave -disable
gui_wv_zoom_timerange -id ${Wave.1} 0 252
gui_list_add_group -id ${Wave.1} -after {New Group} {cs1}
gui_list_select -id ${Wave.1} {cache_tb.cacheBank_E.cs1.r }
gui_seek_criteria -id ${Wave.1} {Any Edge}


gui_set_pref_value -category Wave -key exclusiveSG -value $groupExD
gui_list_set_height -id Wave -height $origWaveHeight
if {$origGroupCreationState} {
	gui_list_create_group_when_add -wave -enable
}
if { $groupExD } {
 gui_msg_report -code DVWW028
}
gui_list_set_filter -id ${Wave.1} -list { {Buffer 1} {Input 1} {Others 1} {Linkage 1} {Output 1} {Parameter 1} {All 1} {Aggregate 1} {LibBaseMember 1} {Event 1} {Assertion 1} {Constant 1} {Interface 1} {BaseMembers 1} {Signal 1} {$unit 1} {Inout 1} {Variable 1} }
gui_list_set_filter -id ${Wave.1} -text {*}
gui_list_set_insertion_bar  -id ${Wave.1} -group cs1  -position in

gui_marker_move -id ${Wave.1} {C1} 224.28
gui_view_scroll -id ${Wave.1} -vertical -set 0
gui_show_grid -id ${Wave.1} -enable false

# View 'Wave.2'
gui_wv_sync -id ${Wave.2} -switch false
set groupExD [gui_get_pref_value -category Wave -key exclusiveSG]
gui_set_pref_value -category Wave -key exclusiveSG -value {false}
set origWaveHeight [gui_get_pref_value -category Wave -key waveRowHeight]
gui_list_set_height -id Wave -height 25
set origGroupCreationState [gui_list_create_group_when_add -wave]
gui_list_create_group_when_add -wave -disable
gui_wv_zoom_timerange -id ${Wave.2} 169.26 304.01
gui_list_add_group -id ${Wave.2} -after {New Group} {ts}
gui_list_select -id ${Wave.2} {cache_tb.cacheBank_E.cs1.ts.w }
gui_seek_criteria -id ${Wave.2} {Any Edge}


gui_set_pref_value -category Wave -key exclusiveSG -value $groupExD
gui_list_set_height -id Wave -height $origWaveHeight
if {$origGroupCreationState} {
	gui_list_create_group_when_add -wave -enable
}
if { $groupExD } {
 gui_msg_report -code DVWW028
}
gui_list_set_filter -id ${Wave.2} -list { {Buffer 1} {Input 1} {Others 1} {Linkage 1} {Output 1} {Parameter 1} {All 1} {Aggregate 1} {LibBaseMember 1} {Event 1} {Assertion 1} {Constant 1} {Interface 1} {BaseMembers 1} {Signal 1} {$unit 1} {Inout 1} {Variable 1} }
gui_list_set_filter -id ${Wave.2} -text {*}
gui_list_set_insertion_bar  -id ${Wave.2} -group ts  -position in

gui_marker_move -id ${Wave.2} {C1} 224.28
gui_view_scroll -id ${Wave.2} -vertical -set 0
gui_show_grid -id ${Wave.2} -enable false

# View 'Wave.3'
gui_wv_sync -id ${Wave.3} -switch false
set groupExD [gui_get_pref_value -category Wave -key exclusiveSG]
gui_set_pref_value -category Wave -key exclusiveSG -value {false}
set origWaveHeight [gui_get_pref_value -category Wave -key waveRowHeight]
gui_list_set_height -id Wave -height 25
set origGroupCreationState [gui_list_create_group_when_add -wave]
gui_list_create_group_when_add -wave -disable
gui_wv_zoom_timerange -id ${Wave.3} 0 252
gui_list_add_group -id ${Wave.3} -after {New Group} {ds}
gui_list_select -id ${Wave.3} {cache_tb.cacheBank_E.cs1.ds.w }
gui_seek_criteria -id ${Wave.3} {Any Edge}


gui_set_pref_value -category Wave -key exclusiveSG -value $groupExD
gui_list_set_height -id Wave -height $origWaveHeight
if {$origGroupCreationState} {
	gui_list_create_group_when_add -wave -enable
}
if { $groupExD } {
 gui_msg_report -code DVWW028
}
gui_list_set_filter -id ${Wave.3} -list { {Buffer 1} {Input 1} {Others 1} {Linkage 1} {Output 1} {Parameter 1} {All 1} {Aggregate 1} {LibBaseMember 1} {Event 1} {Assertion 1} {Constant 1} {Interface 1} {BaseMembers 1} {Signal 1} {$unit 1} {Inout 1} {Variable 1} }
gui_list_set_filter -id ${Wave.3} -text {*}
gui_list_set_insertion_bar  -id ${Wave.3} -group ds  -position in

gui_marker_move -id ${Wave.3} {C1} 224.28
gui_view_scroll -id ${Wave.3} -vertical -set 0
gui_show_grid -id ${Wave.3} -enable false

# Watch 'Watch.1'
gui_watch_page_activate -id ${Watch.1} -page {Watch 1}
gui_list_set_filter -id ${Watch.1} -page {Watch 1} -list { {static 1} {randc 1} {public 1} {Parameter 1} {protected 1} {OtherTypes 1} {array 1} {local 1} {class 1} {AllTypes 1} {rand 1} {constraint 1} }
gui_list_set_filter -id ${Watch.1} -page {Watch 1} -text {*}
gui_list_select -id ${Watch.1} { cache_tb.cacheBank_E.cs1.ds.data_out }
gui_watch_list_scroll_to -id ${Watch.1} -horz 0 -vert 2
gui_watch_page_activate -id ${Watch.1} -page {Watch 2}
gui_list_set_filter -id ${Watch.1} -page {Watch 2} -list { {static 1} {randc 1} {public 1} {Parameter 1} {protected 1} {OtherTypes 1} {array 1} {local 1} {class 1} {AllTypes 1} {rand 1} {constraint 1} }
gui_list_set_filter -id ${Watch.1} -page {Watch 2} -text {*}
gui_watch_page_activate -id ${Watch.1} -page {Watch 3}
gui_list_set_filter -id ${Watch.1} -page {Watch 3} -list { {static 1} {randc 1} {public 1} {Parameter 1} {protected 1} {OtherTypes 1} {array 1} {local 1} {class 1} {AllTypes 1} {rand 1} {constraint 1} }
gui_list_set_filter -id ${Watch.1} -page {Watch 3} -text {*}
gui_watch_page_activate -id ${Watch.1} -page {Watch 1}
gui_view_scroll -id ${Watch.1} -vertical -set 2
gui_view_scroll -id ${Watch.1} -horizontal -set 0

# View 'Wave.4'
gui_wv_sync -id ${Wave.4} -switch false
set groupExD [gui_get_pref_value -category Wave -key exclusiveSG]
gui_set_pref_value -category Wave -key exclusiveSG -value {false}
set origWaveHeight [gui_get_pref_value -category Wave -key waveRowHeight]
gui_list_set_height -id Wave -height 25
set origGroupCreationState [gui_list_create_group_when_add -wave]
gui_list_create_group_when_add -wave -disable
gui_wv_zoom_timerange -id ${Wave.4} 0 252
gui_list_add_group -id ${Wave.4} -after {New Group} {pgT}
gui_list_select -id ${Wave.4} {cache_tb.cacheBank_E.cs1.pgT.pulse }
gui_seek_criteria -id ${Wave.4} {Any Edge}


gui_set_pref_value -category Wave -key exclusiveSG -value $groupExD
gui_list_set_height -id Wave -height $origWaveHeight
if {$origGroupCreationState} {
	gui_list_create_group_when_add -wave -enable
}
if { $groupExD } {
 gui_msg_report -code DVWW028
}
gui_list_set_filter -id ${Wave.4} -list { {Buffer 1} {Input 1} {Others 1} {Linkage 1} {Output 1} {Parameter 1} {All 1} {Aggregate 1} {LibBaseMember 1} {Event 1} {Assertion 1} {Constant 1} {Interface 1} {BaseMembers 1} {Signal 1} {$unit 1} {Inout 1} {Variable 1} }
gui_list_set_filter -id ${Wave.4} -text {*}
gui_list_set_insertion_bar  -id ${Wave.4} -group pgT  -position in

gui_marker_move -id ${Wave.4} {C1} 224.28
gui_view_scroll -id ${Wave.4} -vertical -set 0
gui_show_grid -id ${Wave.4} -enable false

# View 'Wave.5'
gui_wv_sync -id ${Wave.5} -switch false
set groupExD [gui_get_pref_value -category Wave -key exclusiveSG]
gui_set_pref_value -category Wave -key exclusiveSG -value {false}
set origWaveHeight [gui_get_pref_value -category Wave -key waveRowHeight]
gui_list_set_height -id Wave -height 25
set origGroupCreationState [gui_list_create_group_when_add -wave]
gui_list_create_group_when_add -wave -disable
gui_wv_zoom_timerange -id ${Wave.5} 0 252
gui_list_add_group -id ${Wave.5} -after {New Group} {outputAlign_instance}
gui_list_select -id ${Wave.5} {cache_tb.outputAlign_instance.cache_miss1 }
gui_seek_criteria -id ${Wave.5} {Any Edge}



gui_set_env TOGGLE::DEFAULT_WAVE_WINDOW ${Wave.5}
gui_set_pref_value -category Wave -key exclusiveSG -value $groupExD
gui_list_set_height -id Wave -height $origWaveHeight
if {$origGroupCreationState} {
	gui_list_create_group_when_add -wave -enable
}
if { $groupExD } {
 gui_msg_report -code DVWW028
}
gui_list_set_filter -id ${Wave.5} -list { {Buffer 1} {Input 1} {Others 1} {Linkage 1} {Output 1} {Parameter 1} {All 1} {Aggregate 1} {LibBaseMember 1} {Event 1} {Assertion 1} {Constant 1} {Interface 1} {BaseMembers 1} {Signal 1} {$unit 1} {Inout 1} {Variable 1} }
gui_list_set_filter -id ${Wave.5} -text {*}
gui_list_set_insertion_bar  -id ${Wave.5} -group outputAlign_instance  -position in

gui_marker_move -id ${Wave.5} {C1} 224.28
gui_view_scroll -id ${Wave.5} -vertical -set 651
gui_show_grid -id ${Wave.5} -enable false
# Restore toplevel window zorder
# The toplevel window could be closed if it has no view/pane
if {[gui_exist_window -window ${TopLevel.1}]} {
	gui_set_active_window -window ${TopLevel.1}
	gui_set_active_window -window ${Source.1}
	gui_set_active_window -window ${HSPane.1}
}
if {[gui_exist_window -window ${TopLevel.2}]} {
	gui_set_active_window -window ${TopLevel.2}
	gui_set_active_window -window ${Wave.1}
}
if {[gui_exist_window -window ${TopLevel.5}]} {
	gui_set_active_window -window ${TopLevel.5}
	gui_set_active_window -window ${Wave.4}
}
if {[gui_exist_window -window ${TopLevel.4}]} {
	gui_set_active_window -window ${TopLevel.4}
	gui_set_active_window -window ${Wave.3}
}
if {[gui_exist_window -window ${TopLevel.3}]} {
	gui_set_active_window -window ${TopLevel.3}
	gui_set_active_window -window ${Wave.2}
}
if {[gui_exist_window -window ${TopLevel.6}]} {
	gui_set_active_window -window ${TopLevel.6}
	gui_set_active_window -window ${Wave.5}
}
#</Session>

