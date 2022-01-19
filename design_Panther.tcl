
################################################################
# This is a generated script based on design: design_1
#
# Though there are limitations about the generated script,
# the main purpose of this utility is to make learning
# IP Integrator Tcl commands easier.
################################################################

namespace eval _tcl {
proc get_script_folder {} {
   set script_path [file normalize [info script]]
   set script_folder [file dirname $script_path]
   return $script_folder
}
}
variable script_folder
set script_folder [_tcl::get_script_folder]

################################################################
# Check if script is running in correct Vivado version.
################################################################
set scripts_vivado_version 2020.2
set current_vivado_version [version -short]

if { [string first $scripts_vivado_version $current_vivado_version] == -1 } {
   puts ""
   catch {common::send_gid_msg -ssname BD::TCL -id 2041 -severity "ERROR" "This script was generated using Vivado <$scripts_vivado_version> and is being run in <$current_vivado_version> of Vivado. Please run the script in Vivado <$scripts_vivado_version> then open the design in Vivado <$current_vivado_version>. Upgrade the design by running \"Tools => Report => Report IP Status...\", then run write_bd_tcl to create an updated script."}

   return 1
}

################################################################
# START
################################################################

# To test this script, run the following commands from Vivado Tcl console:
# source design_1_script.tcl

# If there is no project opened, this script will create a
# project, but make sure you do not have an existing project
# <./myproj/project_1.xpr> in the current working folder.

set list_projs [get_projects -quiet]
if { $list_projs eq "" } {
   create_project project_1 myproj -part xc7k325tfbg676-2
   set_property BOARD_PART digilab:panther_te0741_325_2cf:part0:2.0 [current_project]
}


# CHANGE DESIGN NAME HERE
variable design_name
set design_name design_1

# If you do not already have an existing IP Integrator design open,
# you can create a design using the following command:
#    create_bd_design $design_name

# Creating design if needed
set errMsg ""
set nRet 0

set cur_design [current_bd_design -quiet]
set list_cells [get_bd_cells -quiet]

if { ${design_name} eq "" } {
   # USE CASES:
   #    1) Design_name not set

   set errMsg "Please set the variable <design_name> to a non-empty value."
   set nRet 1

} elseif { ${cur_design} ne "" && ${list_cells} eq "" } {
   # USE CASES:
   #    2): Current design opened AND is empty AND names same.
   #    3): Current design opened AND is empty AND names diff; design_name NOT in project.
   #    4): Current design opened AND is empty AND names diff; design_name exists in project.

   if { $cur_design ne $design_name } {
      common::send_gid_msg -ssname BD::TCL -id 2001 -severity "INFO" "Changing value of <design_name> from <$design_name> to <$cur_design> since current design is empty."
      set design_name [get_property NAME $cur_design]
   }
   common::send_gid_msg -ssname BD::TCL -id 2002 -severity "INFO" "Constructing design in IPI design <$cur_design>..."

} elseif { ${cur_design} ne "" && $list_cells ne "" && $cur_design eq $design_name } {
   # USE CASES:
   #    5) Current design opened AND has components AND same names.

   set errMsg "Design <$design_name> already exists in your project, please set the variable <design_name> to another value."
   set nRet 1
} elseif { [get_files -quiet ${design_name}.bd] ne "" } {
   # USE CASES: 
   #    6) Current opened design, has components, but diff names, design_name exists in project.
   #    7) No opened design, design_name exists in project.

   set errMsg "Design <$design_name> already exists in your project, please set the variable <design_name> to another value."
   set nRet 2

} else {
   # USE CASES:
   #    8) No opened design, design_name not in project.
   #    9) Current opened design, has components, but diff names, design_name not in project.

   common::send_gid_msg -ssname BD::TCL -id 2003 -severity "INFO" "Currently there is no design <$design_name> in project, so creating one..."

   create_bd_design $design_name

   common::send_gid_msg -ssname BD::TCL -id 2004 -severity "INFO" "Making design <$design_name> as current_bd_design."
   current_bd_design $design_name

}

common::send_gid_msg -ssname BD::TCL -id 2005 -severity "INFO" "Currently the variable <design_name> is equal to \"$design_name\"."

if { $nRet != 0 } {
   catch {common::send_gid_msg -ssname BD::TCL -id 2006 -severity "ERROR" $errMsg}
   return $nRet
}

set bCheckIPsPassed 1
##################################################################
# CHECK IPs
##################################################################
set bCheckIPs 1
if { $bCheckIPs == 1 } {
   set list_check_ips "\ 
TimeEngineers:ip:AXI4Stream_UART:1.0\
DigiLAB:ip:BeltBus_TDCCounter:2.0\
DigiLAB:ip:BeltBus_TDCHistogrammer:5.0\
DigiLAB:ip:BeltBus_TTM:2.0\
DigiLAB:hier:MME:2.2\
xilinx.com:ip:axis_broadcaster:1.1\
xilinx.com:ip:clk_wiz:6.0\
xilinx.com:ip:proc_sys_reset:5.0\
xilinx.com:ip:xadc_wiz:3.3\
xilinx.com:ip:xlconstant:1.1\
xilinx.com:ip:axi_bram_ctrl:4.1\
xilinx.com:ip:blk_mem_gen:8.4\
DigiLAB:ip:AXI4Stream_MuxDebugger:1.1\
DigiLAB:ip:AXI4_TDC_Wrapper:5.0\
xilinx.com:ip:util_ds_buf:2.1\
DigiLAB:ip:CoarseTreeDistributor:1.2\
DigiLAB:ip:StartStopGenerator:2.1\
xilinx.com:ip:util_vector_logic:2.0\
xilinx.com:ip:xlconcat:2.1\
xilinx.com:ip:xlslice:1.0\
DigiLAB:hier:BeltBus_TDL_Channel_TDC:3.5\
DigiLAB:ip:InputLogic:3.2\
DigiLAB:ip:TDCChannelSlice:2.1\
DigiLAB:ip:BeltBus_PeriodMeter:3.0\
"

   set list_ips_missing ""
   common::send_gid_msg -ssname BD::TCL -id 2011 -severity "INFO" "Checking if the following IPs exist in the project's IP catalog: $list_check_ips ."

   foreach ip_vlnv $list_check_ips {
      set ip_obj [get_ipdefs -all $ip_vlnv]
      if { $ip_obj eq "" } {
         lappend list_ips_missing $ip_vlnv
      }
   }

   if { $list_ips_missing ne "" } {
      catch {common::send_gid_msg -ssname BD::TCL -id 2012 -severity "ERROR" "The following IPs are not found in the IP Catalog:\n  $list_ips_missing\n\nResolution: Please add the repository containing the IP(s) to the project." }
      set bCheckIPsPassed 0
   }

}

if { $bCheckIPsPassed != 1 } {
  common::send_gid_msg -ssname BD::TCL -id 2023 -severity "WARNING" "Will not continue with creation of design due to the error(s) above."
  return 3
}

##################################################################
# DESIGN PROCs
##################################################################


# Hierarchical cell: Sync
proc create_hier_cell_Sync { parentCell nameHier } {

  variable script_folder

  if { $parentCell eq "" || $nameHier eq "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2092 -severity "ERROR" "create_hier_cell_Sync() - Empty argument(s)!"}
     return
  }

  # Get object for parentCell
  set parentObj [get_bd_cells $parentCell]
  if { $parentObj == "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2090 -severity "ERROR" "Unable to find parent cell <$parentCell>!"}
     return
  }

  # Make sure parentObj is hier blk
  set parentType [get_property TYPE $parentObj]
  if { $parentType ne "hier" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2091 -severity "ERROR" "Parent <$parentObj> has TYPE = <$parentType>. Expected to be <hier>."}
     return
  }

  # Save current instance; Restore later
  set oldCurInst [current_bd_instance .]

  # Set parent object as current
  current_bd_instance $parentObj

  # Create cell and set as current instance
  set hier_obj [create_bd_cell -type hier $nameHier]
  current_bd_instance $hier_obj

  # Create interface pins
  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:axis_rtl:1.0 M00_AXIS

  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:axis_rtl:1.0 M00_BB

  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:axis_rtl:1.0 M01_AXIS_DebugCT

  create_bd_intf_pin -mode Slave -vlnv DigiLAB:if:diff_ch_tdc_rtl:1.1 ch_sync_diff


  # Create pins
  create_bd_pin -dir I -type data CalibEventIn
  create_bd_pin -dir O -type data Calibrated
  create_bd_pin -dir I -from 7 -to 0 CoarseCounter_CTD
  create_bd_pin -dir I -type clk clk_BB
  create_bd_pin -dir I -type clk clk_TDC
  create_bd_pin -dir O -from 64 -to 0 -type data read_reg
  create_bd_pin -dir I -type rst reset_0
  create_bd_pin -dir I -type rst reset_TDC
  create_bd_pin -dir I -from 73 -to 0 -type data write_debug_reg_0
  create_bd_pin -dir I -from 18 -to 0 -type data write_reg

  # Create instance: AXI4Stream_PeriodMet_0, and set properties
  set AXI4Stream_PeriodMet_0 [ create_bd_cell -type ip -vlnv DigiLAB:ip:BeltBus_PeriodMeter:3.0 AXI4Stream_PeriodMet_0 ]
  set_property -dict [ list \
   CONFIG.BIT_COARSE {8} \
   CONFIG.BIT_OVERFLOW {16} \
 ] $AXI4Stream_PeriodMet_0

  # Create instance: BeltBus_TDL_Channel_0, and set properties
  set BeltBus_TDL_Channel_0 [ create_bd_cell -type ip -vlnv DigiLAB:hier:BeltBus_TDL_Channel_TDC:3.5 BeltBus_TDL_Channel_0 ]
  set_property -dict [ list \
   CONFIG.BIT_SMP_PRE_TDL {128} \
   CONFIG.BIT_SMP_TDL {512} \
   CONFIG.BIT_SUB_INT {11} \
   CONFIG.BIT_UNCALIBRATED {11} \
   CONFIG.BUFFERING_STAGE {false} \
   CONFIG.CEC_VS_CTD_COUNTER {CTD} \
   CONFIG.DEBUG_MODE {true} \
   CONFIG.DEBUG_MODE_CT {true} \
   CONFIG.DEBUG_PORT_DECODER {true} \
   CONFIG.MAX_VALID_TAP_POS {511} \
   CONFIG.MIN_VALID_TAP_POS {-128} \
   CONFIG.NUMBER_OF_TDL {4} \
   CONFIG.NUM_TAP_PRE_TDL {128} \
   CONFIG.NUM_TAP_TDL {512} \
   CONFIG.PASS_THROUGH {Both} \
   CONFIG.STEP_VALID_TAP_POS {16} \
   CONFIG.VALID_POSITION_TAP_INIT {0} \
 ] $BeltBus_TDL_Channel_0

  # Create instance: InputLogic_0, and set properties
  set InputLogic_0 [ create_bd_cell -type ip -vlnv DigiLAB:ip:InputLogic:3.2 InputLogic_0 ]
  set_property -dict [ list \
   CONFIG.BIT_DIVIDER {4} \
   CONFIG.BIT_STRETCH_LENGTH {3} \
   CONFIG.DIVIDER_INIT {15} \
   CONFIG.INPUT_DIFF_CH_TDC_BOARD_INTERFACE {ch_sync_diff} \
   CONFIG.STRETCH_LENGTH_INIT {6} \
   CONFIG.TUNING_MODE {true} \
 ] $InputLogic_0

  # Create instance: TDCChannelSlice_0, and set properties
  set TDCChannelSlice_0 [ create_bd_cell -type ip -vlnv DigiLAB:ip:TDCChannelSlice:2.1 TDCChannelSlice_0 ]
  set_property -dict [ list \
   CONFIG.BIT_DIVIDER {4} \
   CONFIG.BIT_OVERFLOW {16} \
   CONFIG.TDC_ENABLE_DEBUG_PORTS {true} \
 ] $TDCChannelSlice_0

  # Create instance: axis_broadcaster_0, and set properties
  set axis_broadcaster_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axis_broadcaster:1.1 axis_broadcaster_0 ]
  set_property -dict [ list \
   CONFIG.HAS_TREADY {0} \
   CONFIG.M00_TDATA_REMAP {tdata[39:0]} \
   CONFIG.M01_TDATA_REMAP {tdata[39:0]} \
   CONFIG.M_TDATA_NUM_BYTES {5} \
   CONFIG.S_TDATA_NUM_BYTES {5} \
 ] $axis_broadcaster_0

  # Create instance: util_vector_logic_0, and set properties
  set util_vector_logic_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:util_vector_logic:2.0 util_vector_logic_0 ]
  set_property -dict [ list \
   CONFIG.C_OPERATION {not} \
   CONFIG.C_SIZE {1} \
   CONFIG.LOGO_FILE {data/sym_notgate.png} \
 ] $util_vector_logic_0

  # Create interface connections
  connect_bd_intf_net -intf_net AXI4Stream_PeriodMet_0_M00_AXIS [get_bd_intf_pins AXI4Stream_PeriodMet_0/M00_AXIS] [get_bd_intf_pins axis_broadcaster_0/S_AXIS]
  connect_bd_intf_net -intf_net BeltBus_TDL_Channel_0_M00_AXIS [get_bd_intf_pins AXI4Stream_PeriodMet_0/S00_BB] [get_bd_intf_pins BeltBus_TDL_Channel_0/M00_AXIS]
  connect_bd_intf_net -intf_net BeltBus_TDL_Channel_0_M00_BB [get_bd_intf_pins M00_BB] [get_bd_intf_pins BeltBus_TDL_Channel_0/M00_BB]
  connect_bd_intf_net -intf_net BeltBus_TDL_Channel_0_M01_AXIS_DebugCT [get_bd_intf_pins M01_AXIS_DebugCT] [get_bd_intf_pins BeltBus_TDL_Channel_0/M01_AXIS_DebugCT]
  connect_bd_intf_net -intf_net Conn1 [get_bd_intf_pins ch_sync_diff] [get_bd_intf_pins InputLogic_0/AsyncEventIn_Diff]
  connect_bd_intf_net -intf_net axis_broadcaster_0_M00_AXIS [get_bd_intf_pins M00_AXIS] [get_bd_intf_pins axis_broadcaster_0/M00_AXIS]
  connect_bd_intf_net -intf_net axis_broadcaster_0_M01_AXIS [get_bd_intf_pins TDCChannelSlice_0/S00_AXIS_Period] [get_bd_intf_pins axis_broadcaster_0/M01_AXIS]

  # Create port connections
  connect_bd_net -net BeltBus_TDL_Channel_TDC_0_Calibrated [get_bd_pins Calibrated] [get_bd_pins BeltBus_TDL_Channel_0/Calibrated] [get_bd_pins InputLogic_0/IsCalibrate] [get_bd_pins TDCChannelSlice_0/Calibrated]
  connect_bd_net -net CalibEventIn_1 [get_bd_pins CalibEventIn] [get_bd_pins InputLogic_0/CalibEventIn]
  connect_bd_net -net CoarseCounter_CTD_1 [get_bd_pins CoarseCounter_CTD] [get_bd_pins BeltBus_TDL_Channel_0/CoarseCounter_CTD]
  connect_bd_net -net InputLogic_0_AsyncEventOut [get_bd_pins BeltBus_TDL_Channel_0/AsyncInput] [get_bd_pins InputLogic_0/AsyncEventOut]
  connect_bd_net -net TDCChannelSlice_0_Divider [get_bd_pins InputLogic_0/Divider] [get_bd_pins TDCChannelSlice_0/Divider]
  connect_bd_net -net TDCChannelSlice_0_EdgeTrigger [get_bd_pins InputLogic_0/EdgeTrigger] [get_bd_pins TDCChannelSlice_0/EdgeTrigger]
  connect_bd_net -net TDCChannelSlice_0_ForceCalibrate [get_bd_pins InputLogic_0/ForceCalibrate] [get_bd_pins TDCChannelSlice_0/ForceCalibrate]
  connect_bd_net -net TDCChannelSlice_0_Gate [get_bd_pins InputLogic_0/Gate] [get_bd_pins TDCChannelSlice_0/Gate]
  connect_bd_net -net TDCChannelSlice_0_Restart_Calibration [get_bd_pins BeltBus_TDL_Channel_0/Restart_Calibration] [get_bd_pins TDCChannelSlice_0/Restart_Calibration]
  connect_bd_net -net TDCChannelSlice_0_Stop_Calibration [get_bd_pins BeltBus_TDL_Channel_0/Stop_Calibration] [get_bd_pins TDCChannelSlice_0/Stop_Calibration]
  connect_bd_net -net TDCChannelSlice_0_StretchLength [get_bd_pins InputLogic_0/StretchLength] [get_bd_pins TDCChannelSlice_0/StretchLength]
  connect_bd_net -net TDCChannelSlice_0_ValidNumberOfTdl [get_bd_pins BeltBus_TDL_Channel_0/ValidNumberOfTDL] [get_bd_pins TDCChannelSlice_0/ValidNumberOfTdl]
  connect_bd_net -net TDCChannelSlice_0_ValidPositionTap [get_bd_pins BeltBus_TDL_Channel_0/ValidPositionTap] [get_bd_pins TDCChannelSlice_0/ValidPositionTap]
  connect_bd_net -net TDCChannelSlice_0_bitTrn_Cal_dout [get_bd_pins BeltBus_TDL_Channel_0/bitTrn_Cal_dout] [get_bd_pins TDCChannelSlice_0/bitTrn_Cal_dout]
  connect_bd_net -net TDCChannelSlice_0_bitTrn_ReqSample [get_bd_pins BeltBus_TDL_Channel_0/bitTrn_ReqSample] [get_bd_pins TDCChannelSlice_0/bitTrn_ReqSample]
  connect_bd_net -net TDCChannelSlice_0_bitTrn_Uncal_addr [get_bd_pins BeltBus_TDL_Channel_0/bitTrn_Uncal_addr] [get_bd_pins TDCChannelSlice_0/bitTrn_Uncal_addr]
  connect_bd_net -net TDCChannelSlice_0_read_reg [get_bd_pins read_reg] [get_bd_pins TDCChannelSlice_0/read_reg]
  connect_bd_net -net TDCChannelSlice_0_subInterpolationMatrix [get_bd_pins BeltBus_TDL_Channel_0/subInterpolationMatrix] [get_bd_pins TDCChannelSlice_0/subInterpolationMatrix]
  connect_bd_net -net clk_BB_1 [get_bd_pins clk_BB] [get_bd_pins AXI4Stream_PeriodMet_0/clk] [get_bd_pins BeltBus_TDL_Channel_0/clk_BB] [get_bd_pins BeltBus_TDL_Channel_0/clk_SYS] [get_bd_pins TDCChannelSlice_0/aclk] [get_bd_pins TDCChannelSlice_0/clk_BB] [get_bd_pins TDCChannelSlice_0/clk_SYS] [get_bd_pins axis_broadcaster_0/aclk]
  connect_bd_net -net clk_TDC_1 [get_bd_pins clk_TDC] [get_bd_pins BeltBus_TDL_Channel_0/clk_TDC] [get_bd_pins InputLogic_0/clk] [get_bd_pins TDCChannelSlice_0/clk_TDC]
  connect_bd_net -net reset_0_1 [get_bd_pins reset_0] [get_bd_pins axis_broadcaster_0/aresetn] [get_bd_pins util_vector_logic_0/Op1]
  connect_bd_net -net reset_TDC_1 [get_bd_pins reset_TDC] [get_bd_pins BeltBus_TDL_Channel_0/reset_BB] [get_bd_pins BeltBus_TDL_Channel_0/reset_SYS] [get_bd_pins BeltBus_TDL_Channel_0/reset_TDC] [get_bd_pins InputLogic_0/reset]
  connect_bd_net -net util_vector_logic_0_Res [get_bd_pins AXI4Stream_PeriodMet_0/reset] [get_bd_pins util_vector_logic_0/Res]
  connect_bd_net -net write_debug_reg_0_1 [get_bd_pins write_debug_reg_0] [get_bd_pins TDCChannelSlice_0/write_debug_reg]
  connect_bd_net -net xlslice_0_Dout [get_bd_pins write_reg] [get_bd_pins TDCChannelSlice_0/write_reg]

  # Restore current instance
  current_bd_instance $oldCurInst
}

# Hierarchical cell: Ch2
proc create_hier_cell_Ch2 { parentCell nameHier } {

  variable script_folder

  if { $parentCell eq "" || $nameHier eq "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2092 -severity "ERROR" "create_hier_cell_Ch2() - Empty argument(s)!"}
     return
  }

  # Get object for parentCell
  set parentObj [get_bd_cells $parentCell]
  if { $parentObj == "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2090 -severity "ERROR" "Unable to find parent cell <$parentCell>!"}
     return
  }

  # Make sure parentObj is hier blk
  set parentType [get_property TYPE $parentObj]
  if { $parentType ne "hier" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2091 -severity "ERROR" "Parent <$parentObj> has TYPE = <$parentType>. Expected to be <hier>."}
     return
  }

  # Save current instance; Restore later
  set oldCurInst [current_bd_instance .]

  # Set parent object as current
  current_bd_instance $parentObj

  # Create cell and set as current instance
  set hier_obj [create_bd_cell -type hier $nameHier]
  current_bd_instance $hier_obj

  # Create interface pins
  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:axis_rtl:1.0 M00_BB

  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:axis_rtl:1.0 M01_AXIS_DebugCT

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:axis_rtl:1.0 S00_BB

  create_bd_intf_pin -mode Slave -vlnv DigiLAB:if:diff_ch_tdc_rtl:1.1 left_ch2_diff


  # Create pins
  create_bd_pin -dir I -type data CalibEventIn
  create_bd_pin -dir O -type data Calibrated
  create_bd_pin -dir I -from 7 -to 0 CoarseCounter_CTD
  create_bd_pin -dir I -type clk clk_BB
  create_bd_pin -dir I -type clk clk_TDC
  create_bd_pin -dir O -from 64 -to 0 -type data read_reg
  create_bd_pin -dir I -type rst reset_TDC
  create_bd_pin -dir I -from 73 -to 0 -type data write_debug_reg_0
  create_bd_pin -dir I -from 18 -to 0 -type data write_reg

  # Create instance: BeltBus_TDL_Channel_2, and set properties
  set BeltBus_TDL_Channel_2 [ create_bd_cell -type ip -vlnv DigiLAB:hier:BeltBus_TDL_Channel_TDC:3.5 BeltBus_TDL_Channel_2 ]
  set_property -dict [ list \
   CONFIG.BIT_SMP_PRE_TDL {128} \
   CONFIG.BIT_SMP_TDL {512} \
   CONFIG.BIT_SUB_INT {11} \
   CONFIG.BIT_UNCALIBRATED {11} \
   CONFIG.BUFFERING_STAGE {false} \
   CONFIG.CEC_VS_CTD_COUNTER {CTD} \
   CONFIG.DEBUG_MODE {true} \
   CONFIG.DEBUG_MODE_CT {true} \
   CONFIG.DEBUG_PORT_DECODER {true} \
   CONFIG.MAX_VALID_TAP_POS {511} \
   CONFIG.MIN_VALID_TAP_POS {-128} \
   CONFIG.NUMBER_OF_TDL {4} \
   CONFIG.NUM_CH {2} \
   CONFIG.NUM_NODE {2} \
   CONFIG.NUM_TAP_PRE_TDL {128} \
   CONFIG.NUM_TAP_TDL {512} \
   CONFIG.STEP_VALID_TAP_POS {16} \
   CONFIG.VALID_POSITION_TAP_INIT {0} \
 ] $BeltBus_TDL_Channel_2

  # Create instance: InputLogic_0, and set properties
  set InputLogic_0 [ create_bd_cell -type ip -vlnv DigiLAB:ip:InputLogic:3.2 InputLogic_0 ]
  set_property -dict [ list \
   CONFIG.BIT_DIVIDER {4} \
   CONFIG.BIT_STRETCH_LENGTH {3} \
   CONFIG.INPUT_DIFF_CH_TDC_BOARD_INTERFACE {left_ch2_diff} \
   CONFIG.INVERT_BUFFER_POLARITY {true} \
   CONFIG.STRETCH_LENGTH_INIT {6} \
   CONFIG.TUNING_MODE {true} \
 ] $InputLogic_0

  # Create instance: TDCChannelSlice_2, and set properties
  set TDCChannelSlice_2 [ create_bd_cell -type ip -vlnv DigiLAB:ip:TDCChannelSlice:2.1 TDCChannelSlice_2 ]
  set_property -dict [ list \
   CONFIG.BIT_DIVIDER {4} \
   CONFIG.TDC_ENABLE_DEBUG_PORTS {true} \
 ] $TDCChannelSlice_2

  # Create instance: xlconstant_2, and set properties
  set xlconstant_2 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconstant:1.1 xlconstant_2 ]
  set_property -dict [ list \
   CONFIG.CONST_VAL {0} \
 ] $xlconstant_2

  # Create interface connections
  connect_bd_intf_net -intf_net BeltBus_TDL_Channel_2_M00_BB [get_bd_intf_pins M00_BB] [get_bd_intf_pins BeltBus_TDL_Channel_2/M00_BB]
  connect_bd_intf_net -intf_net BeltBus_TDL_Channel_2_M01_AXIS_DebugCT [get_bd_intf_pins M01_AXIS_DebugCT] [get_bd_intf_pins BeltBus_TDL_Channel_2/M01_AXIS_DebugCT]
  connect_bd_intf_net -intf_net Conn1 [get_bd_intf_pins left_ch2_diff] [get_bd_intf_pins InputLogic_0/AsyncEventIn_Diff]
  connect_bd_intf_net -intf_net S00_BB_1 [get_bd_intf_pins S00_BB] [get_bd_intf_pins BeltBus_TDL_Channel_2/S00_BB]

  # Create port connections
  connect_bd_net -net BeltBus_TDL_Channel_TDC_2_Calibrated [get_bd_pins Calibrated] [get_bd_pins BeltBus_TDL_Channel_2/Calibrated] [get_bd_pins InputLogic_0/IsCalibrate] [get_bd_pins TDCChannelSlice_2/Calibrated]
  connect_bd_net -net CalibEventIn_1 [get_bd_pins CalibEventIn] [get_bd_pins InputLogic_0/CalibEventIn]
  connect_bd_net -net CoarseCounter_CTD_1 [get_bd_pins CoarseCounter_CTD] [get_bd_pins BeltBus_TDL_Channel_2/CoarseCounter_CTD]
  connect_bd_net -net InputLogic_0_AsyncEventOut [get_bd_pins BeltBus_TDL_Channel_2/AsyncInput] [get_bd_pins InputLogic_0/AsyncEventOut]
  connect_bd_net -net TDCChannelSlice_2_Divider [get_bd_pins InputLogic_0/Divider] [get_bd_pins TDCChannelSlice_2/Divider]
  connect_bd_net -net TDCChannelSlice_2_EdgeTrigger [get_bd_pins InputLogic_0/EdgeTrigger] [get_bd_pins TDCChannelSlice_2/EdgeTrigger]
  connect_bd_net -net TDCChannelSlice_2_ForceCalibrate [get_bd_pins InputLogic_0/ForceCalibrate] [get_bd_pins TDCChannelSlice_2/ForceCalibrate]
  connect_bd_net -net TDCChannelSlice_2_Gate [get_bd_pins InputLogic_0/Gate] [get_bd_pins TDCChannelSlice_2/Gate]
  connect_bd_net -net TDCChannelSlice_2_Restart_Calibration [get_bd_pins BeltBus_TDL_Channel_2/Restart_Calibration] [get_bd_pins TDCChannelSlice_2/Restart_Calibration]
  connect_bd_net -net TDCChannelSlice_2_Stop_Calibration [get_bd_pins BeltBus_TDL_Channel_2/Stop_Calibration] [get_bd_pins TDCChannelSlice_2/Stop_Calibration]
  connect_bd_net -net TDCChannelSlice_2_StretchLength [get_bd_pins InputLogic_0/StretchLength] [get_bd_pins TDCChannelSlice_2/StretchLength]
  connect_bd_net -net TDCChannelSlice_2_ValidNumberOfTdl [get_bd_pins BeltBus_TDL_Channel_2/ValidNumberOfTDL] [get_bd_pins TDCChannelSlice_2/ValidNumberOfTdl]
  connect_bd_net -net TDCChannelSlice_2_ValidPositionTap [get_bd_pins BeltBus_TDL_Channel_2/ValidPositionTap] [get_bd_pins TDCChannelSlice_2/ValidPositionTap]
  connect_bd_net -net TDCChannelSlice_2_bitTrn_Cal_dout [get_bd_pins BeltBus_TDL_Channel_2/bitTrn_Cal_dout] [get_bd_pins TDCChannelSlice_2/bitTrn_Cal_dout]
  connect_bd_net -net TDCChannelSlice_2_bitTrn_ReqSample [get_bd_pins BeltBus_TDL_Channel_2/bitTrn_ReqSample] [get_bd_pins TDCChannelSlice_2/bitTrn_ReqSample]
  connect_bd_net -net TDCChannelSlice_2_bitTrn_Uncal_addr [get_bd_pins BeltBus_TDL_Channel_2/bitTrn_Uncal_addr] [get_bd_pins TDCChannelSlice_2/bitTrn_Uncal_addr]
  connect_bd_net -net TDCChannelSlice_2_read_reg [get_bd_pins read_reg] [get_bd_pins TDCChannelSlice_2/read_reg]
  connect_bd_net -net TDCChannelSlice_2_subInterpolationMatrix [get_bd_pins BeltBus_TDL_Channel_2/subInterpolationMatrix] [get_bd_pins TDCChannelSlice_2/subInterpolationMatrix]
  connect_bd_net -net clk_BB_1 [get_bd_pins clk_BB] [get_bd_pins BeltBus_TDL_Channel_2/clk_BB] [get_bd_pins BeltBus_TDL_Channel_2/clk_SYS] [get_bd_pins TDCChannelSlice_2/aclk] [get_bd_pins TDCChannelSlice_2/clk_BB] [get_bd_pins TDCChannelSlice_2/clk_SYS]
  connect_bd_net -net clk_TDC_1 [get_bd_pins clk_TDC] [get_bd_pins BeltBus_TDL_Channel_2/clk_TDC] [get_bd_pins InputLogic_0/clk] [get_bd_pins TDCChannelSlice_2/clk_TDC]
  connect_bd_net -net reset_TDC_1 [get_bd_pins reset_TDC] [get_bd_pins BeltBus_TDL_Channel_2/reset_BB] [get_bd_pins BeltBus_TDL_Channel_2/reset_SYS] [get_bd_pins BeltBus_TDL_Channel_2/reset_TDC] [get_bd_pins InputLogic_0/reset]
  connect_bd_net -net write_debug_reg_0_1 [get_bd_pins write_debug_reg_0] [get_bd_pins TDCChannelSlice_2/write_debug_reg]
  connect_bd_net -net xlconstant_2_dout [get_bd_pins TDCChannelSlice_2/s00_axis_period_tvalid] [get_bd_pins xlconstant_2/dout]
  connect_bd_net -net xlslice_2_Dout [get_bd_pins write_reg] [get_bd_pins TDCChannelSlice_2/write_reg]

  # Restore current instance
  current_bd_instance $oldCurInst
}

# Hierarchical cell: Ch1
proc create_hier_cell_Ch1 { parentCell nameHier } {

  variable script_folder

  if { $parentCell eq "" || $nameHier eq "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2092 -severity "ERROR" "create_hier_cell_Ch1() - Empty argument(s)!"}
     return
  }

  # Get object for parentCell
  set parentObj [get_bd_cells $parentCell]
  if { $parentObj == "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2090 -severity "ERROR" "Unable to find parent cell <$parentCell>!"}
     return
  }

  # Make sure parentObj is hier blk
  set parentType [get_property TYPE $parentObj]
  if { $parentType ne "hier" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2091 -severity "ERROR" "Parent <$parentObj> has TYPE = <$parentType>. Expected to be <hier>."}
     return
  }

  # Save current instance; Restore later
  set oldCurInst [current_bd_instance .]

  # Set parent object as current
  current_bd_instance $parentObj

  # Create cell and set as current instance
  set hier_obj [create_bd_cell -type hier $nameHier]
  current_bd_instance $hier_obj

  # Create interface pins
  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:axis_rtl:1.0 M00_BB

  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:axis_rtl:1.0 M01_AXIS_DebugCT

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:axis_rtl:1.0 S00_BB

  create_bd_intf_pin -mode Slave -vlnv DigiLAB:if:diff_ch_tdc_rtl:1.1 left_ch1_diff


  # Create pins
  create_bd_pin -dir I -type data CalibEventIn
  create_bd_pin -dir O -type data Calibrated
  create_bd_pin -dir I -from 7 -to 0 CoarseCounter_CTD
  create_bd_pin -dir I -type clk clk_BB
  create_bd_pin -dir I -type clk clk_TDC
  create_bd_pin -dir O -from 64 -to 0 -type data read_reg
  create_bd_pin -dir I -type rst reset_TDC
  create_bd_pin -dir I -from 73 -to 0 -type data write_debug_reg_0
  create_bd_pin -dir I -from 18 -to 0 -type data write_reg

  # Create instance: BeltBus_TDL_Channel_1, and set properties
  set BeltBus_TDL_Channel_1 [ create_bd_cell -type ip -vlnv DigiLAB:hier:BeltBus_TDL_Channel_TDC:3.5 BeltBus_TDL_Channel_1 ]
  set_property -dict [ list \
   CONFIG.BIT_SMP_PRE_TDL {128} \
   CONFIG.BIT_SMP_TDL {512} \
   CONFIG.BIT_SUB_INT {11} \
   CONFIG.BIT_UNCALIBRATED {11} \
   CONFIG.BUFFERING_STAGE {false} \
   CONFIG.CEC_VS_CTD_COUNTER {CTD} \
   CONFIG.DEBUG_MODE {true} \
   CONFIG.DEBUG_MODE_CT {true} \
   CONFIG.DEBUG_PORT_DECODER {true} \
   CONFIG.MAX_VALID_TAP_POS {511} \
   CONFIG.MIN_VALID_TAP_POS {-128} \
   CONFIG.NUMBER_OF_TDL {4} \
   CONFIG.NUM_CH {1} \
   CONFIG.NUM_NODE {1} \
   CONFIG.NUM_TAP_PRE_TDL {128} \
   CONFIG.NUM_TAP_TDL {512} \
   CONFIG.STEP_VALID_TAP_POS {16} \
   CONFIG.VALID_POSITION_TAP_INIT {0} \
 ] $BeltBus_TDL_Channel_1

  # Create instance: InputLogic_0, and set properties
  set InputLogic_0 [ create_bd_cell -type ip -vlnv DigiLAB:ip:InputLogic:3.2 InputLogic_0 ]
  set_property -dict [ list \
   CONFIG.BIT_DIVIDER {4} \
   CONFIG.BIT_STRETCH_LENGTH {3} \
   CONFIG.INPUT_DIFF_CH_TDC_BOARD_INTERFACE {left_ch1_diff} \
   CONFIG.STRETCH_LENGTH_INIT {6} \
   CONFIG.TUNING_MODE {true} \
 ] $InputLogic_0

  # Create instance: TDCChannelSlice_1, and set properties
  set TDCChannelSlice_1 [ create_bd_cell -type ip -vlnv DigiLAB:ip:TDCChannelSlice:2.1 TDCChannelSlice_1 ]
  set_property -dict [ list \
   CONFIG.BIT_DIVIDER {4} \
   CONFIG.TDC_ENABLE_DEBUG_PORTS {true} \
 ] $TDCChannelSlice_1

  # Create instance: xlconstant_2, and set properties
  set xlconstant_2 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconstant:1.1 xlconstant_2 ]
  set_property -dict [ list \
   CONFIG.CONST_VAL {0} \
 ] $xlconstant_2

  # Create interface connections
  connect_bd_intf_net -intf_net BeltBus_TDL_Channel_1_M00_BB [get_bd_intf_pins M00_BB] [get_bd_intf_pins BeltBus_TDL_Channel_1/M00_BB]
  connect_bd_intf_net -intf_net BeltBus_TDL_Channel_1_M01_AXIS_DebugCT [get_bd_intf_pins M01_AXIS_DebugCT] [get_bd_intf_pins BeltBus_TDL_Channel_1/M01_AXIS_DebugCT]
  connect_bd_intf_net -intf_net Conn1 [get_bd_intf_pins left_ch1_diff] [get_bd_intf_pins InputLogic_0/AsyncEventIn_Diff]
  connect_bd_intf_net -intf_net S00_BB_1 [get_bd_intf_pins S00_BB] [get_bd_intf_pins BeltBus_TDL_Channel_1/S00_BB]

  # Create port connections
  connect_bd_net -net BeltBus_TDL_Channel_TDC_1_Calibrated [get_bd_pins Calibrated] [get_bd_pins BeltBus_TDL_Channel_1/Calibrated] [get_bd_pins InputLogic_0/IsCalibrate] [get_bd_pins TDCChannelSlice_1/Calibrated]
  connect_bd_net -net CalibEventIn_1 [get_bd_pins CalibEventIn] [get_bd_pins InputLogic_0/CalibEventIn]
  connect_bd_net -net CoarseCounter_CTD_1 [get_bd_pins CoarseCounter_CTD] [get_bd_pins BeltBus_TDL_Channel_1/CoarseCounter_CTD]
  connect_bd_net -net InputLogic_0_AsyncEventOut [get_bd_pins BeltBus_TDL_Channel_1/AsyncInput] [get_bd_pins InputLogic_0/AsyncEventOut]
  connect_bd_net -net TDCChannelSlice_1_Divider [get_bd_pins InputLogic_0/Divider] [get_bd_pins TDCChannelSlice_1/Divider]
  connect_bd_net -net TDCChannelSlice_1_EdgeTrigger [get_bd_pins InputLogic_0/EdgeTrigger] [get_bd_pins TDCChannelSlice_1/EdgeTrigger]
  connect_bd_net -net TDCChannelSlice_1_ForceCalibrate [get_bd_pins InputLogic_0/ForceCalibrate] [get_bd_pins TDCChannelSlice_1/ForceCalibrate]
  connect_bd_net -net TDCChannelSlice_1_Gate [get_bd_pins InputLogic_0/Gate] [get_bd_pins TDCChannelSlice_1/Gate]
  connect_bd_net -net TDCChannelSlice_1_Restart_Calibration [get_bd_pins BeltBus_TDL_Channel_1/Restart_Calibration] [get_bd_pins TDCChannelSlice_1/Restart_Calibration]
  connect_bd_net -net TDCChannelSlice_1_Stop_Calibration [get_bd_pins BeltBus_TDL_Channel_1/Stop_Calibration] [get_bd_pins TDCChannelSlice_1/Stop_Calibration]
  connect_bd_net -net TDCChannelSlice_1_StretchLength [get_bd_pins InputLogic_0/StretchLength] [get_bd_pins TDCChannelSlice_1/StretchLength]
  connect_bd_net -net TDCChannelSlice_1_ValidNumberOfTdl [get_bd_pins BeltBus_TDL_Channel_1/ValidNumberOfTDL] [get_bd_pins TDCChannelSlice_1/ValidNumberOfTdl]
  connect_bd_net -net TDCChannelSlice_1_ValidPositionTap [get_bd_pins BeltBus_TDL_Channel_1/ValidPositionTap] [get_bd_pins TDCChannelSlice_1/ValidPositionTap]
  connect_bd_net -net TDCChannelSlice_1_bitTrn_Cal_dout [get_bd_pins BeltBus_TDL_Channel_1/bitTrn_Cal_dout] [get_bd_pins TDCChannelSlice_1/bitTrn_Cal_dout]
  connect_bd_net -net TDCChannelSlice_1_bitTrn_ReqSample [get_bd_pins BeltBus_TDL_Channel_1/bitTrn_ReqSample] [get_bd_pins TDCChannelSlice_1/bitTrn_ReqSample]
  connect_bd_net -net TDCChannelSlice_1_bitTrn_Uncal_addr [get_bd_pins BeltBus_TDL_Channel_1/bitTrn_Uncal_addr] [get_bd_pins TDCChannelSlice_1/bitTrn_Uncal_addr]
  connect_bd_net -net TDCChannelSlice_1_read_reg [get_bd_pins read_reg] [get_bd_pins TDCChannelSlice_1/read_reg]
  connect_bd_net -net TDCChannelSlice_1_subInterpolationMatrix [get_bd_pins BeltBus_TDL_Channel_1/subInterpolationMatrix] [get_bd_pins TDCChannelSlice_1/subInterpolationMatrix]
  connect_bd_net -net clk_BB_1 [get_bd_pins clk_BB] [get_bd_pins BeltBus_TDL_Channel_1/clk_BB] [get_bd_pins BeltBus_TDL_Channel_1/clk_SYS] [get_bd_pins TDCChannelSlice_1/aclk] [get_bd_pins TDCChannelSlice_1/clk_BB] [get_bd_pins TDCChannelSlice_1/clk_SYS]
  connect_bd_net -net clk_TDC_1 [get_bd_pins clk_TDC] [get_bd_pins BeltBus_TDL_Channel_1/clk_TDC] [get_bd_pins InputLogic_0/clk] [get_bd_pins TDCChannelSlice_1/clk_TDC]
  connect_bd_net -net reset_TDC_1 [get_bd_pins reset_TDC] [get_bd_pins BeltBus_TDL_Channel_1/reset_BB] [get_bd_pins BeltBus_TDL_Channel_1/reset_SYS] [get_bd_pins BeltBus_TDL_Channel_1/reset_TDC] [get_bd_pins InputLogic_0/reset]
  connect_bd_net -net write_debug_reg_0_1 [get_bd_pins write_debug_reg_0] [get_bd_pins TDCChannelSlice_1/write_debug_reg]
  connect_bd_net -net xlconstant_2_dout [get_bd_pins TDCChannelSlice_1/s00_axis_period_tvalid] [get_bd_pins xlconstant_2/dout]
  connect_bd_net -net xlslice_1_Dout [get_bd_pins write_reg] [get_bd_pins TDCChannelSlice_1/write_reg]

  # Restore current instance
  current_bd_instance $oldCurInst
}

# Hierarchical cell: TDC
proc create_hier_cell_TDC { parentCell nameHier } {

  variable script_folder

  if { $parentCell eq "" || $nameHier eq "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2092 -severity "ERROR" "create_hier_cell_TDC() - Empty argument(s)!"}
     return
  }

  # Get object for parentCell
  set parentObj [get_bd_cells $parentCell]
  if { $parentObj == "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2090 -severity "ERROR" "Unable to find parent cell <$parentCell>!"}
     return
  }

  # Make sure parentObj is hier blk
  set parentType [get_property TYPE $parentObj]
  if { $parentType ne "hier" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2091 -severity "ERROR" "Parent <$parentObj> has TYPE = <$parentType>. Expected to be <hier>."}
     return
  }

  # Save current instance; Restore later
  set oldCurInst [current_bd_instance .]

  # Set parent object as current
  current_bd_instance $parentObj

  # Create cell and set as current instance
  set hier_obj [create_bd_cell -type hier $nameHier]
  current_bd_instance $hier_obj

  # Create interface pins
  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:axis_rtl:1.0 M00_AXIS

  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:axis_rtl:1.0 M00_BB

  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:axis_rtl:1.0 M01_AXIS_DebugCT

  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:axis_rtl:1.0 M01_AXIS_DebugCT1

  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:axis_rtl:1.0 M01_AXIS_DebugCT2

  create_bd_intf_pin -mode Slave -vlnv DigiLAB:if:diff_ch_tdc_rtl:1.1 ch_sync_diff

  create_bd_intf_pin -mode Slave -vlnv DigiLAB:if:diff_ch_tdc_rtl:1.1 left_ch1_diff

  create_bd_intf_pin -mode Slave -vlnv DigiLAB:if:diff_ch_tdc_rtl:1.1 left_ch2_diff


  # Create pins
  create_bd_pin -dir I -from 56 -to 0 Din
  create_bd_pin -dir I -from 221 -to 0 Din_1
  create_bd_pin -dir O -from 0 -to 0 Res
  create_bd_pin -dir I -type clk clk_BB
  create_bd_pin -dir I -type clk clk_TDC
  create_bd_pin -dir O -from 194 -to 0 dout
  create_bd_pin -dir I -type rst reset_0

  # Create instance: Ch1
  create_hier_cell_Ch1 $hier_obj Ch1

  # Create instance: Ch2
  create_hier_cell_Ch2 $hier_obj Ch2

  # Create instance: CoarseTreeDistributor_0, and set properties
  set CoarseTreeDistributor_0 [ create_bd_cell -type ip -vlnv DigiLAB:ip:CoarseTreeDistributor:1.2 CoarseTreeDistributor_0 ]
  set_property -dict [ list \
   CONFIG.NUMBER_OF_OUTPUT {3} \
 ] $CoarseTreeDistributor_0

  # Create instance: StartStopGenerator_0, and set properties
  set StartStopGenerator_0 [ create_bd_cell -type ip -vlnv DigiLAB:ip:StartStopGenerator:2.1 StartStopGenerator_0 ]
  set_property -dict [ list \
   CONFIG.CLK_SELECT {EXTERNAL} \
   CONFIG.HALF_DIVIDER {5} \
   CONFIG.TUNING_MODE {false} \
 ] $StartStopGenerator_0

  # Create instance: Sync
  create_hier_cell_Sync $hier_obj Sync

  # Create instance: util_vector_logic_0, and set properties
  set util_vector_logic_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:util_vector_logic:2.0 util_vector_logic_0 ]
  set_property -dict [ list \
   CONFIG.C_SIZE {1} \
 ] $util_vector_logic_0

  # Create instance: util_vector_logic_1, and set properties
  set util_vector_logic_1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:util_vector_logic:2.0 util_vector_logic_1 ]
  set_property -dict [ list \
   CONFIG.C_SIZE {1} \
 ] $util_vector_logic_1

  # Create instance: xlconcat_0, and set properties
  set xlconcat_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconcat:2.1 xlconcat_0 ]
  set_property -dict [ list \
   CONFIG.IN0_WIDTH {65} \
   CONFIG.IN1_WIDTH {65} \
   CONFIG.IN2_WIDTH {65} \
   CONFIG.NUM_PORTS {3} \
 ] $xlconcat_0

  # Create instance: xlconstant_0, and set properties
  set xlconstant_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconstant:1.1 xlconstant_0 ]
  set_property -dict [ list \
   CONFIG.CONST_VAL {0} \
 ] $xlconstant_0

  # Create instance: xlslice_0, and set properties
  set xlslice_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_0 ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {18} \
   CONFIG.DIN_WIDTH {57} \
   CONFIG.DOUT_WIDTH {19} \
 ] $xlslice_0

  # Create instance: xlslice_1, and set properties
  set xlslice_1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_1 ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {37} \
   CONFIG.DIN_TO {19} \
   CONFIG.DIN_WIDTH {57} \
   CONFIG.DOUT_WIDTH {19} \
 ] $xlslice_1

  # Create instance: xlslice_2, and set properties
  set xlslice_2 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_2 ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {56} \
   CONFIG.DIN_TO {38} \
   CONFIG.DIN_WIDTH {57} \
   CONFIG.DOUT_WIDTH {19} \
 ] $xlslice_2

  # Create instance: xlslice_3, and set properties
  set xlslice_3 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_3 ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {73} \
   CONFIG.DIN_WIDTH {222} \
   CONFIG.DOUT_WIDTH {74} \
 ] $xlslice_3

  # Create instance: xlslice_4, and set properties
  set xlslice_4 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_4 ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {147} \
   CONFIG.DIN_TO {74} \
   CONFIG.DIN_WIDTH {222} \
   CONFIG.DOUT_WIDTH {74} \
 ] $xlslice_4

  # Create instance: xlslice_5, and set properties
  set xlslice_5 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_5 ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {221} \
   CONFIG.DIN_TO {148} \
   CONFIG.DIN_WIDTH {222} \
   CONFIG.DOUT_WIDTH {74} \
 ] $xlslice_5

  # Create interface connections
  connect_bd_intf_net -intf_net BeltBus_TDL_Channel_0_M00_BB [get_bd_intf_pins Ch1/S00_BB] [get_bd_intf_pins Sync/M00_BB]
  connect_bd_intf_net -intf_net BeltBus_TDL_Channel_0_M01_AXIS_DebugCT [get_bd_intf_pins M01_AXIS_DebugCT2] [get_bd_intf_pins Sync/M01_AXIS_DebugCT]
  connect_bd_intf_net -intf_net BeltBus_TDL_Channel_1_M00_BB [get_bd_intf_pins Ch1/M00_BB] [get_bd_intf_pins Ch2/S00_BB]
  connect_bd_intf_net -intf_net BeltBus_TDL_Channel_1_M01_AXIS_DebugCT [get_bd_intf_pins M01_AXIS_DebugCT] [get_bd_intf_pins Ch1/M01_AXIS_DebugCT]
  connect_bd_intf_net -intf_net BeltBus_TDL_Channel_2_M00_BB [get_bd_intf_pins M00_BB] [get_bd_intf_pins Ch2/M00_BB]
  connect_bd_intf_net -intf_net BeltBus_TDL_Channel_2_M01_AXIS_DebugCT [get_bd_intf_pins M01_AXIS_DebugCT1] [get_bd_intf_pins Ch2/M01_AXIS_DebugCT]
  connect_bd_intf_net -intf_net Conn1 [get_bd_intf_pins ch_sync_diff] [get_bd_intf_pins Sync/ch_sync_diff]
  connect_bd_intf_net -intf_net Conn4 [get_bd_intf_pins M00_AXIS] [get_bd_intf_pins Sync/M00_AXIS]
  connect_bd_intf_net -intf_net Conn5 [get_bd_intf_pins left_ch1_diff] [get_bd_intf_pins Ch1/left_ch1_diff]
  connect_bd_intf_net -intf_net Conn6 [get_bd_intf_pins left_ch2_diff] [get_bd_intf_pins Ch2/left_ch2_diff]

  # Create port connections
  connect_bd_net -net BeltBus_TDL_Channel_TDC_0_Calibrated [get_bd_pins Sync/Calibrated] [get_bd_pins util_vector_logic_1/Op1]
  connect_bd_net -net BeltBus_TDL_Channel_TDC_1_Calibrated [get_bd_pins Ch1/Calibrated] [get_bd_pins util_vector_logic_1/Op2]
  connect_bd_net -net BeltBus_TDL_Channel_TDC_2_Calibrated [get_bd_pins Ch2/Calibrated] [get_bd_pins util_vector_logic_0/Op2]
  connect_bd_net -net CoarseTreeDistributor_0_CoarseCounter_CTD_0 [get_bd_pins CoarseTreeDistributor_0/CoarseCounter_CTD_0] [get_bd_pins Sync/CoarseCounter_CTD]
  connect_bd_net -net CoarseTreeDistributor_0_CoarseCounter_CTD_1 [get_bd_pins Ch1/CoarseCounter_CTD] [get_bd_pins CoarseTreeDistributor_0/CoarseCounter_CTD_1]
  connect_bd_net -net CoarseTreeDistributor_0_CoarseCounter_CTD_2 [get_bd_pins Ch2/CoarseCounter_CTD] [get_bd_pins CoarseTreeDistributor_0/CoarseCounter_CTD_2]
  connect_bd_net -net Din_1_1 [get_bd_pins Din_1] [get_bd_pins xlslice_3/Din] [get_bd_pins xlslice_4/Din] [get_bd_pins xlslice_5/Din]
  connect_bd_net -net Net [get_bd_pins Din] [get_bd_pins xlslice_0/Din] [get_bd_pins xlslice_1/Din] [get_bd_pins xlslice_2/Din]
  connect_bd_net -net StartStopGenerator_0_StartOut [get_bd_pins StartStopGenerator_0/StartOut] [get_bd_pins Sync/CalibEventIn]
  connect_bd_net -net StartStopGenerator_0_StopOut [get_bd_pins Ch1/CalibEventIn] [get_bd_pins Ch2/CalibEventIn] [get_bd_pins StartStopGenerator_0/StopOut]
  connect_bd_net -net Sync_read_reg1 [get_bd_pins Sync/read_reg] [get_bd_pins xlconcat_0/In0]
  connect_bd_net -net TDCChannelSlice_1_read_reg [get_bd_pins Ch1/read_reg] [get_bd_pins xlconcat_0/In1]
  connect_bd_net -net TDCChannelSlice_2_read_reg [get_bd_pins Ch2/read_reg] [get_bd_pins xlconcat_0/In2]
  connect_bd_net -net clk_BB_1 [get_bd_pins clk_BB] [get_bd_pins Ch1/clk_BB] [get_bd_pins Ch2/clk_BB] [get_bd_pins StartStopGenerator_0/clk_in] [get_bd_pins Sync/clk_BB]
  connect_bd_net -net clk_TDC_1 [get_bd_pins clk_TDC] [get_bd_pins Ch1/clk_TDC] [get_bd_pins Ch2/clk_TDC] [get_bd_pins CoarseTreeDistributor_0/clk] [get_bd_pins Sync/clk_TDC]
  connect_bd_net -net reset_0_1 [get_bd_pins reset_0] [get_bd_pins Sync/reset_0]
  connect_bd_net -net reset_TDC_1 [get_bd_pins Ch1/reset_TDC] [get_bd_pins Ch2/reset_TDC] [get_bd_pins CoarseTreeDistributor_0/reset] [get_bd_pins StartStopGenerator_0/reset] [get_bd_pins Sync/reset_TDC] [get_bd_pins xlconstant_0/dout]
  connect_bd_net -net util_vector_logic_0_Res [get_bd_pins Res] [get_bd_pins util_vector_logic_0/Res]
  connect_bd_net -net util_vector_logic_1_Res [get_bd_pins util_vector_logic_0/Op1] [get_bd_pins util_vector_logic_1/Res]
  connect_bd_net -net xlconcat_0_dout [get_bd_pins dout] [get_bd_pins xlconcat_0/dout]
  connect_bd_net -net xlslice_0_Dout [get_bd_pins Sync/write_reg] [get_bd_pins xlslice_0/Dout]
  connect_bd_net -net xlslice_1_Dout [get_bd_pins Ch1/write_reg] [get_bd_pins xlslice_1/Dout]
  connect_bd_net -net xlslice_2_Dout [get_bd_pins Ch2/write_reg] [get_bd_pins xlslice_2/Dout]
  connect_bd_net -net xlslice_3_Dout [get_bd_pins Sync/write_debug_reg_0] [get_bd_pins xlslice_3/Dout]
  connect_bd_net -net xlslice_4_Dout [get_bd_pins Ch1/write_debug_reg_0] [get_bd_pins xlslice_4/Dout]
  connect_bd_net -net xlslice_5_Dout [get_bd_pins Ch2/write_debug_reg_0] [get_bd_pins xlslice_5/Dout]

  # Restore current instance
  current_bd_instance $oldCurInst
}

# Hierarchical cell: TDC_Calib
proc create_hier_cell_TDC_Calib { parentCell nameHier } {

  variable script_folder

  if { $parentCell eq "" || $nameHier eq "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2092 -severity "ERROR" "create_hier_cell_TDC_Calib() - Empty argument(s)!"}
     return
  }

  # Get object for parentCell
  set parentObj [get_bd_cells $parentCell]
  if { $parentObj == "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2090 -severity "ERROR" "Unable to find parent cell <$parentCell>!"}
     return
  }

  # Make sure parentObj is hier blk
  set parentType [get_property TYPE $parentObj]
  if { $parentType ne "hier" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2091 -severity "ERROR" "Parent <$parentObj> has TYPE = <$parentType>. Expected to be <hier>."}
     return
  }

  # Save current instance; Restore later
  set oldCurInst [current_bd_instance .]

  # Set parent object as current
  current_bd_instance $parentObj

  # Create cell and set as current instance
  set hier_obj [create_bd_cell -type hier $nameHier]
  current_bd_instance $hier_obj

  # Create interface pins
  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:axis_rtl:1.0 M00_AXIS

  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:axis_rtl:1.0 M00_AXIS_Autopush

  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:axis_rtl:1.0 M00_BB

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 S00_AXI

  create_bd_intf_pin -mode Slave -vlnv DigiLAB:if:diff_ch_tdc_rtl:1.1 ch_sync_diff

  create_bd_intf_pin -mode Slave -vlnv DigiLAB:if:diff_ch_tdc_rtl:1.1 left_ch1_diff

  create_bd_intf_pin -mode Slave -vlnv DigiLAB:if:diff_ch_tdc_rtl:1.1 left_ch2_diff

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:diff_clock_rtl:1.0 tdc_diff_clock


  # Create pins
  create_bd_pin -dir O -from 0 -to 0 Res
  create_bd_pin -dir I -type clk clk_BB
  create_bd_pin -dir I -type rst reset
  create_bd_pin -dir I -type rst reset_0
  create_bd_pin -dir I -type rst resetn

  # Create instance: AXI4Stream_MuxDebugg_0, and set properties
  set AXI4Stream_MuxDebugg_0 [ create_bd_cell -type ip -vlnv DigiLAB:ip:AXI4Stream_MuxDebugger:1.1 AXI4Stream_MuxDebugg_0 ]
  set_property -dict [ list \
   CONFIG.DEBUG_MODE_CC {false} \
   CONFIG.NUM_CHANNEL {3} \
 ] $AXI4Stream_MuxDebugg_0

  # Create instance: AXI4_TDC_Wrapper_0, and set properties
  set AXI4_TDC_Wrapper_0 [ create_bd_cell -type ip -vlnv DigiLAB:ip:AXI4_TDC_Wrapper:5.0 AXI4_TDC_Wrapper_0 ]
  set_property -dict [ list \
   CONFIG.BIT_CALIBRATION {24} \
   CONFIG.BIT_RESOLUTION {11} \
   CONFIG.BIT_UNCALIBRATED {11} \
   CONFIG.C_S00_AXI_ADDR_ABS {0x44A40000} \
   CONFIG.DEBUG_MODE_CC {false} \
   CONFIG.DEF_CH_STRETCHERLENGTH {6} \
   CONFIG.DEF_SYNC_STRETCHERLENGTH {1} \
   CONFIG.PW_StretcherLength {3} \
   CONFIG.TDC_CH_RPORT_WIDTH {65} \
   CONFIG.TDC_ENABLE_DEBUG_PORTS {true} \
 ] $AXI4_TDC_Wrapper_0

  # Create instance: TDC
  create_hier_cell_TDC $hier_obj TDC

  # Create instance: clk_wiz_1, and set properties
  set clk_wiz_1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:clk_wiz:6.0 clk_wiz_1 ]
  set_property -dict [ list \
   CONFIG.CLKIN1_JITTER_PS {64.0} \
   CONFIG.CLKOUT1_JITTER {119.965} \
   CONFIG.CLKOUT1_PHASE_ERROR {158.075} \
   CONFIG.CLKOUT1_REQUESTED_OUT_FREQ {416.66667} \
   CONFIG.MMCM_CLKFBOUT_MULT_F {19.000} \
   CONFIG.MMCM_CLKIN1_PERIOD {6.400} \
   CONFIG.MMCM_CLKIN2_PERIOD {10.000} \
   CONFIG.MMCM_CLKOUT0_DIVIDE_F {2.375} \
   CONFIG.MMCM_DIVCLK_DIVIDE {3} \
   CONFIG.PRIM_IN_FREQ {156.25} \
   CONFIG.USE_RESET {false} \
 ] $clk_wiz_1

  # Create instance: util_ds_buf_0, and set properties
  set util_ds_buf_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:util_ds_buf:2.1 util_ds_buf_0 ]
  set_property -dict [ list \
   CONFIG.DIFF_CLK_IN_BOARD_INTERFACE {tdc_diff_clock} \
 ] $util_ds_buf_0

  # Create instance: util_ds_buf_1, and set properties
  set util_ds_buf_1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:util_ds_buf:2.1 util_ds_buf_1 ]
  set_property -dict [ list \
   CONFIG.C_BUF_TYPE {BUFG} \
   CONFIG.DIFF_CLK_IN_BOARD_INTERFACE {Custom} \
 ] $util_ds_buf_1

  # Create interface connections
  connect_bd_intf_net -intf_net AXI4Stream_MuxDebugg_0_M00_AXIS_CT [get_bd_intf_pins AXI4Stream_MuxDebugg_0/M00_AXIS_CT] [get_bd_intf_pins AXI4_TDC_Wrapper_0/S00_AXIS_DebugCT]
  connect_bd_intf_net -intf_net AXI4_TDC_Wrapper_0_M00_AXIS_Autopush [get_bd_intf_pins M00_AXIS_Autopush] [get_bd_intf_pins AXI4_TDC_Wrapper_0/M00_AXIS_Autopush]
  connect_bd_intf_net -intf_net Conn1 [get_bd_intf_pins ch_sync_diff] [get_bd_intf_pins TDC/ch_sync_diff]
  connect_bd_intf_net -intf_net Conn2 [get_bd_intf_pins left_ch1_diff] [get_bd_intf_pins TDC/left_ch1_diff]
  connect_bd_intf_net -intf_net Conn3 [get_bd_intf_pins M00_AXIS] [get_bd_intf_pins TDC/M00_AXIS]
  connect_bd_intf_net -intf_net Conn4 [get_bd_intf_pins left_ch2_diff] [get_bd_intf_pins TDC/left_ch2_diff]
  connect_bd_intf_net -intf_net S00_AXI_1 [get_bd_intf_pins S00_AXI] [get_bd_intf_pins AXI4_TDC_Wrapper_0/S00_AXI]
  connect_bd_intf_net -intf_net TDC_M00_BB [get_bd_intf_pins M00_BB] [get_bd_intf_pins TDC/M00_BB]
  connect_bd_intf_net -intf_net TDC_M01_AXIS_DebugCT [get_bd_intf_pins AXI4Stream_MuxDebugg_0/S01_AXIS_DebugCT] [get_bd_intf_pins TDC/M01_AXIS_DebugCT]
  connect_bd_intf_net -intf_net TDC_M01_AXIS_DebugCT1 [get_bd_intf_pins AXI4Stream_MuxDebugg_0/S02_AXIS_DebugCT] [get_bd_intf_pins TDC/M01_AXIS_DebugCT1]
  connect_bd_intf_net -intf_net TDC_M01_AXIS_DebugCT2 [get_bd_intf_pins AXI4Stream_MuxDebugg_0/S00_AXIS_DebugCT] [get_bd_intf_pins TDC/M01_AXIS_DebugCT2]
  connect_bd_intf_net -intf_net tdc_diff_clock_1 [get_bd_intf_pins tdc_diff_clock] [get_bd_intf_pins util_ds_buf_0/CLK_IN_D]

  # Create port connections
  connect_bd_net -net AXI4_TDC_Wrapper_0_MUX_sel [get_bd_pins AXI4Stream_MuxDebugg_0/sel] [get_bd_pins AXI4_TDC_Wrapper_0/MUX_sel]
  connect_bd_net -net AXI4_TDC_Wrapper_0_TDC_DEBUG_PROP_WPORT [get_bd_pins AXI4_TDC_Wrapper_0/TDC_DEBUG_PROP_WPORT] [get_bd_pins TDC/Din_1]
  connect_bd_net -net AXI4_TDC_Wrapper_0_TDC_PROP_WPORT [get_bd_pins AXI4_TDC_Wrapper_0/TDC_PROP_WPORT] [get_bd_pins TDC/Din]
  connect_bd_net -net Net [get_bd_pins reset] [get_bd_pins AXI4Stream_MuxDebugg_0/reset] [get_bd_pins AXI4_TDC_Wrapper_0/reset]
  connect_bd_net -net TDC_Res [get_bd_pins Res] [get_bd_pins TDC/Res]
  connect_bd_net -net TDC_dout [get_bd_pins AXI4_TDC_Wrapper_0/TDC_PROP_RPORT] [get_bd_pins TDC/dout]
  connect_bd_net -net clk_wiz_0_clk_out1 [get_bd_pins clk_BB] [get_bd_pins AXI4Stream_MuxDebugg_0/clk] [get_bd_pins AXI4_TDC_Wrapper_0/aclk] [get_bd_pins AXI4_TDC_Wrapper_0/clk] [get_bd_pins TDC/clk_BB]
  connect_bd_net -net clk_wiz_1_clk_out1 [get_bd_pins TDC/clk_TDC] [get_bd_pins clk_wiz_1/clk_out1]
  connect_bd_net -net proc_sys_reset_0_peripheral_aresetn [get_bd_pins resetn] [get_bd_pins AXI4_TDC_Wrapper_0/aresetn]
  connect_bd_net -net reset_0_1 [get_bd_pins reset_0] [get_bd_pins TDC/reset_0]
  connect_bd_net -net util_ds_buf_0_IBUF_OUT [get_bd_pins util_ds_buf_0/IBUF_OUT] [get_bd_pins util_ds_buf_1/BUFG_I]
  connect_bd_net -net util_ds_buf_1_BUFG_O [get_bd_pins clk_wiz_1/clk_in1] [get_bd_pins util_ds_buf_1/BUFG_O]

  # Restore current instance
  current_bd_instance $oldCurInst
}

# Hierarchical cell: Master
proc create_hier_cell_Master { parentCell nameHier } {

  variable script_folder

  if { $parentCell eq "" || $nameHier eq "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2092 -severity "ERROR" "create_hier_cell_Master() - Empty argument(s)!"}
     return
  }

  # Get object for parentCell
  set parentObj [get_bd_cells $parentCell]
  if { $parentObj == "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2090 -severity "ERROR" "Unable to find parent cell <$parentCell>!"}
     return
  }

  # Make sure parentObj is hier blk
  set parentType [get_property TYPE $parentObj]
  if { $parentType ne "hier" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2091 -severity "ERROR" "Parent <$parentObj> has TYPE = <$parentType>. Expected to be <hier>."}
     return
  }

  # Save current instance; Restore later
  set oldCurInst [current_bd_instance .]

  # Set parent object as current
  current_bd_instance $parentObj

  # Create cell and set as current instance
  set hier_obj [create_bd_cell -type hier $nameHier]
  current_bd_instance $hier_obj

  # Create interface pins
  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 S_AXI


  # Create pins
  create_bd_pin -dir I -type clk s_axi_aclk
  create_bd_pin -dir I -type rst s_axi_aresetn

  # Create instance: axi_bram_ctrl_0, and set properties
  set axi_bram_ctrl_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_bram_ctrl:4.1 axi_bram_ctrl_0 ]
  set_property -dict [ list \
   CONFIG.SINGLE_PORT_BRAM {1} \
   CONFIG.SUPPORTS_NARROW_BURST {0} \
 ] $axi_bram_ctrl_0

  # Create instance: blk_mem_gen_0, and set properties
  set blk_mem_gen_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:blk_mem_gen:8.4 blk_mem_gen_0 ]
  set_property -dict [ list \
   CONFIG.Byte_Size {8} \
   CONFIG.Coe_File {../../../../../../../../../master_v70.coe} \
   CONFIG.EN_SAFETY_CKT {true} \
   CONFIG.Enable_32bit_Address {true} \
   CONFIG.Load_Init_File {true} \
   CONFIG.Memory_Type {Single_Port_ROM} \
   CONFIG.Port_A_Write_Rate {0} \
   CONFIG.Register_PortA_Output_of_Memory_Primitives {false} \
   CONFIG.Use_Byte_Write_Enable {false} \
   CONFIG.Use_RSTA_Pin {true} \
   CONFIG.use_bram_block {BRAM_Controller} \
 ] $blk_mem_gen_0

  # Create interface connections
  connect_bd_intf_net -intf_net axi_bram_ctrl_0_BRAM_PORTA [get_bd_intf_pins axi_bram_ctrl_0/BRAM_PORTA] [get_bd_intf_pins blk_mem_gen_0/BRAM_PORTA]
  connect_bd_intf_net -intf_net axi_interconnect_0_M00_AXI [get_bd_intf_pins S_AXI] [get_bd_intf_pins axi_bram_ctrl_0/S_AXI]

  # Create port connections
  connect_bd_net -net s_axi_aclk_1 [get_bd_pins s_axi_aclk] [get_bd_pins axi_bram_ctrl_0/s_axi_aclk]
  connect_bd_net -net s_axi_aresetn_1 [get_bd_pins s_axi_aresetn] [get_bd_pins axi_bram_ctrl_0/s_axi_aresetn]

  # Restore current instance
  current_bd_instance $oldCurInst
}


# Procedure to create entire design; Provide argument to make
# procedure reusable. If parentCell is "", will use root.
proc create_root_design { parentCell } {

  variable script_folder
  variable design_name

  if { $parentCell eq "" } {
     set parentCell [get_bd_cells /]
  }

  # Get object for parentCell
  set parentObj [get_bd_cells $parentCell]
  if { $parentObj == "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2090 -severity "ERROR" "Unable to find parent cell <$parentCell>!"}
     return
  }

  # Make sure parentObj is hier blk
  set parentType [get_property TYPE $parentObj]
  if { $parentType ne "hier" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2091 -severity "ERROR" "Parent <$parentObj> has TYPE = <$parentType>. Expected to be <hier>."}
     return
  }

  # Save current instance; Restore later
  set oldCurInst [current_bd_instance .]

  # Set parent object as current
  current_bd_instance $parentObj


  # Create interface ports
  set USB_UART [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:uart_rtl:1.0 USB_UART ]

  set ch_sync_diff [ create_bd_intf_port -mode Slave -vlnv DigiLAB:if:diff_ch_tdc_rtl:1.1 ch_sync_diff ]

  set left_ch1_diff [ create_bd_intf_port -mode Slave -vlnv DigiLAB:if:diff_ch_tdc_rtl:1.1 left_ch1_diff ]

  set left_ch2_diff [ create_bd_intf_port -mode Slave -vlnv DigiLAB:if:diff_ch_tdc_rtl:1.1 left_ch2_diff ]

  set sys_diff_clock [ create_bd_intf_port -mode Slave -vlnv xilinx.com:interface:diff_clock_rtl:1.0 sys_diff_clock ]
  set_property -dict [ list \
   CONFIG.FREQ_HZ {100000000} \
   ] $sys_diff_clock

  set tdc_diff_clock [ create_bd_intf_port -mode Slave -vlnv xilinx.com:interface:diff_clock_rtl:1.0 tdc_diff_clock ]
  set_property -dict [ list \
   CONFIG.FREQ_HZ {156250000} \
   ] $tdc_diff_clock


  # Create ports

  # Create instance: AXI4Stream_UART_0, and set properties
  set AXI4Stream_UART_0 [ create_bd_cell -type ip -vlnv TimeEngineers:ip:AXI4Stream_UART:1.0 AXI4Stream_UART_0 ]
  set_property -dict [ list \
   CONFIG.UART_BAUD_RATE {2000000} \
   CONFIG.UART_BOARD_INTERFACE {USB_UART} \
   CONFIG.USE_BOARD_FLOW {true} \
 ] $AXI4Stream_UART_0

  # Create instance: BeltBus_TDCCounter_0, and set properties
  set BeltBus_TDCCounter_0 [ create_bd_cell -type ip -vlnv DigiLAB:ip:BeltBus_TDCCounter:2.0 BeltBus_TDCCounter_0 ]
  set_property -dict [ list \
   CONFIG.NUM_CH {3} \
 ] $BeltBus_TDCCounter_0

  # Create instance: BeltBus_TDCHistogrammer_0, and set properties
  set BeltBus_TDCHistogrammer_0 [ create_bd_cell -type ip -vlnv DigiLAB:ip:BeltBus_TDCHistogrammer:5.0 BeltBus_TDCHistogrammer_0 ]
  set_property -dict [ list \
   CONFIG.BIN_ADDR_WIDTH {13} \
   CONFIG.BIN_DATA_WIDTH {27} \
   CONFIG.BIT_OVERFLOW {16} \
   CONFIG.NUM_CH {3} \
 ] $BeltBus_TDCHistogrammer_0

  # Create instance: BeltBus_TDCHistogrammer_1, and set properties
  set BeltBus_TDCHistogrammer_1 [ create_bd_cell -type ip -vlnv DigiLAB:ip:BeltBus_TDCHistogrammer:5.0 BeltBus_TDCHistogrammer_1 ]
  set_property -dict [ list \
   CONFIG.BIN_ADDR_WIDTH {13} \
   CONFIG.BIN_DATA_WIDTH {27} \
   CONFIG.BIT_OVERFLOW {16} \
   CONFIG.NUM_CH {3} \
 ] $BeltBus_TDCHistogrammer_1

  # Create instance: BeltBus_TTM_0, and set properties
  set BeltBus_TTM_0 [ create_bd_cell -type ip -vlnv DigiLAB:ip:BeltBus_TTM:2.0 BeltBus_TTM_0 ]
  set_property -dict [ list \
   CONFIG.CUSTOM_TRESHOLD {false} \
   CONFIG.INS_TIMEOUT_CYCLES {100000000} \
   CONFIG.TAIL_FIFO_DEPTH {16384} \
   CONFIG.TAIL_TRESHOLD {15884} \
   CONFIG.TLAST_GEN_TIMEOUT_CYCLES {30} \
 ] $BeltBus_TTM_0

  # Create instance: MME_0, and set properties
  set MME_0 [ create_bd_cell -type ip -vlnv DigiLAB:hier:MME:2.2 MME_0 ]
  set_property -dict [ list \
   CONFIG.MAX_PACKET_LENGTH_PACKETIZER {131072} \
   CONFIG.PTE_AUXILIARY_PORTS {true} \
 ] $MME_0

  # Create instance: Master
  create_hier_cell_Master [current_bd_instance .] Master

  # Create instance: TDC_Calib
  create_hier_cell_TDC_Calib [current_bd_instance .] TDC_Calib

  # Create instance: axi_interconnect_0, and set properties
  set axi_interconnect_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_interconnect:2.1 axi_interconnect_0 ]
  set_property -dict [ list \
   CONFIG.NUM_MI {9} \
   CONFIG.NUM_SI {2} \
 ] $axi_interconnect_0

  # Create instance: axis_broadcaster_0, and set properties
  set axis_broadcaster_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axis_broadcaster:1.1 axis_broadcaster_0 ]
  set_property -dict [ list \
   CONFIG.HAS_TREADY {0} \
   CONFIG.M00_TDATA_REMAP {tdata[31:0]} \
   CONFIG.M01_TDATA_REMAP {tdata[31:0]} \
   CONFIG.M02_TDATA_REMAP {tdata[31:0]} \
   CONFIG.M03_TDATA_REMAP {tdata[31:0]} \
   CONFIG.M04_TDATA_REMAP {tdata[31:0]} \
   CONFIG.M_TDATA_NUM_BYTES {4} \
   CONFIG.NUM_MI {5} \
   CONFIG.S_TDATA_NUM_BYTES {4} \
 ] $axis_broadcaster_0

  # Create instance: axis_broadcaster_1, and set properties
  set axis_broadcaster_1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axis_broadcaster:1.1 axis_broadcaster_1 ]
  set_property -dict [ list \
   CONFIG.HAS_TREADY {0} \
   CONFIG.M00_TDATA_REMAP {tdata[39:0]} \
   CONFIG.M01_TDATA_REMAP {tdata[39:0]} \
   CONFIG.M02_TDATA_REMAP {tdata[31:0]} \
   CONFIG.M03_TDATA_REMAP {tdata[31:0]} \
   CONFIG.M_TDATA_NUM_BYTES {5} \
   CONFIG.NUM_MI {2} \
   CONFIG.S_TDATA_NUM_BYTES {5} \
 ] $axis_broadcaster_1

  # Create instance: axis_interconnect_0, and set properties
  set axis_interconnect_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axis_interconnect:2.1 axis_interconnect_0 ]
  set_property -dict [ list \
   CONFIG.NUM_MI {1} \
   CONFIG.NUM_SI {4} \
 ] $axis_interconnect_0

  # Create instance: clk_wiz_0, and set properties
  set clk_wiz_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:clk_wiz:6.0 clk_wiz_0 ]
  set_property -dict [ list \
   CONFIG.CLKOUT1_JITTER {144.719} \
   CONFIG.CLKOUT1_PHASE_ERROR {114.212} \
   CONFIG.CLKOUT2_JITTER {131.841} \
   CONFIG.CLKOUT2_PHASE_ERROR {114.212} \
   CONFIG.CLKOUT2_REQUESTED_OUT_FREQ {160.000} \
   CONFIG.CLKOUT2_USED {true} \
   CONFIG.CLK_IN1_BOARD_INTERFACE {sys_diff_clock} \
   CONFIG.MMCM_CLKFBOUT_MULT_F {8.000} \
   CONFIG.MMCM_CLKOUT0_DIVIDE_F {8.000} \
   CONFIG.MMCM_CLKOUT1_DIVIDE {5} \
   CONFIG.NUM_OUT_CLKS {2} \
   CONFIG.USE_BOARD_FLOW {true} \
   CONFIG.USE_RESET {false} \
 ] $clk_wiz_0

  # Create instance: proc_sys_reset_0, and set properties
  set proc_sys_reset_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:proc_sys_reset:5.0 proc_sys_reset_0 ]

  # Create instance: xadc_wiz_0, and set properties
  set xadc_wiz_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xadc_wiz:3.3 xadc_wiz_0 ]
  set_property -dict [ list \
   CONFIG.ADC_CONVERSION_RATE {39} \
   CONFIG.CHANNEL_AVERAGING {256} \
   CONFIG.CHANNEL_ENABLE_TEMPERATURE {true} \
   CONFIG.CHANNEL_ENABLE_VP_VN {false} \
   CONFIG.DCLK_FREQUENCY {8} \
   CONFIG.EXTERNAL_MUX_CHANNEL {VP_VN} \
   CONFIG.OT_ALARM {false} \
   CONFIG.SEQUENCER_MODE {Continuous} \
   CONFIG.SINGLE_CHANNEL_SELECTION {TEMPERATURE} \
   CONFIG.USER_TEMP_ALARM {false} \
   CONFIG.VCCAUX_ALARM {false} \
   CONFIG.VCCINT_ALARM {false} \
   CONFIG.XADC_STARUP_SELECTION {channel_sequencer} \
 ] $xadc_wiz_0

  # Create instance: xlconstant_0, and set properties
  set xlconstant_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconstant:1.1 xlconstant_0 ]
  set_property -dict [ list \
   CONFIG.CONST_VAL {0} \
 ] $xlconstant_0

  # Create instance: xlconstant_1, and set properties
  set xlconstant_1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconstant:1.1 xlconstant_1 ]
  set_property -dict [ list \
   CONFIG.CONST_VAL {1} \
 ] $xlconstant_1

  # Create interface connections
  connect_bd_intf_net -intf_net AXI4Stream_UART_0_M00_AXIS_RX [get_bd_intf_pins AXI4Stream_UART_0/M00_AXIS_RX] [get_bd_intf_pins MME_0/S_AXIS]
  connect_bd_intf_net -intf_net AXI4Stream_UART_0_UART [get_bd_intf_ports USB_UART] [get_bd_intf_pins AXI4Stream_UART_0/UART]
  connect_bd_intf_net -intf_net BeltBus_TDCCounter_0_M00_AXIS_Push [get_bd_intf_pins BeltBus_TDCCounter_0/M00_AXIS_Push] [get_bd_intf_pins axis_interconnect_0/S00_AXIS]
  connect_bd_intf_net -intf_net BeltBus_TDCHistogrammer_1_M00_AXIS [get_bd_intf_pins BeltBus_TDCHistogrammer_1/M00_AXIS] [get_bd_intf_pins axis_interconnect_0/S02_AXIS]
  connect_bd_intf_net -intf_net BeltBus_TTM_0_M00_AXIS [get_bd_intf_pins BeltBus_TTM_0/M00_AXIS] [get_bd_intf_pins MME_0/PTE_INPUT]
  connect_bd_intf_net -intf_net MME_0_M_AXIS [get_bd_intf_pins AXI4Stream_UART_0/S00_AXIS_TX] [get_bd_intf_pins MME_0/M_AXIS]
  connect_bd_intf_net -intf_net MME_0_M_AXI_MM2S [get_bd_intf_pins MME_0/M_AXI_MM2S] [get_bd_intf_pins axi_interconnect_0/S00_AXI]
  connect_bd_intf_net -intf_net MME_0_M_AXI_S2MM [get_bd_intf_pins MME_0/M_AXI_S2MM] [get_bd_intf_pins axi_interconnect_0/S01_AXI]
  connect_bd_intf_net -intf_net S01_AXIS_1 [get_bd_intf_pins BeltBus_TDCHistogrammer_0/M00_AXIS] [get_bd_intf_pins axis_interconnect_0/S01_AXIS]
  connect_bd_intf_net -intf_net S03_AXIS_1 [get_bd_intf_pins TDC_Calib/M00_AXIS_Autopush] [get_bd_intf_pins axis_interconnect_0/S03_AXIS]
  connect_bd_intf_net -intf_net TDC_Calib_M00_AXIS [get_bd_intf_pins TDC_Calib/M00_AXIS] [get_bd_intf_pins axis_broadcaster_1/S_AXIS]
  connect_bd_intf_net -intf_net TDC_M00_BB [get_bd_intf_pins TDC_Calib/M00_BB] [get_bd_intf_pins axis_broadcaster_0/S_AXIS]
  connect_bd_intf_net -intf_net axi_interconnect_0_M00_AXI [get_bd_intf_pins Master/S_AXI] [get_bd_intf_pins axi_interconnect_0/M00_AXI]
  connect_bd_intf_net -intf_net axi_interconnect_0_M01_AXI [get_bd_intf_pins BeltBus_TDCCounter_0/S00_AXI] [get_bd_intf_pins axi_interconnect_0/M01_AXI]
  connect_bd_intf_net -intf_net axi_interconnect_0_M02_AXI [get_bd_intf_pins BeltBus_TDCHistogrammer_0/S00_AXI] [get_bd_intf_pins axi_interconnect_0/M02_AXI]
  connect_bd_intf_net -intf_net axi_interconnect_0_M03_AXI [get_bd_intf_pins BeltBus_TDCHistogrammer_1/S00_AXI] [get_bd_intf_pins axi_interconnect_0/M03_AXI]
  connect_bd_intf_net -intf_net axi_interconnect_0_M04_AXI [get_bd_intf_pins TDC_Calib/S00_AXI] [get_bd_intf_pins axi_interconnect_0/M04_AXI]
  connect_bd_intf_net -intf_net axi_interconnect_0_M07_AXI [get_bd_intf_pins axi_interconnect_0/M07_AXI] [get_bd_intf_pins xadc_wiz_0/s_axi_lite]
  connect_bd_intf_net -intf_net axi_interconnect_0_M08_AXI [get_bd_intf_pins BeltBus_TTM_0/S00_AXI] [get_bd_intf_pins axi_interconnect_0/M08_AXI]
  connect_bd_intf_net -intf_net axis_broadcaster_0_M00_AXIS [get_bd_intf_pins BeltBus_TDCCounter_0/S00_BB] [get_bd_intf_pins axis_broadcaster_0/M00_AXIS]
  connect_bd_intf_net -intf_net axis_broadcaster_0_M01_AXIS [get_bd_intf_pins BeltBus_TDCHistogrammer_0/S00_BELT] [get_bd_intf_pins axis_broadcaster_0/M01_AXIS]
  connect_bd_intf_net -intf_net axis_broadcaster_0_M02_AXIS [get_bd_intf_pins BeltBus_TDCHistogrammer_1/S00_BELT] [get_bd_intf_pins axis_broadcaster_0/M02_AXIS]
  connect_bd_intf_net -intf_net axis_broadcaster_0_M04_AXIS [get_bd_intf_pins BeltBus_TTM_0/S00_BB] [get_bd_intf_pins axis_broadcaster_0/M04_AXIS]
  connect_bd_intf_net -intf_net axis_broadcaster_1_M00_AXIS [get_bd_intf_pins BeltBus_TDCHistogrammer_0/SYNC] [get_bd_intf_pins axis_broadcaster_1/M00_AXIS]
  connect_bd_intf_net -intf_net axis_broadcaster_1_M01_AXIS [get_bd_intf_pins BeltBus_TDCHistogrammer_1/SYNC] [get_bd_intf_pins axis_broadcaster_1/M01_AXIS]
  connect_bd_intf_net -intf_net axis_interconnect_0_M00_AXIS [get_bd_intf_pins MME_0/S_AXIS_AUX] [get_bd_intf_pins axis_interconnect_0/M00_AXIS]
  connect_bd_intf_net -intf_net ch_sync_diff_1 [get_bd_intf_ports ch_sync_diff] [get_bd_intf_pins TDC_Calib/ch_sync_diff]
  connect_bd_intf_net -intf_net left_ch1_diff_1 [get_bd_intf_ports left_ch1_diff] [get_bd_intf_pins TDC_Calib/left_ch1_diff]
  connect_bd_intf_net -intf_net left_ch2_diff_1 [get_bd_intf_ports left_ch2_diff] [get_bd_intf_pins TDC_Calib/left_ch2_diff]
  connect_bd_intf_net -intf_net sys_diff_clock_1 [get_bd_intf_ports sys_diff_clock] [get_bd_intf_pins clk_wiz_0/CLK_IN1_D]
  connect_bd_intf_net -intf_net tdc_diff_clock_1 [get_bd_intf_ports tdc_diff_clock] [get_bd_intf_pins TDC_Calib/tdc_diff_clock]

  # Create port connections
  connect_bd_net -net clk_wiz_0_clk_out1 [get_bd_pins AXI4Stream_UART_0/m00_axis_rx_aclk] [get_bd_pins AXI4Stream_UART_0/s00_axis_tx_aclk] [get_bd_pins BeltBus_TDCCounter_0/s00_axi_aclk] [get_bd_pins BeltBus_TDCCounter_0/s00_bb_aclk] [get_bd_pins BeltBus_TDCHistogrammer_0/m00_axis_aclk] [get_bd_pins BeltBus_TDCHistogrammer_0/s00_axi_aclk] [get_bd_pins BeltBus_TDCHistogrammer_0/s00_belt_aclk] [get_bd_pins BeltBus_TDCHistogrammer_1/m00_axis_aclk] [get_bd_pins BeltBus_TDCHistogrammer_1/s00_axi_aclk] [get_bd_pins BeltBus_TDCHistogrammer_1/s00_belt_aclk] [get_bd_pins BeltBus_TTM_0/s00_axi_clk] [get_bd_pins BeltBus_TTM_0/s00_bb_clk] [get_bd_pins MME_0/clk] [get_bd_pins Master/s_axi_aclk] [get_bd_pins TDC_Calib/clk_BB] [get_bd_pins axi_interconnect_0/ACLK] [get_bd_pins axi_interconnect_0/M00_ACLK] [get_bd_pins axi_interconnect_0/M01_ACLK] [get_bd_pins axi_interconnect_0/M02_ACLK] [get_bd_pins axi_interconnect_0/M03_ACLK] [get_bd_pins axi_interconnect_0/M04_ACLK] [get_bd_pins axi_interconnect_0/M05_ACLK] [get_bd_pins axi_interconnect_0/M06_ACLK] [get_bd_pins axi_interconnect_0/M07_ACLK] [get_bd_pins axi_interconnect_0/M08_ACLK] [get_bd_pins axi_interconnect_0/S00_ACLK] [get_bd_pins axi_interconnect_0/S01_ACLK] [get_bd_pins axis_broadcaster_0/aclk] [get_bd_pins axis_broadcaster_1/aclk] [get_bd_pins axis_interconnect_0/ACLK] [get_bd_pins axis_interconnect_0/M00_AXIS_ACLK] [get_bd_pins axis_interconnect_0/S00_AXIS_ACLK] [get_bd_pins axis_interconnect_0/S01_AXIS_ACLK] [get_bd_pins axis_interconnect_0/S02_AXIS_ACLK] [get_bd_pins axis_interconnect_0/S03_AXIS_ACLK] [get_bd_pins clk_wiz_0/clk_out1] [get_bd_pins proc_sys_reset_0/slowest_sync_clk] [get_bd_pins xadc_wiz_0/s_axi_aclk]
  connect_bd_net -net clk_wiz_0_clk_out2 [get_bd_pins AXI4Stream_UART_0/clk_uart] [get_bd_pins clk_wiz_0/clk_out2]
  connect_bd_net -net clk_wiz_0_locked [get_bd_pins clk_wiz_0/locked] [get_bd_pins proc_sys_reset_0/dcm_locked]
  connect_bd_net -net proc_sys_reset_0_interconnect_aresetn [get_bd_pins MME_0/interconnect_aresetn] [get_bd_pins axi_interconnect_0/ARESETN] [get_bd_pins axis_interconnect_0/ARESETN] [get_bd_pins proc_sys_reset_0/interconnect_aresetn] [get_bd_pins xadc_wiz_0/s_axi_aresetn]
  connect_bd_net -net proc_sys_reset_0_peripheral_aresetn [get_bd_pins AXI4Stream_UART_0/m00_axis_rx_aresetn] [get_bd_pins AXI4Stream_UART_0/s00_axis_tx_aresetn] [get_bd_pins BeltBus_TDCCounter_0/s00_axi_aresetn] [get_bd_pins BeltBus_TDCCounter_0/s00_bb_aresetn] [get_bd_pins BeltBus_TDCHistogrammer_0/m00_axis_aresetn] [get_bd_pins BeltBus_TDCHistogrammer_0/s00_axi_aresetn] [get_bd_pins BeltBus_TDCHistogrammer_0/s00_belt_aresetn] [get_bd_pins BeltBus_TDCHistogrammer_1/m00_axis_aresetn] [get_bd_pins BeltBus_TDCHistogrammer_1/s00_axi_aresetn] [get_bd_pins BeltBus_TDCHistogrammer_1/s00_belt_aresetn] [get_bd_pins BeltBus_TTM_0/s00_axi_aresetn] [get_bd_pins BeltBus_TTM_0/s00_bb_aresetn] [get_bd_pins MME_0/peripherals_aresetn] [get_bd_pins Master/s_axi_aresetn] [get_bd_pins TDC_Calib/reset_0] [get_bd_pins TDC_Calib/resetn] [get_bd_pins axi_interconnect_0/M00_ARESETN] [get_bd_pins axi_interconnect_0/M01_ARESETN] [get_bd_pins axi_interconnect_0/M02_ARESETN] [get_bd_pins axi_interconnect_0/M03_ARESETN] [get_bd_pins axi_interconnect_0/M04_ARESETN] [get_bd_pins axi_interconnect_0/M05_ARESETN] [get_bd_pins axi_interconnect_0/M06_ARESETN] [get_bd_pins axi_interconnect_0/M07_ARESETN] [get_bd_pins axi_interconnect_0/M08_ARESETN] [get_bd_pins axi_interconnect_0/S00_ARESETN] [get_bd_pins axi_interconnect_0/S01_ARESETN] [get_bd_pins axis_broadcaster_0/aresetn] [get_bd_pins axis_broadcaster_1/aresetn] [get_bd_pins axis_interconnect_0/M00_AXIS_ARESETN] [get_bd_pins axis_interconnect_0/S00_AXIS_ARESETN] [get_bd_pins axis_interconnect_0/S01_AXIS_ARESETN] [get_bd_pins axis_interconnect_0/S02_AXIS_ARESETN] [get_bd_pins axis_interconnect_0/S03_AXIS_ARESETN] [get_bd_pins proc_sys_reset_0/peripheral_aresetn]
  connect_bd_net -net proc_sys_reset_0_peripheral_reset [get_bd_pins TDC_Calib/reset] [get_bd_pins proc_sys_reset_0/peripheral_reset]
  connect_bd_net -net xlconstant_0_dout [get_bd_pins AXI4Stream_UART_0/rst] [get_bd_pins xlconstant_0/dout]
  connect_bd_net -net xlconstant_1_dout [get_bd_pins proc_sys_reset_0/ext_reset_in] [get_bd_pins xlconstant_1/dout]

  # Create address segments
  assign_bd_address -offset 0x44A40000 -range 0x00010000 -target_address_space [get_bd_addr_spaces MME_0/M_AXI_MM2S] [get_bd_addr_segs TDC_Calib/AXI4_TDC_Wrapper_0/S00_AXI/reg0] -force
  assign_bd_address -offset 0x44A40000 -range 0x00010000 -target_address_space [get_bd_addr_spaces MME_0/M_AXI_S2MM] [get_bd_addr_segs TDC_Calib/AXI4_TDC_Wrapper_0/S00_AXI/reg0] -force
  assign_bd_address -offset 0x44A00000 -range 0x00010000 -target_address_space [get_bd_addr_spaces MME_0/M_AXI_MM2S] [get_bd_addr_segs BeltBus_TDCCounter_0/S00_AXI/MAIN] -force
  assign_bd_address -offset 0x44A00000 -range 0x00010000 -target_address_space [get_bd_addr_spaces MME_0/M_AXI_S2MM] [get_bd_addr_segs BeltBus_TDCCounter_0/S00_AXI/MAIN] -force
  assign_bd_address -offset 0x44A10000 -range 0x00010000 -target_address_space [get_bd_addr_spaces MME_0/M_AXI_MM2S] [get_bd_addr_segs BeltBus_TDCHistogrammer_0/S00_AXI/reg0] -force
  assign_bd_address -offset 0x44A10000 -range 0x00010000 -target_address_space [get_bd_addr_spaces MME_0/M_AXI_S2MM] [get_bd_addr_segs BeltBus_TDCHistogrammer_0/S00_AXI/reg0] -force
  assign_bd_address -offset 0x44A20000 -range 0x00010000 -target_address_space [get_bd_addr_spaces MME_0/M_AXI_MM2S] [get_bd_addr_segs BeltBus_TDCHistogrammer_1/S00_AXI/reg0] -force
  assign_bd_address -offset 0x44A20000 -range 0x00010000 -target_address_space [get_bd_addr_spaces MME_0/M_AXI_S2MM] [get_bd_addr_segs BeltBus_TDCHistogrammer_1/S00_AXI/reg0] -force
  assign_bd_address -offset 0x44A60000 -range 0x00010000 -target_address_space [get_bd_addr_spaces MME_0/M_AXI_MM2S] [get_bd_addr_segs BeltBus_TTM_0/S00_AXI/reg0] -force
  assign_bd_address -offset 0x44A60000 -range 0x00010000 -target_address_space [get_bd_addr_spaces MME_0/M_AXI_S2MM] [get_bd_addr_segs BeltBus_TTM_0/S00_AXI/reg0] -force
  assign_bd_address -offset 0x00000000 -range 0x00001000 -target_address_space [get_bd_addr_spaces MME_0/M_AXI_MM2S] [get_bd_addr_segs Master/axi_bram_ctrl_0/S_AXI/Mem0] -force
  assign_bd_address -offset 0x00000000 -range 0x00001000 -target_address_space [get_bd_addr_spaces MME_0/M_AXI_S2MM] [get_bd_addr_segs Master/axi_bram_ctrl_0/S_AXI/Mem0] -force
  assign_bd_address -offset 0x44A50000 -range 0x00010000 -target_address_space [get_bd_addr_spaces MME_0/M_AXI_MM2S] [get_bd_addr_segs xadc_wiz_0/s_axi_lite/Reg] -force
  assign_bd_address -offset 0x44A50000 -range 0x00010000 -target_address_space [get_bd_addr_spaces MME_0/M_AXI_S2MM] [get_bd_addr_segs xadc_wiz_0/s_axi_lite/Reg] -force


  # Restore current instance
  current_bd_instance $oldCurInst

  validate_bd_design
  save_bd_design
}
# End of create_root_design()


##################################################################
# MAIN FLOW
##################################################################

create_root_design ""


