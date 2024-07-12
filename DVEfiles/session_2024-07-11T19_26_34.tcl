# Begin_DVE_Session_Save_Info
# DVE full session
# Saved on Thu Jul 11 19:26:34 2024
# Designs open: 1
#   V1: /home/ecelrc/students/rjain1/uarch/Project-RAVE/processor.dump.vpd
# Toplevel windows open: 1
# 	TopLevel.1
#   Source.1: TOP
#   Group count = 1
#   Group TOP signal count = 655
# End_DVE_Session_Save_Info

# DVE version: T-2022.06_Full64
# DVE build date: May 31 2022 20:53:03


#<Session mode="Full" path="/home/ecelrc/students/rjain1/uarch/Project-RAVE/DVEfiles/session.tcl" type="Debug">

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


# Create and position top-level window: TopLevel.1

if {![gui_exist_window -window TopLevel.1]} {
    set TopLevel.1 [ gui_create_window -type TopLevel \
       -icon $::env(DVE)/auxx/gui/images/toolbars/dvewin.xpm] 
} else { 
    set TopLevel.1 TopLevel.1
}
gui_show_window -window ${TopLevel.1} -show_state normal -rect {{248 258} {1739 1059}}

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
gui_hide_toolbar -toolbar {Testbench}

# End ToolBar settings

# Docked window settings
set HSPane.1 [gui_create_window -type HSPane -parent ${TopLevel.1} -dock_state left -dock_on_new_line true -dock_extent 298]
catch { set Hier.1 [gui_share_window -id ${HSPane.1} -type Hier] }
gui_set_window_pref_key -window ${HSPane.1} -key dock_width -value_type integer -value 298
gui_set_window_pref_key -window ${HSPane.1} -key dock_height -value_type integer -value -1
gui_set_window_pref_key -window ${HSPane.1} -key dock_offset -value_type integer -value 0
gui_update_layout -id ${HSPane.1} {{left 0} {top 0} {width 297} {height 589} {dock_state left} {dock_on_new_line true} {child_hier_colhier 275} {child_hier_coltype 122} {child_hier_colpd 0} {child_hier_col1 0} {child_hier_col2 1} {child_hier_col3 -1}}
set DLPane.1 [gui_create_window -type DLPane -parent ${TopLevel.1} -dock_state left -dock_on_new_line true -dock_extent 149]
catch { set Data.1 [gui_share_window -id ${DLPane.1} -type Data] }
gui_set_window_pref_key -window ${DLPane.1} -key dock_width -value_type integer -value 149
gui_set_window_pref_key -window ${DLPane.1} -key dock_height -value_type integer -value 590
gui_set_window_pref_key -window ${DLPane.1} -key dock_offset -value_type integer -value 0
gui_update_layout -id ${DLPane.1} {{left 0} {top 0} {width 148} {height 589} {dock_state left} {dock_on_new_line true} {child_data_colvariable 140} {child_data_colvalue 100} {child_data_coltype 40} {child_data_col1 0} {child_data_col2 1} {child_data_col3 2}}
set Console.1 [gui_create_window -type Console -parent ${TopLevel.1} -dock_state bottom -dock_on_new_line true -dock_extent 105]
gui_set_window_pref_key -window ${Console.1} -key dock_width -value_type integer -value 1492
gui_set_window_pref_key -window ${Console.1} -key dock_height -value_type integer -value 105
gui_set_window_pref_key -window ${Console.1} -key dock_offset -value_type integer -value 0
gui_update_layout -id ${Console.1} {{left 0} {top 0} {width 1491} {height 105} {dock_state bottom} {dock_on_new_line true}}
#### Start - Readjusting docked view's offset / size
set dockAreaList { top left right bottom }
foreach dockArea $dockAreaList {
  set viewList [gui_ekki_get_window_ids -active_parent -dock_area $dockArea]
  foreach view $viewList {
      if {[lsearch -exact [gui_get_window_pref_keys -window $view] dock_width] != -1} {
        set dockWidth [gui_get_window_pref_value -window $view -key dock_width]
        set dockHeight [gui_get_window_pref_value -window $view -key dock_height]
        set offset [gui_get_window_pref_value -window $view -key dock_offset]
        if { [string equal "top" $dockArea] || [string equal "bottom" $dockArea]} {
          gui_set_window_attributes -window $view -dock_offset $offset -width $dockWidth
        } else {
          gui_set_window_attributes -window $view -dock_offset $offset -height $dockHeight
        }
      }
  }
}
#### End - Readjusting docked view's offset / size
gui_sync_global -id ${TopLevel.1} -option true

# MDI window settings
set Source.1 [gui_create_window -type {Source}  -parent ${TopLevel.1}]
gui_show_window -window ${Source.1} -show_state maximized
gui_update_layout -id ${Source.1} {{show_state maximized} {dock_state undocked} {dock_on_new_line false}}

# End MDI window settings

gui_set_env TOPLEVELS::TARGET_FRAME(Source) ${TopLevel.1}
gui_set_env TOPLEVELS::TARGET_FRAME(Schematic) ${TopLevel.1}
gui_set_env TOPLEVELS::TARGET_FRAME(PathSchematic) none
gui_set_env TOPLEVELS::TARGET_FRAME(Wave) none
gui_set_env TOPLEVELS::TARGET_FRAME(List) none
gui_set_env TOPLEVELS::TARGET_FRAME(Memory) ${TopLevel.1}
gui_set_env TOPLEVELS::TARGET_FRAME(DriverLoad) none
gui_update_statusbar_target_frame ${TopLevel.1}

#</WindowLayout>

#<Database>

# DVE Open design session: 

if { ![gui_is_db_opened -db {/home/ecelrc/students/rjain1/uarch/Project-RAVE/processor.dump.vpd}] } {
	gui_open_db -design V1 -file /home/ecelrc/students/rjain1/uarch/Project-RAVE/processor.dump.vpd -nosource
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
gui_load_child_values {TOP}


set _session_group_1 TOP
gui_sg_create "$_session_group_1"
set TOP "$_session_group_1"

gui_sg_addsignal -group "$_session_group_1" { TOP.file TOP.clk TOP.bus_clk TOP.cycle_number TOP.packet TOP.D_valid TOP.VP_0 TOP.VP_1 TOP.VP_2 TOP.VP_3 TOP.VP_4 TOP.VP_5 TOP.VP_6 TOP.VP_7 TOP.PF_0 TOP.PF_1 TOP.PF_2 TOP.PF_3 TOP.PF_4 TOP.PF_5 TOP.PF_6 TOP.PF_7 TOP.entry_v TOP.entry_P TOP.entry_RW TOP.entry_PCD TOP.VP TOP.PF TOP.global_reset TOP.global_set TOP.global_init TOP.EIP_init TOP.IDTR_base TOP.EX_stall_out TOP.MEM_stall_out TOP.RrAg_stall_out TOP.D_stall_out TOP.D_RrAg_Latches_full TOP.MEM_EX_Latches_full TOP.D_RrAg_Latches_empty TOP.MEM_EX_Latches_empty TOP.valid_F_D_latch_in TOP.packet_F_D_latch_in TOP.BP_alias_F_D_latch_in TOP.IE_F_D_latch_in TOP.IE_type_F_D_latch_in TOP.BR_pred_target_F_D_latch_in TOP.BR_pred_T_NT_F_D_latch_in TOP.valid_F_D_latch_out TOP.packet_F_D_latch_out TOP.BP_alias_F_D_latch_out TOP.IE_F_D_latch_out TOP.IE_type_F_D_latch_out TOP.BR_pred_target_F_D_latch_out TOP.BR_pred_T_NT_F_D_latch_out TOP.D_length_D_F_out TOP.valid_out_D_RrAg_latch_in TOP.reg_addr1_D_RrAg_latch_in TOP.reg_addr2_D_RrAg_latch_in TOP.reg_addr3_D_RrAg_latch_in TOP.reg_addr4_D_RrAg_latch_in TOP.seg_addr1_D_RrAg_latch_in TOP.seg_addr2_D_RrAg_latch_in TOP.seg_addr3_D_RrAg_latch_in TOP.seg_addr4_D_RrAg_latch_in TOP.opsize_D_RrAg_latch_in TOP.addressingmode_D_RrAg_latch_in TOP.op1_D_RrAg_latch_in TOP.op2_D_RrAg_latch_in TOP.op3_D_RrAg_latch_in TOP.op4_D_RrAg_latch_in TOP.res1_ld_D_RrAg_latch_in TOP.res2_ld_D_RrAg_latch_in TOP.res3_ld_D_RrAg_latch_in TOP.res4_ld_D_RrAg_latch_in TOP.dest1_D_RrAg_latch_in TOP.dest2_D_RrAg_latch_in TOP.dest3_D_RrAg_latch_in TOP.dest4_D_RrAg_latch_in TOP.disp_D_RrAg_latch_in TOP.reg3_shfamnt_D_RrAg_latch_in TOP.usereg2_D_RrAg_latch_in TOP.usereg3_D_RrAg_latch_in TOP.rep_D_RrAg_latch_in TOP.BP_alias_D_RrAg_latch_in TOP.aluk_D_RrAg_latch_in TOP.mux_adder_D_RrAg_latch_in TOP.mux_and_int_D_RrAg_latch_in TOP.mux_shift_D_RrAg_latch_in TOP.p_op_D_RrAg_latch_in TOP.p_op_D_out TOP.fmask_D_RrAg_latch_in TOP.conditionals_D_RrAg_latch_in TOP.is_br_D_RrAg_latch_in TOP.is_fp_D_RrAg_latch_in TOP.imm_D_RrAg_latch_in TOP.mem1_rw_D_RrAg_latch_in TOP.mem2_rw_D_RrAg_latch_in TOP.latched_eip_D_RrAg_latch_in TOP.eip_D_RrAg_latch_in TOP.IE_D_RrAg_latch_in TOP.IE_type_D_RrAg_latch_in TOP.BR_pred_target_D_RrAg_latch_in TOP.BR_pred_T_NT_D_RrAg_latch_in TOP.is_imm_D_RrAg_latch_in TOP.memSizeOVR_D_RrAg_latch_in TOP.valid_out_D_RrAg_latch_out TOP.reg_addr1_D_RrAg_latch_out TOP.reg_addr2_D_RrAg_latch_out TOP.reg_addr3_D_RrAg_latch_out TOP.reg_addr4_D_RrAg_latch_out TOP.seg_addr1_D_RrAg_latch_out TOP.seg_addr2_D_RrAg_latch_out TOP.seg_addr3_D_RrAg_latch_out TOP.seg_addr4_D_RrAg_latch_out TOP.opsize_D_RrAg_latch_out TOP.addressingmode_D_RrAg_latch_out TOP.op1_D_RrAg_latch_out TOP.op2_D_RrAg_latch_out TOP.op3_D_RrAg_latch_out TOP.op4_D_RrAg_latch_out TOP.res1_ld_D_RrAg_latch_out TOP.res2_ld_D_RrAg_latch_out TOP.res3_ld_D_RrAg_latch_out TOP.res4_ld_D_RrAg_latch_out TOP.dest1_D_RrAg_latch_out TOP.dest2_D_RrAg_latch_out TOP.dest3_D_RrAg_latch_out TOP.dest4_D_RrAg_latch_out TOP.disp_D_RrAg_latch_out TOP.reg3_shfamnt_D_RrAg_latch_out TOP.usereg2_D_RrAg_latch_out TOP.usereg3_D_RrAg_latch_out TOP.rep_D_RrAg_latch_out TOP.BP_alias_D_RrAg_latch_out TOP.aluk_D_RrAg_latch_out TOP.mux_adder_D_RrAg_latch_out TOP.mux_and_int_D_RrAg_latch_out TOP.mux_shift_D_RrAg_latch_out TOP.p_op_D_RrAg_latch_out TOP.fmask_D_RrAg_latch_out TOP.conditionals_D_RrAg_latch_out TOP.is_br_D_RrAg_latch_out TOP.is_fp_D_RrAg_latch_out TOP.imm_D_RrAg_latch_out TOP.mem1_rw_D_RrAg_latch_out TOP.mem2_rw_D_RrAg_latch_out TOP.latched_eip_D_RrAg_latch_out TOP.eip_D_RrAg_latch_out TOP.IE_D_RrAg_latch_out TOP.IE_type_D_RrAg_latch_out TOP.BR_pred_target_D_RrAg_latch_out TOP.BR_pred_T_NT_D_RrAg_latch_out TOP.is_imm_D_RrAg_latch_out TOP.memSizeOVR_D_RrAg_latch_out TOP.valid_RrAg_MEM_latch_in TOP.opsize_RrAg_MEM_latch_in TOP.mem_addr1_RrAg_MEM_latch_in TOP.mem_addr2_RrAg_MEM_latch_in TOP.mem_addr1_end_RrAg_MEM_latch_in TOP.mem_addr2_end_RrAg_MEM_latch_in TOP.reg1_RrAg_MEM_latch_in TOP.reg2_RrAg_MEM_latch_in TOP.reg3_RrAg_MEM_latch_in TOP.reg4_RrAg_MEM_latch_in }
gui_sg_addsignal -group "$_session_group_1" { TOP.ptc_r1_RrAg_MEM_latch_in TOP.ptc_r2_RrAg_MEM_latch_in TOP.ptc_r3_RrAg_MEM_latch_in TOP.ptc_r4_RrAg_MEM_latch_in TOP.reg1_orig_RrAg_MEM_latch_in TOP.reg2_orig_RrAg_MEM_latch_in TOP.reg3_orig_RrAg_MEM_latch_in TOP.reg4_orig_RrAg_MEM_latch_in TOP.seg1_RrAg_MEM_latch_in TOP.seg2_RrAg_MEM_latch_in TOP.seg3_RrAg_MEM_latch_in TOP.seg4_RrAg_MEM_latch_in TOP.ptc_s1_RrAg_MEM_latch_in TOP.ptc_s2_RrAg_MEM_latch_in TOP.ptc_s3_RrAg_MEM_latch_in TOP.ptc_s4_RrAg_MEM_latch_in TOP.seg1_orig_RrAg_MEM_latch_in TOP.seg2_orig_RrAg_MEM_latch_in TOP.seg3_orig_RrAg_MEM_latch_in TOP.seg4_orig_RrAg_MEM_latch_in TOP.inst_ptcid_RrAg_MEM_latch_in TOP.op1_RrAg_MEM_latch_in TOP.op2_RrAg_MEM_latch_in TOP.op3_RrAg_MEM_latch_in TOP.op4_RrAg_MEM_latch_in TOP.dest1_RrAg_MEM_latch_in TOP.dest2_RrAg_MEM_latch_in TOP.dest3_RrAg_MEM_latch_in TOP.dest4_RrAg_MEM_latch_in TOP.res1_ld_RrAg_MEM_latch_in TOP.res2_ld_RrAg_MEM_latch_in TOP.res3_ld_RrAg_MEM_latch_in TOP.res4_ld_RrAg_MEM_latch_in TOP.rep_num_RrAg_MEM_latch_in TOP.is_rep_RrAg_MEM_latch_in TOP.aluk_RrAg_MEM_latch_in TOP.mux_adder_RrAg_MEM_latch_in TOP.mux_and_int_RrAg_MEM_latch_in TOP.mux_shift_RrAg_MEM_latch_in TOP.p_op_RrAg_MEM_latch_in TOP.fmask_RrAg_MEM_latch_in TOP.conditionals_RrAg_MEM_latch_in TOP.CS_RrAg_MEM_latch_in TOP.is_br_RrAg_MEM_latch_in TOP.is_fp_RrAg_MEM_latch_in TOP.is_imm_RrAg_MEM_latch_in TOP.imm_RrAg_MEM_latch_in TOP.mem1_rw_RrAg_MEM_latch_in TOP.mem2_rw_RrAg_MEM_latch_in TOP.eip_RrAg_MEM_latch_in TOP.latched_eip_RrAg_MEM_latch_in TOP.IE_RrAg_MEM_latch_in TOP.IE_type_RrAg_MEM_latch_in TOP.BR_pred_target_RrAg_MEM_latch_in TOP.BR_pred_T_NT_RrAg_MEM_latch_in TOP.BP_alias_RrAg_MEM_latch_in TOP.memSizeOVR_RrAg_MEM_latch_in TOP.valid_RrAg_MEM_latch_out TOP.opsize_RrAg_MEM_latch_out TOP.mem_addr1_RrAg_MEM_latch_out TOP.mem_addr2_RrAg_MEM_latch_out TOP.mem_addr1_end_RrAg_MEM_latch_out TOP.mem_addr2_end_RrAg_MEM_latch_out TOP.reg1_RrAg_MEM_latch_out TOP.reg2_RrAg_MEM_latch_out TOP.reg3_RrAg_MEM_latch_out TOP.reg4_RrAg_MEM_latch_out TOP.ptc_r1_RrAg_MEM_latch_out TOP.ptc_r2_RrAg_MEM_latch_out TOP.ptc_r3_RrAg_MEM_latch_out TOP.ptc_r4_RrAg_MEM_latch_out TOP.reg1_orig_RrAg_MEM_latch_out TOP.reg2_orig_RrAg_MEM_latch_out TOP.reg3_orig_RrAg_MEM_latch_out TOP.reg4_orig_RrAg_MEM_latch_out TOP.seg1_RrAg_MEM_latch_out TOP.seg2_RrAg_MEM_latch_out TOP.seg3_RrAg_MEM_latch_out TOP.seg4_RrAg_MEM_latch_out TOP.ptc_s1_RrAg_MEM_latch_out TOP.ptc_s2_RrAg_MEM_latch_out TOP.ptc_s3_RrAg_MEM_latch_out TOP.ptc_s4_RrAg_MEM_latch_out TOP.seg1_orig_RrAg_MEM_latch_out TOP.seg2_orig_RrAg_MEM_latch_out TOP.seg3_orig_RrAg_MEM_latch_out TOP.seg4_orig_RrAg_MEM_latch_out TOP.inst_ptcid_RrAg_MEM_latch_out TOP.op1_RrAg_MEM_latch_out TOP.op2_RrAg_MEM_latch_out TOP.op3_RrAg_MEM_latch_out TOP.op4_RrAg_MEM_latch_out TOP.dest1_RrAg_MEM_latch_out TOP.dest2_RrAg_MEM_latch_out TOP.dest3_RrAg_MEM_latch_out TOP.dest4_RrAg_MEM_latch_out TOP.res1_ld_RrAg_MEM_latch_out TOP.res2_ld_RrAg_MEM_latch_out TOP.res3_ld_RrAg_MEM_latch_out TOP.res4_ld_RrAg_MEM_latch_out TOP.rep_num_RrAg_MEM_latch_out TOP.is_rep_RrAg_MEM_latch_out TOP.aluk_RrAg_MEM_latch_out TOP.mux_adder_RrAg_MEM_latch_out TOP.mux_and_int_RrAg_MEM_latch_out TOP.mux_shift_RrAg_MEM_latch_out TOP.p_op_RrAg_MEM_latch_out TOP.fmask_RrAg_MEM_latch_out TOP.CS_RrAg_MEM_latch_out TOP.conditionals_RrAg_MEM_latch_out TOP.is_br_RrAg_MEM_latch_out TOP.is_fp_RrAg_MEM_latch_out TOP.is_imm_RrAg_MEM_latch_out TOP.imm_RrAg_MEM_latch_out TOP.mem1_rw_RrAg_MEM_latch_out TOP.mem2_rw_RrAg_MEM_latch_out TOP.eip_RrAg_MEM_latch_out TOP.latched_eip_RrAg_MEM_latch_out TOP.IE_RrAg_MEM_latch_out TOP.IE_type_RrAg_MEM_latch_out TOP.BR_pred_target_RrAg_MEM_latch_out TOP.BR_pred_T_NT_RrAg_MEM_latch_out TOP.BP_alias_RrAg_MEM_latch_out TOP.memSizeOVR_RrAg_MEM_latch_out TOP.valid_MEM_EX_latch_in TOP.EIP_MEM_EX_latch_in TOP.latched_eip_MEM_EX_latch_in TOP.IE_MEM_EX_latch_in TOP.IE_type_MEM_EX_latch_in TOP.BR_pred_target_MEM_EX_latch_in TOP.BR_pred_T_NT_MEM_EX_latch_in TOP.BP_alias_MEM_EX_latch_in TOP.res1_ld_MEM_EX_latch_in TOP.res2_ld_MEM_EX_latch_in }
gui_sg_addsignal -group "$_session_group_1" { TOP.res3_ld_MEM_EX_latch_in TOP.res4_ld_MEM_EX_latch_in TOP.op1_MEM_EX_latch_in TOP.op2_MEM_EX_latch_in TOP.op3_MEM_EX_latch_in TOP.op4_MEM_EX_latch_in TOP.op1_ptcinfo_MEM_EX_latch_in TOP.op2_ptcinfo_MEM_EX_latch_in TOP.op3_ptcinfo_MEM_EX_latch_in TOP.op4_ptcinfo_MEM_EX_latch_in TOP.dest1_addr_MEM_EX_latch_in TOP.dest2_addr_MEM_EX_latch_in TOP.dest3_addr_MEM_EX_latch_in TOP.dest4_addr_MEM_EX_latch_in TOP.dest1_ptcinfo_MEM_EX_latch_in TOP.dest2_ptcinfo_MEM_EX_latch_in TOP.dest3_ptcinfo_MEM_EX_latch_in TOP.dest4_ptcinfo_MEM_EX_latch_in TOP.res1_is_reg_MEM_EX_latch_in TOP.res2_is_reg_MEM_EX_latch_in TOP.res3_is_reg_MEM_EX_latch_in TOP.res4_is_reg_MEM_EX_latch_in TOP.res1_is_seg_MEM_EX_latch_in TOP.res2_is_seg_MEM_EX_latch_in TOP.res3_is_seg_MEM_EX_latch_in TOP.res4_is_seg_MEM_EX_latch_in TOP.res1_is_mem_MEM_EX_latch_in TOP.res2_is_mem_MEM_EX_latch_in TOP.res3_is_mem_MEM_EX_latch_in TOP.res4_is_mem_MEM_EX_latch_in TOP.opsize_MEM_EX_latch_in TOP.aluk_MEM_EX_latch_in TOP.MUX_ADDER_IMM_MEM_EX_latch_in TOP.MUX_AND_INT_MEM_EX_latch_in TOP.MUX_SHIFT_MEM_EX_latch_in TOP.P_OP_MEM_EX_latch_in TOP.FMASK_MEM_EX_latch_in TOP.conditionals_MEM_EX_latch_in TOP.isBR_MEM_EX_latch_in TOP.is_fp_MEM_EX_latch_in TOP.is_imm_MEM_EX_latch_in TOP.is_rep_MEM_EX_latch_in TOP.CS_MEM_EX_latch_in TOP.inst_ptcid_MEM_EX_latch_in TOP.memSizeOVR_MEM_EX_latch_in TOP.valid_MEM_EX_latch_out TOP.EIP_MEM_EX_latch_out TOP.latched_eip_MEM_EX_latch_out TOP.IE_MEM_EX_latch_out TOP.IE_type_MEM_EX_latch_out TOP.BR_pred_target_MEM_EX_latch_out TOP.BR_pred_T_NT_MEM_EX_latch_out TOP.BP_alias_MEM_EX_latch_out TOP.res1_ld_MEM_EX_latch_out TOP.res2_ld_MEM_EX_latch_out TOP.res3_ld_MEM_EX_latch_out TOP.res4_ld_MEM_EX_latch_out TOP.op1_MEM_EX_latch_out TOP.op2_MEM_EX_latch_out TOP.op3_MEM_EX_latch_out TOP.op4_MEM_EX_latch_out TOP.op1_ptcinfo_MEM_EX_latch_out TOP.op2_ptcinfo_MEM_EX_latch_out TOP.op3_ptcinfo_MEM_EX_latch_out TOP.op4_ptcinfo_MEM_EX_latch_out TOP.dest1_addr_MEM_EX_latch_out TOP.dest2_addr_MEM_EX_latch_out TOP.dest3_addr_MEM_EX_latch_out TOP.dest4_addr_MEM_EX_latch_out TOP.dest1_ptcinfo_MEM_EX_latch_out TOP.dest2_ptcinfo_MEM_EX_latch_out TOP.dest3_ptcinfo_MEM_EX_latch_out TOP.dest4_ptcinfo_MEM_EX_latch_out TOP.res1_is_reg_MEM_EX_latch_out TOP.res2_is_reg_MEM_EX_latch_out TOP.res3_is_reg_MEM_EX_latch_out TOP.res4_is_reg_MEM_EX_latch_out TOP.res1_is_seg_MEM_EX_latch_out TOP.res2_is_seg_MEM_EX_latch_out TOP.res3_is_seg_MEM_EX_latch_out TOP.res4_is_seg_MEM_EX_latch_out TOP.res1_is_mem_MEM_EX_latch_out TOP.res2_is_mem_MEM_EX_latch_out TOP.res3_is_mem_MEM_EX_latch_out TOP.res4_is_mem_MEM_EX_latch_out TOP.opsize_MEM_EX_latch_out TOP.aluk_MEM_EX_latch_out TOP.MUX_ADDER_IMM_MEM_EX_latch_out TOP.MUX_AND_INT_MEM_EX_latch_out TOP.MUX_SHIFT_MEM_EX_latch_out TOP.P_OP_MEM_EX_latch_out TOP.FMASK_MEM_EX_latch_out TOP.conditionals_MEM_EX_latch_out TOP.isBR_MEM_EX_latch_out TOP.is_fp_MEM_EX_latch_out TOP.is_imm_MEM_EX_latch_out TOP.is_rep_MEM_EX_latch_out TOP.CS_MEM_EX_latch_out TOP.wake_MEM_EX_latch_out TOP.inst_ptcid_MEM_EX_latch_out TOP.memSizeOVR_MEM_EX_latch_out TOP.valid_EX_WB_latch_in TOP.EIP_EX_WB_latch_in TOP.latched_eip_EX_WB_latch_in TOP.IE_EX_WB_latch_in TOP.IE_type_EX_WB_latch_in TOP.BR_pred_target_EX_WB_latch_in TOP.BR_pred_T_NT_EX_WB_latch_in TOP.inst_ptcid_EX_WB_latch_in TOP.inp1_EX_WB_latch_in TOP.inp2_EX_WB_latch_in TOP.inp3_EX_WB_latch_in TOP.inp4_EX_WB_latch_in TOP.inp1_isReg_EX_WB_latch_in TOP.inp2_isReg_EX_WB_latch_in TOP.inp3_isReg_EX_WB_latch_in TOP.inp4_isReg_EX_WB_latch_in TOP.inp1_isSeg_EX_WB_latch_in TOP.inp2_isSeg_EX_WB_latch_in TOP.inp3_isSeg_EX_WB_latch_in TOP.inp4_isSeg_EX_WB_latch_in TOP.inp1_isMem_EX_WB_latch_in TOP.inp2_isMem_EX_WB_latch_in TOP.inp3_isMem_EX_WB_latch_in TOP.inp4_isMem_EX_WB_latch_in TOP.inp1_dest_EX_WB_latch_in TOP.inp2_dest_EX_WB_latch_in TOP.inp3_dest_EX_WB_latch_in TOP.inp4_dest_EX_WB_latch_in TOP.inpsize_EX_WB_latch_in TOP.inp1_wb_EX_WB_latch_in TOP.inp2_wb_EX_WB_latch_in TOP.inp3_wb_EX_WB_latch_in TOP.inp4_wb_EX_WB_latch_in TOP.inp1_ptcinfo_EX_WB_latch_in }
gui_sg_addsignal -group "$_session_group_1" { TOP.inp2_ptcinfo_EX_WB_latch_in TOP.inp3_ptcinfo_EX_WB_latch_in TOP.inp4_ptcinfo_EX_WB_latch_in TOP.dest1_ptcinfo_EX_WB_latch_in TOP.dest2_ptcinfo_EX_WB_latch_in TOP.dest3_ptcinfo_EX_WB_latch_in TOP.dest4_ptcinfo_EX_WB_latch_in TOP.BR_valid_EX_WB_latch_in TOP.BR_taken_EX_WB_latch_in TOP.BR_correct_EX_WB_latch_in TOP.BR_FIP_EX_WB_latch_in TOP.BR_FIP_p1_EX_WB_latch_in TOP.CS_EX_WB_latch_in TOP.EFLAGS_EX_WB_latch_in TOP.P_OP_EX_WB_latch_in TOP.is_rep_EX_WB_latch_in TOP.BP_alias_EX_WB_latch_in TOP.memSizeOVR_EX_WB_latch_in TOP.valid_EX_WB_latch_out TOP.EIP_EX_WB_latch_out TOP.latched_eip_EX_WB_latch_out TOP.IE_EX_WB_latch_out TOP.IE_type_EX_WB_latch_out TOP.BR_pred_target_EX_WB_latch_out TOP.BR_pred_T_NT_EX_WB_latch_out TOP.inst_ptcid_EX_WB_latch_out TOP.inp1_EX_WB_latch_out TOP.inp2_EX_WB_latch_out TOP.inp3_EX_WB_latch_out TOP.inp4_EX_WB_latch_out TOP.inp1_isReg_EX_WB_latch_out TOP.inp2_isReg_EX_WB_latch_out TOP.inp3_isReg_EX_WB_latch_out TOP.inp4_isReg_EX_WB_latch_out TOP.inp1_isSeg_EX_WB_latch_out TOP.inp2_isSeg_EX_WB_latch_out TOP.inp3_isSeg_EX_WB_latch_out TOP.inp4_isSeg_EX_WB_latch_out TOP.inp1_isMem_EX_WB_latch_out TOP.inp2_isMem_EX_WB_latch_out TOP.inp3_isMem_EX_WB_latch_out TOP.inp4_isMem_EX_WB_latch_out TOP.inp1_dest_EX_WB_latch_out TOP.inp2_dest_EX_WB_latch_out TOP.inp3_dest_EX_WB_latch_out TOP.inp4_dest_EX_WB_latch_out TOP.inpsize_EX_WB_latch_out TOP.inp1_wb_EX_WB_latch_out TOP.inp2_wb_EX_WB_latch_out TOP.inp3_wb_EX_WB_latch_out TOP.inp4_wb_EX_WB_latch_out TOP.inp1_ptcinfo_EX_WB_latch_out TOP.inp2_ptcinfo_EX_WB_latch_out TOP.inp3_ptcinfo_EX_WB_latch_out TOP.inp4_ptcinfo_EX_WB_latch_out TOP.dest1_ptcinfo_EX_WB_latch_out TOP.dest2_ptcinfo_EX_WB_latch_out TOP.dest3_ptcinfo_EX_WB_latch_out TOP.dest4_ptcinfo_EX_WB_latch_out TOP.BR_valid_EX_WB_latch_out TOP.BR_taken_EX_WB_latch_out TOP.BR_correct_EX_WB_latch_out TOP.BR_FIP_EX_WB_latch_out TOP.BR_FIP_p1_EX_WB_latch_out TOP.CS_EX_WB_latch_out TOP.EFLAGS_EX_WB_latch_out TOP.P_OP_EX_WB_latch_out TOP.is_rep_EX_WB_latch_out TOP.BP_alias_EX_WB_latch_out TOP.memSizeOVR_EX_WB_latch_out TOP.fwd_stall_WB_EX_out TOP.is_valid_WB_out TOP.res1_WB_RRAG_out TOP.res2_WB_RRAG_out TOP.res3_WB_RRAG_out TOP.res4_WB_RRAG_out TOP.mem_data_WB_M_out TOP.res1_ptcinfo_WB_RRAG_out TOP.res2_ptcinfo_WB_RRAG_out TOP.res3_ptcinfo_WB_RRAG_out TOP.res4_ptcinfo_WB_RRAG_out TOP.ressize_WB_RRAG_out TOP.memsize_WB_M_out TOP.reg_addr_WB_RRAG_out TOP.seg_addr_WB_RRAG_out TOP.mem_addr_WB_M_out TOP.reg_ld_WB_RRAG_out TOP.seg_ld_WB_RRAG_out TOP.mem_ld_WB_M_out TOP.wbaq_isfull_WB_M_in TOP.inst_ptcid_out_WB_RRAG_out TOP.WB_BP_update_alias TOP.newFIP_e_WB_out TOP.newFIP_o_WB_out TOP.newEIP_WB_out TOP.latched_EIP_WB_out TOP.EIP_WB_out TOP.latched_eip_WB_out TOP.is_resteer_WB_out TOP.BR_valid_WB_BP_out TOP.BR_taken_WB_BP_out TOP.BR_correct_WB_BP_out TOP.final_IE_val TOP.final_IE_type TOP.IE_type_WB_out TOP.final_EFLAGS TOP.final_CS TOP.BP_EIP_BTB_out TOP.is_BR_T_NT_BP_out TOP.BP_FIP_e_BTB_out TOP.BP_FIP_o_BTB_out TOP.BP_update_alias_out TOP.IDTR_packet_out TOP.IDTR_packet_select_out TOP.IDTR_PTC_out TOP.IDTR_is_POP_EFLAGS TOP.IDTR_LD_EIP_out TOP.IDTR_flush_pipe TOP.is_servicing_IE TOP.idtr_ptc_clear_out TOP.IDTR_PTC_clear TOP.freeIE TOP.freeIO TOP.freeDE TOP.freeDO TOP.reqIE TOP.reqIO TOP.reqDEr TOP.reqDEw TOP.reqDOr TOP.reqDOw TOP.relIE TOP.relIO TOP.relDEr TOP.relDEw TOP.relDOr TOP.relDOw TOP.destIE TOP.destIO TOP.destDEr TOP.destDEw TOP.destDOr TOP.destDOw TOP.BUS TOP.ackIE TOP.ackIO TOP.ackDEr TOP.ackDEw TOP.ackDOr TOP.ackDOw TOP.grantIE TOP.grantIO TOP.grantDEr TOP.grantDEw TOP.grantDOr TOP.grantDOw TOP.recvIE TOP.recvIO TOP.recvDE TOP.recvDO TOP.WB_to_clr_latches_resteer_active_low TOP.F_D_latch_LD TOP.F_D_latch_clr TOP.m_din_D_RrAg TOP.n_din_D_RrAg TOP.D_RrAg_Latch_RD TOP.D_RrAg_Latch_clr TOP.reg1_rragdf TOP.reg2_rragdf TOP.reg3_rragdf TOP.reg4_rragdf TOP.seg1_rragdf TOP.seg2_rragdf TOP.seg3_rragdf TOP.seg4_rragdf TOP.dummy_zero_collector TOP.RrAg_MEM_latch_LD TOP.RrAg_MEM_latch_clr TOP.reg1_memdf TOP.reg2_memdf TOP.reg3_memdf TOP.reg4_memdf TOP.seg1_memdf }
gui_sg_addsignal -group "$_session_group_1" { TOP.seg2_memdf TOP.seg3_memdf TOP.seg4_memdf TOP.init_wake TOP.cache_wake TOP.mshr_rd_qslot_e_out TOP.mshr_sw_qslot_e_out TOP.mshr_rd_qslot_o_out TOP.mshr_sw_qslot_o_out TOP.cache_qslot_out TOP.cache_out_valid TOP.cache_out_data TOP.cache_out_ptcinfo TOP.cacheline_e_bus_in_data TOP.cacheline_o_bus_in_data TOP.cacheline_e_bus_in_ptcinfo TOP.cacheline_o_bus_in_ptcinfo TOP.m_din_MEM_EX TOP.n_din_MEM_EX TOP.MEM_EX_Latch_RD TOP.exinvstall TOP.MEM_EX_Latch_clr TOP.new_m_M_EX TOP.old_m_M_EX TOP.modify_M_EX_latch TOP.expostwakevalid TOP.op1_exdf TOP.op2_exdf TOP.op3_exdf TOP.op4_exdf TOP.EX_WB_latch_LD TOP.halts TOP.CYCLE_TIME TOP.CYCLE_TIME_BUS TOP.m_size_D_RrAg TOP.n_size_D_RrAg TOP.m_size_MEM_EX TOP.n_size_MEM_EX }
gui_set_radix -radix {decimal} -signals {V1:TOP.file}
gui_set_radix -radix {twosComplement} -signals {V1:TOP.file}
gui_set_radix -radix {decimal} -signals {V1:TOP.cycle_number}
gui_set_radix -radix {twosComplement} -signals {V1:TOP.cycle_number}
gui_set_radix -radix {decimal} -signals {V1:TOP.m_size_D_RrAg}
gui_set_radix -radix {twosComplement} -signals {V1:TOP.m_size_D_RrAg}
gui_set_radix -radix {decimal} -signals {V1:TOP.n_size_D_RrAg}
gui_set_radix -radix {twosComplement} -signals {V1:TOP.n_size_D_RrAg}
gui_set_radix -radix {decimal} -signals {V1:TOP.m_size_MEM_EX}
gui_set_radix -radix {twosComplement} -signals {V1:TOP.m_size_MEM_EX}
gui_set_radix -radix {decimal} -signals {V1:TOP.n_size_MEM_EX}
gui_set_radix -radix {twosComplement} -signals {V1:TOP.n_size_MEM_EX}

# Global: Highlighting

# Global: Stack
gui_change_stack_mode -mode list

# Post database loading setting...

# Restore C1 time
gui_set_time -C1_only 664981



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
gui_list_set_filter -id ${Hier.1} -text {*}
gui_hier_list_init -id ${Hier.1}
gui_change_design -id ${Hier.1} -design V1
catch {gui_list_select -id ${Hier.1} {TOP}}
gui_view_scroll -id ${Hier.1} -vertical -set 0
gui_view_scroll -id ${Hier.1} -horizontal -set 0

# Data 'Data.1'
gui_list_set_filter -id ${Data.1} -list { {Buffer 1} {Input 1} {Others 1} {Linkage 1} {Output 1} {LowPower 1} {Parameter 1} {All 1} {Aggregate 1} {LibBaseMember 1} {Event 1} {Assertion 1} {Constant 1} {Interface 1} {BaseMembers 1} {Signal 1} {$unit 1} {Inout 1} {Variable 1} }
gui_list_set_filter -id ${Data.1} -text {*}
gui_list_show_data -id ${Data.1} {TOP}
gui_view_scroll -id ${Data.1} -vertical -set 0
gui_view_scroll -id ${Data.1} -horizontal -set 0
gui_view_scroll -id ${Hier.1} -vertical -set 0
gui_view_scroll -id ${Hier.1} -horizontal -set 0

# Source 'Source.1'
gui_src_value_annotate -id ${Source.1} -switch false
gui_set_env TOGGLE::VALUEANNOTATE 0
gui_open_source -id ${Source.1}  -replace -active TOP /home/ecelrc/students/rjain1/uarch/Project-RAVE/TOP.v
gui_view_scroll -id ${Source.1} -vertical -set 0
gui_src_set_reusable -id ${Source.1}
# Restore toplevel window zorder
# The toplevel window could be closed if it has no view/pane
if {[gui_exist_window -window ${TopLevel.1}]} {
	gui_set_active_window -window ${TopLevel.1}
	gui_set_active_window -window ${Source.1}
	gui_set_active_window -window ${HSPane.1}
}
#</Session>

