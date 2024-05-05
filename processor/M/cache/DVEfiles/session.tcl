# Begin_DVE_Session_Save_Info
# DVE reload session
# Saved on Sun May 5 02:39:17 2024
# Designs open: 1
#   V1: /home/ecelrc/students/jnederveld/Project-RAVE/processor/M/cache/cache.vpd
# Toplevel windows open: 3
# 	TopLevel.1
# 	TopLevel.2
# 	TopLevel.3
#   Source.1: cache_tb
#   Wave.1: 55 signals
#   Wave.2: 79 signals
#   Group count = 2
#   Group outputAlign_instance signal count = 55
#   Group iA signal count = 79
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
gui_update_layout -id ${Wave.1} {{show_state maximized} {dock_state undocked} {dock_on_new_line false} {child_wave_left 556} {child_wave_right 1357} {child_wave_colname 276} {child_wave_colvalue 276} {child_wave_col1 0} {child_wave_col2 1}}

# End MDI window settings


# Create and position top-level window: TopLevel.3

set TopLevel.3 TopLevel.3

# Docked window settings
gui_sync_global -id ${TopLevel.3} -option true

# MDI window settings
set Wave.2 Wave.2
gui_update_layout -id ${Wave.2} {{show_state maximized} {dock_state undocked} {dock_on_new_line false} {child_wave_left 556} {child_wave_right 1357} {child_wave_colname 276} {child_wave_colvalue 276} {child_wave_col1 0} {child_wave_col2 1}}

# End MDI window settings


#</WindowLayout>

#<Database>

# DVE Open design session: 

if { ![gui_is_db_opened -db {/home/ecelrc/students/jnederveld/Project-RAVE/processor/M/cache/cache.vpd}] } {
	gui_open_db -design V1 -file /home/ecelrc/students/jnederveld/Project-RAVE/processor/M/cache/cache.vpd -nosource
}
gui_set_precision 10ps
gui_set_time_units 10ps
#</Database>

# DVE Global setting session: 


# Global: Bus

# Global: Expressions

# Global: Signal Time Shift

# Global: Signal Compare

# Global: Signal Groups
gui_load_child_values {cache_tb.outputAlign_instance}
gui_load_child_values {cache_tb.iA}


set _session_group_5 outputAlign_instance
gui_sg_create "$_session_group_5"
set outputAlign_instance "$_session_group_5"

gui_sg_addsignal -group "$_session_group_5" { cache_tb.outputAlign_instance.E_cache_miss cache_tb.outputAlign_instance.E_cache_stall cache_tb.outputAlign_instance.E_data cache_tb.outputAlign_instance.E_needP1 cache_tb.outputAlign_instance.E_oddIsGreater cache_tb.outputAlign_instance.E_pAddress cache_tb.outputAlign_instance.E_size cache_tb.outputAlign_instance.E_vAddress cache_tb.outputAlign_instance.E_valid cache_tb.outputAlign_instance.E_wake cache_tb.outputAlign_instance.O_cache_miss cache_tb.outputAlign_instance.O_cache_stall cache_tb.outputAlign_instance.O_data cache_tb.outputAlign_instance.O_needP1 cache_tb.outputAlign_instance.O_oddIsGreater cache_tb.outputAlign_instance.O_pAddress cache_tb.outputAlign_instance.O_size cache_tb.outputAlign_instance.O_vAddress cache_tb.outputAlign_instance.O_valid cache_tb.outputAlign_instance.O_wake cache_tb.outputAlign_instance.PTC0 cache_tb.outputAlign_instance.PTC0_shift cache_tb.outputAlign_instance.PTC1 cache_tb.outputAlign_instance.PTCDATA cache_tb.outputAlign_instance.PTC_out cache_tb.outputAlign_instance.cache_miss0 cache_tb.outputAlign_instance.cache_miss1 cache_tb.outputAlign_instance.cache_stall0 cache_tb.outputAlign_instance.cache_stall1 cache_tb.outputAlign_instance.data0 cache_tb.outputAlign_instance.data0_shift cache_tb.outputAlign_instance.data1 cache_tb.outputAlign_instance.data_out cache_tb.outputAlign_instance.muxData cache_tb.outputAlign_instance.needP10 cache_tb.outputAlign_instance.needP11 cache_tb.outputAlign_instance.oddIsGreater0 cache_tb.outputAlign_instance.oddIsGreater1 cache_tb.outputAlign_instance.oneSize cache_tb.outputAlign_instance.pAddress0 cache_tb.outputAlign_instance.pAddress1 cache_tb.outputAlign_instance.preSext cache_tb.outputAlign_instance.preVAL cache_tb.outputAlign_instance.sext cache_tb.outputAlign_instance.shift0_dec cache_tb.outputAlign_instance.shift0_enc cache_tb.outputAlign_instance.size0 cache_tb.outputAlign_instance.size1 cache_tb.outputAlign_instance.vAddress0 cache_tb.outputAlign_instance.vAddress1 cache_tb.outputAlign_instance.valid0 cache_tb.outputAlign_instance.valid1 cache_tb.outputAlign_instance.valid_out cache_tb.outputAlign_instance.wake0 cache_tb.outputAlign_instance.wake1 }

set _session_group_6 iA
gui_sg_create "$_session_group_6"
set iA "$_session_group_6"

gui_sg_addsignal -group "$_session_group_6" { cache_tb.iA.PCD_not cache_tb.iA.PCD_out cache_tb.iA.PCD_out0 cache_tb.iA.PCD_out1 cache_tb.iA.PF cache_tb.iA.TLB_hit cache_tb.iA.TLB_miss cache_tb.iA.VP cache_tb.iA.addRes cache_tb.iA.address0 cache_tb.iA.address1 cache_tb.iA.address_in cache_tb.iA.adrDecBuf cache_tb.iA.adrDec cache_tb.iA.baseSize cache_tb.iA.clk cache_tb.iA.data0 cache_tb.iA.data1 cache_tb.iA.data1_t cache_tb.iA.data_in cache_tb.iA.dc cache_tb.iA.dc1 cache_tb.iA.dc2 cache_tb.iA.entry_PCD cache_tb.iA.entry_P cache_tb.iA.entry_RW cache_tb.iA.entry_V cache_tb.iA.fromBUS cache_tb.iA.fromBUS0 cache_tb.iA.fromBUS1 cache_tb.iA.fromMEM cache_tb.iA.hit0 cache_tb.iA.hit1 cache_tb.iA.idk cache_tb.iA.mask0 cache_tb.iA.mask1 cache_tb.iA.maskGen cache_tb.iA.maskSelect2 cache_tb.iA.maskSelect cache_tb.iA.miss0 cache_tb.iA.miss1 cache_tb.iA.needP1 cache_tb.iA.oneSize cache_tb.iA.prot_except0 cache_tb.iA.prot_except1 cache_tb.iA.protection_exception cache_tb.iA.r cache_tb.iA.r0 cache_tb.iA.r1 cache_tb.iA.shift0_buf cache_tb.iA.shift0_dec cache_tb.iA.shift0_enc cache_tb.iA.shift1_buf cache_tb.iA.shift1_dec cache_tb.iA.shift1_enc cache_tb.iA.shift2 cache_tb.iA.size0 cache_tb.iA.size0_n cache_tb.iA.size1 cache_tb.iA.size1_n cache_tb.iA.sizeAdd2 cache_tb.iA.sizeAdd cache_tb.iA.sizeOVR cache_tb.iA.size_dec cache_tb.iA.size_in cache_tb.iA.sw cache_tb.iA.sw0 cache_tb.iA.sw1 cache_tb.iA.tlb0 cache_tb.iA.tlb1 cache_tb.iA.vAddress0 cache_tb.iA.vAddress1 cache_tb.iA.valid0 cache_tb.iA.valid1 cache_tb.iA.valid1_t cache_tb.iA.valid_in cache_tb.iA.w cache_tb.iA.w0 cache_tb.iA.w1 }

# Global: Highlighting

# Global: Stack
gui_change_stack_mode -mode list

# Post database loading setting...

# Restore C1 time
gui_set_time -C1_only 12144



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
catch {gui_list_select -id ${Hier.1} {cache_tb.iA}}
gui_view_scroll -id ${Hier.1} -vertical -set 0
gui_view_scroll -id ${Hier.1} -horizontal -set 0

# Data 'Data.1'
gui_list_set_filter -id ${Data.1} -list { {Buffer 1} {Input 1} {Others 1} {Linkage 1} {Output 1} {LowPower 1} {Parameter 1} {All 1} {Aggregate 1} {LibBaseMember 1} {Event 1} {Assertion 1} {Constant 1} {Interface 1} {BaseMembers 1} {Signal 1} {$unit 1} {Inout 1} {Variable 1} }
gui_list_set_filter -id ${Data.1} -text {*}
gui_list_show_data -id ${Data.1} {cache_tb.iA}
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
gui_wv_zoom_timerange -id ${Wave.1} 0 13200
gui_list_add_group -id ${Wave.1} -after {New Group} {outputAlign_instance}
gui_list_select -id ${Wave.1} {cache_tb.outputAlign_instance.valid1 }
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
gui_list_set_insertion_bar  -id ${Wave.1} -group outputAlign_instance  -position in

gui_marker_move -id ${Wave.1} {C1} 12144
gui_view_scroll -id ${Wave.1} -vertical -set 602
gui_show_grid -id ${Wave.1} -enable false

# View 'Wave.2'
gui_wv_sync -id ${Wave.2} -switch false
set groupExD [gui_get_pref_value -category Wave -key exclusiveSG]
gui_set_pref_value -category Wave -key exclusiveSG -value {false}
set origWaveHeight [gui_get_pref_value -category Wave -key waveRowHeight]
gui_list_set_height -id Wave -height 25
set origGroupCreationState [gui_list_create_group_when_add -wave]
gui_list_create_group_when_add -wave -disable
gui_wv_zoom_timerange -id ${Wave.2} 0 13200
gui_list_add_group -id ${Wave.2} -after {New Group} {iA}
gui_seek_criteria -id ${Wave.2} {Any Edge}



gui_set_env TOGGLE::DEFAULT_WAVE_WINDOW ${Wave.2}
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
gui_list_set_insertion_bar  -id ${Wave.2} -group iA  -position in

gui_marker_move -id ${Wave.2} {C1} 12144
gui_view_scroll -id ${Wave.2} -vertical -set 0
gui_show_grid -id ${Wave.2} -enable false
# Restore toplevel window zorder
# The toplevel window could be closed if it has no view/pane
if {[gui_exist_window -window ${TopLevel.1}]} {
	gui_set_active_window -window ${TopLevel.1}
	gui_set_active_window -window ${Source.1}
	gui_set_active_window -window ${HSPane.1}
}
if {[gui_exist_window -window ${TopLevel.3}]} {
	gui_set_active_window -window ${TopLevel.3}
	gui_set_active_window -window ${Wave.2}
}
if {[gui_exist_window -window ${TopLevel.2}]} {
	gui_set_active_window -window ${TopLevel.2}
	gui_set_active_window -window ${Wave.1}
}
#</Session>

