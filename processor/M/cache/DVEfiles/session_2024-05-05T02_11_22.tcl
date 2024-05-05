# Begin_DVE_Session_Save_Info
# DVE full session
# Saved on Sun May 5 02:11:22 2024
# Designs open: 1
#   V1: /home/ecelrc/students/jnederveld/Project-RAVE/processor/M/cache/cache.vpd
# Toplevel windows open: 1
# 	TopLevel.2
#   Wave.1: 55 signals
#   Group count = 3
#   Group outputAlign_instance signal count = 55
#   Group iA signal count = 78
#   Group outputAlign_instance_1 signal count = 55
# End_DVE_Session_Save_Info

# DVE version: T-2022.06_Full64
# DVE build date: May 31 2022 20:53:03


#<Session mode="Full" path="/home/ecelrc/students/jnederveld/Project-RAVE/processor/M/cache/DVEfiles/session.tcl" type="Debug">

gui_set_loading_session_type Post
gui_continuetime_set

# Close design
if { [gui_sim_state -check active] } {
    gui_sim_terminate
}
gui_close_db -all
gui_expr_clear_all

# Close all windows
gui_close_window -type Console
gui_close_window -type Wave
gui_close_window -type Source
gui_close_window -type Schematic
gui_close_window -type Data
gui_close_window -type DriverLoad
gui_close_window -type List
gui_close_window -type Memory
gui_close_window -type HSPane
gui_close_window -type DLPane
gui_close_window -type Assertion
gui_close_window -type CovHier
gui_close_window -type CoverageTable
gui_close_window -type CoverageMap
gui_close_window -type CovDetail
gui_close_window -type Local
gui_close_window -type Stack
gui_close_window -type Watch
gui_close_window -type Group
gui_close_window -type Transaction



# Application preferences
gui_set_pref_value -key app_default_font -value {Helvetica,10,-1,5,50,0,0,0,0,0}
gui_src_preferences -tabstop 8 -maxbits 24 -windownumber 1
#<WindowLayout>

# DVE top-level session


# Create and position top-level window: TopLevel.2

if {![gui_exist_window -window TopLevel.2]} {
    set TopLevel.2 [ gui_create_window -type TopLevel \
       -icon $::env(DVE)/auxx/gui/images/toolbars/dvewin.xpm] 
} else { 
    set TopLevel.2 TopLevel.2
}
gui_show_window -window ${TopLevel.2} -show_state normal -rect {{2560 539} {3824 1172}}

# ToolBar settings
gui_set_toolbar_attributes -toolbar {TimeOperations} -dock_state top
gui_set_toolbar_attributes -toolbar {TimeOperations} -offset 0
gui_show_toolbar -toolbar {TimeOperations}
gui_hide_toolbar -toolbar {&File}
gui_set_toolbar_attributes -toolbar {&Edit} -dock_state top
gui_set_toolbar_attributes -toolbar {&Edit} -offset 0
gui_show_toolbar -toolbar {&Edit}
gui_hide_toolbar -toolbar {CopyPaste}
gui_set_toolbar_attributes -toolbar {&Trace} -dock_state top
gui_set_toolbar_attributes -toolbar {&Trace} -offset 0
gui_show_toolbar -toolbar {&Trace}
gui_hide_toolbar -toolbar {TraceInstance}
gui_hide_toolbar -toolbar {BackTrace}
gui_set_toolbar_attributes -toolbar {&Scope} -dock_state top
gui_set_toolbar_attributes -toolbar {&Scope} -offset 0
gui_show_toolbar -toolbar {&Scope}
gui_set_toolbar_attributes -toolbar {&Window} -dock_state top
gui_set_toolbar_attributes -toolbar {&Window} -offset 0
gui_show_toolbar -toolbar {&Window}
gui_set_toolbar_attributes -toolbar {Signal} -dock_state top
gui_set_toolbar_attributes -toolbar {Signal} -offset 0
gui_show_toolbar -toolbar {Signal}
gui_set_toolbar_attributes -toolbar {Zoom} -dock_state top
gui_set_toolbar_attributes -toolbar {Zoom} -offset 0
gui_show_toolbar -toolbar {Zoom}
gui_set_toolbar_attributes -toolbar {Zoom And Pan History} -dock_state top
gui_set_toolbar_attributes -toolbar {Zoom And Pan History} -offset 0
gui_show_toolbar -toolbar {Zoom And Pan History}
gui_set_toolbar_attributes -toolbar {Grid} -dock_state top
gui_set_toolbar_attributes -toolbar {Grid} -offset 0
gui_show_toolbar -toolbar {Grid}
gui_hide_toolbar -toolbar {Simulator}
gui_hide_toolbar -toolbar {Interactive Rewind}
gui_set_toolbar_attributes -toolbar {Testbench} -dock_state top
gui_set_toolbar_attributes -toolbar {Testbench} -offset 0
gui_show_toolbar -toolbar {Testbench}

# End ToolBar settings

# Docked window settings
gui_sync_global -id ${TopLevel.2} -option true

# MDI window settings
set Wave.1 [gui_create_window -type {Wave}  -parent ${TopLevel.2}]
gui_show_window -window ${Wave.1} -show_state maximized
gui_update_layout -id ${Wave.1} {{show_state maximized} {dock_state undocked} {dock_on_new_line false} {child_wave_left 366} {child_wave_right 893} {child_wave_colname 102} {child_wave_colvalue 260} {child_wave_col1 0} {child_wave_col2 1}}

# End MDI window settings

gui_set_env TOPLEVELS::TARGET_FRAME(Source) none
gui_set_env TOPLEVELS::TARGET_FRAME(Schematic) none
gui_set_env TOPLEVELS::TARGET_FRAME(PathSchematic) none
gui_set_env TOPLEVELS::TARGET_FRAME(Wave) none
gui_set_env TOPLEVELS::TARGET_FRAME(List) none
gui_set_env TOPLEVELS::TARGET_FRAME(Memory) none
gui_set_env TOPLEVELS::TARGET_FRAME(DriverLoad) none
gui_update_statusbar_target_frame ${TopLevel.2}

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


set _session_group_3 outputAlign_instance
gui_sg_create "$_session_group_3"
set outputAlign_instance "$_session_group_3"

gui_sg_addsignal -group "$_session_group_3" { cache_tb.outputAlign_instance.E_valid cache_tb.outputAlign_instance.E_data cache_tb.outputAlign_instance.E_vAddress cache_tb.outputAlign_instance.E_pAddress cache_tb.outputAlign_instance.E_size cache_tb.outputAlign_instance.E_wake cache_tb.outputAlign_instance.E_cache_stall cache_tb.outputAlign_instance.E_cache_miss cache_tb.outputAlign_instance.E_oddIsGreater cache_tb.outputAlign_instance.E_needP1 cache_tb.outputAlign_instance.oneSize cache_tb.outputAlign_instance.O_valid cache_tb.outputAlign_instance.O_data cache_tb.outputAlign_instance.O_vAddress cache_tb.outputAlign_instance.O_pAddress cache_tb.outputAlign_instance.O_size cache_tb.outputAlign_instance.O_wake cache_tb.outputAlign_instance.O_cache_stall cache_tb.outputAlign_instance.O_cache_miss cache_tb.outputAlign_instance.O_oddIsGreater cache_tb.outputAlign_instance.O_needP1 cache_tb.outputAlign_instance.PTC_out cache_tb.outputAlign_instance.data_out cache_tb.outputAlign_instance.valid_out cache_tb.outputAlign_instance.wake1 cache_tb.outputAlign_instance.wake0 cache_tb.outputAlign_instance.valid0 cache_tb.outputAlign_instance.data0 cache_tb.outputAlign_instance.vAddress0 cache_tb.outputAlign_instance.pAddress0 cache_tb.outputAlign_instance.size0 cache_tb.outputAlign_instance.cache_stall0 cache_tb.outputAlign_instance.cache_miss0 cache_tb.outputAlign_instance.oddIsGreater0 cache_tb.outputAlign_instance.needP10 cache_tb.outputAlign_instance.valid1 cache_tb.outputAlign_instance.data1 cache_tb.outputAlign_instance.vAddress1 cache_tb.outputAlign_instance.pAddress1 cache_tb.outputAlign_instance.size1 cache_tb.outputAlign_instance.cache_stall1 cache_tb.outputAlign_instance.cache_miss1 cache_tb.outputAlign_instance.oddIsGreater1 cache_tb.outputAlign_instance.needP11 cache_tb.outputAlign_instance.shift0_enc cache_tb.outputAlign_instance.data0_shift cache_tb.outputAlign_instance.shift0_dec cache_tb.outputAlign_instance.muxData cache_tb.outputAlign_instance.preSext cache_tb.outputAlign_instance.sext cache_tb.outputAlign_instance.PTC0_shift cache_tb.outputAlign_instance.PTC0 cache_tb.outputAlign_instance.PTC1 cache_tb.outputAlign_instance.preVAL cache_tb.outputAlign_instance.PTCDATA }

set _session_group_4 iA
gui_sg_create "$_session_group_4"
set iA "$_session_group_4"

gui_sg_addsignal -group "$_session_group_4" { cache_tb.iA.PCD_not cache_tb.iA.PCD_out cache_tb.iA.PCD_out0 cache_tb.iA.PCD_out1 cache_tb.iA.PF cache_tb.iA.TLB_hit cache_tb.iA.TLB_miss cache_tb.iA.VP cache_tb.iA.addRes cache_tb.iA.address0 cache_tb.iA.address1 cache_tb.iA.address_in cache_tb.iA.adrDecBuf cache_tb.iA.adrDec cache_tb.iA.baseSize cache_tb.iA.clk cache_tb.iA.data0 cache_tb.iA.data1 cache_tb.iA.data1_t cache_tb.iA.data_in cache_tb.iA.dc cache_tb.iA.dc1 cache_tb.iA.dc2 cache_tb.iA.entry_PCD cache_tb.iA.entry_P cache_tb.iA.entry_RW cache_tb.iA.entry_V cache_tb.iA.fromBUS cache_tb.iA.fromBUS0 cache_tb.iA.fromBUS1 cache_tb.iA.fromMEM cache_tb.iA.hit0 cache_tb.iA.hit1 cache_tb.iA.idk cache_tb.iA.mask0 cache_tb.iA.mask1 cache_tb.iA.maskGen cache_tb.iA.maskSelect2 cache_tb.iA.maskSelect cache_tb.iA.miss0 cache_tb.iA.miss1 cache_tb.iA.needP1 cache_tb.iA.oneSize cache_tb.iA.prot_except0 cache_tb.iA.prot_except1 cache_tb.iA.protection_exception cache_tb.iA.r cache_tb.iA.r0 cache_tb.iA.r1 cache_tb.iA.shift0_buf cache_tb.iA.shift0_dec cache_tb.iA.shift0_enc cache_tb.iA.shift1_buf cache_tb.iA.shift1_dec cache_tb.iA.shift1_enc cache_tb.iA.shift2 cache_tb.iA.size0 cache_tb.iA.size0_n cache_tb.iA.size1 cache_tb.iA.size1_n cache_tb.iA.sizeAdd cache_tb.iA.sizeOVR cache_tb.iA.size_dec cache_tb.iA.size_in cache_tb.iA.sw cache_tb.iA.sw0 cache_tb.iA.sw1 cache_tb.iA.tlb0 cache_tb.iA.tlb1 cache_tb.iA.vAddress0 cache_tb.iA.vAddress1 cache_tb.iA.valid0 cache_tb.iA.valid1 cache_tb.iA.valid1_t cache_tb.iA.valid_in cache_tb.iA.w cache_tb.iA.w0 cache_tb.iA.w1 }

set _session_group_5 outputAlign_instance_1
gui_sg_create "$_session_group_5"
set outputAlign_instance_1 "$_session_group_5"

gui_sg_addsignal -group "$_session_group_5" { cache_tb.outputAlign_instance.E_cache_miss cache_tb.outputAlign_instance.E_cache_stall cache_tb.outputAlign_instance.E_data cache_tb.outputAlign_instance.E_needP1 cache_tb.outputAlign_instance.E_oddIsGreater cache_tb.outputAlign_instance.E_pAddress cache_tb.outputAlign_instance.E_size cache_tb.outputAlign_instance.E_vAddress cache_tb.outputAlign_instance.E_valid cache_tb.outputAlign_instance.E_wake cache_tb.outputAlign_instance.O_cache_miss cache_tb.outputAlign_instance.O_cache_stall cache_tb.outputAlign_instance.O_data cache_tb.outputAlign_instance.O_needP1 cache_tb.outputAlign_instance.O_oddIsGreater cache_tb.outputAlign_instance.O_pAddress cache_tb.outputAlign_instance.O_size cache_tb.outputAlign_instance.O_vAddress cache_tb.outputAlign_instance.O_valid cache_tb.outputAlign_instance.O_wake cache_tb.outputAlign_instance.PTC0 cache_tb.outputAlign_instance.PTC0_shift cache_tb.outputAlign_instance.PTC1 cache_tb.outputAlign_instance.PTCDATA cache_tb.outputAlign_instance.PTC_out cache_tb.outputAlign_instance.cache_miss0 cache_tb.outputAlign_instance.cache_miss1 cache_tb.outputAlign_instance.cache_stall0 cache_tb.outputAlign_instance.cache_stall1 cache_tb.outputAlign_instance.data0 cache_tb.outputAlign_instance.data0_shift cache_tb.outputAlign_instance.data1 cache_tb.outputAlign_instance.data_out cache_tb.outputAlign_instance.muxData cache_tb.outputAlign_instance.needP10 cache_tb.outputAlign_instance.needP11 cache_tb.outputAlign_instance.oddIsGreater0 cache_tb.outputAlign_instance.oddIsGreater1 cache_tb.outputAlign_instance.oneSize cache_tb.outputAlign_instance.pAddress0 cache_tb.outputAlign_instance.pAddress1 cache_tb.outputAlign_instance.preSext cache_tb.outputAlign_instance.preVAL cache_tb.outputAlign_instance.sext cache_tb.outputAlign_instance.shift0_dec cache_tb.outputAlign_instance.shift0_enc cache_tb.outputAlign_instance.size0 cache_tb.outputAlign_instance.size1 cache_tb.outputAlign_instance.vAddress0 cache_tb.outputAlign_instance.vAddress1 cache_tb.outputAlign_instance.valid0 cache_tb.outputAlign_instance.valid1 cache_tb.outputAlign_instance.valid_out cache_tb.outputAlign_instance.wake0 cache_tb.outputAlign_instance.wake1 }

# Global: Highlighting

# Global: Stack
gui_change_stack_mode -mode list

# Post database loading setting...

# Restore C1 time
gui_set_time -C1_only 9527



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


# View 'Wave.1'
gui_wv_sync -id ${Wave.1} -switch false
set groupExD [gui_get_pref_value -category Wave -key exclusiveSG]
gui_set_pref_value -category Wave -key exclusiveSG -value {false}
set origWaveHeight [gui_get_pref_value -category Wave -key waveRowHeight]
gui_list_set_height -id Wave -height 25
set origGroupCreationState [gui_list_create_group_when_add -wave]
gui_list_create_group_when_add -wave -disable
gui_marker_set_ref -id ${Wave.1}  C1
gui_wv_zoom_timerange -id ${Wave.1} 0 8619
gui_list_add_group -id ${Wave.1} -after {New Group} {outputAlign_instance}
gui_list_select -id ${Wave.1} {cache_tb.outputAlign_instance.oneSize }
gui_seek_criteria -id ${Wave.1} {Any Edge}



gui_set_env TOGGLE::DEFAULT_WAVE_WINDOW ${Wave.1}
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

gui_marker_move -id ${Wave.1} {C1} 9527
gui_view_scroll -id ${Wave.1} -vertical -set 75
gui_show_grid -id ${Wave.1} -enable false
# Restore toplevel window zorder
# The toplevel window could be closed if it has no view/pane
if {[gui_exist_window -window ${TopLevel.2}]} {
	gui_set_active_window -window ${TopLevel.2}
	gui_set_active_window -window ${Wave.1}
}
#</Session>

